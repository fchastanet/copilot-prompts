# dockerfile's stages inheritance/dependency diagram:
#
# node:18-alpine  ─────────────────────>  production
#     │                                      ▲
#     ├────> deps   ─────────────────────────┤
#     │                                      │
#     └────> build  ─────────────────────────┤
#              │                             │
#              └────>  test ─────────────────┘

######################################################################################
#####                     deps                                                    ####
######################################################################################
FROM node:18-alpine AS deps
SHELL ["/bin/sh", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]
WORKDIR /app
COPY package*.json ./
RUN <<EOF
    npm ci --only=production
    npm cache clean --force
EOF

######################################################################################
#####                     build                                                   ####
######################################################################################
FROM node:18-alpine AS build
WORKDIR /app
SHELL ["/bin/sh", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

######################################################################################
#####                     test                                                    ####
######################################################################################
FROM build AS test
SHELL ["/bin/sh", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]
RUN <<EOF
    npm run test
    npm run lint
    echo "All tests passed!" > /tmp/test-results/tests-passed.txt
EOF

######################################################################################
#####                     production                                              ####
######################################################################################
FROM node:18-alpine AS production
WORKDIR /app

# This COPY instruction makes the production stage to wait for the test stage to complete
COPY --from=test /tmp/test-results/tests-passed.txt /tmp/tests-passed.txt
COPY --from=deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./
USER node
EXPOSE 3000
CMD ["node", "dist/main.js"]

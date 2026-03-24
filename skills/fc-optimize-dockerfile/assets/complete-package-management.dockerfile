FROM ubuntu:24.04

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# Non-interactive installation
ARG DEBIAN_FRONTEND=noninteractive

RUN <<EOF
    apt-get update
    # CRITICAL: Apply security updates
    # Reference: https://pythonspeed.com/articles/security-updates-in-docker/
    apt-get upgrade -y
    apt-get install -y -q --no-install-recommends \
        # Packages listed alphabetically, one per line
        # Use quotes to prevent shell expansion of wildcards
        apache2='2.4.*' \
        php7.4='7.4.*' \
        php7.4-curl='7.4.*' \
        # Note the epoch notation with colon
        redis-tools='5:5.*'

    # Comprehensive cleanup
    apt-get autoremove -y
    apt-get clean
    rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/doc/*
EOF

# Optional: Check installed versions (comment out after verification)
# RUN apt-cache policy apache2 php7.4 php7.4-curl redis-tools

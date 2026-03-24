# BAD: Multiple layers, inefficient caching, no error handling
FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y python3 python3-pip
RUN pip3 install flask
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# GOOD: Optimized layers with proper error handling using ;\  separator
FROM ubuntu:20.04
SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]
RUN <<EOF
    apt-get update
    apt-get install -y \
        python3 \
        python3-pip
    pip3 install \
        flask
    apt-get autoremove -y
    apt-get clean
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
EOF

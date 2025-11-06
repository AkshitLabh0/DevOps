# jenkins.Dockerfile (Option A: Docker Hub)
FROM jenkins/jenkins:lts

# Add this to your jenkins.Dockerfile before USER jenkins:
RUN apt-get update && apt-get install -y git

USER root

# Avoid interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Base tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg lsb-release \
 && rm -rf /var/lib/apt/lists/*

# ----------------------------
# Docker CLI (via Docker APT repo) - no apt-key, use keyring
# ----------------------------
RUN install -m 0755 -d /etc/apt/keyrings \
 && curl -fsSL https://download.docker.com/linux/debian/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
 && chmod a+r /etc/apt/keyrings/docker.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
    > /etc/apt/sources.list.d/docker.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends docker-ce-cli \
 && rm -rf /var/lib/apt/lists/*

# ----------------------------
# kubectl (download the static binary)
# ----------------------------
RUN curl -L -s https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl \
      -o /usr/local/bin/kubectl \
 && chmod 0755 /usr/local/bin/kubectl

# (Optional) Verify binaries
# RUN docker --version && kubectl version --client

USER jenkins

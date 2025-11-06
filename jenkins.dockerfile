# jenkins.Dockerfile
FROM jenkins/jenkins:lts

# --- run package installs as root ---
USER root
ENV DEBIAN_FRONTEND=noninteractive

# Base packages (includes git)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg lsb-release git \
 && rm -rf /var/lib/apt/lists/*

# Docker CLI via Docker’s APT repo (keyring, no apt-key)
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

# kubectl (static binary)
RUN curl -L -s https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl \
      -o /usr/local/bin/kubectl \
 && chmod 0755 /usr/local/bin/kubectl

# --- drop back to the Jenkins user ---
USER jenkins

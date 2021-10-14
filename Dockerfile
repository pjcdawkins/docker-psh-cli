FROM php:7-cli

RUN apt-get update

# Install Git and SSH CLI clients.
RUN apt-get install --no-install-recommends -y git ssh-client

# Install the Platform.sh CLI
ADD install-cli.sh .
RUN bash ./install-cli.sh

# Add known_hosts to the Docker home directory.
ADD known_hosts .
RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    cp known_hosts ~/.ssh/known_hosts && \
    chmod 644 ~/.ssh/known_hosts

# Add known_hosts to /root, for GitLab CI.
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    cp known_hosts /root/.ssh/known_hosts && \
    chmod 644 /root/.ssh/known_hosts

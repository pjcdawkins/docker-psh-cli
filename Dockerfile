FROM php:7-cli

RUN apt-get update

# Install Git and SSH CLI clients.
RUN apt-get install --no-install-recommends -y git ssh-client

# Add platform.sh git repository server as a known host.
RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    ssh-keyscan git.us.platform.sh >> ~/.ssh/known_hosts && \
    chmod 644 ~/.ssh/known_hosts

# Install the Platform.sh CLI
ADD install-cli.sh .
RUN bash ./install-cli.sh

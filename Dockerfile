FROM php:7-cli

RUN apt-get update

# Install Git and SSH CLI clients.
RUN apt-get install --no-install-recommends -y git ssh-client

# Add platform.sh git repository server as a known host.
RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    ssh-keyscan git.us.platform.sh >> ~/.ssh/known_hosts && \
    ssh-keyscan git.us-2.platform.sh >> ~/.ssh/known_hosts && \
    ssh-keyscan git.eu.platform.sh >> ~/.ssh/known_hosts && \
    ssh-keyscan git.eu-2.platform.sh >> ~/.ssh/known_hosts && \
    ssh-keyscan git.eu-3.platform.sh >> ~/.ssh/known_hosts && \
    ssh-keyscan git.eu-4.platform.sh >> ~/.ssh/known_hosts && \
    ssh-keyscan git.au.platform.sh >> ~/.ssh/known_hosts && \
    chmod 644 ~/.ssh/known_hosts

# Install the Platform.sh CLI
ADD install-cli.sh .
RUN bash ./install-cli.sh

FROM ubuntu:24.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    tree \
    vim \
    xclip \
    zsh \
    sudo \
    iproute2 \
    net-tools \
    iputils-ping \
    gnupg2 \
    && apt-get clean

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

COPY .zshrc /root/.zshrc

RUN cat /root/.zshrc >> /root/.bashrc

# Set the default command to run when the container starts
CMD ["tail", "-f", "/dev/null"]

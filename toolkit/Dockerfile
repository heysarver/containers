FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    PATH="/root/.krew/bin:$PATH"

# Install core OS tools, Python, Node.js, Ruby, DB clients, Docker CLI in one shot
RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    apt-transport-https \
    bash-completion \
    ca-certificates \
    curl \
    dnsutils \
    git \
    gnupg \
    htop \
    iftop \
    iotop \
    iperf3 \
    iputils-ping \
    jq \
    lsof \
    man-db \
    mtr-tiny \
    nano \
    net-tools \
    netcat-traditional \
    nmap \
    openssh-client \
    python3 python3-pip python3-full python3-venv \
    ripgrep \
    rsync \
    strace \
    sudo \
    sysstat \
    tcpdump \
    telnet \
    tmux \
    traceroute \
    unzip \
    vim \
    wget \
    zip \
    zsh \
    conntrack ethtool iproute2 ipvsadm nftables socat \
    default-mysql-client postgresql-client redis-tools \
    ruby ruby-dev build-essential \
    nodejs npm \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python packages in a virtual environment
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir \
    boto3 docker hcloud httpie ipython kubernetes \
    mysql-connector-python netaddr pg8000 pika psycopg2-binary \
    pymssql pymongo python-digitalocean pyyaml redis requests virtualenv

# Update PATH to include the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Install Node.js tools
RUN npm install -g artillery forever localtunnel tldr

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Detect architecture and set variables for architecture-specific downloads
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        echo "export ARCH_NAME=amd64" >> /etc/profile.d/arch.sh; \
        echo "export ARCH_NAME_AWS=x86_64" >> /etc/profile.d/arch.sh; \
        echo "export ARCH_NAME_ALT=x64" >> /etc/profile.d/arch.sh; \
    elif [ "$ARCH" = "aarch64" ]; then \
        echo "export ARCH_NAME=arm64" >> /etc/profile.d/arch.sh; \
        echo "export ARCH_NAME_AWS=aarch64" >> /etc/profile.d/arch.sh; \
        echo "export ARCH_NAME_ALT=arm64" >> /etc/profile.d/arch.sh; \
    fi && \
    chmod +x /etc/profile.d/arch.sh && \
    . /etc/profile.d/arch.sh

# Install AWS CLI v2
RUN . /etc/profile.d/arch.sh && \
    curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH_NAME_AWS}.zip" -o awscliv2.zip && \
    unzip awscliv2.zip && ./aws/install && \
    rm -rf aws awscliv2.zip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Google Cloud CLI
RUN . /etc/profile.d/arch.sh && \
    if [ "$ARCH_NAME" = "amd64" ]; then \
        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz && \
        tar -xf google-cloud-cli-linux-x86_64.tar.gz && \
        ./google-cloud-sdk/install.sh --quiet && \
        rm -rf google-cloud-sdk google-cloud-cli-linux-x86_64.tar.gz; \
    elif [ "$ARCH_NAME" = "arm64" ]; then \
        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-arm.tar.gz && \
        tar -xf google-cloud-cli-linux-arm.tar.gz && \
        ./google-cloud-sdk/install.sh --quiet && \
        rm -rf google-cloud-sdk google-cloud-cli-linux-arm.tar.gz; \
    fi

# Kubernetes tools
RUN . /etc/profile.d/arch.sh && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH_NAME}/kubectl" && \
    install -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl && \
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash && \
    curl -sL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_${ARCH_NAME}.tar.gz | tar xz -C /usr/local/bin k9s && \
    git clone https://github.com/jonmosco/kube-ps1.git /opt/kube-ps1 && \
    echo 'source /opt/kube-ps1/kube-ps1.sh' >> /root/.zshrc && echo 'PS1="$(kube_ps1)$PS1"' >> /root/.zshrc && \
    git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens && \
    curl -s https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh | bash && \
    mv kustomize /usr/local/bin/

# Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" > /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y --no-install-recommends terraform && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# MongoDB tools
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor > /usr/share/keyrings/mongo.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/mongo.gpg arch=amd64,arm64] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-7.0.list && \
    apt-get update && apt-get install -y mongodb-mongosh mongodb-database-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# DigitalOcean and Hetzner CLI
RUN . /etc/profile.d/arch.sh && \
    curl -sL https://github.com/digitalocean/doctl/releases/download/$(curl -s https://api.github.com/repos/digitalocean/doctl/releases/latest | jq -r .tag_name)/doctl-$(curl -s https://api.github.com/repos/digitalocean/doctl/releases/latest | jq -r .tag_name | sed 's/v//g')-linux-${ARCH_NAME}.tar.gz | tar xz -C /usr/local/bin doctl && \
    curl -sL https://github.com/hetznercloud/cli/releases/download/$(curl -s https://api.github.com/repos/hetznercloud/cli/releases/latest | jq -r .tag_name)/hcloud-linux-${ARCH_NAME}.tar.gz | tar xz -C /usr/local/bin hcloud

# Install krew + plugins
RUN . /etc/profile.d/arch.sh && set -eux; cd "$(mktemp -d)" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/$(curl -s https://api.github.com/repos/kubernetes-sigs/krew/releases/latest | jq -r .tag_name)/krew-linux_${ARCH_NAME}.tar.gz" && \
    tar zxvf krew-linux_${ARCH_NAME}.tar.gz && \
    ./krew-linux_${ARCH_NAME} install krew && \
    kubectl krew install ctx ns resource-capacity view-utilization

# Install Ruby tools
RUN gem install sidekiq redis sinatra

# Copy scripts and make executable
COPY scripts/ /opt/tools/
RUN chmod -R +x /opt/tools/

# Set aliases and welcome message
RUN echo 'alias k=kubectl' >> /root/.zshrc && \
    echo 'source /opt/venv/bin/activate' >> /root/.zshrc && \
    echo 'source /etc/profile.d/arch.sh' >> /root/.zshrc && \
    echo 'echo "Welcome to the DevOps/SRE Toolkit Container!"' >> /root/.zshrc && \
    echo 'echo "Tools and scripts are in /opt/tools/*"' >> /root/.zshrc && \
    echo 'echo "Try \`tldr\` for simplified man pages."' >> /root/.zshrc

WORKDIR /root
SHELL ["/bin/zsh", "-c"]
CMD ["/bin/zsh"]

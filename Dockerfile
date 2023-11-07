FROM kalilinux/kali-rolling
LABEL NAME="k8tlery" MAINTAINER="xoph"

WORKDIR /tmp

RUN apt update && apt install -y  curl wget neovim htop nmap python3 python3-pip \
    dnsutils ca-certificates iputils-arping iputils-ping iputils-tracepath net-tools git \
    unzip whois tcpdump openssl proxychains-ng procps zmap netcat-openbsd masscan \
    nikto wordlists jq yq iproute2 stress-ng libxcb-shape0 libxcb-render-util0 \
    && apt-get clean && rm -rf /var/lib/lists/*

ENV DOCKER_VERSION=24.0.6
ENV KUBECTL_VERSION=1.28.2
ENV CRICTL_VERSION=1.28.0
#ENV HELM_VERSION=3.2.2
#ENV HELMV2_VERSION=2.16.7
ENV AUDIT2RBAC_VERSION=0.10.0
ENV AMICONTAINED_VERSION=0.4.9
ENV KUBESEC_VERSION=2.13.0
ENV CFSSL_VERSION=1.6.4
ENV AMASS_VERSION=4.2.0
ENV KUBECTL_WHOCAN_VERSION=0.4.0
ENV ETCDCTL_VERSION=3.4.9
ENV KUBEBENCH_VERSION=0.6.17
ENV GITLEAKS_VERSION=8.18.0
ENV TLDR_VERSION=0.6.1
ENV GOBUSTER_VERSION=3.6.0
ENV KUBELETCTL_VERSION=1.11
ENV NETASSERT_VERSION=2.0.2
ENV KUBEAUDIT_VERSION=0.22.0
ENV KDIGGER_VERSION=1.5.0
ENV PEIRATES_VERSION=1.1.13
ENV POPEYE_VERSION=0.11.1
ENV HADOLINT_VERSION=2.10.0
#ENV CONFTEST_VERSION=0.45.0
ENV JLESS_VERSION=0.9.0
ENV TRUFFLEHOG_VERSION=3.56.1

COPY res/.bashrc /root/.bashrc

# Install kubectl
RUN curl -LO https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && mv kubectl /usr/local/bin/kubectl \
    && chmod a+x /usr/local/bin/kubectl

# Install crictl
RUN curl -fSLO https://github.com/kubernetes-sigs/cri-tools/releases/download/v${CRICTL_VERSION}/crictl-v${CRICTL_VERSION}-linux-amd64.tar.gz \
    && tar -xvzf crictl-v${CRICTL_VERSION}-linux-amd64.tar.gz \
    && mv crictl /usr/local/bin/crictl \
    && chmod a+x /usr/local/bin/crictl

# Install kubeaudit
RUN curl -fSLO https://github.com/Shopify/kubeaudit/releases/download/v${KUBEAUDIT_VERSION}/kubeaudit_${KUBEAUDIT_VERSION}_linux_amd64.tar.gz \
    && tar -xvzf kubeaudit_${KUBEAUDIT_VERSION}_linux_amd64.tar.gz \
    && mv kubeaudit /usr/local/bin/kubeaudit \
    && chmod a+x /usr/local/bin/kubeaudit

# Install kube-bench
RUN curl -fSLO https://github.com/aquasecurity/kube-bench/releases/download/v${KUBEBENCH_VERSION}/kube-bench_${KUBEBENCH_VERSION}_linux_amd64.deb \
    && dpkg -i kube-bench_${KUBEBENCH_VERSION}_linux_amd64.deb \
    && curl -fSLO https://github.com/aquasecurity/kube-bench/archive/refs/tags/v${KUBEBENCH_VERSION}.tar.gz

# Install Popeye
RUN curl -fSLO https://github.com/derailed/popeye/releases/download/v${POPEYE_VERSION}/popeye_Linux_x86_64.tar.gz \
    && tar -xvzf popeye_Linux_x86_64.tar.gz \
    && mv popeye /usr/local/bin/popeye \
    && chmod a+x /usr/local/bin/popeye

# Install Hadolint
RUN curl -fSL https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 -o /usr/local/bin/hadolint \
    && chmod a+x /usr/local/bin/hadolint

# Install Conftest
#RUN curl -fSLO https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
#    && tar -xvzf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
#    && mv conftest /usr/local/bin/conftest \
#    && chmod a+x /usr/local/bin/conftest

# Install Helm
#RUN curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
#    && tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
#    && mv linux-amd64/helm /usr/local/bin/helm \
#    && chmod a+x /usr/local/bin/helm

# Install Helm v2
#RUN curl -LO https://get.helm.sh/helm-v${HELMV2_VERSION}-linux-amd64.tar.gz \
#    && tar -zxvf helm-v${HELMV2_VERSION}-linux-amd64.tar.gz \
#    && mv linux-amd64/helm /usr/local/bin/helm2 \
#    && chmod a+x /usr/local/bin/helm2

# Install audit2rbac
#RUN curl -LO https://github.com/liggitt/audit2rbac/releases/download/v${AUDIT2RBAC_VERSION}/audit2rbac-linux-amd64.tar.gz

# Install amicontained
RUN curl -fSL https://github.com/genuinetools/amicontained/releases/download/v${AMICONTAINED_VERSION}/amicontained-linux-amd64 -o /usr/local/bin/amicontained \
    && chmod a+x /usr/local/bin/amicontained

# Install netassert
RUN curl -fSLO https://github.com/controlplaneio/netassert/releases/download/v${NETASSERT_VERSION}/netassert_v${NETASSERT_VERSION}_linux_amd64.tar.gz \
    && tar -xvzf netassert_v${NETASSERT_VERSION}_linux_amd64.tar.gz \
    && mv netassert /usr/local/bin/netassert \
    && chmod a+x /usr/local/bin/netassert

# Install kubesec
RUN curl -fSLO https://github.com/controlplaneio/kubesec/releases/download/v${KUBESEC_VERSION}/kubesec_linux_amd64.tar.gz \
    && tar -xvzf kubesec_linux_amd64.tar.gz \
    && mv kubesec /usr/local/bin/kubesec \
    && chmod a+x /usr/local/bin/kubesec

# Install cfssl
RUN curl -fSL https://github.com/cloudflare/cfssl/releases/download/v${CFSSL_VERSION}/cfssl_${CFSSL_VERSION}_linux_amd64 -o /usr/local/bin/cfssl \
    && chmod a+x /usr/local/bin/cfssl

# Install Amass
RUN curl -fSLO https://github.com/owasp-amass/amass/releases/download/v${AMASS_VERSION}/amass_linux_amd64.zip \
    && unzip amass_linux_amd64.zip \
    && mv amass_Linux_amd64/amass /usr/local/bin/amass \
    && mv amass_Linux_amd64/examples/ /root/amass_examples \
    && chmod a+x /usr/local/bin/amass

# Install kubectl-who-can
RUN curl -fSLO https://github.com/aquasecurity/kubectl-who-can/releases/download/v${KUBECTL_WHOCAN_VERSION}/kubectl-who-can_linux_x86_64.tar.gz \
    && tar -xvzf kubectl-who-can_linux_x86_64.tar.gz \
    && mv kubectl-who-can /usr/local/bin/kubectl-who-can \
    && chmod a+x /usr/local/bin/kubectl-who-can

# Install Docker
RUN curl -fSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
    && tar -xvzf docker-${DOCKER_VERSION}.tgz \
    && mv docker/* /usr/local/bin/ \
    && chmod a+x /usr/local/bin/docker

# Install etcdctl
RUN curl -fSLO https://github.com/etcd-io/etcd/releases/download/v${ETCDCTL_VERSION}/etcd-v${ETCDCTL_VERSION}-linux-amd64.tar.gz \
    && tar -xvzf etcd-v${ETCDCTL_VERSION}-linux-amd64.tar.gz \
    && mv etcd-v${ETCDCTL_VERSION}-linux-amd64/etcdctl /usr/local/bin/ \
    && chmod a+x /usr/local/bin/etcdctl

# Clone docker-bench-security
COPY res/docker-bench.sh /usr/local/bin/docker-bench.sh
RUN git clone https://github.com/docker/docker-bench-security.git /root/docker-bench-security \
    && chmod a+x /usr/local/bin/docker-bench.sh \
    && ln -s /usr/local/bin/docker-bench.sh /usr/local/bin/docker-bench

# Clone Lynis
RUN git clone https://github.com/CISOfy/lynis /root/lynis

# Clone testssl.sh
RUN git clone --depth 1 https://github.com/drwetter/testssl.sh.git /usr/share/testssl \
    && ln -s /usr/share/testssl/testssl.sh /usr/local/bin/testssl

# Install gitleaks
RUN curl -fSLO https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz \
    && tar -xzvf gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz \
    && mv gitleaks /usr/local/bin/gitleaks \
    && chmod a+x /usr/local/bin/gitleaks

# Install LinEnum
RUN curl -fSL https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -o /usr/local/bin/linenum \
    && chmod a+x /usr/local/bin/linenum

# Clone unix-privesc-check
RUN git clone --depth 1 https://github.com/pentestmonkey/unix-privesc-check.git /root/unix-privesc-check

# Install linux-exploit-suggester
RUN curl -fSL https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -o /usr/local/bin/linux-exploit-suggester \
    && chmod a+x /usr/local/bin/linux-exploit-suggester

# Install postenum
RUN curl -fSL https://raw.githubusercontent.com/mbahadou/postenum/master/postenum.sh -o /usr/local/bin/postenum \
    && chmod a+x /usr/local/bin/postenum

# Install gobuster
RUN curl -fsLO https://github.com/OJ/gobuster/releases/download/v${GOBUSTER_VERSION}/gobuster_Linux_x86_64.tar.gz \
    && tar -xzvf gobuster_Linux_x86_64.tar.gz \
    && mv gobuster /usr/local/bin/gobuster \
    && chmod a+x /usr/local/bin/gobuster

# Install kubeletctl
RUN curl -fsLO https://github.com/cyberark/kubeletctl/releases/download/v${KUBELETCTL_VERSION}/kubeletctl_linux_amd64 \
    && mv ./kubeletctl_linux_amd64 /usr/local/bin/kubeletctl \
    && chmod a+x /usr/local/bin/kubeletctl

# Clone kube-hunter
RUN pip3 install kube-hunter

# Install kdigger
RUN curl -fSLO https://github.com/quarkslab/kdigger/releases/download/v${KDIGGER_VERSION}/kdigger-linux-amd64 \
    && mv ./kdigger-linux-amd64 /usr/local/bin/kdigger \
    && chmod a+x /usr/local/bin/kdigger

# Install peirates
RUN curl -fSLO https://github.com/inguardians/peirates/releases/download/v${PEIRATES_VERSION}/peirates-linux-amd64.tar.xz \
    && tar -xvf peirates-linux-amd64.tar.xz \
    && mv peirates-linux-amd64/peirates /usr/local/bin/peirates \
    && chmod a+x /usr/local/bin/peirates

# Install trufflehog
RUN curl -fSLO https://github.com/trufflesecurity/trufflehog/releases/download/v${TRUFFLEHOG_VERSION}/trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz \
    && tar -xzvf trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz \
    && mv trufflehog /usr/local/bin/trufflehog \
    && chmod a+x /usr/local/bin/trufflehog

# Install jless
RUN curl -fSLO https://github.com/PaulJuliusMartinez/jless/releases/download/v${JLESS_VERSION}/jless-v${JLESS_VERSION}-x86_64-unknown-linux-gnu.zip \
    && unzip jless-v${JLESS_VERSION}-x86_64-unknown-linux-gnu.zip \
    && mv jless /usr/local/bin/ \
    && chmod a+x /usr/local/bin/jless

# Install Python dependencies
RUN pip3 install --no-cache-dir awscli trufflehog3

# Clean up
RUN rm -rf /tmp/* ;


WORKDIR /root

CMD [ "/bin/bash" ]

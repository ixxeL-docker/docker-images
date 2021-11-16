FROM alpine:latest AS builder

RUN apk update --no-cache \
    && apk add curl wget --no-cache --update \
    && ARGO_VERSION=$(curl -sSL "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq) \
    && curl -sSL -o /usr/local/bin/argocd "https://github.com/argoproj/argo-cd/releases/download/${ARGO_VERSION}/argocd-linux-amd64" \
    && chmod +x /usr/local/bin/argocd \
    && curl -LO "https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64" \
    && chmod +x ./kubectl-argo-rollouts-linux-amd64 \
    && mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts \
    && HELM_VERSION=$(curl -sSL "https://github.com/kubernetes/helm/releases/latest" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq) \
    && curl -sSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" | tar xzv \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && curl -sSL "https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz" -o /tmp/oc.tar.gz \
    && tar -xzvf /tmp/oc.tar.gz -C /bin \
    && rm /tmp/oc.tar.gz \
    && KUBECTL_VERSION=$(curl -s "https://storage.googleapis.com/kubernetes-release/release/stable.txt") \
    && curl -sSLO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && VAULT_VERSION=$(curl -sSL "https://releases.hashicorp.com/vault" | grep -oE '/[0-9]+\.[0-9]+\.[0-9]+/' | head -1 | sed 's/\///g') \
    && wget -q "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" -O "/tmp/vault_${VAULT_VERSION}_linux_amd64.zip" \
    && unzip "/tmp/vault_${VAULT_VERSION}_linux_amd64.zip" -d /usr/local/bin \
    && ENVCONSUL_VERSION=$(curl -sSL "https://releases.hashicorp.com/envconsul" | grep -oE '/[0-9]+\.[0-9]+\.[0-9]+/' | head -1 | sed 's/\///g') \
    && wget -q "https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip" -O "/tmp/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip" \
    && unzip "/tmp/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip" -d /usr/local/bin \
    && curl -fL "https://getcli.jfrog.io" | sh \
    && mv jfrog /usr/local/bin \
    && curl -sSfL "https://raw.githubusercontent.com/anchore/grype/main/install.sh" | sh -s -- -b /usr/local/bin

FROM alpine:latest

LABEL maintainer="Frederic Spiers <fredspiers@gmail.com>" \
      component="CI/CD tools"

ENV TZ="Europe/Paris" \
    IMG_VERSION="1.0.1"

COPY --from=builder /bin/oc /bin/
COPY --from=builder /usr/local/bin/kubectl-argo-rollouts /usr/local/bin/grype /usr/local/bin/jfrog /usr/local/bin/envconsul /usr/local/bin/vault /usr/local/bin/argocd /usr/local/bin/helm /usr/local/bin/kubectl /usr/local/bin/

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk update --no-cache \
    && apk upgrade --no-cache \  
    && apk add --no-cache --update \
    libc6-compat \
    podman \
    skopeo \
    buildah \
    git \
    wget \
    curl \
    gettext \
    bash \
    jq \
    yq \
    python3 \
    py3-pip \
    bind-tools \
    tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && rm -f /var/lib/containers/storage/libpod/bolt_state.db \
    && sed -i "s/driver = \"overlay\"/driver = \"vfs\"/" /etc/containers/storage.conf \
    && pip3 install --no-cache-dir awxkit ansible-tower-cli \
    && apk add trivy --no-cache --update --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

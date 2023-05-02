FROM alpine:latest AS builder

RUN apk update --no-cache \
    && apk add curl wget --no-cache --update \
    && ARGO_VERSION=$(curl -sSL "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq) \
    && curl -sSL -o /usr/local/bin/argocd "https://github.com/argoproj/argo-cd/releases/download/${ARGO_VERSION}/argocd-linux-amd64" \
    && chmod +x /usr/local/bin/argocd \
    && HELM_VERSION=$(curl -sSL "https://github.com/kubernetes/helm/releases/latest" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq) \
    && curl -sSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" | tar xzv \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && curl -sSL "https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz" -o /tmp/oc.tar.gz \
    && tar -xzvf /tmp/oc.tar.gz -C /bin \
    && rm /tmp/oc.tar.gz \
    && KUBECTL_VERSION=$(curl -s "https://storage.googleapis.com/kubernetes-release/release/stable.txt") \
    && curl -sSLO "https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && VAULT_VERSION=$(curl -sSL "https://releases.hashicorp.com/vault" | grep -oE '/[0-9]+\.[0-9]+\.[0-9]+/' | head -1 | sed 's/\///g') \
    && wget -q "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" -O "/tmp/vault_${VAULT_VERSION}_linux_amd64.zip" \
    && unzip "/tmp/vault_${VAULT_VERSION}_linux_amd64.zip" -d /usr/local/bin \
    && ENVCONSUL_VERSION=$(curl -sSL "https://releases.hashicorp.com/envconsul" | grep -oE '/[0-9]+\.[0-9]+\.[0-9]+/' | head -1 | sed 's/\///g') \
    && wget -q "https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip" -O "/tmp/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip" \
    && unzip "/tmp/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip" -d /usr/local/bin \
    && curl -fL "https://getcli.jfrog.io" | sh \
    && mv jfrog /usr/local/bin

FROM minio/mc:latest AS minio

FROM fortio/fortio:latest AS tempfortio 

######################################################
######################################################

FROM alpine:3.14

ARG IMG_VERSION="1.0.0"

LABEL maintainer="Frederic Spiers <fredspiers@gmail.com>" \
      component="CI/CD tools" \
      feature.homebin=false \
      feature.kubectlrun=false \
      apps.version=$VERSION 

# Environment Variables
#######################
ENV TZ="Europe/Paris"
ENV VERSION=$VERSION
ENV APK_PACKAGES="podman skopeo buildah git curl wget bash jq yq gettext python3 py3-pip bind-tools"
ENV BIN_PACKAGES="oc argocd helm kubectl vault fortio"
ENV BIN_PACKAGES_VERSION="envconsul jfrog mc"
ENV PIP_PACKAGES="awxkit ansible-tower-cli"

# Install native packages
#########################
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk update --no-cache \
    && apk upgrade --no-cache \  
    && apk add --no-cache --update $APK_PACKAGES \
    # libc6 is required for oc binary
    libc6-compat \
    && rm -f /var/lib/containers/storage/libpod/bolt_state.db \
    && sed -i "s/driver = \"overlay\"/driver = \"vfs\"/" /etc/containers/storage.conf \
    && pip3 install --no-cache-dir $PIP_PACKAGES

# External binaries will be installed only in /usr/local/bin
###################################################
COPY --from=builder /bin/oc /usr/local/bin/argocd /usr/local/bin/helm /usr/local/bin/kubectl /usr/local/bin/vault /usr/local/bin/envconsul /usr/local/bin/jfrog /usr/local/bin/
COPY --from=minio /bin/mc /usr/local/bin
COPY --from=tempfortio /usr/bin/fortio /usr/local/bin/fortio

# Create dynamically version.sh script
RUN { \
    echo '#!/bin/bash'; \
    echo "echo VERSION=$VERSION"; \
    echo "apk version $APK_PACKAGES"; \
    echo "pip3 list PIP_PACKAGES"; \
    echo "echo ------------------"; \
    echo "echo "; \
    echo "for apps in $BIN_PACKAGES ;do echo \${apps}; echo ---; \${apps} version; echo ; done"; \
    echo "for apps in $BIN_PACKAGES_VERSION ; do echo \${apps}; echo ---;  \${apps} --version; echo; done"; \
  } > /usr/local/bin/version.sh \
  && chmod a+x  /usr/local/bin/version.sh

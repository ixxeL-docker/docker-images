# checkov:skip=CKV_DOCKER_2: This is not a running container. Its purpose is to be used in CI pipeline jobs
# checkov:skip=CKV_DOCKER_3: GH actions must be root to work
# checkov:skip=CKV_DOCKER_8: GH actions must be root to work
ARG BASE_REGISTRY
FROM ${BASE_REGISTRY}python:3.11-alpine3.17



ENV TZ="Europe/Paris"

LABEL maintainer="fredspiers@gmail.com"
LABEL org.opencontainers.image.authors="FSPIERS"
LABEL org.opencontainers.image.title="ci-helm-toolbox"
LABEL org.opencontainers.image.source="https://github.com/ixxeL-docker/docker-images/blob/main/src/helm/Dockerfile"
LABEL org.opencontainers.image.base.name="python:3.11-alpine3.17"

RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache --update \
    curl \
    bash \
    jq \
    yq \
    git \
    util-linux \
    shellcheck \
    yamllint \
    black \
    moreutils \
    make \
    gradle \
    tzdata && \
    apk add --no-cache --update --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community" \
    helm && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime

RUN helm plugin install "https://github.com/chartmuseum/helm-push" && \
    helm plugin install "https://github.com/datreeio/helm-datree" && \
    helm plugin install "https://github.com/helm-unittest/helm-unittest"

RUN pip3 install --no-cache-dir --upgrade checkov

ENV HELM_PLUGINS=/root/.local/share/helm/plugins


RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --update \
    curl \
    bash \
    git \
    shellcheck \
    jq \
    black \
    yamllint \
    util-linux \
    moreutils \
    ca-certificates \
    tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && helm plugin install "https://github.com/chartmuseum/helm-push" \
    && helm plugin install "https://github.com/databus23/helm-diff" \
    && helm plugin install "https://github.com/datreeio/helm-datree" \
    && helm plugin install "https://github.com/helm-unittest/helm-unittest.git" \
    && apk add --no-cache --update --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community" \
    github-cli \
    yq \
    podman \
    && sed -i 's/^#mount_program/mount_program/' /etc/containers/storage.conf \
    # && rm -f /var/lib/containers/storage/libpod/bolt_state.db \
    # && sed -i "s/driver = \"overlay\"/driver = \"vfs\"/" /etc/containers/storage.conf \
    && update-ca-certificates







# checkov:skip=CKV_DOCKER_2: This is not a running container. Its purpose is to be used in CI pipeline jobs
ARG BASE_REGISTRY
FROM ${BASE_REGISTRY}alpine:3.17 AS builder

ARG RELEASE_CLI=v0.15.0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk update --no-cache \
    && apk add tar curl unzip bash gzip wget --no-cache --update \
    && curl -o /usr/local/bin/gitlab-helper -sSfL "https://s3.eu-central-1.amazonaws.com/valmano-gitlab-helper/gitlab-helper" \
    && chmod +x /usr/local/bin/gitlab-helper \
    && curl -sSfLO "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64" \
    && chmod +x hadolint-Linux-x86_64 \
    && mv ./hadolint-Linux-x86_64 /usr/local/bin/hadolint \
    && curl -sSfL "https://github.com/stackrox/kube-linter/releases/latest/download/kube-linter-linux.tar.gz" | tar -xz \
    && chmod +x kube-linter \
    && mv ./kube-linter /usr/local/bin/kube-linter \
    && curl -sSfL "https://github.com/controlplaneio/kubesec/releases/latest/download/kubesec_linux_amd64.tar.gz" | tar -xz \
    && chmod +x kubesec \
    && mv ./kubesec /usr/local/bin/kubesec \
    && KUBE_SCORE_VERSION=$(curl -L "https://github.com/zegl/kube-score/releases/latest/" | grep -Eo "^\\s+v[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}$" | sed 's/ //g' | sort -rV | uniq | head -1) \
    && KUBE_SCORE_VER_LIGHT=$(echo "$KUBE_SCORE_VERSION" | sed 's/v//g') \
    && curl -sSfL "https://github.com/zegl/kube-score/releases/download/${KUBE_SCORE_VERSION}/kube-score_${KUBE_SCORE_VER_LIGHT}_linux_amd64.tar.gz" | tar -xz \
    && chmod +x kube-score \
    && mv ./kube-score /usr/local/bin/kube-score \
    && curl -sSfL -o /usr/local/bin/semver "https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver" \
    && chmod +x /usr/local/bin/semver \
    && HELM_VERSION=$(curl -L "https://github.com/kubernetes/helm/releases/latest" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq | tail -1) \
    && curl -sSfL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" | tar -xzv \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && curl -sSfLO "https://storage.googleapis.com/container-structure-test/latest/container-structure-test-linux-amd64" \
    && chmod +x container-structure-test-linux-amd64 \
    && mv container-structure-test-linux-amd64 /usr/local/bin/container-structure-test \
    && curl -sSfL "https://github.com/aelsabbahy/goss/releases/latest/download/goss-linux-amd64" -o /usr/local/bin/goss \
    && chmod +rx /usr/local/bin/goss \
    && curl -sSfL "https://raw.githubusercontent.com/aelsabbahy/goss/master/extras/dgoss/dgoss" -o /usr/local/bin/dgoss \
    && chmod +rx /usr/local/bin/dgoss \
    && DIVE_VERSION=$(curl -L "https://github.com/wagoodman/dive/releases/latest" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq | tail -1) \
    && DIVE_VERSION_LIGHT=$(echo "${DIVE_VERSION}" | sed 's/v//g') \
    && curl -sSfL "https://github.com/wagoodman/dive/releases/download/${DIVE_VERSION}/dive_${DIVE_VERSION_LIGHT}_linux_amd64.tar.gz" | tar -xz \
    && chmod +x dive \
    && mv ./dive /usr/local/bin/dive \
    && curl -sSfL "https://get.datree.io" | /bin/bash \
    && curl -sSfLO "https://gitlab.com/gitlab-org/release-cli/-/releases/${RELEASE_CLI}/downloads/bin/release-cli-linux-amd64" \
    && chmod +x ./release-cli-linux-amd64 \
    && mv ./release-cli-linux-amd64 /usr/local/bin/release-cli

FROM ${BASE_REGISTRY}ixxel/musl-dns-hack-alpine as dnshack

FROM ${BASE_REGISTRY}python:3.11-alpine3.17

LABEL maintainer="Frederic Spiers <fredspiers@gmail.com>" \
      component="CI/CD tools"

ARG BUILD_VERSION

ENV TZ="Europe/Paris" \
    IMG_VERSION="$BUILD_VERSION"

COPY ./pki_root_ca.pem /usr/local/share/ca-certificates/root.crt
COPY ./pki_int_ca.pem /usr/local/share/ca-certificates/int.crt

COPY --from=dnshack /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1

COPY --from=builder /usr/local/bin/helm \
                    /usr/local/bin/kube-score \
                    /usr/local/bin/kubesec \
                    /usr/local/bin/hadolint \
                    /usr/local/bin/kube-linter \
                    /usr/local/bin/semver \
                    /usr/local/bin/container-structure-test \
                    /usr/local/bin/goss \
                    /usr/local/bin/dgoss \
                    /usr/local/bin/dive \
                    /usr/local/bin/datree \
                    /usr/local/bin/gitlab-helper \
                    /usr/local/bin/release-cli \
                    /usr/local/bin/

WORKDIR /usr/app 

RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --update \
    curl \
    bash \
    git \
    shellcheck \
    jq \
    black \
    yamllint \
    util-linux \
    moreutils \
    ca-certificates \
    tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && helm plugin install "https://github.com/chartmuseum/helm-push" \
    && helm plugin install "https://github.com/databus23/helm-diff" \
    && helm plugin install "https://github.com/datreeio/helm-datree" \
    && helm plugin install "https://github.com/helm-unittest/helm-unittest.git" \
    && apk add --no-cache --update --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community" \
    github-cli \
    yq \
    podman \
    && sed -i 's/^#mount_program/mount_program/' /etc/containers/storage.conf \
    # && rm -f /var/lib/containers/storage/libpod/bolt_state.db \
    # && sed -i "s/driver = \"overlay\"/driver = \"vfs\"/" /etc/containers/storage.conf \
    && update-ca-certificates
    
RUN pip3 install --no-cache-dir --upgrade flake8 \
                                          flake8-json \
                                          pytest \
                                          pytest-cov \
                                          coverage \
                                          bandit \
                                          yamlfix \
                                          python-gitlab \
                                          envparse \
                                          checkov

ENV HELM_PLUGINS="/root/.local/share/helm/plugins"

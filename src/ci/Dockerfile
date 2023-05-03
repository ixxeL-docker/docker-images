# checkov:skip=CKV_DOCKER_2: This is not a running container. Its purpose is to be used in CI pipeline jobs
# checkov:skip=CKV_DOCKER_3: GH actions must be root to work
# checkov:skip=CKV_DOCKER_8: GH actions must be root to work
ARG BASE_REGISTRY

FROM ${BASE_REGISTRY}alpine:3.17 AS builder

ARG RELEASE_CLI=v0.15.0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk update --no-cache && \
    apk add tar curl --no-cache --update && \
    curl -sSfLO "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64" && \
    chmod +x hadolint-Linux-x86_64 && \
    mv ./hadolint-Linux-x86_64 /usr/local/bin/hadolint && \
    GH_VERSION=$(curl -sSfL "https://github.com/cli/cli/releases/latest" | grep -Eo "^\\s+v[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}" | sed 's/ //g' | sort -rV | uniq | head -1) && \
    GH_VERSION_LIGHT=$(echo "$GH_VERSION" | sed 's/v//g') && \
    curl -sSfL "https://github.com/cli/cli/releases/download/${GH_VERSION}/gh_${GH_VERSION_LIGHT}_linux_amd64.tar.gz" | tar -xz && \
    mv ./gh_${GH_VERSION_LIGHT}_linux_amd64/bin/gh /usr/local/bin

FROM ${BASE_REGISTRY}python:3.11-alpine3.17

ENV TZ="Europe/Paris"

LABEL maintainer="fredspiers@gmail.com"
LABEL org.opencontainers.image.authors="FSPIERS"
LABEL org.opencontainers.image.title="ci-toolbox"
LABEL org.opencontainers.image.source="https://github.com/ixxeL-docker/docker-images/blob/main/src/ci/Dockerfile"
LABEL org.opencontainers.image.base.name="python:3.11-alpine3.17"

COPY --from=builder /usr/local/bin/helm \
                    /usr/local/bin/hadolint \
                    /usr/local/bin/gh \
                    /usr/local/bin/

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
    yarn \
    tzdata && \
    apk add --no-cache --update --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community" \
    helm && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime

RUN pip3 install --no-cache-dir --upgrade checkov

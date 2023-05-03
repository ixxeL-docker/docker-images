# checkov:skip=CKV_DOCKER_2: This is not a running container. Its purpose is to be used in CI pipeline jobs
# checkov:skip=CKV_DOCKER_3: GH actions must be root to work
# checkov:skip=CKV_DOCKER_8: GH actions must be root to work
ARG BASE_REGISTRY

FROM ${BASE_REGISTRY}alpine:3.17 AS builder

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk update --no-cache && \
    apk add tar curl --no-cache --update && \
    curl -sSfLO "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64" && \
    chmod +x hadolint-Linux-x86_64 && \
    mv ./hadolint-Linux-x86_64 /usr/local/bin/hadolint

FROM ${BASE_REGISTRY}python:3.11-alpine3.17

ENV TZ="Europe/Paris"

LABEL maintainer="fredspiers@gmail.com"
LABEL org.opencontainers.image.authors="FSPIERS"
LABEL org.opencontainers.image.title="ci-toolbox"
LABEL org.opencontainers.image.source="https://github.com/ixxeL-docker/docker-images/blob/main/src/ci/Dockerfile"
LABEL org.opencontainers.image.base.name="python:3.11-alpine3.17"

COPY --from=builder /usr/local/bin/hadolint /usr/local/bin/

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
    cp /usr/share/zoneinfo/${TZ} /etc/localtime

RUN apk add --no-cache --update --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community" \
    helm \
    github-cli

RUN pip3 install --no-cache-dir --upgrade checkov

# checkov:skip=CKV_DOCKER_2: This is not a running container. Its purpose is to be used in CI pipeline jobs
# checkov:skip=CKV_DOCKER_3: Kaniko must be root to work
# checkov:skip=CKV_DOCKER_8: Kaniko must be root to work
ARG BASE_REGISTRY

FROM ${BASE_REGISTRY}python:3.11-alpine3.17 as certs

LABEL maintainer="fredspiers@gmail.com"
LABEL org.opencontainers.image.authors="FSPIERS"
LABEL org.opencontainers.image.title="certs-toolbox"
LABEL org.opencontainers.image.source="https://github.com/ixxeL-docker/docker-images/blob/main/src/certs/Dockerfile"
LABEL org.opencontainers.image.base.name="python:3.11-alpine3.17"

ENV TZ="Europe/Paris"

COPY ./pki_root_ca.pem /usr/local/share/ca-certificates/root.crt
COPY ./pki_int_ca.pem /usr/local/share/ca-certificates/int.crt

RUN apk update --no-cache && \
    apk upgrade  --no-cache && \
    apk add --no-cache --update \
    git \
    curl \
    bash \
    jq \
    yq \
    moreutils \
    util-linux \
    tzdata \
    step-cli \
    ca-certificates && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    update-ca-certificates
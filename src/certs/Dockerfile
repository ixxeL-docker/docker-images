# checkov:skip=CKV_DOCKER_2: This is not a running container. Its purpose is to be used in CI pipeline jobs
# checkov:skip=CKV_DOCKER_3: Kaniko must be root to work
# checkov:skip=CKV_DOCKER_8: Kaniko must be root to work
ARG BASE_REGISTRY

FROM ${BASE_REGISTRY}alpine:3.17 AS builder

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk update --no-cache && \
    apk add tar curl --no-cache --update && \
    GH_VERSION=$(curl -sSfL "https://github.com/cli/cli/releases/latest" | grep -Eo "^\\s+v[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}" | sed 's/ //g' | sort -rV | uniq | head -1) && \
    GH_VERSION_LIGHT=$(echo "$GH_VERSION" | sed 's/v//g') && \
    curl -sSfL "https://github.com/cli/cli/releases/download/${GH_VERSION}/gh_${GH_VERSION_LIGHT}_linux_amd64.tar.gz" | tar -xz && \
    mv ./gh_${GH_VERSION_LIGHT}_linux_amd64/bin/gh /usr/local/bin

FROM ${BASE_REGISTRY}python:3.11-alpine3.17 as certs

LABEL maintainer="fredspiers@gmail.com"
LABEL org.opencontainers.image.authors="FSPIERS"
LABEL org.opencontainers.image.title="certs-toolbox"
LABEL org.opencontainers.image.source="https://github.com/ixxeL-docker/docker-images/blob/main/src/certs/Dockerfile"
LABEL org.opencontainers.image.base.name="python:3.11-alpine3.17"

ENV TZ="Europe/Paris"

COPY ./pki_root_ca.pem /usr/local/share/ca-certificates/root.crt
COPY ./pki_int_ca.pem /usr/local/share/ca-certificates/int.crt
COPY --from=builder /usr/local/bin/gh /usr/local/bin/

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
    ca-certificates && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    update-ca-certificates
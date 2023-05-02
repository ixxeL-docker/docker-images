# checkov:skip=CKV_DOCKER_2: This is not a running container. Its purpose is to be used in CI pipeline jobs
ARG BASE_REGISTRY
FROM ${BASE_REGISTRY}python:3.11-alpine3.17

ARG IMG_USER=pipelines

ENV TZ="Europe/Paris"

LABEL maintainer="warehousebox@decathlon.net"
LABEL org.opencontainers.image.authors="CS-WAREHOUSEBOX"
LABEL org.opencontainers.image.title="ci-helm-toolbox"
LABEL org.opencontainers.image.source="https://github.com/dktunited/whbox-docker-common/blob/master/docker/gh-actions/Dockerfile.imgbuild"
LABEL org.opencontainers.image.base.name="python:3.11-alpine3.17"

RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache --update \
    curl \
    bash \
    jq \
    yq \
    git \
    tzdata && \
    apk add --no-cache --update --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community" \
    helm && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime

RUN helm plugin install "https://github.com/chartmuseum/helm-push" && \
    helm plugin install "https://github.com/datreeio/helm-datree" && \
    helm plugin install "https://github.com/helm-unittest/helm-unittest"

RUN pip3 install --no-cache-dir --upgrade checkov

ENV IMG_USER="$IMG_USER"
ENV HELM_PLUGINS=/home/${IMG_USER}/.local/share/helm/plugins

RUN addgroup -S ${IMG_USER} && \
    adduser -S ${IMG_USER} -G ${IMG_USER}

USER ${IMG_USER}:${IMG_USER}






# checkov:skip=CKV_DOCKER_2: This is not a running container. Its purpose is to be used in CI pipeline jobs
# checkov:skip=CKV_DOCKER_3: Buildkit must be root to work
# checkov:skip=CKV_DOCKER_8: Buildkit must be root to work
ARG BASE_REGISTRY

FROM ${BASE_REGISTRY}moby/buildkit:master as buildkit

FROM ${BASE_REGISTRY}python:3.11-alpine3.17

ENV TZ="Europe/Paris"

LABEL maintainer="warehousebox@decathlon.net"
LABEL org.opencontainers.image.authors="CS-WAREHOUSEBOX"
LABEL org.opencontainers.image.title="ci-helm-toolbox"
LABEL org.opencontainers.image.source="https://github.com/dktunited/whbox-docker-common/blob/master/docker/gh-actions/Dockerfile.imgbuild"
LABEL org.opencontainers.image.base.name="python:3.11-alpine3.17"

COPY --from=buildkit /usr/bin/ /usr/bin/

RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache --update \
    fuse3 fuse-overlayfs openssh pigz shadow-uidmap xz \
    podman \
    podman-docker \
    moreutils \
    curl \
    bash \
    jq \
    yq \
    git \
    tzdata && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    sed -i 's/^#mount_program/mount_program/' /etc/containers/storage.conf

RUN apk add --update --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community" \
    cosign

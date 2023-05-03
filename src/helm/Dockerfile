# checkov:skip=CKV_DOCKER_2: This is not a running container. Its purpose is to be used in CI pipeline jobs
# checkov:skip=CKV_DOCKER_3: GH actions must be root to work
# checkov:skip=CKV_DOCKER_8: GH actions must be root to work
ARG BASE_REGISTRY
FROM ${BASE_REGISTRY}python:3.11-alpine3.17

# ARG IMG_USER=pipelines

ENV TZ="Europe/Paris"

LABEL maintainer="fredspiers@gmail.com"
LABEL org.opencontainers.image.authors="FSPIERS"
LABEL org.opencontainers.image.title="helm-toolbox"
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
    tzdata && \
    apk add --no-cache --update --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community" \
    helm && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime

RUN helm plugin install "https://github.com/chartmuseum/helm-push" && \
    helm plugin install "https://github.com/datreeio/helm-datree" && \
    helm plugin install "https://github.com/helm-unittest/helm-unittest"

RUN pip3 install --no-cache-dir --upgrade checkov

ENV HELM_PLUGINS=/root/.local/share/helm/plugins

# RUN addgroup -S ${IMG_USER} && \
#     adduser -S ${IMG_USER} -G ${IMG_USER}

# USER ${IMG_USER}:${IMG_USER} 

ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

ARG KUBECTL_VERSION
ARG HELM_VERSION

USER root

RUN set -x; \
    apt-get update && \
    apt-get -y install curl jq yq ansible && \
    rm -Rf /var/lib/apt/lists/* && \
    rm -Rf /usr/share/doc/* && rm -Rf /usr/share/doc-base/* && rm -Rf /usr/share/man/*

RUN set -x; \
    ARCH="$(dpkg --print-architecture)" && \
    # kubectl
    curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    # helm
    curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-${ARCH}.tar.gz" | tar xz --strip-components=1 -C /usr/local/bin "linux-${ARCH}/helm"

USER $SYSTEM_USER

ARG BASE_IMAGE
LABEL base.image=$BASE_IMAGE
LABEL image.usage=release
LABEL apt-get.install=curl,jq,yq,kubectl,helm

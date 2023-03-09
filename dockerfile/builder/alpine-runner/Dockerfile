ARG BASE_IMAGE

FROM ${BASE_IMAGE} as base

USER root

RUN apk update --purge --no-cache && \
    apk add --update --purge --no-cache bash && \
    apk add --update --purge --no-cache git openssh && \
    apk add --update --purge --no-cache curl && \
    apk add --update --purge --no-cache libxml2-utils && \
    apk add --update --purge --no-cache jq

# This is a builder and root needed for future installations
#USER $SYSTEM_USER

ARG BASE_IMAGE
LABEL base.image=$BASE_IMAGE
LABEL image.usage=release
LABEL apt-get.install=bash,git,openssh,curl,libxml2-utils,jq

ARG BASE_IMAGE

FROM ${BASE_IMAGE} as base

USER root

RUN apk add --purge --no-cache --no-interactive --no-progress bash git openssh curl libxml2-utils jq unzip

# This is a builder and root needed for future installations
#USER $SYSTEM_USER

ARG BASE_IMAGE
LABEL base.image=$BASE_IMAGE
LABEL image.usage=release
LABEL apt-get.install=bash,git,openssh,curl,libxml2-utils,jq,unzip

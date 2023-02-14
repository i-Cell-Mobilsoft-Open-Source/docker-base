ARG BASE_IMAGE

FROM ${BASE_IMAGE} as base

USER root

RUN set -x; \
    apt-get update; \
    apt-get -y install curl

USER $SYSTEM_USER

ARG BASE_IMAGE
LABEL base.image=$BASE_IMAGE
LABEL image.usage=release
LABEL apt-get.install=curl

ARG BASE_IMAGE
ARG JRE_TEMURIN_IMAGE
################################################################################
# Create jre copy image
# https://hub.docker.com/_/eclipse-temurin
################################################################################
FROM ${JRE_TEMURIN_IMAGE} as jre-build

## Create a custom Java runtime
#RUN $JAVA_HOME/bin/jlink \
#         --add-modules java.base \
#         --strip-debug \
#         --no-man-pages \
#         --no-header-files \
#         --compress=2 \
#         --output /javaruntime

################################################################################
# Create production image
################################################################################
FROM ${BASE_IMAGE} as base

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "$JAVA_HOME/bin:${PATH}"

USER root

# Required font packages for Excel generation (fontconfig, fonts-dejavu)
RUN set -x; \
    apt-get update && \
    apt-get -y install fontconfig fonts-dejavu jq && \
    rm -Rf /var/lib/apt/lists/* && \
    rm -Rf /usr/share/doc/* && rm -Rf /usr/share/doc-base/* && rm -Rf /usr/share/man/*

COPY --from=jre-build --chown=$SYSTEM_USER:$SYSTEM_USER_GROUP $JAVA_HOME $JAVA_HOME

USER $SYSTEM_USER

ARG BASE_IMAGE
ARG JRE_TEMURIN_IMAGE
LABEL base.image=$BASE_IMAGE
LABEL image.usage=release
LABEL builder.images=$JRE_TEMURIN_IMAGE
LABEL java.image=$JRE_TEMURIN_IMAGE
LABEL apt-get.install=fontconfig,fonts-dejavu

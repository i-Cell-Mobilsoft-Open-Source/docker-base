ARG BASE_BUILDER_IMAGE
FROM ${BASE_BUILDER_IMAGE}

ENV GALLEON_HOME=$HOME/galleon

ARG GALLEON_VERSION
ENV GALLEON_VERSION=${GALLEON_VERSION}

ARG DOWNLOAD_DIR=$HOME/download

USER root
RUN set -x; \
    apt-get -y install unzip && \
    mkdir -m u=rwx,g=rwx,o=rx -p $DOWNLOAD_DIR $GALLEON_HOME && \
    chown -R $SYSTEM_USER:$SYSTEM_USER_GROUP $DOWNLOAD_DIR $GALLEON_HOME

USER $SYSTEM_USER

WORKDIR $DOWNLOAD_DIR
# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN curl -O -L https://github.com/wildfly/galleon/releases/download/${GALLEON_VERSION}/galleon-${GALLEON_VERSION}.zip && \
    unzip -q galleon-${GALLEON_VERSION}.zip && \
    mv galleon-${GALLEON_VERSION}/* ${GALLEON_HOME} && \
    rm -rf galleon-${GALLEON_VERSION} galleon-${GALLEON_VERSION}.zip

WORKDIR $GALLEON_HOME

ARG BASE_BUILDER_IMAGE
LABEL base.image=$BASE_BUILDER_IMAGE
LABEL image.usage=builder
LABEL galleon.version=$GALLEON_VERSION
LABEL galleon.home=$GALLEON_HOME
LABEL apt-get.install=unzip

ARG BASE_IMAGE
ARG JDK_TEMURIN_IMAGE
################################################################################
# Create jdk copy image
# https://hub.docker.com/_/eclipse-temurin
################################################################################
FROM ${JDK_TEMURIN_IMAGE} as jdk-build

################################################################################
# Create maven jdk image
################################################################################
FROM ${BASE_IMAGE} as base

ARG MAVEN_VERSION
ENV MAVEN_VERSION=${MAVEN_VERSION}

ARG DOWNLOAD_DIR_DEFAULT=$HOME/download
ENV DOWNLOAD_DIR=$DOWNLOAD_DIR_DEFAULT
ENV MAVEN_HOME=$HOME/maven
ENV MAVEN_CONFIG=$HOME/.m2

# SHA key to validate the maven download
ARG MAVEN_SHA=${MAVEN_SHA}
ARG MAVEN_DOWNLOAD_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries

USER root
#  Create the dirs, download, validate, install, remove downloaded file and set links
RUN set -x; \
    apt-get update && \
    apt-get -y install libxml2-utils git jq && \
    rm -Rf /var/lib/apt/lists/* && \
    rm -Rf /usr/share/doc/* && rm -Rf /usr/share/doc-base/* && rm -Rf /usr/share/man/* && \
    mkdir -m u=rwx,g=rwx,o=rx -p $DOWNLOAD_DIR $MAVEN_HOME $MAVEN_HOME/ref && \
    curl -L -X GET ${MAVEN_DOWNLOAD_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz --output $DOWNLOAD_DIR/apache-maven.tar.gz && \
    echo "Checking download hash" && \
    echo "${MAVEN_SHA}  $DOWNLOAD_DIR/apache-maven.tar.gz" | sha512sum -c - && \
    tar -xzf $DOWNLOAD_DIR/apache-maven.tar.gz -C $MAVEN_HOME --strip-components=1 && \
    chown -R $SYSTEM_USER:$SYSTEM_USER_GROUP $DOWNLOAD_DIR $MAVEN_HOME && \
    rm -f $DOWNLOAD_DIR/apache-maven.tar.gz && \
    ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn
# This is a builder and root needed for future installations
#USER $SYSTEM_USER

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "$JAVA_HOME/bin:${PATH}"

COPY --from=jdk-build --chown=$SYSTEM_USER:$SYSTEM_USER_GROUP $JAVA_HOME $JAVA_HOME

ARG BASE_IMAGE
ARG JDK_TEMURIN_IMAGE
LABEL base.image=$BASE_IMAGE
LABEL image.usage=builder
LABEL builder.images=$JDK_TEMURIN_IMAGE
LABEL maven.version=$MAVEN_VERSION
LABEL maven.home=$MAVEN_HOME

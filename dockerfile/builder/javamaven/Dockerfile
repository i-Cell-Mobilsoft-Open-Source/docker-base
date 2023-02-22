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

ENV MAVEN_VERSION=3.8.5

ARG DOWNLOAD_DIR_DEFAULT=$HOME/download
ENV DOWNLOAD_DIR=$DOWNLOAD_DIR_DEFAULT
ENV MAVEN_HOME=$HOME/maven
ENV MAVEN_CONFIG=$HOME/.m2

# SHA key to validate the maven download
ARG SHA=89ab8ece99292476447ef6a6800d9842bbb60787b9b8a45c103aa61d2f205a971d8c3ddfb8b03e514455b4173602bd015e82958c0b3ddc1728a57126f773c743
ARG BASE_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries

USER root
#  Create the dirs, download, validate, install, remove downloaded file and set links
RUN set -x; \
    mkdir -m u=rwx,g=rwx,o=rx -p $DOWNLOAD_DIR $MAVEN_HOME $MAVEN_HOME/ref && \
    curl -L -X GET ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz --output $DOWNLOAD_DIR/apache-maven.tar.gz && \
    echo "Checking download hash" && \
    echo "${SHA}  $DOWNLOAD_DIR/apache-maven.tar.gz" | sha512sum -c - && \
    tar -xzf $DOWNLOAD_DIR/apache-maven.tar.gz -C $MAVEN_HOME --strip-components=1 && \
    chown -R $SYSTEM_USER:$SYSTEM_USER_GROUP $DOWNLOAD_DIR $MAVEN_HOME && \
    rm -f $DOWNLOAD_DIR/apache-maven.tar.gz && \
    ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn
USER $SYSTEM_USER

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

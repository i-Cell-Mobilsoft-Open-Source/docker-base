ARG MAVEN_BUILD_BASE_IMAGE

################################################################################
# Create maven jdk sonar image
################################################################################
FROM ${MAVEN_BUILD_BASE_IMAGE} AS base

# SonarQube version
ENV SONAR_VERSION=9.9.8.100196
ENV SONAR_HOME=/opt/sonarqube

USER root

# Wget, unzip for install sonarqube, procps for sonar.sh script
RUN set -x; \
    apt-get update && \
    apt-get -y install wget unzip procps  && \
    rm -Rf /var/lib/apt/lists/* && \
    rm -Rf /usr/share/doc/* && rm -Rf /usr/share/doc-base/* && rm -Rf /usr/share/man/*


# letöltés és kicsomagolás
RUN wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip && \
    unzip sonarqube-${SONAR_VERSION}.zip && \
    mv sonarqube-${SONAR_VERSION} ${SONAR_HOME} && \
    rm sonarqube-${SONAR_VERSION}.zip

RUN chown -R ${SYSTEM_USER_GROUP}:${SYSTEM_USER} /opt/sonarqube

# port
EXPOSE 9000

USER $SYSTEM_USER

# At startup, run SonarQube
CMD ["sh", "-c", "${SONAR_HOME}/bin/linux-x86-64/sonar.sh console"]

ARG MAVEN_BUILD_BASE_IMAGE
LABEL base.image=$MAVEN_BUILD_BASE_IMAGE
LABEL image.usage=builder
LABEL apt-get.install=sonarqube,wget,unzip,procps

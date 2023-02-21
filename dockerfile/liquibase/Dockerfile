ARG BASE_IMAGE
ARG LIQUIBASE_IMAGE
################################################################################
# Create liquibase copy image
# https://hub.docker.com/r/liquibase/liquibase
################################################################################
FROM ${LIQUIBASE_IMAGE} as liqui

FROM ${BASE_IMAGE} as base

COPY --from=liqui --chown=$SYSTEM_USER:$SYSTEM_USER_GROUP /liquibase $HOME/liquibase

ENV PATH="$HOME/liquibase:${PATH}"

RUN mkdir $HOME/liquibase/changelog&& \
    mkdir $HOME/liquibase/classpath

WORKDIR $HOME/liquibase

ENTRYPOINT ["./docker-entrypoint.sh"]

ARG BASE_IMAGE
LABEL base.image=$BASE_IMAGE
LABEL image.usage=release
LABEL install=liquibase
LABEL liquibase.version=$LIQUIBASE_VERSION

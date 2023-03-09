ARG BASE_IMAGE

FROM ${BASE_IMAGE} as base

ARG USER_GID=101
ARG USER_UID=101
ARG SYSTEM_USER_DEFAULT=icellmobilsoft
ARG SYSTEM_USER_GROUP_DEFAULT=icellmobilsoft
ENV SYSTEM_USER=$SYSTEM_USER_DEFAULT
ENV SYSTEM_USER_GROUP=$SYSTEM_USER_GROUP_DEFAULT
ENV HOME=/home/$SYSTEM_USER

# switch to C.UTF-8, default=POSIX, locale -a -> C, C.UTF-8, POSIX
ENV LC_ALL=C.UTF-8

RUN set -x; \
    addgroup --gid $USER_GID $SYSTEM_USER_GROUP && \
# "--system": Create a system user
# "--disabled-password": Don't assign a password
# "--no-create-home": Don't create home directory
# "--uid": User id
# "--disabled-login": Login shell
# "--gid": Group
# "--gecos": GECOS field
    adduser --system --disabled-password --uid ${USER_UID} --disabled-login --gecos ${SYSTEM_USER} --gid ${USER_GID} ${SYSTEM_USER_GROUP}

USER $SYSTEM_USER
WORKDIR $HOME

ARG BASE_IMAGE
LABEL base.image=$BASE_IMAGE
LABEL image.usage=release

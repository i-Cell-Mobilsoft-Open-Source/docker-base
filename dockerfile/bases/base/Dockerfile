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
    groupadd --gid $USER_GID $SYSTEM_USER_GROUP && \
    useradd --system --uid ${USER_UID} --shell /usr/sbin/nologin --no-user-group --create-home --gid ${USER_GID} ${SYSTEM_USER_GROUP}

USER $SYSTEM_USER
WORKDIR $HOME

ARG BASE_IMAGE
LABEL base.image=$BASE_IMAGE
LABEL image.usage=release

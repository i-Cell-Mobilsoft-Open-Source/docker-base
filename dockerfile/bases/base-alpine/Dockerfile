ARG ALPINE_BASE_IMAGE

FROM ${ALPINE_BASE_IMAGE} as base

ARG USER_GID=101
ARG USER_UID=101
ARG SYSTEM_USER_DEFAULT=icellmobilsoft
ARG SYSTEM_USER_GROUP_DEFAULT=icellmobilsoft
ENV SYSTEM_USER=$SYSTEM_USER_DEFAULT
ENV SYSTEM_USER_GROUP=$SYSTEM_USER_GROUP_DEFAULT
ENV HOME=/home/$SYSTEM_USER

# switch to C.UTF-8, default=POSIX, locale -a -> C, C.UTF-8, POSIX
ENV LC_ALL=C.UTF-8

RUN addgroup --gid $USER_GID $SYSTEM_USER_GROUP
# https://wiki.alpinelinux.org/wiki/Setting_up_a_new_user
#     -g --gecos GECOS        GECOS field
#     -G --ingroup GRP        Group (by name)
#     -S --system             Create a system user
#     -D --disabled-password  Don't assign a password, so cannot login
#     -u --uid UID            User id
RUN adduser --gecos ${SYSTEM_USER} --ingroup ${SYSTEM_USER_GROUP} --system --disabled-password --uid ${USER_UID}  ${SYSTEM_USER_GROUP}

USER $SYSTEM_USER
WORKDIR $HOME

ARG ALPINE_BASE_IMAGE
LABEL base.image=$ALPINE_BASE_IMAGE
LABEL image.usage=release

#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM alpine:latest

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Or your actual UID, GID on Linux if not the default 1000
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN sed -i -e 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories\
    && apk --update add --no-cache \
        libuuid \
        gcc \
        libc-dev \
        linux-headers \
        make  \
        automake   \
        g++  \
        python3-dev \
        sudo \
        bash \
        git \
        curl \
        python3 \
    && curl https://bootstrap.pypa.io/get-pip.py| python3 - \
    # Install pylint
    && pip --disable-pip-version-check --no-cache-dir install pylint -i https://mirrors.aliyun.com/pypi/simple/ \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && addgroup -g $USER_GID $USERNAME \
    && adduser -s /bin/bash -u $USER_UID -G $USERNAME -D $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
    
# USER ${USERNAME}

# RUN mkdir -p ~/.vscode-server ~/.vscode-server-insiders

# USER root

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

VOLUME [ "/workspace" ]


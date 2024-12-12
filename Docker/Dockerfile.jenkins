# Base image
FROM debian:bullseye

ARG ANDROID_API_LEVEL=34
ARG ANDROID_BUILD_TOOLS_LEVEL=34.0.0
ARG ANDROID_NDK_VERSION=25.2.9519653
ARG ANDROID_CLI_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
ARG SDKMANAGER_PACKAGES="build-tools;${ANDROID_BUILD_TOOLS_LEVEL} platforms;android-$ANDROID_API_LEVEL cmake;3.6.4111459 system-images;android-${ANDROID_API_LEVEL};google_apis;x86_64 platform-tools"

ARG USER_ID=1000
ARG USER_HOME=/home/usr
ARG GROUP_ID=1000
ARG KVM_GROUP_ID=999

ENV ANDROID_SDK_ROOT=$USER_HOME/android/sdk
ENV ANDROID_AVD_HOME=$USER_HOME/avds
# Deprecated: Still used by gradle, once gradle respects ANDROID_SDK_ROOT, this can be removed
ENV ANDROID_HOME=$ANDROID_SDK_ROOT
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
ARG _SDKMANAGER=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager

ENV FLUTTER_VERSION=3.22.2


# Install necessary tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    wget \
    libglu1-mesa \
    libsqlite3-dev \
    libsqlite3-0 \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.deb && \
apt-get update && \
apt-get install -y ./amazon-corretto-11-x64-linux-jdk.deb && \
rm amazon-corretto-11-x64-linux-jdk.deb

RUN if [ ! $(getent group $GROUP_ID) ]; then groupadd -g $GROUP_ID user; fi
RUN groupadd -g $KVM_GROUP_ID kvm
RUN useradd -m -u $USER_ID -g $GROUP_ID -G $KVM_GROUP_ID -d $USER_HOME -s /usr/sbin/nologin user
# Run all other commands as user
USER user

RUN mkdir -p $ANDROID_AVD_HOME

# Android SDK
# ------------------
#
ARG _CMD_LINE=$ANDROID_SDK_ROOT/cmdline-tools
RUN curl $ANDROID_CLI_TOOLS_URL --output /tmp/android_sdk.zip \
    && mkdir -p $ANDROID_SDK_ROOT \
    && unzip -d $ANDROID_SDK_ROOT /tmp/android_sdk.zip \
    && rm /tmp/android_sdk.zip \
                && mkdir -p $_CMD_LINE/latest \
                && mv $_CMD_LINE/bin $_CMD_LINE/lib $_CMD_LINE/source.properties $_CMD_LINE/latest/
# Installing SDK Packages
# -----------------------
#
#RUN if [ ! -z $SDKMANAGER_PACKAGES ]; then yes | $_SDKMANAGER $SDKMANAGER_PACKAGES; fi
RUN yes | $_SDKMANAGER $SDKMANAGER_PACKAGES
# Performance related settings for the JVM
# - Respect the cgroup settings for memory.
#
# Note: Usage of _JAVA_OPTIONS is in general discouraged.
#       This is an internal flag that will be preferred over
#       JAVA_TOOL_OPTIONS and the command line parameters.
#       We still use it here to ensure that these settings
#       are respected, no matter what is configured elsewhere.
# Accept SDK licenses
RUN yes | $_SDKMANAGER --licenses

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git home/usr/local/flutter \
    && cd home \
    && cd usr \
    && cd local \
    && cd flutter \
    && git checkout $FLUTTER_VERSION \
    && /home/usr/local/flutter/bin/flutter doctor

# Add Flutter to PATH
ENV PATH="/home/usr/local/flutter/bin:${PATH}"

# Pre-cache Flutter dependencies
RUN flutter precache

WORKDIR /app

# Default command
CMD ["flutter", "--version"]

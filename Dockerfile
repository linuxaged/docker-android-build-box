FROM ubuntu:16.04

MAINTAINER Tracy Ma

ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_NDK_HOME  /opt/android-ndk

# Get the latest version from https://developer.android.com/studio/index.html
ENV ANDROID_SDK_VERSION="25.2.3"

# Get the latest version from https://developer.android.com/ndk/downloads/index.html
ENV ANDROID_NDK_VERSION="13b"

ENV LANG en_US.UTF-8
RUN locale-gen $LANG

COPY README.md /README.md

WORKDIR /tmp

# Installing packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        autoconf \
        git \
        curl \
        wget \
        lib32stdc++6 \
        lib32z1 \
        lib32z1-dev \
        lib32ncurses5 \
        libc6-dev \
        libgmp-dev \
        libmpc-dev \
        libmpfr-dev \
        libxslt-dev \
        libxml2-dev \
        m4 \
        ncurses-dev \
        ocaml \
        openssh-client \
        pkg-config \
        python-software-properties \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev && \
    apt-add-repository -y ppa:openjdk-r/ppa && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/ && \
    apt-get clean

# Install Android SDK
RUN wget -q -O tools.zip https://dl.google.com/android/repository/tools_r${ANDROID_SDK_VERSION}-linux.zip && \
    unzip -q tools.zip && \
    rm -fr $ANDROID_HOME tools.zip && \
    mkdir -p $ANDROID_HOME && \
    mv tools $ANDROID_HOME/tools && \

    # Install Android components
    cd $ANDROID_HOME && \

    echo "Install android-19" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-19 && \
    echo "Install android-20" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-20 && \
    echo "Install android-21" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-21 && \
    echo "Install android-22" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-22 && \
    echo "Install android-23" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-23 && \
    echo "Install android-24" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-24 && \
    echo "Install android-25" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter android-25 && \

    echo "Install platform-tools" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter platform-tools && \

    echo "Install build-tools-21.1.2" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-21.1.2 && \
    echo "Install build-tools-22.0.1" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-22.0.1 && \
    echo "Install build-tools-23.0.1" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-23.0.1 && \
    echo "Install build-tools-23.0.2" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-23.0.2 && \
    echo "Install build-tools-23.0.3" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-23.0.3 && \
    echo "Install build-tools-24" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-24 && \
    echo "Install build-tools-24.0.1" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-24.0.1 && \
    echo "Install build-tools-24.0.2" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-24.0.2 && \
    echo "Install build-tools-24.0.3" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-24.0.3 && \
    echo "Install build-tools-25" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-25 && \
    echo "Install build-tools-25.0.1" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-25.0.1 && \
    echo "Install build-tools-25.0.2" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-25.0.2 && \
    echo "Install build-tools-25.0.3" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter build-tools-25.2.3 && \

    echo "Install extra-android-m2repository" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter extra-android-m2repository && \

    echo "Install extra-google-google_play_services" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter extra-google-google_play_services && \

    echo "Install extra-google-m2repository" && \
    echo y | tools/android --silent update sdk --no-ui --all --filter extra-google-m2repository

# Install Android NDK, put it in a separate RUN to avoid travis-ci timeout in 10 minutes.
RUN wget -q -O android-ndk.zip http://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    unzip -q android-ndk.zip && \
    rm -fr $ANDROID_NDK_HOME android-ndk.zip && \
    mv android-ndk-r${ANDROID_NDK_VERSION} $ANDROID_NDK_HOME

# Add android commands to PATH
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH $PATH:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools:$ANDROID_NDK_HOME


# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS "-Xms512m -Xmx1024m"
ENV GRADLE_OPTS "-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"


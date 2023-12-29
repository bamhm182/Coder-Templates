FROM kasmweb/core-kali-rolling:1.14.0-rolling

USER root

RUN apt update \
    && apt install -y \
    curl \
    firefox-esr \
    git \
    sudo \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN echo "kasm-user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/kasm-user \
    && chmod 0440 /etc/sudoers.d/kasm-user
ENV VNCOPTIONS='-PreferBandwidth -DynamicQualityMin=4 -DynamicQualityMax=7 -DLP_ClipDelay=0 -disableBasicAuth'

RUN apt update \
  && apt install -y \
  burpsuite \
  golang \
  && rm -rf /var/lib/apt/lists/*

USER kasm-user
WORKDIR /home/kasm-user

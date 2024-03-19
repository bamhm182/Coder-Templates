FROM ubuntu:22.04

ARG USER=coder

USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    ssh \
    sudo \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --groups sudo --create-home --shell /bin/bash ${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
    && chmod 0440 /etc/sudoers.d/${USER}

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  latexmk \
  #texlive-latex-recommended \
  texlive-full \
  make \
  python3-pygments \
  && rm -rf /var/lib/apt/lists/*

USER ${USER}
WORKDIR /home/${USER}

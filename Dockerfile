FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y libav-tools \
    python3-numpy \
    python3-scipy \
    python3-setuptools \
    python3-pip \
    libpq-dev \
    libjpeg-dev \
    curl \
    cmake \
    swig \
    python3-opengl \
    libboost-all-dev \
    libsdl2-dev \
    wget \
    unzip \
    git \
    golang \
    libjson-c-dev \
    net-tools \
    iptables \
    libvncserver-dev \
    software-properties-common \
    mupen64plus \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/pip3 /usr/local/bin/pip \
    && ln -sf /usr/bin/python3 /usr/local/bin/python \
    && pip install -U pip

# Install gym
RUN pip install gym==0.9.5
RUN pip install gym[atari]
RUN pip install six
RUN pip install tensorflow
RUN pip install keras

WORKDIR /usr/local/universe/

RUN mkdir mupen64plus-src && cd "$_" \
    && git clone https://github.com/mupen64plus/mupen64plus-core \
    && git clone https://github.com/kevinhughes27/mupen64plus-input-bot \
    && cd mupen64plus-input-bot \
    && make all \
    && make install

# Cachebusting
COPY ./setup.py ./
COPY ./tox.ini ./

RUN pip install -e .

# Upload our actual code
COPY . ./

# Just in case any python cache files were carried over from the source directory, remove them
RUN py3clean .

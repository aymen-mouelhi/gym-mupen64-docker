FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y libav-tools \
    python2.7 \
    python-pip \
    libpq-dev \
    libjpeg-dev \
    curl \
    cmake \
    swig \
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
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*



RUN ln -sf /usr/bin/pip3 /usr/local/bin/pip \
    && ln -sf /usr/bin/python3 /usr/local/bin/python \
    && pip2 install -U pip

# Install gym
RUN pip2 install gym==0.9.5
RUN pip2 install gym[atari]
RUN pip2 install six
RUN pip2 install tensorflow
RUN pip2 install keras
RUN pip2 install opencv-python

WORKDIR /usr/local/universe/

RUN mkdir mupen64plus-src && cd "$_" \
    && git clone https://github.com/mupen64plus/mupen64plus-core \
    && git clone https://github.com/kevinhughes27/mupen64plus-input-bot \
    && cd mupen64plus-input-bot \
    && make all \
    && make install

# Cachebusting
COPY ./setup.py ./

RUN pip2 install -e .

# Upload our actual code
COPY . ./

# Just in case any python cache files were carried over from the source directory, remove them
RUN py3clean .

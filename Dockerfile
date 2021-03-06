FROM ubuntu:latest

RUN apt-get update && apt-get install -y --no-install-recommends --allow-downgrades --allow-change-held-packages \
        build-essential \
        cmake \
        git \
        curl \
        vim \
        wget \
        ca-certificates \
        python \
        python-dev \
        python-pip \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN pip install setuptools wheel numpy


ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.1.0

# Install nvm with node and npm
RUN mkdir $NVM_DIR
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


# install neuroglancer
RUN git clone https://github.com/google/neuroglancer.git
WORKDIR "/neuroglancer"
RUN npm i
WORKDIR "/neuroglancer/python"
RUN pip install .
RUN python setup.py develop
RUN python setup.py bundle_client

WORKDIR "/neuroglancer"


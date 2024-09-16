ARG UBUNTU_IMAGE=mcr.microsoft.com/vscode/devcontainers/base:0.201.9-ubuntu-20.04
FROM ${UBUNTU_IMAGE}

# Set the version of OpenStudio when building the container. For example `docker build --build-arg
ARG OPENSTUDIO_VERSION=3.7.0
ARG OPENSTUDIO_VERSION_EXT=""
ARG RUBY_VERSION=2.7.2
ARG OPENSTUDIO_DOWNLOAD_URL=https://github.com/NREL/OpenStudio/releases/download/v3.7.0/OpenStudio-3.7.0+d5269793f1-Ubuntu-20.04-x86_64.deb
ARG RUBY_DOWNLOAD_URL=https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.2.tar.gz 

ARG PACKAGES=' gawk build-essential ca-certificates curl gdebi-core git libffi-dev libsqlite3-dev libssl-dev locales python python3-pip software-properties-common sudo zlib1g-dev'
ARG RUBYGEMS='nokogiri:1.13.10 solargraph:0.50.0 debug:1.9.2'  
ARG PYTHON_PACKAGES='openstudio'

# Set ENV variables
ENV RUBY_VERSION=${RUBY_VERSION}
ENV RC_RELEASE=FALSE
ENV OS_BUNDLER_VERSION=2.1.4
ENV BUNDLE_WITHOUT=native_ext
ENV RUBYLIB=/usr/local/openstudio-${OPENSTUDIO_VERSION}${OPENSTUDIO_VERSION_EXT}/Ruby
ENV PYTHONPATH=/usr/local/openstudio-${OPENSTUDIO_VERSION}${OPENSTUDIO_VERSION_EXT}/Python
ENV ENERGYPLUS_EXE_PATH=/usr/local/openstudio-${OPENSTUDIO_VERSION}${OPENSTUDIO_VERSION_EXT}/EnergyPlus/energyplus


# # Install gdebi, then download and install OpenStudio, then clean up.
# # gdebi handles the installation of OpenStudio's dependencies

# install locales and set to en_US.UTF-8. This is needed for running the CLI on some machines
# such as singularity.
RUN apt-get update \
    && apt-get install -y ${PACKAGES} \
    && echo "OpenStudio Package Download URL is ${OPENSTUDIO_DOWNLOAD_URL}" \
    && curl -SLO $OPENSTUDIO_DOWNLOAD_URL \
    && OPENSTUDIO_DOWNLOAD_FILENAME=$(ls *.deb) \
    # Verify that the download was successful (not access denied XML from s3)
    && grep -v -q "<Code>AccessDenied</Code>" ${OPENSTUDIO_DOWNLOAD_FILENAME} \
    && gdebi -n $OPENSTUDIO_DOWNLOAD_FILENAME \
    # Cleanup
    && rm -f $OPENSTUDIO_DOWNLOAD_FILENAME \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US en_US.UTF-8 \
    && dpkg-reconfigure locales \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && apt-get update -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get clean

RUN curl -SLO -k ${RUBY_DOWNLOAD_URL}\
    && tar -xvzf ruby-${RUBY_VERSION}.tar.gz \
    && cd ruby-${RUBY_VERSION} \
    && ./configure \
    && make && make install \ 
    && cd .. \
    && rm -fr ruby-${RUBY_VERSION} \
    && rm ruby-${RUBY_VERSION}.tar.gz


# May need this for syscalls that do not have ext in path
RUN ln -s /usr/local/openstudio-${OPENSTUDIO_VERSION}${OPENSTUDIO_VERSION_EXT} /usr/local/openstudio-${OPENSTUDIO_VERSION}
RUN ln -s /usr/local/openstudio-${OPENSTUDIO_VERSION}/EnergyPlus/energyplus /usr/local/bin/energyplus
RUN gem install -N ${RUBYGEMS} && \
    pip install ${PYTHON_PACKAGES}
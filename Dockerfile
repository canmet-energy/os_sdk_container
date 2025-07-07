ARG UBUNTU_IMAGE=mcr.microsoft.com/vscode/devcontainers/base:ubuntu-20.04
FROM ${UBUNTU_IMAGE}

# Set the version of OpenStudio when building the container. For example `docker build --build-arg
ARG OPENSTUDIO_VERSION=3.8.0
ARG OPENSTUDIO_VERSION_EXT=""
ARG OPENSTUDIO_DOWNLOAD_URL=https://openstudio-ci-builds.s3.amazonaws.com/develop/OpenStudio-3.8.0%2Bf953b6fcaf-Ubuntu-20.04-x86_64.deb
ARG OS_BUNDLER_VERSION=2.4.10
ARG PYTHON_VERSION=3.12
ARG RUBY_VERSION=3.2.2
ARG RUBY_DOWNLOAD_URL=https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.2.tar.gz 
ARG PACKAGES=' \
    curl \
    gdebi-core\ 
    libsqlite3-dev \
    libssl-dev \
    libffi-dev \
    build-essential \ 
    zlib1g-dev \
    vim \
    git \
    locales \ 
    sudo \
    gawk \
    ca-certificates \
    software-properties-common \
    libyaml-dev \
    unzip \
'

ARG RUBYGEMS=' \
    nokogiri:1.13.10 \
    solargraph:0.50.0 \
    debug:1.9.2 \
'
# Set ENV variables
ENV OPENSTUDIO_VERSION=${OPENSTUDIO_VERSION}
ENV RUBY_VERSION=${RUBY_VERSION}
ENV RC_RELEASE=FALSE
ENV OS_BUNDLER_VERSION=${OS_BUNDLER_VERSION}
ENV BUNDLE_WITHOUT=""
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
    && curl -SLO -k $OPENSTUDIO_DOWNLOAD_URL \
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
    && apt-get clean \
    && locale-gen en_US en_US.UTF-8 \
    && dpkg-reconfigure locales

# Install Ruby
RUN curl -SLO -k ${RUBY_DOWNLOAD_URL}\
    && tar -xvzf ruby-${RUBY_VERSION}.tar.gz \
    && cd ruby-${RUBY_VERSION} \
    && ./configure \
    && make && make install \ 
    && cd .. \
    && rm -fr ruby-${RUBY_VERSION} \
    && rm ruby-${RUBY_VERSION}.tar.gz \
    # Install gems required for vscode
    && gem install -N ${RUBYGEMS} --source http://rubygems.org


#Install AWS tools
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
&& unzip awscliv2.zip \
&& ./aws/install \
&& rm -rf ./aws \
&& rm -rf awscliv2.zip

# Install Python and create a virtual environment. As we move from Ruby to Python
# for os-standards we will need a consistent way to manage dependencies. This will not impact the 
# current system pythons required by ubuntu 20.04, and will reside in /venv/bin/python.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository -y ppa:deadsnakes \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python${PYTHON_VERSION}-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && python${PYTHON_VERSION} -m venv /venv \
    # Install openstudio python bindings. Stores to /venv/lib/python3.12/site-packages/
    && /venv/bin/python -m pip install openstudio==${OPENSTUDIO_VERSION}

# May need this for syscalls that do not have ext in path
RUN ln -s /usr/local/openstudio-${OPENSTUDIO_VERSION}${OPENSTUDIO_VERSION_EXT} /usr/local/openstudio-${OPENSTUDIO_VERSION}
RUN ln -s /usr/local/openstudio-${OPENSTUDIO_VERSION}/EnergyPlus/energyplus /usr/local/bin/energyplus
# Install locales package
RUN apt-get update && apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Update package lists and apply only security updates
# RUN apt-get update && apt-get install -y --only-upgrade $(apt list --upgradable 2>/dev/null | grep security | cut -d/ -f1) && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set environment variables
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8


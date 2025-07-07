REM Build Version 3.10.0
docker build --no-cache --build-arg UBUNTU_IMAGE=mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04 --build-arg OPENSTUDIO_VERSION=3.10.0  --build-arg OPENSTUDIO_DOWNLOAD_URL=https://github.com/NREL/OpenStudio/releases/download/v3.10.0/OpenStudio-3.10.0+86d7e215a1-Ubuntu-22.04-x86_64.deb --build-arg OS_BUNDLER_VERSION=2.4.10 --build-arg PYTHON_VERSION=3.12 --build-arg RUBY_VERSION=3.2.2 --build-arg RUBY_DOWNLOAD_URL=https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.2.tar.gz  -t canmet/os_sdk_container:3.10.0 .
docker push canmet/os_sdk_container:3.10.0
REM Build Version 3.9.0
docker build --no-cache --build-arg UBUNTU_IMAGE=mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04 --build-arg OPENSTUDIO_VERSION=3.9.0  --build-arg OPENSTUDIO_DOWNLOAD_URL=https://github.com/NREL/OpenStudio/releases/download/v3.9.0/OpenStudio-3.9.0+c77fbb9569-Ubuntu-22.04-x86_64.deb --build-arg OS_BUNDLER_VERSION=2.4.10 --build-arg PYTHON_VERSION=3.12 --build-arg RUBY_VERSION=3.2.2 --build-arg RUBY_DOWNLOAD_URL=https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.2.tar.gz  -t canmet/os_sdk_container:3.9.0 .
docker push canmet/os_sdk_container:3.9.0
REM Build Version 3.8.0
docker build --no-cache --build-arg UBUNTU_IMAGE=mcr.microsoft.com/vscode/devcontainers/base:ubuntu-20.04 --build-arg OPENSTUDIO_VERSION=3.8.0  --build-arg OPENSTUDIO_DOWNLOAD_URL=https://github.com/NREL/OpenStudio/releases/download/v3.8.0/OpenStudio-3.8.0+f953b6fcaf-Ubuntu-20.04-x86_64.deb --build-arg OS_BUNDLER_VERSION=2.4.10 --build-arg PYTHON_VERSION=3.12 --build-arg RUBY_VERSION=3.2.2 --build-arg RUBY_DOWNLOAD_URL=https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.2.tar.gz  -t canmet/os_sdk_container:3.8.0 .
docker push canmet/os_sdk_container:3.8.0
REM Build Version 3.7.0
docker build --no-cache --build-arg UBUNTU_IMAGE=mcr.microsoft.com/vscode/devcontainers/base:ubuntu-20.04 --build-arg OPENSTUDIO_VERSION=3.7.0  --build-arg OPENSTUDIO_DOWNLOAD_URL=https://github.com/NREL/OpenStudio/releases/download/v3.7.0/OpenStudio-3.7.0+d5269793f1-Ubuntu-20.04-x86_64.deb --build-arg OS_BUNDLER_VERSION=2.1.4 --build-arg PYTHON_VERSION=3.12 --build-arg RUBY_VERSION=2.7.2 --build-arg RUBY_DOWNLOAD_URL=https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.2.tar.gz   -t canmet/os_sdk_container:3.7.0 .
docker push canmet/os_sdk_container:3.7.0


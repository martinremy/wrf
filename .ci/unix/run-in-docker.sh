#!/usr/bin/env bash

# WRF-CMake (https://github.com/WRF-CMake/wrf).
# Copyright 2018 M. Riechert and D. Meyer. Licensed under the MIT License.

set -e

SCRIPTDIR=$(dirname "$0")
ROOTDIR=$(realpath $SCRIPTDIR/../..)
cd $ROOTDIR

container=wrf-ci

# Create container if it doesn't exist
if [ ! "$(docker ps -q -f name=$container)" ]; then
    echo "Creating Docker container $container"
    set -x
    docker run --name $container -t -d -v $ROOTDIR:$ROOTDIR -w $ROOTDIR -e DOCKER=1 $IMAGE
    set +x
    
    echo "Installing sudo inside container"
    if [[ $OS_NAME == CentOS ]]; then
      set -x
      docker exec $container sh -c "yum install -y sudo"
      set +x
    else
      set -x
      docker exec $container sh -c "apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confold" -y install sudo"
      set +x
    fi
fi

echo "Running inside container: $@"
host_envs=$(python3 -c "import os; print(' '.join(f'-e {k}' for k in os.environ if k not in ['PATH', 'HOME']))")
# Use login shell so that ~/.bash_profile is read.
# use-conda.sh appends to that file to modify the PATH.
set -x
docker exec $host_envs $container bash --login -c "$@"

#!/bin/bash

set -eux

docker run -e MM_LICENSE_KEY="$MM_LICENSE_KEY" --rm --volume "$PWD:/root" mm-dl

#!/bin/bash

set -eux

docker run -e POSTGRES_PASSWORD=foo --rm -p 5432:5432 --volume "$PWD/share/dbs:/share/dbs" mmpg

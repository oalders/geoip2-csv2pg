#!/bin/bash

set -eux

docker build -t mm-dl -f mm-dl-Dockerfile .

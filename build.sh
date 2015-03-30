#!/bin/bash
set -e

BUILD_PATH=$(dirname $0)

# Build base container image
sudo docker build -t="forestfloor/base" $BUILD_PATH

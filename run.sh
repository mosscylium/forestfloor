#!/bin/sh
set -e


# Launch container image
sudo docker run -it -d -p 80:80 forestfloor/base

#!/bin/bash

docker build . -f xonsh-portable-musl-alpine.Dockerfile -t xonsh/xonsh-portable-musl-alpine  #--no-cache --force-rm
docker run --rm -v `pwd`/result:/result xonsh/xonsh-portable-musl-alpine

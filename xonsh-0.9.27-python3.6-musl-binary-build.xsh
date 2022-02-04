#!/usr/bin/env xonsh

mkdir -p result
docker build . -f xonsh-0.9.27-python3.6-musl-binary.Dockerfile -t local/xonsh-portable-musl-alpine  #--no-cache --force-rm
docker run --rm -v $PWD/result:/result local/xonsh-portable-musl-alpine

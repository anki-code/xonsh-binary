#!/usr/bin/env xonsh

mkdir -p result
docker build . -f xonsh-musl-binary.Dockerfile -t local/xonsh-musl-binary  #--no-cache --force-rm
docker run --rm -v $PWD/result:/result local/xonsh-musl-binary

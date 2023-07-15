#!/usr/bin/env xonsh

mkdir -p result
docker build . -f xonsh-glibc-binary.Dockerfile -t local/xonsh-glibc-binary  #--no-cache --force-rm
docker run --rm -v $PWD/result:/result local/xonsh-glibc-binary

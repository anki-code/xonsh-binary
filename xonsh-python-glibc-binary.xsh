#!/usr/bin/env xonsh

mkdir -p result
docker build . -f xonsh-python-glibc-binary.Dockerfile -t local/xonsh-python-glibc-binary  #--no-cache --force-rm
docker run --rm -v $PWD/result:/result local/xonsh-python-glibc-binary

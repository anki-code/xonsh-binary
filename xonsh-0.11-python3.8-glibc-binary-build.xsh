#!/usr/bin/env xonsh

mkdir -p result
docker build . -f xonsh-0.11-python3.8-glibc-binary.Dockerfile -t local/xonsh-0.11-python3.8-glibc-binary  #--no-cache --force-rm
docker run --rm -v $PWD/result:/result local/xonsh-0.11-python3.8-glibc-binary

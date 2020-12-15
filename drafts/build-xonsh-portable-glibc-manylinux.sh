#!/bin/bash

docker build . -f xonsh-portable-glibc-manylinux.Dockerfile -t xonsh/xonsh-portable-glibc-manylinux  #--no-cache --force-rm
docker run --rm -v `pwd`/result:/result xonsh/xonsh-portable-glibc-manylinux

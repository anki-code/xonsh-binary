FROM python:3.10-alpine
VOLUME /result

ENV XONSH_VER=0.18.1
ENV XONSH_BIN=xonsh-$XONSH_VER-py3.10-musl.bin

RUN apk update && apk add --update musl-dev gcc make cmake python3-dev py3-pip chrpath git vim mc wget openssh-client libuuid build-base patchelf
RUN pip3 install -U pip prompt_toolkit pygments setproctitle
RUN pip3 install -U git+https://github.com/Nuitka/Nuitka@factory

RUN mkdir /python /xonsh

RUN cd /lib &&  ln -s libuuid.so.1 libuuid.so  # Fix https://github.com/Nuitka/Nuitka/issues/1046

#
# BUILD PYTHON
#
WORKDIR /python
RUN mkdir -p python-build && mkdir -p python-install
RUN git clone -b python3.10 https://github.com/anki-code/python-cmake-buildsystem-py3.10 && mv python-cmake-buildsystem-py3.10 python-cmake-buildsystem

WORKDIR /python/python-build
# TODO: Switch OFF all not used extensions
RUN cmake -DPYTHON_VERSION=3.10.13 -DBUILD_EXTENSIONS_AS_BUILTIN=ON -DBUILTIN_OSSAUDIODEV=OFF -DENABLE_OSSAUDIODEV=OFF -DENABLE_LINUXAUDIODEV=OFF -DBUILTIN_LINUXAUDIODEV=OFF -DENABLE_AUDIOOP=OFF -DBUILTIN_AUDIOOP=OFF -DCMAKE_INSTALL_PREFIX:PATH=${HOME}/scratch/python-install ../python-cmake-buildsystem
RUN make -j10
RUN cp lib/libpython3.10.a /usr/lib

#
# BUILD XONSH
#
WORKDIR /xonsh
RUN git clone -b $XONSH_VER https://github.com/xonsh/xonsh

#
# Switching off ctypes library to reduce compilation errors.
# This library mostly used to Windows use cases and not needed in Linux.
#
#RUN find ./xonsh -type f -name "*.py" -print0 | xargs -0 sed -i 's/import ctypes/#import ctypes/g'
#RUN sed -i 's/def LIBC():/def LIBC():\n    return None/g' ./xonsh/xonsh/platform.py


#
# Switching off SQLite. Sad but it raises compilation error. We should found the way to fix it in the future.
#
RUN find ./xonsh -type f -name "*.py" -print0 | xargs -0 sed -i 's/import sqlite/#import sqlite/g'
#RUN find ./xonsh -type f -name "*.py" -print0 | xargs -0 sed -i 's/\@lazyobject/\#\@lazyobject/g'

ENV LDFLAGS "-static -l:libpython3.10.a"
RUN nuitka --standalone --onefile \
        --onefile-tempdir-spec='%TEMP%/onefile_%PID%_%TIME%' \
        --show-progress --show-scons --show-modules \
        --assume-yes-for-downloads --jobs=2 \
        xonsh/xonsh

RUN ls -la *

CMD cp xonsh.bin /result/$XONSH_BIN

FROM python:3.9-alpine
VOLUME /result

RUN apk update && apk add --update musl-dev gcc make cmake python3-dev py3-pip chrpath git vim mc wget openssh-client libuuid build-base patchelf
RUN pip3 install -U pip nuitka prompt_toolkit pygments setproctitle

RUN mkdir /python /xonsh

RUN cd /lib &&  ln -s libuuid.so.1 libuuid.so  # Fix https://github.com/Nuitka/Nuitka/issues/1046

#
# BUILD PYTHON
#
WORKDIR /python
RUN mkdir -p python-build && mkdir -p python-install
RUN git clone -n http://github.com/python-cmake-buildsystem/python-cmake-buildsystem && cd python-cmake-buildsystem && git checkout 312ca57

WORKDIR /python/python-build
# TODO: Switch OFF all not used extensions
RUN cmake -DBUILD_EXTENSIONS_AS_BUILTIN=ON -DBUILTIN_OSSAUDIODEV=OFF -DENABLE_OSSAUDIODEV=OFF -DENABLE_LINUXAUDIODEV=OFF -DBUILTIN_LINUXAUDIODEV=OFF -DENABLE_AUDIOOP=OFF -DBUILTIN_AUDIOOP=OFF -DCMAKE_INSTALL_PREFIX:PATH=${HOME}/scratch/python-install ../python-cmake-buildsystem
RUN make -j10
RUN cp lib/libpython3.9.a /usr/lib

#
# BUILD XONSH
#
WORKDIR /xonsh
RUN git clone -n https://github.com/xonsh/xonsh && cd xonsh && git checkout 7219663

#
# Switching off ctypes library to reduce compilation errors.
# This library mostly used to Windows use cases and not needed in Linux.
#
RUN find ./xonsh -type f -name "*.py" -print0 | xargs -0 sed -i 's/import ctypes/#import ctypes/g'
RUN sed -i 's/def LIBC():/def LIBC():\n    return None/g' ./xonsh/xonsh/platform.py


#
# Switching off SQLite. Sad but it raises compilation error. We should found the way to fix it in the future.
#
RUN find ./xonsh -type f -name "*.py" -print0 | xargs -0 sed -i 's/import sqlite/#import sqlite/g'

ENV LDFLAGS "-static -l:libpython3.9.a"
RUN nuitka3 --python-flag=no_site --python-flag=no_warnings --standalone --follow-imports xonsh/xonsh  # --show-progress
RUN ls -la xonsh.dist/xonsh.bin

CMD cp xonsh.dist/xonsh.bin /result/xonsh-musl-binary

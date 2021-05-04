FROM python:3.8-alpine
VOLUME /result

RUN apk update && apk add --update musl-dev gcc make cmake python3-dev py3-pip chrpath git vim mc wget openssh-client libuuid build-base tar zstd

RUN mkdir /python /xonsh

RUN cd /lib &&  ln -s libuuid.so.1 libuuid.so  # Fix https://github.com/Nuitka/Nuitka/issues/1046

#
# BUILD PYTHON
#
WORKDIR /python
RUN wget https://github.com/indygreg/python-build-standalone/releases/download/20210415/cpython-3.8.9-x86_64-unknown-linux-musl-lto-20210414T1515.tar.zst
RUN tar -I zstd -xvf  cpython-3.8.9-x86_64-unknown-linux-musl-lto-20210414T1515.tar.zst
RUN cp python/install/lib/libpython3.8.a /usr/lib

#
# BUILD XONSH
#
WORKDIR /xonsh
RUN pip3 install -U pip nuitka prompt_toolkit pygments setproctitle
RUN git clone -n https://github.com/xonsh/xonsh && cd xonsh && git checkout 7168b26

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

ENV LDFLAGS "-static -l:libpython3.8.a"
RUN nuitka3 --python-flag=no_site --python-flag=no_warnings --standalone --follow-imports xonsh/xonsh  # --show-progress
RUN ls -la xonsh.dist/xonsh

CMD cp xonsh.dist/xonsh /result

FROM python:3.8-alpine
VOLUME /result

RUN apk update && apk add --update musl-dev gcc make cmake python3-dev py3-pip chrpath git vim mc wget openssh-client libuuid
RUN pip3 install -U pip nuitka prompt_toolkit pygments setproctitle

RUN mkdir /python /xonsh

#
# BUILD PYTHON
#
WORKDIR /python
RUN mkdir -p python-build && mkdir -p python-install

#
# See https://github.com/python-cmake-buildsystem/python-cmake-buildsystem/pull/267
#
RUN git clone --depth 1 -b upgrade-py383 https://github.com/dand-oss/python-cmake-buildsystem

WORKDIR /python/python-build
# TODO: Switch OFF all not used extensions
RUN cmake -DBUILD_EXTENSIONS_AS_BUILTIN=ON -DBUILTIN_OSSAUDIODEV=OFF -DENABLE_OSSAUDIODEV=OFF -DENABLE_LINUXAUDIODEV=OFF -DBUILTIN_LINUXAUDIODEV=OFF -DENABLE_AUDIOOP=OFF -DBUILTIN_AUDIOOP=OFF -DCMAKE_INSTALL_PREFIX:PATH=${HOME}/scratch/python-install ../python-cmake-buildsystem
RUN make -j10
RUN cp lib/libpython3.8.a /usr/lib

#
# BUILD XONSH
#
WORKDIR /xonsh
RUN git clone -n https://github.com/xonsh/xonsh && cd xonsh && git checkout 7168b26

#
# Switching off ctypes library to reduce compilation errors.
# This library mostly used to Windows use cases and not needed in Linux.
#
RUN find ./xonsh -type f -name "*.py" -print0 | xargs -0 sed -i 's/import ctypes/#import ctypes/g'
RUN sed -i 's/def LIBC():/def LIBC():\n    return None/g' ./xonsh/xonsh/platform.py

#
# Fix Nuitka + Alpine issue when libuuid is installed via `apk add libuuid`
# but `ctypes.util.find_library('uuid')` returns None instead of right path.
#
RUN sed -i 's|locateDLL("uuid")|"/lib/libuuid.so.1.3.0"|g' /usr/local/lib/python3.8/site-packages/nuitka/plugins/standard/ImplicitImports.py

#
# Switching off SQLite. Sad but it raises compilation error. We should found the way to fix it in the future.
#
RUN find ./xonsh -type f -name "*.py" -print0 | xargs -0 sed -i 's/import sqlite/#import sqlite/g'

ENV LDFLAGS "-static -l:libpython3.8.a"
RUN nuitka3 --python-flag=no_site --python-flag=no_warnings --standalone --follow-imports xonsh/xonsh  # --show-progress
RUN ls -la xonsh.dist/xonsh

CMD cp xonsh.dist/xonsh /result

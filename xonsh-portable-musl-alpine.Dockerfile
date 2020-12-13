FROM python:3.6-alpine
VOLUME /result

RUN apk update && apk add --update musl-dev gcc make cmake python3-dev py3-pip chrpath git vim mc wget openssh-client libuuid
RUN pip3 install -U pip nuitka==0.6.10 prompt_toolkit pygments setproctitle

RUN mkdir /python /xonsh

#
# BUILD PYTHON
#
WORKDIR /python
RUN git clone --depth 1 git://github.com/python-cmake-buildsystem/python-cmake-buildsystem
RUN mkdir -p python-build && mkdir -p python-install
WORKDIR python-build
# TODO: Switch OFF all not used extensions
RUN cmake -DBUILD_EXTENSIONS_AS_BUILTIN=ON -DBUILTIN_OSSAUDIODEV=OFF -DENABLE_OSSAUDIODEV=OFF -DENABLE_LINUXAUDIODEV=OFF -DBUILTIN_LINUXAUDIODEV=OFF -DENABLE_AUDIOOP=OFF -DBUILTIN_AUDIOOP=OFF -DCMAKE_INSTALL_PREFIX:PATH=${HOME}/scratch/python-install ../python-cmake-buildsystem
RUN make -j10
RUN cp lib/libpython3.6m.a /usr/lib && cp lib/libpython3.6m.a /usr/lib/libpython3.6.a

#
# BUILD XONSH
#
WORKDIR /xonsh
RUN git clone --depth 1 -b nuitka_fix https://github.com/anki-code/xonsh

#
# Switching off ctypes library to reduce compilation errors.
# This library mostly used to Windows use cases and not needed in Linux.
#
RUN find ./xonsh -type f -name "*.py" -print0 | xargs -0 sed -i 's/import ctypes/#import ctypes/g'
RUN sed -i 's/def LIBC():/def LIBC():\n    return None/g' ./xonsh/xonsh/platform.py

#
# Fix Nuitka + Python 3.6 + Alpine issue when libuuid is installed via `apk add libuuid`
# but `ctypes.util.find_library('uuid')` returns None instead of right path.
#
RUN sed -i 's|locateDLL("uuid")|"/lib/libuuid.so.1.3.0"|g' /usr/local/lib/python3.6/site-packages/nuitka/plugins/standard/ImplicitImports.py

#
# Switching off SQLite. Sad but it raises compilation error. We should found the way to fix it in the future.
#
RUN find ./xonsh -type f -name "*.py" -print0 | xargs -0 sed -i 's/import sqlite/#import sqlite/g'

ENV LDFLAGS "-static -l:libpython3.6m.a"
RUN nuitka3 --python-flag=no_site --python-flag=no_warnings --standalone --follow-imports xonsh/xonsh  # --show-progress
RUN ls -la xonsh.dist/xonsh

CMD cp xonsh.dist/xonsh /result

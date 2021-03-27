FROM python:3.8-alpine
VOLUME /result

ENV PYTHON_VER 3.8.8
ENV PYTHON_LIB_VER 3.8

RUN apk update && apk add --update musl-dev gcc python3-dev py3-pip chrpath git vim mc wget make openssh-client
RUN pip3 install -U pip nuitka prompt_toolkit pygments setproctitle

RUN mkdir /python /xonsh

#
# BUILD PYTHON
#
WORKDIR /python
RUN wget https://www.python.org/ftp/python/$PYTHON_VER/Python-$PYTHON_VER.tgz && tar -xzf Python-$PYTHON_VER.tgz
WORKDIR Python-$PYTHON_VER
ADD Setup.local Modules/
RUN ./configure LDFLAGS="-static" --disable-shared
RUN make LDFLAGS="-static" LINKFORSHARED=" "
RUN ls -la libp*.a
RUN cp libpython$PYTHON_LIB_VER.a /usr/lib

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

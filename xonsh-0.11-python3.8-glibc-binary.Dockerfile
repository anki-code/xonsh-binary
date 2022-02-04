FROM ubuntu:20.04

RUN apt update && apt install --yes patchelf python3 python3-pip gcc make zlib1g-dev git
RUN pip3 install nuitka zstandard

WORKDIR /
RUN git clone -n https://github.com/xonsh/xonsh && cd xonsh && git checkout 0.11.0

WORKDIR /xonsh
RUN nuitka3 --static-libpython=yes --standalone --onefile --onefile-tempdir xonsh
RUN mv xonsh.bin xonsh-0.11-python3.8-glibc-binary
CMD cp xonsh-0.11-python3.8-glibc-binary /result

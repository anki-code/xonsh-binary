# set `debian:sid` here to get more fresh python (see also https://hub.docker.com/_/debian)
FROM ubuntu:23.04

RUN apt update && apt install --yes patchelf python3-full python3-pip gcc make zlib1g-dev git
RUN pip3 install --break-system-packages nuitka zstandard 
RUN pip3 install --break-system-packages 'xonsh[full]' && pip3 uninstall --break-system-packages -y xonsh  # To install full xonsh dependencies

WORKDIR /
RUN git clone -n https://github.com/xonsh/xonsh && cd xonsh && git checkout 0.14.2

WORKDIR /xonsh

#
# To install addition module use --include-module argument (https://github.com/Nuitka/Nuitka/issues/1401) i.e.
#   pip3 install tqdm
#   nuitka3 --static-libpython=yes --standalone --onefile --onefile-tempdir --include-module=tqdm xonsh
#
RUN nuitka3 --static-libpython=yes --standalone --onefile --onefile-tempdir-spec='%TEMP%/onefile_%PID%_%TIME%' xonsh

RUN mv xonsh.bin xonsh-glibc-binary
CMD cp xonsh-glibc-binary /result

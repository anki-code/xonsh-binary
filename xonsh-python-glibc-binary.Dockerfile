FROM ubuntu:20.04

RUN apt update && apt install --yes patchelf python3 python3-pip gcc make zlib1g-dev git
RUN pip3 install nuitka zstandard 
RUN pip3 install 'xonsh[full]' && pip3 uninstall -y xonsh  # To install full xonsh dependencies

WORKDIR /
RUN git clone -n https://github.com/xonsh/xonsh && cd xonsh && git checkout 0.13.4

WORKDIR /xonsh

#
# To install addition module use --include-module argument (https://github.com/Nuitka/Nuitka/issues/1401) i.e.
#   pip3 install tqdm
#   nuitka3 --static-libpython=yes --standalone --onefile --onefile-tempdir --include-module=tqdm xonsh
#
RUN nuitka3 --static-libpython=yes --standalone --onefile --onefile-tempdir-spec='%TEMP%/onefile_%PID%_%TIME%' xonsh

RUN mv xonsh.bin xonsh-0.11.0-python3.8-glibc-binary
CMD cp xonsh-0.11.0-python3.8-glibc-binary /result

# set `debian:sid` here to get more fresh python (see also https://hub.docker.com/_/debian)
FROM ubuntu:23.04

RUN apt update && apt install -y curl git vim patchelf elfutils binutils-common binutils
RUN yes | "${SHELL}" <(curl -L https://micro.mamba.pm/install.sh)
RUN source ~/.bashrc
RUN micromamba activate base
RUN micromamba install -c conda-forge libpython-static==3.11.3 gcc ccache  # 3.11.3 because # https://github.com/Nuitka/Nuitka/issues/2521
RUN pip install nuitka

WORKDIR /
RUN git clone -b 0.17.0 https://github.com/xonsh/xonsh

# --python-flag=nosite,-O,-v
RUN nuitka3 --standalone --onefile --static-libpython=yes \
        --onefile-tempdir-spec='%TEMP%/onefile_%PID%_%TIME%' \
        --show-progress --show-scons --show-modules \
        --assume-yes-for-downloads --jobs=2 \
        xonsh/xonsh

RUN mv xonsh.bin xonsh-glibc-binary
CMD cp xonsh-glibc-binary /result

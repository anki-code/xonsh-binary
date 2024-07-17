# set `debian:sid` here to get more fresh python (see also https://hub.docker.com/_/debian)
FROM ubuntu

ARG PYTHON_VER=3.11.3
ARG XONSH_VER=0.18.1

ENV PYTHON_VER=${PYTHON_VER}
ENV XONSH_VER=${XONSH_VER}

SHELL ["/bin/bash", "-c"]
RUN apt update && apt install -y curl git vim patchelf elfutils binutils-common binutils
RUN yes | bash -c "$(curl -L https://micro.mamba.pm/install.sh)"
RUN /root/.local/bin/micromamba shell init -s bash -p ~/micromamba >> ~/.bashrc

WORKDIR /
RUN git clone -b $XONSH_VER https://github.com/xonsh/xonsh
RUN mkdir -p /result

RUN eval "$(/root/.local/bin/micromamba shell hook -s bash)" \
     && micromamba activate base \
     && micromamba install -c conda-forge libpython-static==$PYTHON_VER gcc ccache \
     && pip install xonsh[full] \
     && xonsh -c '2+2' \
     && pip install git+https://github.com/Nuitka/Nuitka@factory \
     && nuitka --standalone --onefile --static-libpython=yes \
        --onefile-tempdir-spec='%TEMP%/onefile_%PID%_%TIME%' \
        --show-progress --show-scons --show-modules \
        --assume-yes-for-downloads --jobs=2 \
        /root/micromamba/lib/python3.11/site-packages/xonsh

# --python-flag=nosite,-O,-v

RUN mv xonsh.bin xonsh-$XONSH_VER-py$PYTHON_VER-glibc-$(uname -m).bin
CMD cp xonsh-*.bin /result

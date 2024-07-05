# From: https://github.com/Nuitka/Nuitka/issues/2521

# Dockerfile to illustrate nuitka problem to compile based on python version and environment used :

#   - problem description
#       some nuikta compilations fail with this kind of error
#                     >>   /usr/bin/ld: /usr/bin/ld: DWARF error: can't find .debug_ranges section.
#                     >>   /opt/conda/envs/test_env/lib/libpython3.11.a(pystrtod.o): in function `PyOS_double_to_string':
#                     >>   pystrtod.c:(.text.hot.PyOS_double_to_string+0x1b9): undefined reference to `__warn_memset_zero_len'
#                     >>   collect2: error: ld returned 1 exit status
#        Related info found on the net (upgrade relation between glibc and gcc/clang on memset check...) :
#                       https://sourceware.org/bugzilla/show_bug.cgi?id=25399

#   - three environment are tested in their own docker image :
#      - no_inv : pure python
#      - conda_env : conda env from continuumio
#      - mamba_env : mamba env

#   - python version
#      - till 3.11.0 to 3.11.3, every images can be built
#      - from 3.11.4 to 3.11.6, see following TEST RESULTS (in short, on conda and mamba env, nuitka fails to compile)
#          - image no_env : compilation PASS whatever python version
#          - images conda & mamba: compilation FAIL

# Note : to reproduce the bug, just run this dockerfile with command :
#    DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile_reproducer_nuitka.txt --target no_env .
#    DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile_reproducer_nuitka.txt --target conda_env .
#    DOCKER_BUILDKIT=1 docker build --no-cache -f Dockerfile_reproducer_nuitka.txt --target mamba_env .


############################# variable args to edit or select to choose tests ##########################################

# select python version
#ARG python_version="3.11.0"
#ARG python_version="3.11.1"
#ARG python_version="3.11.2"
#ARG python_version="3.11.3"
ARG python_version="3.11.4"
#ARG python_version="3.11.5"
#ARG python_version="3.11.6"

# select default compiler (empty string for gcc) or clang :
ARG compiler_option=""
#ARG compiler_option="--clang"

############################# constant args to all images ##############################################################
# nuitka packages
ARG GCC_AND_CLANG_DEPENDENCIES="build-essential clang"
ARG NUITKA_PACKAGES="nuitka==1.8.4 ordered-set==4.1.0"

# nuitka cmd to run
ARG NUITKA_COMPILATION_CMD=" \
-m nuitka  \
    --python-flag=nosite,-O,-v  \
    --show-progress \
    --show-scons \
    --show-modules  \
    --assume-yes-for-downloads  \
    --jobs=6  \
    $compiler_option \
    --output-dir=. \
    hello_world.py \
"

############################# no_env : pure python without env #########################################################
FROM python:${python_version} as no_env
ARG python_version
ARG GCC_AND_CLANG_DEPENDENCIES
ARG NUITKA_PACKAGES
ARG NUITKA_COMPILATION_CMD

SHELL [ "/bin/bash", "--login", "-c" ]

# install gcc
RUN apt-get update && apt-get install -y $GCC_AND_CLANG_DEPENDENCIES

# install nuitka packages
RUN python -m pip install $NUITKA_PACKAGES

# create test dir +  hello_world.py
WORKDIR "test_dir"
RUN echo "print('hello world')" > hello_world.py

# run nuitka
RUN python $NUITKA_COMPILATION_CMD


############################# conda_env : use continuumio 's conda #####################################################
FROM continuumio/miniconda3 as conda_env
ARG python_version
ARG GCC_AND_CLANG_DEPENDENCIES
ARG NUITKA_PACKAGES
ARG NUITKA_COMPILATION_CMD

SHELL [ "/bin/bash", "--login", "-c" ]

# install gcc
RUN apt-get update && apt-get install -y $GCC_AND_CLANG_DEPENDENCIES

# init bash
RUN conda init bash
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.profile

# create environment
RUN conda create --name test_env python=$python_version --yes \
  && conda activate test_env  \
  && conda install -c conda-forge $NUITKA_PACKAGES

# create test dir +  hello_world.py
WORKDIR "test_dir"
RUN echo "print('hello world')" > hello_world.py

# run nuitka
RUN conda activate test_env  && python $NUITKA_COMPILATION_CMD


############################# conda_env : use mamba ####################################################################
FROM condaforge/mambaforge as mamba_env
ARG python_version
ARG GCC_AND_CLANG_DEPENDENCIES
ARG NUITKA_PACKAGES
ARG NUITKA_COMPILATION_CMD

SHELL [ "/bin/bash", "--login", "-c" ]

# install gcc
RUN apt-get update && apt-get install -y $GCC_AND_CLANG_DEPENDENCIES

# init bash
RUN conda init bash
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.profile
RUN echo ". /opt/conda/etc/profile.d/mamba.sh" >> ~/.profile

# create environment
RUN mamba create --name test_env python=$python_version --yes \
  && conda activate test_env  \
  && mamba install $NUITKA_PACKAGES

# create test dir +  hello_world.py
WORKDIR "test_dir"
RUN echo "print('hello world')" > hello_world.py

# run nuitka
RUN conda activate test_env  && python $NUITKA_COMPILATION_CMD



Here you can find drafts of Dockerfiles that is not completed.

## xonsh-portable-glibc-manylinux.Dockerfile 

Building on [Manylinux 2014](https://github.com/pypa/manylinux) with GLIBC. Working was stopped because the compilated file has an error after starting.

## xonsh-portable-musl-alpine-Python-3.8-cmake.Dockerfile

Building Python 3.8 from [python-cmake-buildsystem pull request](https://github.com/python-cmake-buildsystem/python-cmake-buildsystem/pull/267). Working was stopped because the compilated file has an error after starting.

## xonsh-portable-musl-alpine-Python-3.8-make.Dockerfile

Building Python 3.8 from sources. Working was stopped on selecting appropriate modules for compilation.

## xonsh-portable-musl-alpine-Python-3.9-make.Dockerfile

Building Python 3.9 from [python-cmake-buildsystem](https://github.com/python-cmake-buildsystem/python-cmake-buildsystem/). Working was stopped because [errors during compilation with Nuitka](https://github.com/Nuitka/Nuitka/issues/1392).

## xonsh-portable-musl--python-build-standalone.Dockerfile

Building Python 3.8 from [python-build-standalone](https://github.com/indygreg/python-build-standalone). Working was stopped on Nuitka error `file format not recognized`.

## Building xonsh with nuitka draft.sh

This draft is working but returns the AppImage file to run using FUSE.

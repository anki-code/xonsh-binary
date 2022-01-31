# docker run -it --rm ubuntu:20.04

apt update --yes --force-yes && apt install --yes --force-yes patchelf python3 python3-pip gcc make zlib1g-dev git
pip3 install nuitka zstandard

mkdir /xonsh
cd xonsh
git clone -n https://github.com/xonsh/xonsh && cd xonsh && git checkout 7168b26

nuitka3 --static-libpython=yes --standalone --onefile --onefile-tempdir xonsh

./xonsh.bin

docker run -it --rm --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor:unconfined --cap-add MKNOD ubuntu:18.04

apt update && apt install patchelf python3 python3-pip gcc make zlib1g-dev git fuse
pip3 install nuitka

mkdir /xonsh
cd xonsh
git clone -n https://github.com/xonsh/xonsh && cd xonsh && git checkout 7168b26

nuitka3 --static-libpython=yes --standalone --onefile xonsh

./xonsh.bin

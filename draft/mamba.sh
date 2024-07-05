apt update && apt install -y curl git vim patchelf elfutils binutils-common binutils
"${SHELL}" <(curl -L https://micro.mamba.pm/install.sh)
source ~/.bashrc
micromamba activate base
micromamba install -c conda-forge libpython-static==3.11.3 gcc ccache
pip install nuitka

git clone -b executables https://github.com/xonsh/xonsh
cd xonsh
find ./xonsh -type f -name "*.py" -print0 | xargs -0 sed -i 's/import ctypes/#import ctypes/g'
sed -i 's/def LIBC():/def LIBC():\n    return None/g' ./xonsh/platform.py
cd ..

echo "import subprocess; print(123)" > sp.py
nuitka3 --static-libpython=yes --standalone --show-progress --show-scons --show-modules --assume-yes-for-downloads --jobs=6  sp.py
nuitka3 --static-libpython=yes --standalone --python-flag=nosite,-O,-v --show-progress --show-scons --show-modules --assume-yes-for-downloads --jobs=6  sp.py

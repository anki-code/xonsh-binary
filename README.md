<p align="center">
This is the proof of concept of building <a href="https://github.com/xonsh/xonsh">xonsh</a> binary file. This allows you to run xonsh interactive or run xonsh scripts without Python installation. Also you can <a href="https://github.com/anki-code/xonsh-binary/blob/516ec6ddeef414bcf2f15d61320f6df853b888e6/xonsh-0.11.0-python3.8-glibc-binary.Dockerfile#L12-L17">include any module into the binary file</a> and import it in xonsh.
</p>

<p align="center">  
If you like the idea click ⭐ on the repo and stay tuned.
</p>

## Available builds

Download xonsh binary from [the release assets](https://github.com/anki-code/xonsh-portable-binary/releases):

* **xonsh-0.11.0-python3.8-glibc-binary** - glibc-build of xonsh 0.11.0 binary with Python 3.8 based on Nuitka.
* **xonsh-0.9.27-python3.6-musl-binary** - musl-build of xonsh 0.9.27 binary with Python 3.6 from [python-cmake-buildsystem](https://github.com/python-cmake-buildsystem/python-cmake-buildsystem) (Note: it has [Python 3.9 support](https://github.com/python-cmake-buildsystem/python-cmake-buildsystem/issues/304)). SQLite3 is disabled in this build.

## Drafts

In the `./drafts` directory you can find drafts of Dockerfiles that is not completed.



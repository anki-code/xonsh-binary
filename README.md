<p align="center">
This is the proof of concept of building <a href="https://github.com/xonsh/xonsh">xonsh</a> binary file. This allows you to run xonsh interactive or run xonsh scripts without Python installation. Also you can <a href="https://github.com/anki-code/xonsh-binary/blob/516ec6ddeef414bcf2f15d61320f6df853b888e6/xonsh-0.11.0-python3.8-glibc-binary.Dockerfile#L12-L17">include any module into the binary file</a> and import it in xonsh.
</p>

<p align="center">  
If you like the idea click ⭐ on the repo and stay tuned.
</p>

## Available builds

Download xonsh binary from [the release assets](https://github.com/anki-code/xonsh-portable-binary/releases):

* Recommended: **xonsh-glibc-binary** - glibc-build of xonsh 0.17.0 binary with Python 3.11 based on [Nuitka](https://nuitka.net/).
* Just for demo: **xonsh-musl-binary** - musl-build of xonsh 0.17.0 binary with Python 3.10 from [python-cmake-buildsystem](https://github.com/python-cmake-buildsystem/python-cmake-buildsystem). SQLite3 is disabled in this build (PR is welcome!).
* [Find another path](https://gregoryszorc.com/docs/pyoxidizer/main/pyoxidizer_comparisons.html).

## Known issues

### Binary is not working

Do not try to run x86_64 binary files on Mac because it has aarch64 architecture.

## Drafts

In the `./drafts` directory you can find drafts of Dockerfiles that is not completed.

## Speed

If you're looking how to increase xonsh speed take a look into this:
* [RustPython](https://github.com/RustPython/RustPython) ([performance](https://user-images.githubusercontent.com/1309177/212613257-5f4bca12-6d6b-4c79-9bac-51a4c6d08928.svg) of [Ruff](https://github.com/charliermarsh/ruff) - Python linter on Rust)
  * [pyoxidizer](https://gregoryszorc.com/docs/pyoxidizer/main/)
* https://lpython.org/
* [Python 3.12: A Game-Changer in Performance and Efficiency](https://python.plainenglish.io/python-3-12-a-game-changer-in-performance-and-efficiency-8dfaaa1e744c)
* [Python 3.11 is up to 10-60% faster than Python 3.10](https://docs.python.org/3.11/whatsnew/3.11.html)
* [Making Python 5x FASTER with Guido van Rossum](https://www.youtube.com/watch?v=_r6bFhl6wR8).


<p align="center">
This is the proof of concept of building portable <a href="https://github.com/xonsh/xonsh">xonsh</a> binary file.
</p>

<p align="center">  
If you like the idea click ⭐ on the repo and stay tuned.
</p>

Build specification:
* Pinned Python 3.6 becase [python-cmake-buildsystem](https://github.com/python-cmake-buildsystem/python-cmake-buildsystem) has not updated yet.
* Pinned Xonsh to 0.9.27 7168b26 to [increase the version manually](https://github.com/anki-code/xonsh-portable-binary/blob/3ec06162ff75bd5d78ff17b1c0da74e0acb7dc73/xonsh-portable-musl-alpine.Dockerfile#L22-L26).
* sqlite3 disabled in this xonsh build

## Try

Download xonsh binary from [the latest release assets](https://github.com/anki-code/xonsh-portable-binary/releases).

Try in Alpine:
```bash
docker run --rm -it alpine
wget https://github.com/anki-code/xonsh-portable-binary/releases/download/0.9.27-7168b26/xonsh
chmod +x xonsh
./xonsh
```

Try in Ubuntu:
```bash
docker run --rm -it ubuntu
apt update && apt install -y wget
wget https://github.com/anki-code/xonsh-portable-binary/releases/download/0.9.27-7168b26/xonsh
chmod +x xonsh
./xonsh
```

## Building

Run building process in docker:
```bash
xonsh ./build-xxh-portable-musl-alpine.xsh
```

As result you will get `./result/xonsh` file - the one binary file that statically linked and linux-portable.

## Drafts

In the `./drafts` directory you can find drafts of Dockerfiles that is not completed.



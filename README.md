<p align="center">
This is the proof of concept of building portable <a href="https://github.com/xonsh/xonsh">xonsh</a> binary file.
</p>

<p align="center">  
If you like the idea click ⭐ on the repo and stay tuned.
</p>



## Try

Try in Alpine:
```bash
docker run --rm -it alpine
wget https://github.com/anki-code/xonsh-portable-binary/releases/download/0.9.24-build2/xonsh
chmod +x xonsh
./xonsh
```

Try in Ubuntu:
```bash
docker run --rm -it ubuntu
apt update && apt install -y wget
wget https://github.com/anki-code/xonsh-portable-binary/releases/download/0.9.24-build2/xonsh
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



This is the proof of concept of building portable [xonsh](https://github.com/xonsh/xonsh) binary file. 

Run building process in docker:
```bash
./build-xxh-portable-musl-alpine.sh
```

As result you will get `./result/xonsh` file - the one binary file that statically linked and linux-portable.

Test xonsh binary in clean environment:
```bash
# On Alpine:
docker run --rm -it -v $PWD/result:/result alpine
/result/xonsh

# or Ubuntu:
docker run --rm -it -v $PWD/result:/result ubuntu
/result/xonsh
```




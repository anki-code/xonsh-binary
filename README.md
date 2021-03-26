<p align="center">
This is the proof of concept of building portable <a href="https://github.com/xonsh/xonsh">xonsh</a> binary file.
</p>

<p align="center">  
If you like the idea click ⭐ on the repo and stay tuned.
</p>

## Building

Run building process in docker:
```bash
xonsh ./build-xxh-portable-musl-alpine.xsh
```

As result you will get `./result/xonsh` file - the one binary file that statically linked and linux-portable.

## Testing

Test xonsh binary in clean environment:
```bash
# On Alpine:
docker run --rm -it -v $PWD/result:/result alpine
/result/xonsh

# or Ubuntu:
docker run --rm -it -v $PWD/result:/result ubuntu
/result/xonsh
```

## Drafts

In the `./drafts` directory you can find drafts of Dockerfiles that is not completed.



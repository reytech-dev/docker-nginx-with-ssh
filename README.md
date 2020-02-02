# Usage

1. Build

```sh
$ cd /project/root/ && docker build -t nginx-with-ssh .
```

2. Start

```sh
$ docker run --rm -it -p 8080:80 -p 2222:22 --name nginx-with-ssh -t nginx-with-ssh:latest
```

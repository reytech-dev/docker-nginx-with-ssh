# Usage

1. Create your own pair of ssh keys and replace the ones in the repository

```sh
$ ssh-keygen -t rsa -b 4096
```

2. Build

```sh
$ cd /project/root/ && docker build -t nginx-with-ssh --build-arg PUB_SSH_KEY="$(cat ./id_rsa.pub)" --build-arg USER=nonrootuser .
```

3. Start

```sh
$ docker run --rm -it -p 8080:80 -p 2222:22 -p 8443:443 --name nginx-with-ssh -t nginx-with-ssh:latest
```

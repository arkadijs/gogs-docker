#!/bin/sh -xe
tmp=$(mktemp -d)
docker run -ti --rm \
    -p 50022:22 \
    -p 50443:50443 \
    -v $tmp:/home/git \
    -e DOMAIN=git.domain.com \
    -e SSH_PORT=50022 \
    -e HTTPS_PORT=50443 \
    arkadi/gogs \
    /sbin/my_init -- bash -l

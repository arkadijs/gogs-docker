#!/bin/sh -xe
v=0.5.11-2
tag=arkadi/gogs
tag2=$DEV_REGISTRY/$tag
docker build -t $tag:$v .
docker tag -f $tag:$v $tag:latest
docker tag -f $tag:$v $tag2:$v
docker push $tag:$v
docker push $tag:latest
docker push $tag2:$v

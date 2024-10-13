#!/bin/bash
set -e
set -x

if [ ! -f "package.json" ];then
   echo "package.json not found"
   exit
fi

DOCKER_VERSION=$(jq -r ".version" package.json)
REGISTRY=$(jq -r ".registry" package.json)
CONTEXT=$(jq -r ".context" package.json)
if [[ $1 ]]; then
  DOCKER_PKG=$1

  if [[ $2 ]]; then
    DOCKER_FILE=$2
  else
    echo "Please specific docker file"
    exit
  fi
else
  DOCKER_PKG=$(jq -r ".name" package.json)
fi

# if [ -z "$DOCKER_PASS" ];then
#     echo "Missing DOCKER_PASS"
#     exit
# fi
if [ -z "$DOCKER_PKG" ];then
    echo "Missing package.json name"
    exit
fi

DOCKER_REGISTRY=$DOCKER_HUB;

if [[ $REGISTRY ]]; then
  DOCKER_REGISTRY=$REGISTRY
fi

# echo "$DOCKER_PKG:$DOCKER_VERSION - `date`" >AS-BUILT-VERSION

if [[ $DOCKER_FILE ]];then
  docker build . -t $DOCKER_PKG:$DOCKER_VERSION -f $DOCKER_FILE
else
  docker build . -t $DOCKER_PKG:$DOCKER_VERSION
fi

docker tag $DOCKER_PKG:$DOCKER_VERSION $DOCKER_REGISTRY/$DOCKER_PKG:$DOCKER_VERSION

if [[ $CONTEXT ]]; then
  doctl auth switch --context $CONTEXT
else
 doctl auth switch --context default
fi

doctl registry login

#docker login -u $DOCKER_USER -p $DOCKER_PASS $DOCKER_HUB
docker push $DOCKER_REGISTRY/$DOCKER_PKG:$DOCKER_VERSION

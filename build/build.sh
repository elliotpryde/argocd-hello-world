#!/bin/bash
set -Eeo pipefail

usage() {
  echo "Usage: build.sh -u docker-hub-username -p docker-hub-password"
}

while getopts "u:p:" o; do
  case "$o" in
    u)
      docker_hub_username=$OPTARG
      ;;
    p)
      docker_hub_password=$OPTARG
      ;;
    *)
      usage
      exit 1
      ;;
    esac
done

if [ -z "$docker_hub_username" ] || [ -z "$docker_hub_password" ]; then
  usage
  exit 1
fi

echo "Logging into Docker Hub"
echo "$docker_hub_password" | docker login --username "$docker_hub_username" --password-stdin

VERSION=$(cat "${BASH_SOURCE%/*}/VERSION")

echo "Building version: $VERSION"
docker build "${BASH_SOURCE%/*}/.." -t argocd-hello-world

docker tag argocd-hello-world "$docker_hub_username/argocd-hello-world:latest"
docker push "$docker_hub_username/argocd-hello-world:latest"

docker tag argocd-hello-world "$docker_hub_username/argocd-hello-world:$VERSION"
docker push "$docker_hub_username/argocd-hello-world:$VERSION"

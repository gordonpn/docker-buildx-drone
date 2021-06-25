# docker-buildx-drone

[![Docker Image](https://badgen.net/badge/icon/docker?icon=docker&label)](https://hub.docker.com/r/gordonpn/docker-buildx-drone)
[![Build Status](https://drone.gordon-pn.com/api/badges/gordonpn/docker-buildx-drone/status.svg)](https://drone.gordon-pn.com/gordonpn/docker-buildx-drone)
[![License](https://badgen.net/github/license/gordonpn/docker-buildx-drone)](./LICENSE)
[![Project Status: Inactive – The project has reached a stable, usable state but is no longer being actively developed; support/maintenance will be provided as time allows.](https://www.repostatus.org/badges/latest/inactive.svg)](https://www.repostatus.org/#inactive)

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/gordonpn)

## Deprecated

Buildx now comes bundled with Docker Engine and this image is no longer needed.

<https://docs.docker.com/buildx/working-with-buildx/>

## Motivation

My continuous integration and continuous delivery (CI/CD) platform of choice is [Drone](https://drone.io/). What is particular about this platform is that every step of the pipeline is executed inside an isolated docker container.

Buildx is an experimental feature available on Docker 19.03+ which allows the user to build images for multiple architectures.

The purpose of this image is to provide the latest Docker as well as the latest Buildx binary pre-installed.

## Description

This image is based on Docker latest image and includes the latest Buildx binary. The Buildx binary version can be changed at the Docker image build-time.

Currently, this Docker image only supports amd64.

## Example

Here is an example of a pipeline for Drone CI.

```yaml
---
kind : pipeline
type: docker
name: build and publish docker image

platform:
  os: linux
  arch: amd64

trigger:
  event: [ push, pull_request ]

steps:
  - name: publish
    image: gordonpn/docker-buildx-drone
    environment:
      DOCKER_TOKEN:
        from_secret: DOCKER_TOKEN
    volumes:
      - name: dockersock
        path: /var/run/docker.sock
    commands:
      - echo $DOCKER_TOKEN | docker login -u gordonpn --password-stdin
      - docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
      - docker buildx rm builder || true
      - docker buildx create --name builder --driver docker-container --use
      - docker buildx inspect --bootstrap
      - cd /drone/src/project-one
      - docker buildx build -t yourUsername/yourRepo:yourTag --platform linux/amd64,linux/arm64 --push .
      - cd /drone/src/project-two
      - docker build -t yourUsername/yourRepo:yourTag .
      - docker push yourUsername/yourRepo:yourTag

volumes:
  - name: dockersock
    host:
      path: /var/run/docker.sock
```

## Building image with a different Buildx version

```sh
cd $PROJECT_DIR
docker build --build-arg BUILDX_VERSION=v0.4.0 .
```

## Authors

[@gordonpn](https://github.com/gordonpn)

## License

[MIT License](./LICENSE)

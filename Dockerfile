FROM docker:latest
ARG BUILDX_VERSION
ENV DOCKER_CLI_EXPERIMENTAL=enabled
RUN apk add --no-cache \
  curl \
  jq
RUN mkdir -p /root/.docker/cli-plugins
RUN set -e; \
  if [ -z "$BUILDX_VERSION" ]; then \
    echo "BUILDX_VERSION is empty"; \
    export BUILDX_VERSION=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | jq -r ".tag_name"); \
  else \
    echo "BUILDX_VERSION is set"; \
  fi; \
  echo "Building with buildx ${BUILDX_VERSION}"; \
  curl -sfL https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64 -o /root/.docker/cli-plugins/docker-buildx; \
  chmod a+x /root/.docker/cli-plugins/docker-buildx;

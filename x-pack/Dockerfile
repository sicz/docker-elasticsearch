ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG DOCKER_IMAGE_NAME
ARG DOCKER_IMAGE_TAG
ARG DOCKER_PROJECT_DESC
ARG DOCKER_PROJECT_URL
ARG BUILD_DATE
ARG GITHUB_URL
ARG VCS_REF

LABEL \
  org.label-schema.schema-version="1.0" \
  org.label-schema.name="${DOCKER_IMAGE_NAME}" \
  org.label-schema.version="${DOCKER_IMAGE_TAG}" \
  org.label-schema.description="${DOCKER_PROJECT_DESC}" \
  org.label-schema.url="${DOCKER_PROJECT_URL}" \
  org.label-schema.vcs-url="${GITHUB_URL}" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.build-date="${BUILD_DATE}"

RUN set -exo pipefail; \
  elasticsearch-plugin install --batch x-pack; \
  rm -f bin/x-pack/*.bat bin/x-pack/*.exe; \
  rm -rf plugins/x-pack/platform/darwin-x86_64; \
  rm -rf plugins/x-pack/platform/windows-x86_64; \
  rm -f config/elasticsearch.keystore; \
  mv config/x-pack/log4j2.properties config/x-pack/log4j2.default.properties

ARG ELASTICSEARCH_TAG

COPY x-pack/rootfs /
COPY ${ELASTICSEARCH_TAG}/x-pack/rootfs /

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

ARG ELASTICSEARCH_VERSION
ARG ES_TARBALL="elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz"
ARG ES_TARBALL_URL="https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${ELASTICSEARCH_VERSION}/${ES_TARBALL}"
ARG ES_TARBALL_SHA1_URL="${ES_TARBALL_URL}.sha1"
ARG ES_HOME="/usr/share/elasticsearch"

ENV \
  DOCKER_USER="elasticsearch" \
  DOCKER_COMMAND="elasticsearch" \
  ELASTIC_CONTAINER="true" \
  ELASTICSEARCH_VERSION="${ELASTICSEARCH_VERSION}" \
  ES_HOME="${ES_HOME}" \
  PATH="${ES_HOME}/bin:${PATH}"

WORKDIR ${ES_HOME}

RUN set -exo pipefail; \
  adduser --uid 1000 --user-group --home-dir ${ES_HOME} ${DOCKER_USER}; \
  curl -fLo /tmp/${ES_TARBALL} ${ES_TARBALL_URL}; \
  EXPECTED_SHA1=$(curl -fL ${ES_TARBALL_SHA1_URL}); \
  TARBALL_SHA1=$(sha1sum /tmp/${ES_TARBALL} | cut -d ' ' -f 1); \
  [ "${TARBALL_SHA1}" = "${EXPECTED_SHA1}" ]; \
  tar xz --strip-components=1 -f /tmp/${ES_TARBALL}; \
  rm -f /tmp/${ES_TARBALL}; \
  mkdir -p plugins; \
  chown -R root:root .; \
  mv config/elasticsearch.yml config/elasticsearch.default.yml; \
  mv config/logging.yml config/logging.default.yml

COPY rootfs /
COPY ${ELASTICSEARCH_VERSION}/rootfs /

EXPOSE \
  9200/tcp \
  9300/tcp

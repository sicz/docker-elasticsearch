ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG ELASTICSEARCH_VERSION
ARG ES_TARBALL="elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz"
ARG ES_TARBALL_URL="https://artifacts.elastic.co/downloads/elasticsearch/${ES_TARBALL}"
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
  EXPECTED_CHECKSUM=$(curl -fL ${ES_TARBALL_URL}.sha512 | cut -d " " -f 1); \
  TARBALL_CHECKSUM=$(sha512sum /tmp/${ES_TARBALL} | cut -d " " -f 1); \
  [ "${TARBALL_CHECKSUM}" = "${EXPECTED_CHECKSUM}" ]; \
  tar xz --strip-components=1 -f /tmp/${ES_TARBALL}; \
  rm -f /tmp/${ES_TARBALL}; \
  rm -f bin/*.bat bin/*.exe; \
  chown -R root:root .; \
  mv config/elasticsearch.yml config/elasticsearch.default.yml; \
  mv config/log4j2.properties config/log4j2.default.properties; \
  mv config/jvm.options config/jvm.default.options

COPY rootfs /

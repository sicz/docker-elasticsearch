ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN set -exo pipefail; \
  elasticsearch-plugin install --batch x-pack; \
  rm -f bin/x-pack/*.bat bin/x-pack/*.exe; \
  rm -rf plugins/x-pack/platform/darwin-x86_64; \
  rm -rf plugins/x-pack/platform/windows-x86_64; \
  rm -f config/elasticsearch.keystore; \
  mv config/x-pack/log4j2.properties config/x-pack/log4j2.default.properties

COPY x-pack/rootfs /

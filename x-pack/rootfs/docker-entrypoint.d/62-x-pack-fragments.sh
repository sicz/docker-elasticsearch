#!/bin/bash -e

### ELASTICSEARCH_YML ##########################################################

if [ ! -e ${ES_PATH_CONF}/x-pack.default_tls_settings.yml ]; then
  info "Creating ${ES_PATH_CONF}/x-pack.default_tls_settings.yml"
  (
    echo "xpack.ssl.supported_protocols: TLSv1.2"
    if [ -n "${JAVA_TRUSTSTORE_FILE}" -a -e "${JAVA_TRUSTSTORE_FILE}" ]; then
      echo "xpack.ssl.truststore.path: ${JAVA_TRUSTSTORE_FILE}"
      # TODO: Elasticsearch 6.0.0-beta2 crashes with keystore passwords in Elasticsearch keystore
      echo "xpack.ssl.truststore.password: ${JAVA_TRUSTSTORE_PWD}"
    fi
    if [ -n "${JAVA_KEYSTORE_FILE}" -a -e "${JAVA_KEYSTORE_FILE}" ]; then
      echo "xpack.ssl.keystore.path: ${JAVA_KEYSTORE_FILE}"
      # TODO: Elasticsearch 6.0.0-beta2 crashes with keystore passwords in Elasticsearch keystore
      echo "xpack.ssl.keystore.password: ${JAVA_KEYSTORE_PWD}"
    fi
  ) > ${ES_PATH_CONF}/x-pack.default_tls_settings.yml
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${ES_PATH_CONF}/x-pack.default_tls_settings.yml
  fi
fi

ELASTICSEARCH_YML_FILES="${ELASTICSEARCH_YML_FILES} x-pack.${XPACK_EDITION}.yml x-pack.default_tls_settings.yml"

### XPACK_KEYSTORE #############################################################

if [ ! -e "${ES_PATH_CONF}/elasticsearch.keystore" ]; then
  info "Creating ${ES_PATH_CONF}/elasticsearch.keystore"
  elasticsearch-keystore create
  for XPACK_SECRET_FILE in $(ls /run/secrets/*.secret 2> /dev/null); do
    XPACK_SECRET="$(basename ${XPACK_SECRET_FILE} | sed -E "s/.secret$")"
    cat ${XPACK_SECRET_FILE} | elasticsearch-keystore add "${XPACK_SECRET}"
  done
  # TODO: Elasticsearch 6.0.0-beta2 crashes with keystore passwords in Elasticsearch keystore
  # if [ -n "${JAVA_TRUSTSTORE_PWD}" ]; then
  #   echo "${JAVA_TRUSTSTORE_PWD}" | elasticsearch-keystore add "xpack.ssl.truststore.password"
  # fi
  # if [ -n "${JAVA_KEYSTORE_PWD}" ]; then
  #   echo "${JAVA_KEYSTORE_PWD}" | elasticsearch-keystore add "xpack.ssl.keystore.password"
  # fi
  if [ -n "${XPACK_BOOTSTRAP_PASSWORD}" ]; then
    echo "${XPACK_BOOTSTRAP_PASSWORD}" | elasticsearch-keystore add "bootstrap.password"
  fi
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    elasticsearch-keystore list
  fi
fi

################################################################################
#!/bin/bash -e

### XPACK_EDITION ##############################################################

# Default X-Pack edition - free Basic license
: ${XPACK_EDITION:=basic}

### ELASTICSEARCH_YML ##########################################################

ELASTICSEARCH_YML_FILES="${ELASTICSEARCH_YML_FILES} elasticsearch.x-pack.${XPACK_EDITION}.yml"

### XPACK_BOOTSTRAP_PASSWORD ###################################################

: ${XPACK_BOOTSTRAP_PASSWORD_FILE:=/run/secrets/xpack_bootstrap.pwd}
if [ -n "${XPACK_BOOTSTRAP_PASSWORD_FILE}" -a -e "${XPACK_BOOTSTRAP_PASSWORD_FILE}" ]; then
  info "Using Elasticsearch bootstrap password from file ${XPACK_BOOTSTRAP_PASSWORD_FILE}"
  XPACK_BOOTSTRAP_PASSWORD="$(cat ${XPACK_BOOTSTRAP_PASSWORD_FILE})"
fi

### XPACK_LOG4J2_PROPERTIES ####################################################

# Default X-Pack Log4j2 properties file name
: ${XPACK_LOG4J2_PROPERTIES_FILES:=log4j2.docker.properties}

################################################################################

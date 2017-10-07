#!/bin/bash -e

### LOG4J2_PROPERTIES ##########################################################

if [ ! -e ${ES_PATH_CONF}/log4j2.properties ]; then
  info "Creating ${ES_PATH_CONF}/log4j2.properties"
  (
    for LOG4J2_PROPERTIES_FILE in ${LOG4J2_PROPERTIES_FILES}; do
      echo "# ${LOG4J2_PROPERTIES_FILE}"
      cat ${ES_PATH_CONF}/${LOG4J2_PROPERTIES_FILE}
    done
  ) > ${ES_PATH_CONF}/log4j2.properties
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${ES_PATH_CONF}/log4j2.properties
  fi
fi

### JVM_OPTIONS ################################################################

if [ ! -e ${ES_PATH_CONF}/jvm.options ]; then
  info "Creating ${ES_PATH_CONF}/jvm.options"
  (
    for JVM_OPTIONS_FILE in ${JVM_OPTIONS_FILES}; do
      echo "# ${ES_PATH_CONF}/${JVM_OPTIONS_FILE}"
      cat ${ES_PATH_CONF}/${JVM_OPTIONS_FILE}
    done
  ) > ${ES_PATH_CONF}/jvm.options
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${ES_PATH_CONF}/jvm.options
  fi
fi

### ELASTICSEARCH_YML ##########################################################

if [ ! -e ${ES_PATH_CONF}/elasticsearch.yml ]; then
  info "Creating ${ES_PATH_CONF}/elasticsearch.yml"
  (
    for ELASTICSEARCH_YML_FILE in ${ELASTICSEARCH_YML_FILES}; do
      echo "# ${ELASTICSEARCH_YML_FILE}"
      cat ${ES_PATH_CONF}/${ELASTICSEARCH_YML_FILE}
    done
  ) > ${ES_PATH_CONF}/elasticsearch.yml
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${ES_PATH_CONF}/elasticsearch.yml
  fi
fi

################################################################################

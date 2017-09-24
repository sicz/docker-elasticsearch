#!/bin/bash -e

### XPACK_LOG4J2_PROPERTIES ####################################################

if [ ! -e ${ES_PATH_CONF}/x-pack/log4j2.properties ]; then
  info "Creating ${ES_PATH_CONF}/x-pack/log4j2.properties"
  (
    for XPACK_LOG4J2_PROPERTIES_FILE in ${XPACK_LOG4J2_PROPERTIES_FILES}; do
      echo "# ${XPACK_LOG4J2_PROPERTIES_FILE}"
      cat ${ES_PATH_CONF}/x-pack/${XPACK_LOG4J2_PROPERTIES_FILE}
    done
  ) > ${ES_PATH_CONF}/x-pack/log4j2.properties
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${ES_PATH_CONF}/x-pack/log4j2.properties
  fi
fi

################################################################################

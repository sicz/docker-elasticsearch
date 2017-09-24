#!/bin/bash -e

### LOGGING_YML ################################################################

if [ ! -e ${ES_PATH_CONF}/logging.yml ]; then
  info "Creating ${ES_PATH_CONF}/logging.yml"
  (
    for LOGGING_YML_FILE in ${LOGGING_YML_FILES}; do
      echo "# ${LOGGING_YML_FILE}"
      cat ${ES_PATH_CONF}/${LOGGING_YML_FILE}
    done
  ) > ${ES_PATH_CONF}/logging.yml
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${ES_PATH_CONF}/logging.yml
  fi
fi

################################################################################

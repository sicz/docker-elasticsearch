#!/bin/bash -e

### ELASTICSEARCH_YML ##########################################################

if [ ! -e ${ES_PATH_CONF}/elasticsearch.docker.yml ]; then
  info "Creating ${ES_PATH_CONF}/elasticsearch.docker.yml"
  (
    echo "node.name: ${ES_NODE_NAME}"
    echo "http.publish_host: ${ES_HTTP_PUBLISH_HOST}"
    echo "http.bind_host: ${ES_HTTP_BIND_HOST}"
    echo "transport.host: ${ES_TRANSPORT_HOST}"
    echo "path.data: ${ES_PATH_DATA}"
    echo "path.logs: ${ES_PATH_LOGS}"
  ) > ${ES_PATH_CONF}/elasticsearch.docker.yml
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${ES_PATH_CONF}/elasticsearch.docker.yml
  fi
fi

ELASTICSEARCH_YML_FILES="${ES_PATH_CONF}/elasticsearch.docker.yml ${ELASTICSEARCH_YML_FILES}"

################################################################################

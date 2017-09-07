#!/bin/bash -e

### ES_NODE ####################################################################

# Elasticsearch node name
if [ -n "${DOCKER_HOST_NAME}" ]; then
  ES_NODE_NAME="${DOCKER_CONTAINER_NAME}@${DOCKER_HOST_NAME}"
else
  ES_NODE_NAME="${DOCKER_CONTAINER_NAME}"
fi

### ES_PATH ####################################################################

# Path to settings directory
: ${ES_SETTINGS_DIR:=${ELASTICSEARCH_HOME}/config}

# Path do data and log directories
: ${ES_PATH_DATA:=${ELASTICSEARCH_HOME}/data}
: ${ES_PATH_LOGS:=${ELASTICSEARCH_HOME}/logs}
# Swarm service in replicated mode might use one volume for multiple nodes
if [ -n "${DOCKER_HOST_NAME}" ]; then
  ES_PATH_DATA=${ES_PATH_DATA}/${DOCKER_CONTAINER_NAME}
  ES_PATH_LOGS=${ES_PATH_LOGS}/${DOCKER_CONTAINER_NAME}
fi

### LOG4J2_PROPERTIES ##########################################################

# Default Log4j2 properties file name
: ${LOG4J2_PROPERTIES_FILES:=log4j2.docker.properties}

### JAVA_KEYSTORE ##############################################################

# Default truststore and keystore directories
SERVER_CRT_DIR=${ES_SETTINGS_DIR}
SERVER_KEY_DIR=${ES_SETTINGS_DIR}

### XPACK_CONFIG ###############################################################

# By default, X-Pack capabilities are disabled
: ${XPACK_ML_ENABLED:=false}            # From Elasticsearch 5.5.0
: ${XPACK_MONITORING_ENABLED:=false}    # From Elasticsearch 5.0.0
: ${XPACK_SECURITY_ENABLED:=false}      # From Elasticsearch 5.0.0
: ${XPACK_WATCHER_ENABLED:=false}       # From Elasticsearch 5.0.0

################################################################################

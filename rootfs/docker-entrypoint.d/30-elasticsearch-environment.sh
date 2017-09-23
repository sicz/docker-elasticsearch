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
: ${ES_PATH_CONF:=${ES_HOME}/config}

# Path to data and log directories
: ${ES_PATH_DATA:=${ES_HOME}/data}
: ${ES_PATH_LOGS:=${ES_HOME}/logs}
# Swarm service in replicated mode might use one volume for multiple nodes
if [ -n "${DOCKER_HOST_NAME}" ]; then
  ES_PATH_DATA=${ES_PATH_DATA}/${DOCKER_CONTAINER_NAME}
  ES_PATH_LOGS=${ES_PATH_LOGS}/${DOCKER_CONTAINER_NAME}
fi

### LOG4J2_PROPERTIES ##########################################################

# Default Log4j2 properties file name
: ${LOG4J2_PROPERTIES_FILES:=log4j2.default.properties}

### JVM_OPTIONS ################################################################

# Default Java options
: ${ES_JVM_OPTIONS_FILES:=jvm.default.options}

### JAVA_KEYSTORE ##############################################################

# Default truststore and keystore directories
SERVER_CRT_DIR=${ES_PATH_CONF}
SERVER_KEY_DIR=${ES_PATH_CONF}

################################################################################

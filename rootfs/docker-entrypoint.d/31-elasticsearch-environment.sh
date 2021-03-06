#!/bin/bash -e

### ES_PATH ####################################################################

# Path to settings directory
: ${ES_PATH_CONF:=${ES_HOME}/config}

# Path to data and log directories
: ${ES_PATH_DATA:=${ES_HOME}/data}
: ${ES_PATH_LOGS:=${ES_HOME}/logs}
# Docker Stack service in replicated mode might use one volume for multiple nodes
if [ -n "${DOCKER_HOST_NAME}" ]; then
  ES_PATH_DATA=${ES_PATH_DATA}/${DOCKER_CONTAINER_NAME}
  ES_PATH_LOGS=${ES_PATH_LOGS}/${DOCKER_CONTAINER_NAME}
fi

# Create missing directories
mkdir -p ${ES_PATH_CONF} ${ES_PATH_DATA} ${ES_PATH_LOGS}

# Populate settings directory
if [ "$(readlink -f ${ES_HOME}/config)" != "$(readlink -f ${ES_PATH_CONF})" ]; then
  info "Populating ${ES_PATH_CONF} config directory"
  cp -rp ${ES_HOME}/config/* ${ES_PATH_CONF}
fi

### ES_NODE ####################################################################

# Elasticsearch node name
if [ -n "${DOCKER_HOST_NAME}" ]; then
  ES_NODE_NAME="${DOCKER_CONTAINER_NAME}@${DOCKER_HOST_NAME}"
else
  ES_NODE_NAME="${DOCKER_CONTAINER_NAME}"
fi

info "Using '${ES_NODE_NAME}' node name"

# When Elasticsearch container is started as Docker Stack service it uses
# service loadbalancer IP address for http.publish_host on all cluster nodes
# which prevents to form a cluster.
ES_NODE_IP=$(hostname -i || echo "0.0.0.0")
: ${ES_HTTP_PUBLISH_HOST:=${ES_NODE_IP}}
: ${ES_HTTP_BIND_HOST:=0.0.0.0}
: ${ES_TRANSPORT_HOST:=${ES_NODE_IP}}

debug "ES_HTTP_PUBLISH_HOST=${ES_HTTP_PUBLISH_HOST}"
debug "ES_HTTP_BIND_HOST=${ES_HTTP_BIND_HOST}"
debug "ES_TRANSPORT_HOST=${ES_TRANSPORT_HOST}"

### LOG4J2_PROPERTIES ##########################################################

# Default Log4j2 properties file name
: ${LOG4J2_PROPERTIES_FILES:=log4j2.docker.properties}

### JVM_OPTIONS ################################################################

# Default Java options
: ${JVM_OPTIONS_FILES:=jvm.default.options}

### SERVER_CERTS ###############################################################

# Default certificate and key directories
SERVER_CRT_DIR=${ES_PATH_CONF}
SERVER_KEY_DIR=${ES_PATH_CONF}

################################################################################

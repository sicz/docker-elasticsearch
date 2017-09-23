#!/bin/bash -e

### ES_PATH ####################################################################

# Create missing directories
mkdir -p ${ES_PATH_CONF} ${ES_PATH_DATA} ${ES_PATH_LOGS}

### ES_HOST ####################################################################

# When Elasticsearch container is started as Docker Stack service it uses service
# loadbalancer IP address for http.publish_host on all cluster nodes # which
# prevents to form a cluster.
DOCKER_NODE_IP=$(hostname -i || echo "0.0.0.0")
: ${ES_HTTP_PUBLISH_HOST:=${DOCKER_NODE_IP}}
: ${ES_HTTP_BIND_HOST:=0.0.0.0}
: ${ES_TRANSPORT_HOST:=${DOCKER_NODE_IP}}

### ELASTICSEARCH_YML ##########################################################

if [ ! -e ${ES_PATH_CONF}/elasticsearch.yml ]; then
  info "Creating ${ES_PATH_CONF}/elasticsearch.yml"
  (
    echo "node.name: ${ES_NODE_NAME}"
    echo "http.publish_host: ${ES_HTTP_PUBLISH_HOST}"
    echo "http.bind_host: ${ES_HTTP_BIND_HOST}"
    echo "transport.host: ${ES_TRANSPORT_HOST}"
    echo "path.data: ${ES_PATH_DATA}"
    echo "path.logs: ${ES_PATH_LOGS}"
    echo "# Environment variables"
    for ES_SETTINGS_FILE in ${ES_SETTINGS_FILES}; do
      echo "# ${ES_PATH_CONF}/${ES_SETTINGS_FILE}"
      cat ${ES_PATH_CONF}/${ES_SETTINGS_FILE}
    done
  ) > ${ES_PATH_CONF}/elasticsearch.yml
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${ES_PATH_CONF}/elasticsearch.yml
  fi
fi

if [ -n "${DOCKER_CONTAINER_START}" ]; then
  declare -a ES_OPTS
  while IFS="=" read -r KEY VAL; do
    if [ ! -z "${VAL}" ]; then
      ES_OPTS+=("-E${KEY}=${VAL}")
    fi
  done < <(env | egrep "^[a-z_]+\.[a-z_]+" | sort)
  set -- "$@" "${ES_OPTS[@]}"
  unset ES_OPTS
fi

export ES_PATH_CONF

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
    for ES_JVM_OPTIONS_FILE in ${ES_JVM_OPTIONS_FILES}; do
      echo "# ${ES_PATH_CONF}/${ES_JVM_OPTIONS_FILE}"
      cat ${ES_PATH_CONF}/${ES_JVM_OPTIONS_FILE}
    done
  ) > ${ES_PATH_CONF}/jvm.options
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${ES_PATH_CONF}/jvm.options
  fi
fi

### ES_PATH ####################################################################

# Set permissions
chown -R ${DOCKER_USER}:${DOCKER_GROUP} ${ES_PATH_CONF} ${ES_PATH_DATA} ${ES_PATH_LOGS}
chmod -R u=rwX,g=rX,o-rwx ${ES_PATH_CONF} ${ES_PATH_DATA} ${ES_PATH_LOGS}

### ES_JAVA_OPTS ###############################################################

# The virtual file /proc/self/cgroup should list the current cgroup
# membership. For each hierarchy, you can follow the cgroup path from
# this file to the cgroup filesystem (usually /sys/fs/cgroup/) and
# introspect the statistics for the cgroup for the given
# hierarchy. Alas, Docker breaks this by mounting the container
# statistics at the root while leaving the cgroup paths as the actual
# paths. Therefore, Elasticsearch provides a mechanism to override
# reading the cgroup path from /proc/self/cgroup and instead uses the
# cgroup path defined the JVM system property
# es.cgroups.hierarchy.override. Therefore, we set this value here so
# that cgroup statistics are available for the container this process
# will run in.
export ES_JAVA_OPTS="-Des.cgroups.hierarchy.override=/ $ES_JAVA_OPTS"

################################################################################

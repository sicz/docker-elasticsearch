#!/bin/bash -e

### ES_PATH ####################################################################

# Create missing directories
mkdir -p ${ES_SETTINGS_DIR} ${ES_PATH_DATA} ${ES_PATH_LOGS}

### ES_HOST ####################################################################

# When Elasticsearch container is started as Docker service it uses Docker
# service loadbalancer IP address for http.publish_host on all cluster nodes
# which prevents to form a cluster.
DOCKER_NODE_IP=$(hostname -i || echo "0.0.0.0")
: ${ES_HTTP_PUBLISH__HOST:=${DOCKER_NODE_IP}}
: ${ES_HTTP_BIND__HOST:=0.0.0.0}
: ${ES_TRANSPORT_HOST:=${DOCKER_NODE_IP}}

### XPACK_MONITORING ###########################################################

for XPACK_MONITORING_EXPORTER in ${XPACK_MONITORING_EXPORTERS}; do
  eval ": \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_TYPE:=http}"
  if eval "[ -e /run/secrets/es_\${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_AUTH_USERNAME}_pwd ]"; then
    eval ": \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_AUTH_PASSWORD_FILE:=/run/secrets/es_\${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_AUTH_USERNAME}.pwd}"
  else
    eval ": \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_AUTH_PASSWORD_FILE:=${ES_SETTINGS_DIR}/es_\${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_AUTH_USERNAME}.pwd}"
  fi
  if eval "[ -e \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_AUTH_PASSWORD_FILE} ]"; then
    eval ": \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_AUTH_USERNAME:=monitoring}"
    eval "XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_AUTH_PASSWORD=$(cat \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_AUTH_PASSWORD_FILE})"
  fi
  eval "unset XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_AUTH_PASSWORD_FILE"
  if [ -e ${JAVA_TRUSTSTORE_FILE} ]; then
    eval ": \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_SSL_TRUSTSTORE_PATH:=${JAVA_TRUSTSTORE_FILE}}"
    eval ": \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_SSL_TRUSTSTORE_PASSWORD:=${JAVA_TRUSTSTORE_PWD}}"
  fi
  if [ -e ${JAVA_KEYSTORE_FILE} ]; then
    eval ": \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_SSL_KEYSTORE_PATH:=${JAVA_KEYSTORE_FILE}}"
    eval ": \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_SSL_KEYSTORE_PASSWORD:=${JAVA_KEYSTORE_PWD}}"
  fi
  if eval "[ -n \"\${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_SSL_TRUSTSTORE_PATH}\" ]"; then
    eval ": \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_HOST:=https://${XPACK_MONITORING_EXPORTER}:9200}"
  else
    eval ": \${XPACK_MONITORING_EXPORTERS_${XPACK_MONITORING_EXPORTER}_HOST:=http://${XPACK_MONITORING_EXPORTER}:9200}"
  fi
done
unset XPACK_MONITORING_EXPORTER
unset XPACK_MONITORING_EXPORTERS

### ELASTICSEARCH_YML ###############################################################

if [ ! -e ${ES_SETTINGS_DIR}/elasticsearch.yml ]; then
  info "Creating ${ES_SETTINGS_DIR}/elasticsearch.yml"
  (
    for ES_SETTINGS_FILE in ${ES_SETTINGS_FILES}; do
      cat ${ES_SETTINGS_DIR}/${ES_SETTINGS_FILE}
    done
    while IFS="=" read -r KEY VAL; do
      if [ ! -z "${VAL}" ]; then
        echo "${KEY}: ${VAL}"
      fi
    done < <(set | egrep "^(ES|XPACK)_" | egrep -v "^(ES_JAVA_OPTS=|ES_PATH_PLUGINS=|ES_SETTINGS_)" | sed -E "s/^ES_//" | tr "_[:upper:]" ".[:lower:]" | sed -E "s/\.\./_/g" | sort)
  ) > ${ES_SETTINGS_DIR}/elasticsearch.yml
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${ES_SETTINGS_DIR}/elasticsearch.yml
  fi
fi

### LOG4J2_PROPERTIES ##########################################################

if [ ! -e ${ES_SETTINGS_DIR}/log4j2.properties ]; then
  info "Creating ${ES_SETTINGS_DIR}/log4j2.properties"
  (
    for LOG4J2_PROPERTIES_FILE in ${LOG4J2_PROPERTIES_FILES}; do
      cat ${ES_SETTINGS_DIR}/${LOG4J2_PROPERTIES_FILE}
    done
    while IFS="=" read -r KEY VAL; do
      if [ ! -z "${VAL}" ]; then
        echo "${KEY} = ${VAL}"
      fi
    done < <(set | egrep "^LOG4J2_" | egrep -v "^(LOG4J2_PROPERTIES_)" | sed -E "s/^LOG4J2_//" | tr "_[:upper:]" ".[:lower:]" | sort)
  ) > ${ES_SETTINGS_DIR}/log4j2.properties
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${ES_SETTINGS_DIR}/log4j2.properties
  fi
fi

### ES_PATH ####################################################################

# Set permissions
chown -R ${DOCKER_USER}:${DOCKER_GROUP} ${ES_SETTINGS_DIR} ${ES_PATH_DATA} ${ES_PATH_LOGS}
chmod -R o-rwx ${ES_SETTINGS_DIR} ${ES_PATH_DATA} ${ES_PATH_LOGS}

################################################################################

# Export Elasticsearch Java options
export ES_JAVA_OPTS

################################################################################

#!/bin/bash -e

### XPACK_ELASTICSEARCH_YML ####################################################

# Default X-Pack TLS settings file
XPACK_DEFAULT_TLS_SETTINGS_FILE="elasticsearch.default_tls_settings.yml"

### XPACK_LOG4J2_PROPERTIES ####################################################

# Default X-Pack Log4j2 properties file name
: ${XPACK_LOG4J2_PROPERTIES_FILES:=log4j2.default.properties}

################################################################################

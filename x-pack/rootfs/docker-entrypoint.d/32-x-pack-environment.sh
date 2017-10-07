#!/bin/bash -e

### XPACK_EDITION ##############################################################

# Default X-Pack edition - free Basic license
: ${XPACK_EDITION:=basic}

### ELASTICSEARCH_YML ##########################################################

ELASTICSEARCH_YML_FILES="${ELASTICSEARCH_YML_FILES} elasticsearch.x-pack.${XPACK_EDITION}.yml"

### XPACK_LOG4J2_PROPERTIES ####################################################

# Default X-Pack Log4j2 properties file name
: ${XPACK_LOG4J2_PROPERTIES_FILES:=log4j2.docker.properties}

################################################################################

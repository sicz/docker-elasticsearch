#!/bin/bash -e

# Elasticsearch 2.x

### LOG4J2_PROPERTIES ##########################################################

# Default Log4j2 properties file name
unset LOG4J2_PROPERTIES_FILES

### LOGGING_YML ################################################################

# Default Log4j properties file name
: ${LOGGING_YML_FILES=logging.default.yml}

### JVM_OPTIONS ################################################################

# Default Java options
unset ES_JVM_OPTIONS_FILES

################################################################################

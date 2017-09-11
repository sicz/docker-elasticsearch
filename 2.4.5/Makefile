### DOCKER_IMAGE ###############################################################

ELASTICSEARCH_VERSION	?= 2.4.5

DOCKER_IMAGE_TAGS	?= 2.4 2

### BUILD ######################################################################

VARIANT_DIR		?= $(CURDIR)

### EXECUTOR ###################################################################

# Elasticsearch 2 does not have bootstrap checks
ES_DISCOVERY_TYPE	?=

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(abspath ..)
include $(PROJECT_DIR)/docker.version.mk

################################################################################

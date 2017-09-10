### DOCKER_IMAGE ###############################################################

ELASTICSEARCH_VERSION	?= 6.0.0-beta2

DOCKER_IMAGE_TAG	?= $(shell echo $(ELASTICSEARCH_VERSION) | sed -E "s/-.*//")
DOCKER_IMAGE_TAGS	?= 6.0 6

### EXECUTOR ###################################################################

COMPOSE_VARS		+= ES_DISCOVERY_TYPE

ES_DISCOVERY_TYPE	?= single-node

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(abspath ..)
include $(PROJECT_DIR)/docker.version.mk

################################################################################

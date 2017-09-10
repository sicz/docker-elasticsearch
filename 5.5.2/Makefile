### DOCKER_IMAGE ###############################################################

ELASTICSEARCH_VERSION	?= 5.5.2

DOCKER_IMAGE_TAGS	?= 5.5 5 latest

### EXECUTOR ###################################################################

COMPOSE_VARS		+= ES_DISCOVERY_TYPE

ES_DISCOVERY_TYPE	?= single-node

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(abspath ..)
include $(PROJECT_DIR)/docker.version.mk

################################################################################

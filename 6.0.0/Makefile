### DOCKER_IMAGE ###############################################################

ELASTICSEARCH_VERSION	?= 6.0.0-beta2

DOCKER_IMAGE_TAG	?= $(shell echo $(ELASTICSEARCH_VERSION) | sed -E "s/-.*//")

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(abspath ..)
include $(PROJECT_DIR)/docker.version.mk

################################################################################

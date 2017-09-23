### DOCKER_IMAGE ###############################################################

ELASTICSEARCH_VERSION	?= 6.0.0-beta2
ELASTICSEARCH_TAG	?= $(subst -beta2,,$(ELASTICSEARCH_VERSION))

### TEST #######################################################################

# Skip Elasticsearch X-Pack tests
SPEC_OPTS		?= --tag ~x_pack

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(abspath ..)
include $(PROJECT_DIR)/docker.version.mk

################################################################################

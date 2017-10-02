### BASE_IMAGE #################################################################

BASE_IMAGE_NAME		?= $(DOCKER_IMAGE_NAME)
BASE_IMAGE_TAG		?= $(ELASTICSEARCH_TAG)

### DOCKER_IMAGE ###############################################################

DOCKER_IMAGE_TAG	?= $(BASE_IMAGE_TAG)-x-pack

### BUILD ######################################################################

VARIANT_DIR		?= $(PROJECT_DIR)/x-pack

### EXECUTOR ###################################################################

DOCKER_CONFIG		?= x-pack-5

# Elasticsearch HTTP endpoint
ELASTICSEARCH_URL	?= https://elasticsearch.local:9200

### TEST #######################################################################

# Do all tests
SPEC_OPTS		?=

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(abspath ../..)
include ../Makefile

################################################################################

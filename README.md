# docker-elasticsearch

[![CircleCI Status Badge](https://circleci.com/gh/sicz/docker-elasticsearch.svg?style=shield&circle-token=f63ab29b32c23bb250c02d1cc6db3300396888e2)](https://circleci.com/gh/sicz/docker-elasticsearch)

**This project is not aimed at public consumption.
It exists to serve as a single endpoint for SICZ containers.**

[Elasticsearch](https://www.elastic.co/products/elasticsearch) is a NoSQL database and search engine.

## Contents

This container only contains essential components:
* [sicz/openjdk:8-jre-centos](https://github.com/sicz/docker-openjdk)
  as a base image.
* [Elasticsearch](https://www.elastic.co/products/elasticsearch) is a NoSQL
  database and search engine.
* [Elasticsearch X-Pack plugin](https://www.elastic.co/products/x-pack) adds
  many capabilities to Elasticsearch.

## Getting started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes. See deployment for notes
on how to deploy the project on a live system.

### Installing

Clone the GitHub repository into your working directory:
```bash
git clone https://github.com/sicz/docker-elasticsearch
```

### Usage

The project contains Docker image version directories:
* `2.4.1` - Elasticsearch 2.4.1
* `5.5.2` - Elasticsearch 5.5.2
* `6.0.0` - Elasticsearch 6.0.0

Use the command `make` in the project directory:
```bash
make all                          # Build and test all Docker images
make build                        # Build all Docker images
make rebuild                      # Rebuild all Docker images
make clean                        # Remove all containers and clean work files
make docker-pull                  # Pull all images from Docker Registry
make docker-pull-dependencies     # Pull all image dependencies from Docker Registry
make docker-pull-image            # Pull all project images from Docker Registry
make docker-pull-testimage        # Pull all project images from Docker Registry
make docker-push                  # Push all project images to Docker Registry
```

Use the command `make` in the image version directories:
```bash
make all                # Build a new image and run the tests
make ci                 # Build a new image and run the tests
make build              # Build a new image
make rebuild            # Build a new image without using the Docker layer caching
make config-file        # Display the configuration file for the current configuration
make vars               # Display the make variables for the current configuration
make up                 # Remove the containers and then run them fresh
make create             # Create the containers
make start              # Start the containers
make stop               # Stop the containers
make restart            # Restart the containers
make rm                 # Remove the containers
make wait               # Wait for the start of the containers
make ps                 # Display running containers
make logs               # Display the container logs
make logs-tail          # Follow the container logs
make shell              # Run the shell in the container
make test               # Run the tests
make test-shell         # Run the shell in the test container
make clean              # Remove all containers and work files
make docker-pull        # Pull all images from the Docker Registry
make docker-pull-dependencies # Pull the project image dependencies from the Docker Registry
make docker-pull-image  # Pull the project image from the Docker Registry
make docker-pull-testimage # Pull the test image from the Docker Registry
make docker-push        # Push the project image into the Docker Registry
```

`elasticsearch` container with the default configuration listens on TCP port
9200.

## Deployment

You can start with this sample `docker-compose.yml` file:
```yaml
services:
  elasticsearch:
    image: sicz/elasticsearch
    ports:
      - 9200:9200
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch_data
volumes:
  elasticsearch_data:
```

## Authors

* [Petr Řehoř](https://github.com/prehor) - Initial work.

See also the list of [contributors](https://github.com/sicz/docker-elasticsearch/contributors)
who participated in this project.

## License

This project is licensed under the Apache License, Version 2.0 - see the
[LICENSE](LICENSE) file for details.

VERSION          ?= v10

DOCKER           ?= $(shell which docker)
BUILD_IMAGE      ?= "zenoss/serviced-ceph:$(VERSION)"
PWD               = $(shell pwd)

######################
# Dockerized targets #
#####################

.PHONY:
docker_build_quickstart:
	$(DOCKER) build -t $(BUILD_IMAGE) quickstart/

.PHONY:
docker_run_quickstart:
	cd quickstart && $(DOCKER) run --name=ceph -v `pwd`:/mnt/pwd -it $(BUILD_IMAGE) su - ceph -c bash

clean:
	docker rmi $(BUILD_IMAGE)


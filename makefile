VERSION          ?= v10

DOCKER           ?= $(shell which docker)
BUILD_IMAGE      ?= "zenoss/serviced-ceph:$(VERSION)"
PWD               = $(shell pwd)

NODES_MON  = ceph-mon1
NODES_OSD  = ceph-osd1
NODES_OSD += ceph-osd2

######################
# Dockerized targets #
#####################

FORCE:
	$(DOCKER) build -t $(BUILD_IMAGE) quickstart/

.PHONY:
run:
	@echo ==== STARTING CONTAINERS: $(NODES_MON) $(NODES_OSD)
	for node in $(NODES_OSD); do \
		( mkdir -p share/$${node} && cd quickstart && \
			$(DOCKER) run -d --hostname=$${node} --name=$${node} \
			-v `pwd`/share/$${node}:/mnt/space -v `pwd`:/mnt/pwd -it $(BUILD_IMAGE) /usr/sbin/sshd -D); \
	done
	for node in $(NODES_MON); do \
		( mkdir -p share/$${node} && cd quickstart && \
			$(DOCKER) run -d --hostname=$${node} --name=$${node} \
			`echo $(NODES_OSD)|awk 'BEGIN{RS=" "}{print "--link", $$1 ":" $$1}'` \
			-v `pwd`/share/$${node}:/mnt/space -v `pwd`:/mnt/pwd -it $(BUILD_IMAGE) /usr/sbin/sshd -D ); \
	done
	@echo ==== SETTING UP NODES: $(NODES_MON) $(NODES_OSD)
	docker exec -it $(NODES_MON) /setup-hosts.sh $(NODES_MON) $(NODES_OSD)
	@echo ==== SETTING UP CLUSTER
	docker exec -it $(NODES_MON) su - ceph /quick-ceph-cluster.sh $(NODES_MON) $(NODES_OSD)
	@echo ==== CLUSTER READY FOR NODES: $(NODES_MON) $(NODES_OSD)

.PHONY:
rm:
	docker stop $(NODES_MON) $(NODES_OSD) | xargs docker rm -fv

.PHONY:
clean:
	docker rmi $(BUILD_IMAGE)
	rm -fr share


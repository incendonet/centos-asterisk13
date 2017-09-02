IMAGE_NAME_BUILDER = centos-asterisk13
CONTAINER_NAME = builder
IMAGE_NAME = asterisk
IMAGE_TAG_FINAL = 13.13-cert5
REPO_HOST = docker.io
REPO_NAME = incendonet
LOCAL_REPO_PORT = 5000

BASE_DIR = /usr/local/src/$(REPO_NAME)/images
PROJ_DIR = $(BASE_DIR)/$(IMAGE_NAME_BUILDER)
ART_DIR = $(BASE_DIR)/artifacts/$(IMAGE_NAME)
SHARE_MAN_DIR = share/man
VAR_LIB_DIR = var/lib
SW = $(PROJ_DIR)/software
GIT_NAME = centos-asterisk13

.PHONY: build clean tag push-local push-remote

default: build

build:
	mkdir -p $(SW)
	mkdir -p $(ART_DIR)
	mkdir -p $(ART_DIR)/$(SHARE_MAN_DIR)
	mkdir -p $(ART_DIR)/$(VAR_LIB_DIR)

	-docker rm $(CONTAINER_NAME)
	docker build \
		-t $(REPO_HOST)/$(REPO_NAME)/$(IMAGE_NAME_BUILDER) \
		-f Dockerfile \
		.
	-docker create --name=$(CONTAINER_NAME) $(REPO_HOST)/$(REPO_NAME)/$(IMAGE_NAME_BUILDER) /bin/true
	docker cp $(CONTAINER_NAME):/usr/local/lib/ $(ART_DIR)/
	docker cp $(CONTAINER_NAME):/usr/local/sbin/ $(ART_DIR)/
	docker cp $(CONTAINER_NAME):/usr/local/$(SHARE_MAN_DIR)/man8/ $(ART_DIR)/$(SHARE_MAN_DIR)/
	docker cp $(CONTAINER_NAME):/usr/local/$(VAR_LIB_DIR)/asterisk/ $(ART_DIR)/$(VAR_LIB_DIR)/

	mkdir -p $(SW)/lib
	mkdir -p $(SW)/sbin
	mkdir -p $(SW)/$(SHARE_MAN_DIR)/man8
	mkdir -p $(SW)/$(VAR_LIB_DIR)/asterisk
	cp -R $(ART_DIR)/lib $(SW)/
	cp -R $(ART_DIR)/sbin $(SW)/
	cp -R $(ART_DIR)/$(SHARE_MAN_DIR)/man8 $(SW)/share/man/
	cp -R $(ART_DIR)/$(VAR_LIB_DIR)/asterisk $(SW)/var/lib/
	docker build \
		-t $(REPO_HOST)/$(REPO_NAME)/$(IMAGE_NAME):$(IMAGE_TAG_FINAL) \
		-f asterisk13-min.Dockerfile \
		.

clean:
	rm -Rf $(PROJ_DIR)
	docker rm $(CONTAINER_NAME)

tag:
	docker tag $(REPO_HOST)/$(REPO_NAME)/$(IMAGE_NAME):$(IMAGE_TAG_FINAL) $(REPO_HOST)/$(REPO_NAME)/$(IMAGE_NAME):latest
	docker tag $(REPO_HOST)/$(REPO_NAME)/$(IMAGE_NAME):latest localhost:$(LOCAL_REPO_PORT)/$(IMAGE_NAME)
	docker tag $(REPO_HOST)/$(REPO_NAME)/$(IMAGE_NAME):latest localhost:$(LOCAL_REPO_PORT)/$(IMAGE_NAME):$(IMAGE_TAG_FINAL)

push-local: tag
	docker push localhost:$(LOCAL_REPO_PORT)/$(IMAGE_NAME):$(IMAGE_TAG_FINAL)
	docker push localhost:$(LOCAL_REPO_PORT)/$(IMAGE_NAME):latest

push-remote: tag
	docker push $(REPO_HOST)/$(REPO_NAME)/$(IMAGE_NAME):$(IMAGE_TAG_FINAL)
	docker push $(REPO_HOST)/$(REPO_NAME)/$(IMAGE_NAME):latest

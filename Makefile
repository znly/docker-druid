DOCKER_REPO_NAME:= gcr.io/npav-172917/
DOCKER_IMAGE_NAME := druid-0.10.1-stable
DOCKER_VER := $(if $(DOCKER_VER),$(DOCKER_VER),latest)

all: docker

docker: .FORCE
	docker build -t $(DOCKER_REPO_NAME)$(DOCKER_IMAGE_NAME):$(DOCKER_VER) .

push: docker
	docker push $(DOCKER_REPO_NAME)$(DOCKER_IMAGE_NAME):$(DOCKER_VER)

circleci-push: circleci-docker
	docker push $(DOCKER_REPO_NAME)$(DOCKER_IMAGE_NAME):$(DOCKER_VER)

circleci-docker: .FORCE
	docker build -t $(DOCKER_REPO_NAME)$(DOCKER_IMAGE_NAME):$(DOCKER_VER) .
	
.FORCE: 
clean:  
	rm -rf bin


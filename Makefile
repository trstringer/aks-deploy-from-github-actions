VERSION_FILE := version
VERSION := $(shell cat ${VERSION_FILE})
IMAGE_REPO := $(ACR_NAME).azurecr.io/upgrade-test

build:
	docker build -t $(IMAGE_REPO):$(VERSION) .

registry-login:
	@az login \
		--service-principal \
		--username $(SERVICE_PRINCIPAL_APP_ID) \
		--password $(SERVICE_PRINCIPAL_SECRET) \
		--tenant $(SERVICE_PRINCIPAL_TENANT)
	@az acr login --name $(ACR_NAME)

push:
	docker push $(IMAGE_REPO):$(VERSION)

deploy:
	sed 's|IMAGE_REPO|$(IMAGE_REPO)|g; s/VERSION/$(VERSION)/g' ./deployment.yaml | \
		kubectl apply -f -

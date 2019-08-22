ifneq ($(VERSION),)
	DOCKER_IMAGE_TAG := :$(shell echo $(VERSION) | cut -c 2-)
	TARBALL_NAME := julia-$(shell echo $(VERSION) | cut -c 2-)-x86_64-linux-musl.tar.gz
endif
image:
	docker build --build-arg VERSION=$(VERSION) -t fredrikekre/julia-alpine$(DOCKER_IMAGE_TAG) .
binary-dist:
	rm -rf build
	docker build --build-arg VERSION=$(VERSION) --target=builder -t julia-alpine-builder$(DOCKER_IMAGE_TAG) .
	docker run -itd --rm --name extract-tarball julia-alpine-builder$(DOCKER_IMAGE_TAG)
	docker exec extract-tarball sh -c "mkdir /extract; mv julia*.tar.gz /extract"
	docker cp extract-tarball:/extract/ build
	docker stop extract-tarball
ifneq ($(TARBALL_NAME),)
	mv build/julia*.tar.gz build/$(TARBALL_NAME)
endif
	cd build && \
	sha256sum * > julia-$(shell echo $(VERSION) | cut -c 2-).sha256 && \
	cd ..

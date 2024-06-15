
all: lint test

.PHONY: test
test:
	nim c -r tests/* "*"

.PHONY: docker-build-static
docker-build-static:
	docker buildx build \
	--platform linux/amd64 \
	--tag nim-static-example \
	-f Dockerfile.static .


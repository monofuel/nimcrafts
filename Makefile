
all: lint test

.PHONY: test
test:
	nim c -r tests/*

.PHONY: lint
lint:
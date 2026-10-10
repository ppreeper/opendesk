# Prefer podman, fall back to docker for the bashly build container.
CONTAINER ?= $(shell command -v podman >/dev/null 2>&1 && echo podman || echo docker)

build:
	$(CONTAINER) run --rm -i -e BASHLY_TAB_INDENT=1 -v "$(CURDIR):/app" docker.io/dannyben/bashly generate --upgrade

.PHONY: build lint test

lint:
	uv run ansible-lint

test:
	uv run molecule test

SHELL := /usr/bin/env bash

.PHONY: validate backend-test web-test platform-build public-repo-check

validate: public-repo-check backend-test web-test platform-build

backend-test:
	python3 -m pip install --require-hashes -r app/backend/requirements.lock
	pytest -q app/backend/tests

web-test:
	cd app/web && npm ci && npm test

platform-build:
	kustomize build platform/clusters/prod >/tmp/mobile-platform-prod.yaml

public-repo-check:
	./scripts/check-public-repo.sh

ROOT := $(shell git rev-parse --show-toplevel)
FLUTTER := $(shell which flutter)
FLUTTER_BIN_DIR := $(shell dirname $(FLUTTER))
FLUTTER_DIR := $(FLUTTER_BIN_DIR:/bin=)
DART := $(FLUTTER_BIN_DIR)/cache/dart-sdk/bin/dart
CLIENT_DIR := rest_client

# Flutter
.PHONY: analyze
analyze:
	$(FLUTTER) analyze

.PHONY: format
format:
	$(FLUTTER) format .

.PHONY: test
test:
	$(FLUTTER) test

.PHONY: codegen
codegen:
	openapi-generator generate \
		-i https://raw.githubusercontent.com/TimeCopSync/timecopsync_projects_api/refs/heads/main/priv/static/swagger.json \
		-g dart \
		-o $(CLIENT_DIR) \
		-pubAuthor=timecopsync-project \
		-pubAuthorEmail=yann.pomie@laposte.net \
		-pubDescription="Api client to interact with a timecopsync endpoint (generated with openapi-generator)" \
		-pubName=timecopsync_api \
		--minimal-update
	rm -v $(CLIENT_DIR)/.travis.yml
	rm -v $(CLIENT_DIR)/git_push.sh

.PHONY: run
run:
	$(FLUTTER) run


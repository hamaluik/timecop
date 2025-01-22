ROOT := $(shell git rev-parse --show-toplevel)
FLUTTER := $(shell which flutter)
DART := $(shell which dart)
FLUTTER_BIN_DIR := $(shell dirname $(FLUTTER))
FLUTTER_DIR := $(FLUTTER_BIN_DIR:/bin=)
CLIENT_DIR := openapi

.PHONY: run
run:
	$(FLUTTER) run

.PHONY: analyze
analyze:
	$(FLUTTER) analyze

.PHONY: format
format:
	$(DART) format .

.PHONY: check-format
check-format:
	$(DART) format . --set-exit-if-changed


.PHONY: test
test:
	$(FLUTTER) test

.PHONY: codegen
codegen:
	openapi-generator generate \
		-i https://raw.githubusercontent.com/TimeCopSync/timecopsync_projects_api/refs/heads/main/priv/static/swagger.json \
		-g dart \
		-o $(CLIENT_DIR) \
		-pubName=$(CLIENT_DIR) \
		-pubAuthor=timecopsync-project \
		-pubAuthorEmail=yann.pomie@laposte.net \
		-pubDescription="Api client to interact with a timecopsync endpoint (generated with openapi-generator)" \
		-pubName=timecopsync_api \
		--minimal-update
	rm -v $(CLIENT_DIR)/.travis.yml
	rm -v $(CLIENT_DIR)/git_push.sh
	$(DART) format $(CLIENT_DIR)

.PHONY: ci
ci:
	$(FLUTTER) pub get
	$(DART) format . -o none --set-exit-if-changed
	$(FLUTTER) analyze
	$(FLUTTER) test

SHELL=/bin/bash

build:
	swift build

release:
	swift build -c release
	
test:
	swift test --parallel

test-with-coverage:
	swift test --parallel --enable-code-coverage

clean:
	rm -rf .build

check:
	./scripts/run-checks.sh

format:
	./scripts/run-swift-format.sh --fix

make build-swift-openapi:
	./scripts/generate-swift-openapi.sh

make openapi-server:
	./scripts/run-openapi-server.sh

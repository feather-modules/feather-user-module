SHELL=/bin/bash

baseUrl = https://raw.githubusercontent.com/BinaryBirds/github-workflows/refs/heads/dev/scripts

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

lint:
	curl -s $(baseUrl)/run-swift-format.sh | bash

format:
	curl -s $(baseUrl)/run-swift-format.sh | bash -s -- --fix 

run-openapi:
	curl -s $(baseUrl)/run-openapi-docker.sh | bash -s
REPORTER = spec
VERSION := $(shell cat package.json | grep version | grep -o -E '[0-9]+\.[0-9]+\.[0-9]+')
TESTFILES := $(shell find test -name '*-test.js' -path './test/browser' -prune)
SRC := $(shell find lib -name "*.js" -type f)

wantworthy.js: $(SRC)
	@node support/compile $^

test: test-unit

test-unit:
	@./node_modules/.bin/mocha \
		--ui bdd \
		--reporter $(REPORTER) \
		--globals i,e \
		$(TESTFILES)

test-spec:
	@./node_modules/.bin/mocha \
		--ui bdd \
		--reporter $(REPORTER) \
		--grep "$(grep)" \
		--globals i,e \
		$(TESTFILES)

clean:
	rm -rf ./examples/build

release:
	git tag -a v$(VERSION) -m 'release version $(VERSION)'
	git push
	git push --tags
	npm publish .

.PHONY: test test-unit test-spec release
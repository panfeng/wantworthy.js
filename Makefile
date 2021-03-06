REPORTER = spec
VERSION := $(shell cat package.json | grep version | grep -o -E '[0-9]+\.[0-9]+\.[0-9]+')
TESTFILES := $(shell find test -path 'test/browser' -prune -o -name '*-test.js' -type f -print)
SRC := $(shell find lib -name "*.js" -type f)

wantworthy.js: $(SRC)
	@node support/compile $^

test: test-unit

test-unit:
	@./node_modules/.bin/mocha \
		--ui bdd \
		--reporter $(REPORTER) \
		$(TESTFILES)

test-spec:
	@./node_modules/.bin/mocha \
		--ui bdd \
		--reporter $(REPORTER) \
		--grep "$(grep)" \
		$(TESTFILES)

test-server:
	@node test/browser/server

clean:
	rm -rf ./examples/build

hint:
	find lib -name "*.js" -print0 | xargs -0 ./node_modules/.bin/jshint --config .jshintrc

release:
	git tag -a v$(VERSION) -m 'release version $(VERSION)'
	git push
	git push --tags
	npm publish .

.PHONY: test test-unit test-spec release
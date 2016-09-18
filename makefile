all: build

clean:
	scripts/clean.sh

build: clean
	scripts/build.sh

watch: clean
	scripts/watch.sh

lint:
	scripts/lint.sh

all: build

init:
	scripts/init.sh

clean:
	scripts/clean.sh

build: clean
	scripts/build.sh

watch: clean
	scripts/watch.sh

lint:
	scripts/lint.sh

link:
	scripts/link.sh

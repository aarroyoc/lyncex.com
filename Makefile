.PHONY: build
build:
	/home/aarroyoc/dev/scryer-prolog/target/release/scryer-prolog -g 'run("website", "output"),halt' render.pl

.PHONY: clean
clean:
	rm -rf output
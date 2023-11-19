

##
## * https://packages.debian.org/sid/live-build
##


prepare:
	sudo apt-get install live-build
.PHONY: prepare


debian-keyring-install:
	sudo apt-get install debian-keyring
.PHONY: debian-keyring-install


build:
	./build.sh
.PHONY: build


run_iso:
	echo "TODO:"
.PHONY: run_iso


clean:
	sudo rm -rf tmp
.PHONY: clean

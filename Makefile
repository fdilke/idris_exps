# a more standard makefile.
#
#

idris   ?= idris
pkg     := IdrisExps
target  := ./target

.PHONY: build clean clobber install rebuild test

all: test

build:
	@ ${idris} --ibcsubdir ${target} --build ${pkg}.ipkg

clean:
	@ ${idris} --clean ${pkg}.ipkg

clobber: clean
	@ find . -name '*.ibc' -delete

install:
	@ ${idris} --ibcsubdir ${target} --install ${pkg}.ipkg

rebuild: clean build

test:
	@ ${idris} --ibcsubdir ${target} --testpkg ${pkg}.ipkg


#   all: install test app
#
#   install:
#   	idris --install build.ipkg
#
#   app:
#   	idris -i src -p contrib Main.idr -o run
#   	@echo "Created executable file run"
#
#   test: install
#   	idris -i src -p contrib test/test.idr -o run-tests
#   	@echo "Created test executable file run-tests"
#   	./run-tests
#
#   alt-test:
#   	idris --testpkg build.ipkg
#
#   clean:
#   	idris --clean build.ipkg
#   	rm -f run run-tests Main.ibc
#   	find . -name *~ -delete
#   	find . -name *.o -delete
#   	find . -name *.ibc -delete
#
#   .PHONY: app test alt-test clean

all: install test app

install:
	idris --install build.ipkg

app:
	idris -i src -p contrib Main.idr -o run
	@echo "Created executable file run"

test: install
	idris -i src -p contrib test/test.idr -o run-tests
	@echo "Created test executable file run-tests"
	./run-tests

clean:
	idris --clean build.ipkg
	rm -f run run-tests Main.ibc
	find . -name *~ -delete
	find . -name *.o -delete
	find . -name *.ibc -delete

.PHONY: app test clean

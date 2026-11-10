.PHONY: all clean build

all: build

build:
	@chmod +x build.sh
	./build.sh

clean:
	rm -rf out/ build_temp/
	@echo "Մաքրված է։"

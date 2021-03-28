all: build run

build:
	docker build -t verne_test:racetest .
run:
	docker run --rm -it -p 1883:1883 verne_test:racetest

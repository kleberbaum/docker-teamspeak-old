.PHONY : all build run clear check logs
TS_VOICE_PORT=$(or $(VOICE_PORT),1337) # Use non standard port to evaluate environment variables

all: build

build:
	docker build -t phaldan/teamspeak .

run:
	docker run -d --name teamspeak -v ${PWD}/config:/teamspeak/config -v ${PWD}/files:/teamspeak/files -v ${PWD}/logs:/teamspeak/logs -e "TS_DEFAULT_VOICE_PORT=$(TS_VOICE_PORT)" phaldan/teamspeak

clear:
	docker stop teamspeak
	docker rm teamspeak

check: run
	sleep 1
	make logs 2>/dev/null | grep listening | grep VirtualServer | grep $(TS_VOICE_PORT) > /dev/null || (make logs clear && false)
	make clear

logs:
	docker logs teamspeak


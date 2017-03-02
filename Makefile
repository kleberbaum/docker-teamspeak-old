.PHONY : all build run clear check logs
TS_VERSION=$(or $(VERSION),3.0.13.6)
TS_VOICE_PORT=$(or $(VOICE_PORT),1337) # Use non standard port to evaluate environment variables

all: build

build:
	docker build --build-arg TS_VERSION=$(TS_VERSION) -t phaldan/teamspeak:$(TS_VERSION) .

run:
	docker run -d --name teamspeak \
	-v ${PWD}/config:/teamspeak/config \
	-v ${PWD}/files:/teamspeak/files \
	-v ${PWD}/logs:/teamspeak/logs \
	-e "TS_DEFAULT_VOICE_PORT=$(TS_VOICE_PORT)" \
	phaldan/teamspeak:$(TS_VERSION)

clear:
	docker stop teamspeak
	docker rm teamspeak

check: run
	sleep 1
	make logs 2>/dev/null | grep ServerLibPriv | grep TeamSpeak | grep $(TS_VERSION) > /dev/null || (make check_failed && false)
	make logs 2>/dev/null | grep VirtualServer | grep listening | grep $(TS_VOICE_PORT) > /dev/null || (make check_failed && false)
	make clear

check_failed:
	>&2 echo "Failed. Please check logs output"
	make logs clear

logs:
	docker logs teamspeak


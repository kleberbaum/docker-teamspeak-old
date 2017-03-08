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
	-v ${PWD}/data:/teamspeak/data \
	-e "TS_DEFAULT_VOICE_PORT=$(TS_VOICE_PORT)" \
	-e "TS_CLEAR_DATABASE=1" \
	phaldan/teamspeak:$(TS_VERSION)

clear:
	docker stop teamspeak
	docker rm teamspeak

check: run
	sleep 1
	echo "# CHECK TEAMSPEAK VERSION"
	make -s logs 2>/dev/null | grep ServerLibPriv | grep TeamSpeak | grep $(TS_VERSION) > /dev/null || (make -s check_failed && false)
	echo "# CHECK VOICE PORT"
	make -s logs 2>/dev/null | grep VirtualServer | grep listening | grep $(TS_VOICE_PORT) > /dev/null || (make -s check_failed && false)
	echo "# CLEANUP"
	make -s clear

check_failed:
	>&2 echo "# FAILED. PLEASE CHECK DOCKER LOGS OUTPUT"
	make logs clear

logs:
	docker logs teamspeak

upgrade: build check
	TS_VERSION=$(TS_VERSION) ./upgrade.sh


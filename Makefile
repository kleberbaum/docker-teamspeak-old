.PHONY : all build update run clear check logs upgrade
TS_VERSION=$(or $(VERSION),3.0.13.6)
TS_VOICE_PORT=$(or $(VOICE_PORT),1337) # Use non standard port to evaluate environment variables
UPGRADE_SCRIPT=upgrade.sh
DOCKER_IMAGE=phaldan/teamspeak
DOCKER_CLI=$(shell which docker.io || which docker)
DOCKER_LOGS=$(DOCKER_CLI) logs teamspeak 2>&1
MAKE=make -s
CHECK_FAILED=$(MAKE) logs clear && false

all: build

build:
	$(DOCKER_CLI) build --build-arg TS_VERSION=$(TS_VERSION) -t $(DOCKER_IMAGE):$(TS_VERSION) .

update:
	$(DOCKER_CLI) pull $(shell sed -n 's/^FROM //p' Dockerfile)
	$(MAKE) build

run:
	$(DOCKER_CLI) run -d --name teamspeak \
	-v ${PWD}/config:/teamspeak/config \
	-v ${PWD}/files:/teamspeak/files \
	-v ${PWD}/logs:/teamspeak/logs \
	-v ${PWD}/data:/teamspeak/data \
	-e "TS_DEFAULT_VOICE_PORT=$(TS_VOICE_PORT)" \
	-e "TS_CLEAR_DATABASE=1" \
	$(DOCKER_IMAGE):$(TS_VERSION)

clear:
	$(DOCKER_CLI) stop teamspeak
	$(DOCKER_CLI) rm teamspeak

check: run
	sleep 2
	echo "# CHECK TEAMSPEAK VERSION"
	$(DOCKER_LOGS) | grep ServerLibPriv | grep TeamSpeak | grep $(TS_VERSION) > /dev/null || ($(CHECK_FAILED))
	echo "# CHECK VOICE PORT"
	$(DOCKER_LOGS) | grep VirtualServer | grep listening | grep $(TS_VOICE_PORT) > /dev/null || ($(CHECK_FAILED))
	echo "# CLEANUP"
	$(MAKE) clear

logs:
	$(DOCKER_CLI) logs teamspeak

upgrade: build check
	curl -o $(UPGRADE_SCRIPT) https://raw.githubusercontent.com/phaldan/docker-tags-upgrade/master/$(UPGRADE_SCRIPT)
	chmod +x $(UPGRADE_SCRIPT)
	./$(UPGRADE_SCRIPT) "$(DOCKER_IMAGE)" "$(TS_VERSION)"


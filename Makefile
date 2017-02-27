all:
	docker build -t phaldan/teamspeak .

run:
	docker run -d --name teamspeak -v ${PWD}/config:/teamspeak/config -v ${PWD}/files:/teamspeak/files -v ${PWD}/logs:/teamspeak/logs phaldan/teamspeak

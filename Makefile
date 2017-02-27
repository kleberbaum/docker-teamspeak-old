all:
	docker build -t phaldan/teamspeak .

run:
	docker run -d --name teamspeak phaldan/teamspeak

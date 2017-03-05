# TeamSpeak server

[![](https://images.microbadger.com/badges/version/phaldan/teamspeak.svg)](https://microbadger.com/images/phaldan/teamspeak) [![](https://images.microbadger.com/badges/image/phaldan/teamspeak.svg)](https://microbadger.com/images/phaldan/teamspeak) [![](https://img.shields.io/docker/stars/phaldan/teamspeak.svg)](https://hub.docker.com/r/phaldan/teamspeak/) [![](https://img.shields.io/docker/pulls/phaldan/teamspeak.svg)](https://hub.docker.com/r/phaldan/teamspeak/) [![](https://img.shields.io/docker/automated/phaldan/teamspeak.svg)](https://hub.docker.com/r/phaldan/teamspeak/)

Size optimised docker image based on [alpine](https://hub.docker.com/_/alpine/) image:

* `3.0.13.6`, `3.0.13`, `3.0`, `3`, `latest` ([Dockerfile](https://github.com/phaldan/docker-teamspeak/blob/5790f11612e731264cd5fe57ccb8032a608b1027/Dockerfile))
* `3.0.12.4`, `3.0.12` ([Dockerfile](https://github.com/phaldan/docker-teamspeak/blob/b31100b62944859ca56d71bdd4961eb8ce439259/Dockerfile))
&nbsp;

## What is TeamSpeak

TeamSpeak is proprietary voice-over-Internet Protocol (VoIP) software for audio communication between users on a chat channel, much like a telephone conference call. Users typically use headphones with a microphone. The client software connects to a TeamSpeak server of the user's choice, from which the user may join chat channels.

> [wikipedia.org/wiki/TeamSpeak](https://en.wikipedia.org/wiki/TeamSpeak)

![logo](https://raw.githubusercontent.com/phaldan/docker-teamspeak/54d169025092ad9f612a1647a5bc9e19fdbe56c6/logo.png)
&nbsp;

## How to use this image

```
$ docker run -d --name teamspeak \
  -p 9987:9987/udp \
  -p 30033:30033 \
  -p 10011:10011 \
  phaldan/teamspeak
```

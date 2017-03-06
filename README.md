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
&nbsp;

## Configuration

### Environment variables

This image supports environment variables for the TeamSpeak server.

|Variable|Default|
|-----------|---------|
|TS_CLEAR_DATABASE|0|
|TS_CREATE_DEFAULT_VIRTUALSERVER|1|
|TS_CREATEINIFILE|1|
|TS_DBCLIENTKEEPDAYS|90|
|TS_DBCONNECTIONS|10|
|TS_DBLOGKEEPDAYS|90|
|TS_DBPLUGIN|ts3db_sqlite3|
|TS_DBPLUGINPARAMETER|config/ts3db.ini|
|TS_DBSQLCREATEPATH|create_sqlite/|
|TS_DBSQLPATH|sql/|
|TS_DEFAULT_VOICE_PORT|9987|
|TS_FILETRANSFER_IP|0.0.0.0,0::0|
|TS_FILETRANSFER_PORT|30033|
|TS_INIFILE|config/ts3server.ini|
|TS_LICENSEPATH|config/|
|TS_LOGAPPEND|0|
|TS_LOGPATH|logs/|
|TS_LOGQUERYCOMMANDS|1|
|TS_MACHINE_ID|&lt;empty&gt;|
|TS_NO_PERMISSION_UPDATE|0|
|TS_QUERY_IP|0.0.0.0,0::0|
|TS_QUERY_IP_BLACKLIST|config/query_ip_blacklist.txt|
|TS_QUERY_IP_WHITELIST|config/query_ip_whitelist.txt|
|TS_QUERY_PORT|10011|
|TS_QUERY_SKIPBRUTEFORCECHECK|0|
|TS_VOICE_IP|0.0.0.0,0::0|
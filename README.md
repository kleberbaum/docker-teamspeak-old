# TeamSpeak server

[![](https://images.microbadger.com/badges/version/phaldan/teamspeak.svg)](https://microbadger.com/images/phaldan/teamspeak) [![](https://images.microbadger.com/badges/image/phaldan/teamspeak.svg)](https://microbadger.com/images/phaldan/teamspeak) [![](https://img.shields.io/docker/stars/phaldan/teamspeak.svg)](https://hub.docker.com/r/phaldan/teamspeak/) [![](https://img.shields.io/docker/pulls/phaldan/teamspeak.svg)](https://hub.docker.com/r/phaldan/teamspeak/) [![](https://img.shields.io/docker/automated/phaldan/teamspeak.svg)](https://hub.docker.com/r/phaldan/teamspeak/)

Size optimised docker image based on [alpine](https://hub.docker.com/_/alpine/) image:

* `3.0.13.6`, `3.0.13`, `3.0`, `3`, `latest` ([Dockerfile](https://github.com/phaldan/docker-teamspeak/blob/cc4b6d4e48ed5b6a30448b017bee0f722b742725/Dockerfile))
* `3.0.12.4`, `3.0.12` ([Dockerfile](https://github.com/phaldan/docker-teamspeak/blob/cc4b6d4e48ed5b6a30448b017bee0f722b742725/Dockerfile))
&nbsp;

## What is TeamSpeak

TeamSpeak is proprietary voice-over-Internet Protocol (VoIP) software for audio communication between users on a chat channel, much like a telephone conference call. Users typically use headphones with a microphone. The client software connects to a TeamSpeak server of the user's choice, from which the user may join chat channels.

> [wikipedia.org/wiki/TeamSpeak](https://en.wikipedia.org/wiki/TeamSpeak)

![logo](https://raw.githubusercontent.com/phaldan/docker-teamspeak/54d169025092ad9f612a1647a5bc9e19fdbe56c6/logo.png)
&nbsp;

## How to use this image

### Default

```
$ docker run -d --name teamspeak \
  -p 9987:9987/udp \
  -p 30033:30033 \
  -p 10011:10011 \
  phaldan/teamspeak
```
&nbsp;

### Persist data
```
docker run -d --name teamspeak \
  -v ${PWD}/config:/teamspeak/config \
  -v ${PWD}/files:/teamspeak/files \
  -v ${PWD}/logs:/teamspeak/logs \
  -v ${PWD}/data:/teamspeak/data \
  -p 9987:9987/udp \
  -p 30033:30033 \
  -p 10011:10011 \
  phaldan/teamspeak
```
&nbsp;

### Docker-compose
```
version: '2'
services:
  teamspeak:
    image: phaldan/teamspeak:3.0.13.6
    environment:
      - TS_DBPLUGIN=ts3db_mariadb
      - TS_DBSQLCREATEPATH=create_mariadb/
      - TS_DBHOST=mysql
      - TS_DBDATABASE=teamspeak
      - TS_DBPASSWORD=changeme
    volumes:
      - ./files:/teamspeak/files
      - ./logs:/teamspeak/logs
    links:
      - mysql
    ports:
      - 9987:9987/udp
      - 10011:10011
      - 30033:30033
  mysql:
    image: mariadb:10
    environment:
      - MYSQL_DATABASE=teamspeak
      - MYSQL_ROOT_PASSWORD=changeme
    volumes:
      - ./mysql:/var/lib/mysql
```
&nbsp;

## Configuration

### Commandline Parameters

This images uses docker entrypoint for starting the server. Cmd can be used to append paramters to the start command. Full list of parameters can be found at the official [quick-start guilde](http://media.teamspeak.com/ts3_literature/TeamSpeak%203%20Server%20Quick%20Start.txt). A few parameters are predefined to have a simpler docker setup:

```
licensepath=config/ createinifile=1 inifile=config/ts3server.ini query_ip_whitelist=config/query_ip_whitelist.txt query_ip_blacklist=config/query_ip_blacklist.txt dbpluginparameter=config/ts3db.ini
```

You can override the predefined parameter with your own. For example by enabling log append instead of creating a new log file on each startup:

```
$ docker run -d --name teamspeak -v ${PWD}/logs:/teamspeak/logs phaldan/teamspeak logappend=1
```
&nbsp;

### File ts3server.ini

Instead of using commandline parameters a config file can be used. This file is located in `data/ts3server.ini`. An example of a config file can be found in the following snippet: 

```
machine_id=
default_voice_port=1337
voice_ip=0.0.0.0
licensepath=config/
filetransfer_port=30033
filetransfer_ip=0.0.0.0
query_port=10011
query_ip=0.0.0.0
query_ip_whitelist=config/query_ip_whitelist.txt
query_ip_blacklist=config/query_ip_blacklist.txt
dbplugin=ts3db_sqlite3
dbpluginparameter=config/ts3db.ini
dbsqlpath=sql/
dbsqlcreatepath=create_sqlite/
dbconnections=10
logpath=logs
logquerycommands=0
dbclientkeepdays=30
logappend=0
query_skipbruteforcecheck=0
```
&nbsp;

### File ts3db.ini

If you want to use MariaDB/MySQL instead of the default SQLite you have to define a own config file with the connection settings. This config file is located in `data/ts3db.ini`. An example of a config file can be found in the following snippet:

```
[config]
host=localhost
port=3306
username=teamspeak
password=x5gUjs
database=ts3db
socket=
```
&nbsp;

### Environment variables

This image supports environment variables for the TeamSpeak server.

&#x1F534; Mapped to commandline parameter &#x1F537; Mapped to ts3db.ini

|Variable|Default|
|-----------|---------|
|&#x1F534; TS_CLEAR_DATABASE|0|
|&#x1F534; TS_CREATE_DEFAULT_VIRTUALSERVER|1|
|&#x1F534; TS_CREATEINIFILE|1|
|&#x1F534; TS_DBCLIENTKEEPDAYS|90|
|&#x1F534; TS_DBCONNECTIONS|10|
|&#x1F537; TS_DBDATABASE|test|
|&#x1F537; TS_DBHOST|127.0.0.1|
|&#x1F534; TS_DBLOGKEEPDAYS|90|
|&#x1F537; TS_DBPASSWORD|&lt;empty&gt;|
|&#x1F534; TS_DBPLUGIN|ts3db_sqlite3|
|&#x1F534; TS_DBPLUGINPARAMETER|config/ts3db.ini|
|&#x1F537; TS_DBPORT|3306|
|&#x1F537; TS_DBSOCKET|&lt;empty&gt;|
|&#x1F534; TS_DBSQLCREATEPATH|create_sqlite/|
|TS_DBSQLITE|data/ts3server.sqlitedb|
|&#x1F534; TS_DBSQLPATH|sql/|
|&#x1F537; TS_DBUSERNAME|root|
|&#x1F534; TS_DEFAULT_VOICE_PORT|9987|
|&#x1F534; TS_FILETRANSFER_IP|0.0.0.0,0::0|
|&#x1F534; TS_FILETRANSFER_PORT|30033|
|&#x1F534; TS_INIFILE|config/ts3server.ini|
|&#x1F534; TS_LICENSEPATH|config/|
|&#x1F534; TS_LOGAPPEND|0|
|&#x1F534; TS_LOGPATH|logs/|
|&#x1F534; TS_LOGQUERYCOMMANDS|1|
|&#x1F534; TS_MACHINE_ID|&lt;empty&gt;|
|&#x1F534; TS_NO_PERMISSION_UPDATE|0|
|&#x1F534; TS_QUERY_IP|0.0.0.0,0::0|
|&#x1F534; TS_QUERY_IP_BLACKLIST|config/query_ip_blacklist.txt|
|&#x1F534; TS_QUERY_IP_WHITELIST|config/query_ip_whitelist.txt|
|&#x1F534; TS_QUERY_PORT|10011|
|&#x1F534; TS_QUERY_SKIPBRUTEFORCECHECK|0|
|&#x1F534; TS_VOICE_IP|0.0.0.0,0::0|
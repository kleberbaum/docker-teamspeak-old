#!/usr/bin/env ash
set -o errexit
set -o pipefail

main() {
  handleEnv
  createSqliteSymlinks "ts3server.sqlitedb" "-shm" "-wal"
  LD_LIBRARY_PATH=lib/ exec ./ts3server "$@" "${ARGS}"
}

handleEnv() {
  appendEnv "default_voice_port"
  appendEnv "voice_ip"
  appendEnv "create_default_virtualserver"
  appendEnv "machine_id"
  appendEnv "filetransfer_port"
  appendEnv "filetransfer_ip"
  appendEnv "query_port"
  appendEnv "query_ip"
  appendEnv "clear_database"
  appendEnv "logpath"
  appendEnv "dbplugin"
  appendEnv "dbpluginparameter"
  appendEnv "dbsqlpath"
  appendEnv "dbsqlcreatepath"
  appendEnv "licensepath"
  appendEnv "createinifile"
  appendEnv "inifile"
  appendEnv "query_ip_whitelist"
  appendEnv "query_ip_blacklist"
  appendEnv "query_skipbruteforcecheck"
  appendEnv "dbclientkeepdays"
  appendEnv "dblogkeepdays"
  appendEnv "logquerycommands"
  appendEnv "no_permission_update"
  appendEnv "dbconnections"
  appendEnv "logappend"
}

appendEnv() {
  PARAMETER=${1}
  ENV_NAME="TS_$(echo ${PARAMETER} | awk '{print toupper($0)}')"
  ENV_VALUE=$(eval echo \$${ENV_NAME})

  if [ -n "${ENV_VALUE}" ]; then
    appendArg "${1}=${ENV_VALUE}"
  fi
}

appendArg() {
  ARGS="${ARGS} $1"
}

createSqliteSymlinks() {
  FILE_NAME=$1
  SHARED_MEMORY=$2
  WRITE_AHEAD_LOG=$3
  
  ln -s "${TS_DBSQLITE}" "${FILE_NAME}"
  ln -s "${TS_DBSQLITE}${SHARED_MEMORY}" "${FILE_NAME}${SHARED_MEMORY}"
  ln -s "${TS_DBSQLITE}${WRITE_AHEAD_LOG}" "${FILE_NAME}${WRITE_AHEAD_LOG}"
}

ARGS=""
main "$@"


#!/usr/bin/env ash
set -o errexit
set -o pipefail

main() {
  handleEnv
  prepareSqliteSymlinks "ts3server.sqlitedb" "-shm" "-wal"
  prepareDbSettings
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
  appendEnv "query_buffer_mb"
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

prepareSqliteSymlinks() {
  FILE_NAME=$1
  SHARED_MEMORY=$2
  WRITE_AHEAD_LOG=$3

  createSymlink "${TS_DBSQLITE}" "${FILE_NAME}"
  createSymlink "${TS_DBSQLITE}${SHARED_MEMORY}" "${FILE_NAME}${SHARED_MEMORY}"
  createSymlink "${TS_DBSQLITE}${WRITE_AHEAD_LOG}" "${FILE_NAME}${WRITE_AHEAD_LOG}"
}

createSymlink() {
  TARGET_PATH=$1
  LINK_PATH=$2

  if [ ! -f "${LINK_PATH}" ] && [ ! -L "${LINK_PATH}" ]; then
    ln -s "${TARGET_PATH}" "${LINK_PATH}"
  fi
}

prepareDbSettings() {
  initiDbSettingsFile

  if [ ! -z ${TS_DBHOST+x} ]; then addDbSetting "host" "${TS_DBHOST}"; fi
  if [ ! -z ${TS_DBPORT+x} ]; then addDbSetting "port" "${TS_DBPORT}"; fi
  if [ ! -z ${TS_DBUSERNAME+x} ]; then addDbSetting "username" "${TS_DBUSERNAME}"; fi
  if [ ! -z ${TS_DBPASSWORD+x} ]; then addDbSetting "password" "${TS_DBPASSWORD}"; fi
  if [ ! -z ${TS_DBDATABASE+x} ]; then addDbSetting "database" "${TS_DBDATABASE}"; fi
  if [ ! -z ${TS_DBSOCKET+x} ]; then addDbSetting "socket" "${TS_DBSOCKET}"; fi
}

addDbSetting() {
  KEY=$1
  VALUE=$2
  LINE="${KEY}=${VALUE}"

  if [ $(grep -c '^\[config\]$' ${DB_CONFIG}) -eq "0" ]; then
    insertFirstLine "${DB_CONFIG}" "[config]"
  fi

  if grep -q "${KEY}=" ${DB_CONFIG}; then
    sed -i 's|'${KEY}'=.*|'${LINE}'|g' ${DB_CONFIG}
  else
    echo "${LINE}" >> ${DB_CONFIG}
  fi
}

initiDbSettingsFile() {
  if [ ! -f "${DB_CONFIG}" ]; then
    touch ${DB_CONFIG}
    echo '[config]' >> ${DB_CONFIG}
    echo 'host=127.0.0.1' >> ${DB_CONFIG}
    echo 'port=3306' >> ${DB_CONFIG}
    echo 'username=root' >> ${DB_CONFIG}
    echo 'password=' >> ${DB_CONFIG}
    echo 'database=test' >> ${DB_CONFIG}
    echo 'socket=' >> ${DB_CONFIG}
  fi
}

insertFirstLine() {
  TMP_FILE=$(mktemp)
  FILE=$1
  OUTPUT=$2

  echo ${OUTPUT} > ${TMP_FILE}
  cat ${FILE} >> ${TMP_FILE}
  mv ${TMP_FILE} ${FILE}
}

DB_CONFIG="config/ts3db.ini"
ARGS=""
main "$@"

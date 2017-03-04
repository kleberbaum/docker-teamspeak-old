#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

main() {
  docker push phaldan/teamspeak:${TS_VERSION}

  for i in `seq ${#TS_VERSION} -1 1`; do
    TAGS_FILE=v${TS_VERSION:0:$i}
    if [ -e "${TAGS_FILE}" ]; then
      upgrade "$TAGS_FILE"
      exit 0
    fi
  done
  exit 1
}

upgrade() {
  TAGS_FILE=$1
  echo -n "# USING ${TAGS_FILE} FILE FOR TAGING: "
  echo $(cat ${TAGS_FILE})

  while read p; do
    docker tag phaldan/teamspeak:${TS_VERSION} phaldan/teamspeak:$p
    docker push phaldan/teamspeak:$p
  done <${TAGS_FILE}
}

main

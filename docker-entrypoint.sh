#!/usr/bin/env ash
set -o errexit
set -o pipefail
set -o nounset

main() {
  LD_LIBRARY_PATH=lib/ exec ./ts3server "$@"
}

main "$@"


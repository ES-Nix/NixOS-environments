#!/usr/bin/env bash


set -x

USER="${1:-nixuser}"
PORT="${3:-10023}"
IP="${2:-127.0.0.1}"

ssh-keygen -R '['"${IP}"']:'"${PORT}"

ssh "${USER}"@"${IP}" \
-p "${PORT}" \
-o GlobalKnownHostsFile=/dev/null \
-o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no \
-o LogLevel=DEBUG \
"$@"
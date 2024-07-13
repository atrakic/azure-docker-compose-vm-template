#!/bin/bash

set -e

wait_for_conn() {
  local i=0
  echo "Waiting for a successful connection to ${1:?}"
  until curl -k "${1:?}" > /dev/null 2>&1; do
    if [ $i -gt 60 ]; then
      echo "Could not connect to ${1:?} using http under one minute, timing out."
      exit 1
    fi
    i=$((i + 2))
    sleep 2
  done
  echo "Connection to ${1:?} was successfull."
}

wait_for_healthy_container() {
  local container_name=${1:?}
  local i=0
  until \
    [[ "$(docker inspect --format "{{json .State.Health }}" "${container_name}" | jq -r ".Status")" == "healthy" ]];\
  do \
    if [ $i -gt 60 ]; then
      echo "Container ${container_name} did not become healthy under one minute, timing out."
      exit 1
    fi
    i=$((i + 2))
    echo "Waiting for ${container_name} to be healthy..."
    sleep 2
  done
}

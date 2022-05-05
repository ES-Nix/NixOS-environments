#!/usr/bin/env bash



number_of_arguments="$#"

while [ $number_of_arguments -gt 0 ]; do
  # echo '$# '$#
  case "$1" in
    -dn|-disk-name|--disk-name)
      DISK_NAME="$2"
      ;;
    -sdn|-store-disk-name|--store-disk-name)
      STORE_DISK_NAME="$2"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      echo "$1"
      echo "$2"
      should_shift='false'
      # exit 1
  esac

  if [ "$should_shift" == 'true' ]; then
    shift
    shift
  fi

  number_of_arguments="$((number_of_arguments - 1))"
done


DISK_NAME=${DISK_NAME:-disk.qcow2}

STORE_PATH_TO_DISK=${STORE_PATH_TO_DISK:-store-path-to-disk}

# echo "${STORE_PATH_TO_DISK}"

if [[ ! -f "${DISK_NAME}" ]]; then
  # Setup the VM configuration on boot
  cp --reflink=auto "${STORE_PATH_TO_DISK}" "${DISK_NAME}"
  chmod +w "${DISK_NAME}"
fi


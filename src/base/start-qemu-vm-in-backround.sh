#!/usr/bin/env bash


while [ $# -gt 0 ]; do
  # echo '$# '$#
  case "$1" in
    -p|-port|--port)
      PORT="$2"
      ;;
    -in|-image_name|--image_name)
      IMAGE_NAME="$2"
      ;;
    -is|-iso_name|--iso_name)
      ISO_NAME="$2"
      ;;
    -u|-uuid|--uuid)
      UUIID="$2"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      echo "$1"
      echo "$2"
      exit 1
  esac
  shift
  shift
done


PORT=${PORT:-10023}
IMAGE_NAME=${IMAGE_NAME:-nixos.img}
ISO_NAME=${ISO_NAME:-nixos-21.11pre-git-x86_64-linux-kubernetes.iso}
UUIID=${UUIID:-$(uuidgen)}


#echo "${PORT}"
#echo "${IMAGE_NAME}"
#echo "${ISO_NAME}"
#echo "${UUIID}"


qemu-img create nixos.img 12G

ls -al

echo 'Starting the Virtual Machine' \
&& { qemu-kvm \
-boot d \
-drive format=raw,file="${IMAGE_NAME}" \
-cdrom "${ISO_NAME}" \
-m 12G \
-enable-kvm \
-cpu host \
-smp "$(nproc)" \
-nographic \
-device "rtl8139,netdev=net0" \
-netdev 'user,id=net0,hostfwd=tcp:127.0.0.1:'"${PORT}"'-:29980' \
-uuid "${UUIID}" < /dev/null & }

#!/usr/bin/env bash


ssh-keygen -R '[127.0.0.1]:10023' \
&& ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no


#sshKey=$(mktemp)
#trap 'rm $sshKey' EXIT
#cp ${./vagrant} "$sshKey"
#chmod 0600 "$sshKey"
#
## TODO; decouple the kvm hardcoded dependency
## https://stackoverflow.com/a/19295632
#qemu_process_id=$(pidof qemu-system-x86_64)
#if [[ -z $qemu_process_id ]]; then
#    (run-vm-kvm < /dev/null &)
#fi

# https://unix.stackexchange.com/a/508856
#
# ssh -Q protocol-version localhost
# https://askubuntu.com/a/1112242
# https://serverfault.com/a/1040559
#
# Compression yes
# https://unix.stackexchange.com/a/626033
#
# https://unix.stackexchange.com/a/326046
# https://stackoverflow.com/a/49572001
# https://stackoverflow.com/a/39339317
#              -X11Forwarding yes \
#
# https://unix.stackexchange.com/a/191065
#              -o X11UseLocalhost no \
#
# https://github.com/bitnami/minideb/blob/master/qemu_build#L11
# https://askubuntu.com/questions/35512/what-is-the-difference-between-ssh-y-trusted-x11-forwarding-and-ssh-x-u/35518#35518

#until
#   ${pkgsAllowUnfree.openssh}/bin/ssh \
#    -X \
#    -Y \
#    -o GlobalKnownHostsFile=/dev/null \
#    -o UserKnownHostsFile=/dev/null \
#    -o StrictHostKeyChecking=no \
#    -o LogLevel=ERROR \
#    -i "$sshKey" ${user_name}@127.0.0.1 -p 10023 "$@"; do
#  ((c++)) && ((c==60)) && break
#  sleep 1
#done
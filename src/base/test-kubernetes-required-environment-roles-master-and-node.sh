#!/usr/bin/env bash



# Checking RAM size (really hard to choose a weapon to do this, do you know a better one?)
MINIMAL_KUBERNETES_RAM_NEEDED=2147483648
CURRENT_RAM_IN_BYTES="$(free -b | awk '/Mem:/{print $2}')"
awk 'BEGIN {return_code=('"${CURRENT_RAM_IN_BYTES}"' > '"${MINIMAL_KUBERNETES_RAM_NEEDED}"') ? 0 : 1; exit} END {exit return_code}' || echo 'Error, not enough RAM'


# Checking the number of CPUs
MINIMAL_KUBERNETES_CPU_NEEDED=2
CURRENT_NUMBER_OF_CPU="$(nproc)"
awk 'BEGIN {return_code=('"${CURRENT_NUMBER_OF_CPU}"' > '"${MINIMAL_KUBERNETES_CPU_NEEDED}"') ? 0 : 1; exit} END {exit return_code}' || echo 'Error, not enough CPUs'

#
cat /sys/class/dmi/id/product_uuid | wc -c | rg -q 37 || echo 'Error, this machine does not have product_uuid'
# Refs.:
# - https://stackoverflow.com/a/63148464



# ip link show docker0 | grep link/ether | awk '{print $2}'
# ip link show docker0 | grep link/ether | cut -d' ' -f 6 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' || echo 'Error' 'ip link show docker0'

ifconfig docker0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' || echo 'Error' 'ifconfig docker0 error'

# ip route show default | awk '/default/ {print $5}' | grep -E 'eth0' || echo 'Error'
# ip route show default | cut -d' ' -f5 | grep -E 'eth0' || echo 'Error' 'ip route show default'
ifconfig eth0 | grep -o -E -q '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' || echo 'Error' 'ifconfig eth0 error'

# Refs.:
# - https://stackoverflow.com/a/68784841
# - https://stackoverflow.com/a/40182414
# - https://stackoverflow.com/a/23830537


ifconfig -a | awk '/^[a-z]/ { iface=$1; mac=$NF; next } /inet addr:/ { print iface, mac }'

#  Refs.:
#  - https://stackoverflow.com/a/23828821


lsmod | rg -c br_netfilter | rg -q 2 || echo 'Error, kernel module br_netfilter not loaded'


timeout 1 telnet 127.0.0.1 6443 || test $? -eq 124 || echo 'Error' 'telnet 127.0.0.1 6443 fails, firewall maybe?'

#  Refs.:
#  - https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports
#  - https://askubuntu.com/a/609174


netstat -lnpt | rg -c kube | rg 9
netstat -a | rg 6443

#  Refs.:
#  - https://medium.com/@texasdave2/troubleshoot-kubectl-connection-refused-6f5445a396ed

#!/usr/bin/env bash

# What is an correct order to cleaning all k8s stuff?

# TODO: when is it use full?
# kubectl delete pod --all --force -n kube-system
# https://stackoverflow.com/questions/35453792/pods-stuck-in-terminating-status#comment126248144_41752955

kubeadm reset --force

rm -rfv /home/nixuser/.kube/ \
&& rm -rfv /var/lib/kubelet/ \
&& rm -rfv /var/lib/cni/ \
&& rm -rfv /etc/cni/

#rm -rfv /etc/kubernetes/pki
#rm -rf /etc/kubernetes/
#rm -rfv /var/lib/cfssl/
#rm -rf /var/lib/etcd/
#mkdir -pv -m 0700 /var/lib/etcd \
#&& chown etcd:root /var/lib/etcd


docker system prune -af \
&& docker image prune -af
systemctl stop docker
systemctl stop docker.socket
systemctl stop kubelet


# TODO: in some k8s documentation there are these commands
# or similar ones.
iptables --flush
iptables -tnat --flush

## https://superuser.com/a/1664173
## https://superuser.com/a/1664173
## https://blog.heptio.com/properly-resetting-your-kubeadm-bootstrapped-cluster-nodes-heptioprotip-473bd0b824aa
#iptables -F \
#&& iptables -t nat -F \
#&& iptables -t mangle -F \
#&& iptables -X


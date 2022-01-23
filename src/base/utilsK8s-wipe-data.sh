#!/usr/bin/env bash

# What is an correct order to cleaning all k8s stuff?

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

iptables --flush
iptables -tnat --flush

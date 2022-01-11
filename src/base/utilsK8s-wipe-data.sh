#!/usr/bin/env bash


# docker system prune -af \
# && docker image prune -af
# systemctl stop docker
# && systemctl stop kubelet \


kubeadm reset --force \
&& rm -rf /etc/kubernetes/ \
&& rm -rf /home/nixuser/.kube/ \
&& rm -rf /var/lib/kubelet/ \
&& rm -rf /var/lib/cni/ \
&& rm -rf /etc/cni/ \
&& rm -rf /var/lib/etcd/ \
&& rm -rf /etc/kubernetes/ \
&& mkdir -pv -m 0700 /var/lib/etcd \
&& chown etcd:root /var/lib/etcd

# kubeadm init phase kubeconfig admin --cert-dir /etc/kubernetes
# kubeadm init phase kubeconfig admin --apiserver-advertise-address --cert-dir /etc/kubernetes

#!/usr/bin/env bash

kubeadm certs renew all

systemctl restart kube-apiserver
systemctl restart kube-controller-manager
systemctl restart kube-scheduler
systemctl restart etcd

# stat /var/lib/kubernetes
chown kubernetes:kubernetes -Rv /var/lib/kubernetes
chmod -Rv 0775 /var/lib/kubernetes

# TODO: Do we want it always after renew all certs? I think so.
mkdir -pv "$HOME"/.kube
cp -fv /etc/kubernetes/cluster-admin.kubeconfig "$HOME"/.kube/config
#cp -fv /etc/kubernetes/admin.conf "$HOME"/.kube/config
#cp -fv /etc/kubernetes/kubelet.conf "$HOME"/.kube/config
chmod -v 0644 "$HOME"/.kube/config
chown -v "$(id -u)":"$(id -g)" "$HOME"/.kube/config


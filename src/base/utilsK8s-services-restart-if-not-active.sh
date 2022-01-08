#!/usr/bin/env bash


systemctl is-active --quiet certmgr || systemctl restart certmgr
systemctl is-active --quiet cfssl || systemctl restart cfssl
systemctl is-active --quiet containerd || systemctl restart containerd
systemctl is-active --quiet flannel || systemctl restart flannel
systemctl is-active --quiet kube-addon-manager || systemctl restart kube-addon-manager
systemctl is-active --quiet kube-apiserver || systemctl restart kube-apiserver
systemctl is-active --quiet kube-controller-manager || systemctl restart kube-controller-manager
systemctl is-active --quiet kube-proxy || systemctl restart kube-proxy
systemctl is-active --quiet kube-scheduler || systemctl restart kube-scheduler
systemctl is-active --quiet kubelet || systemctl restart kubelet
systemctl is-active --quiet etcd || systemctl restart etcd
systemctl is-active --quiet kubernetes || systemctl restart kubernetes
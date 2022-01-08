#!/usr/bin/env bash

systemctl stop certmgr.service
systemctl stop cfssl.service
systemctl stop containerd.service
systemctl stop flannel.service
systemctl stop kube-addon-manager.service
systemctl stop kube-apiserver.service
systemctl stop kube-controller-manager.service
systemctl stop kube-proxy.service
systemctl stop kube-scheduler.service
systemctl stop kubelet.service
systemctl stop etcd.service
systemctl stop kubernetes.target

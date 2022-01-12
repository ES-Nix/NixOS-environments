#!/usr/bin/env bash


QUIET='-q'
systemctl status certmgr.service | rg $QUIET -e 'Active: active' || echo 'Error! Service certmgr.service'
systemctl status cfssl.service | rg $QUIET -e 'Active: active' || echo 'Error! Service cfssl.service'
systemctl status containerd.service | rg $QUIET -e 'Active: active' || echo 'Error! Service containerd.service'
systemctl status flannel.service | rg $QUIET -e 'Active: active' || echo 'Error! Service flannel.service'
systemctl status kube-addon-manager.service | rg $QUIET -e 'Active: active' || echo 'Error! Service kube-addon-manager.service'
systemctl status kube-apiserver.service | rg $QUIET -e 'Active: active' || echo 'Error! Service kube-apiserver.service'
systemctl status kube-controller-manager.service | rg $QUIET -e 'Active: active' || echo 'Error! Service kube-controller-manager.service'
systemctl status kube-proxy.service | rg $QUIET -e 'Active: active' || echo 'Error! Service kube-proxy.service'
systemctl status kube-scheduler.service | rg $QUIET -e 'Active: active' || echo 'Error! Service kube-scheduler.service'
systemctl status kubelet.service | rg $QUIET -e 'Active: active' || echo 'Error! Service kubelet.service'
systemctl status etcd.service | rg $QUIET -e 'Active: active' || echo 'Error! Service etcd.service'
systemctl status kubernetes.target | rg $QUIET -e 'Active: active' || echo 'Error! Service kubernetes.target'


systemctl list-dependencies kubernetes.target
systemctl list-dependencies --reverse kubernetes.target

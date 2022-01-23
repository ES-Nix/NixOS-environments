#!/usr/bin/env bash


chmod -Rv 0775 /var/lib/kubernetes /etc/kubernetes/cluster-admin.kubeconfig
chown kubernetes:kubernetes -Rv /var/lib/kubernetes /etc/kubernetes/cluster-admin.kubeconfig

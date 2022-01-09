#!/usr/bin/env bash

kubeadm certs renew all

#systemctl restart kube-apiserver
#systemctl restart kube-controller-manager
#systemctl restart kube-scheduler
#systemctl restart etcd

LOG_START_DATE="$(date +'%Y-%m-%d %H:%M:%S')"
systemctl restart kube-apiserver
journalctl \
--since "${LOG_START_DATE}" \
--until "$(date +'%Y-%m-%d %T' --date="${LOG_START_DATE} 2 minutes")" \
--no-pager \
-u kube-apiserver

LOG_START_DATE="$(date +'%Y-%m-%d %H:%M:%S')"
systemctl restart kube-controller-manager
journalctl \
--since "${LOG_START_DATE}" \
--until "$(date +'%Y-%m-%d %T' --date="${LOG_START_DATE} 2 minutes")" \
--no-pager \
-u kube-controller-manager


LOG_START_DATE="$(date +'%Y-%m-%d %H:%M:%S')"
systemctl restart kube-scheduler
journalctl \
--since "${LOG_START_DATE}" \
--until "$(date +'%Y-%m-%d %T' --date="${LOG_START_DATE} 2 minutes")" \
--no-pager \
-u kube-scheduler


LOG_START_DATE="$(date +'%Y-%m-%d %H:%M:%S')"
systemctl restart etcd
journalctl \
--since "${LOG_START_DATE}" \
--until "$(date +'%Y-%m-%d %T' --date="${LOG_START_DATE} 2 minutes")" \
--no-pager \
-u etcd


# stat /var/lib/kubernetes
chown kubernetes:kubernetes -Rv /var/lib/kubernetes
chmod -Rv 0775 /var/lib/kubernetes

# TODO: Do we want it always after renew all certs? I think so.
# TODO: remove this hard code in the user name?
# If running as root "$HOME" is the root home, but for kubernetes
# we need nixuser's home.
HARCODED_HOME='/home/nixuser'
mkdir -pv "$HARCODED_HOME"/.kube
cp -fv /etc/kubernetes/cluster-admin.kubeconfig "$HARCODED_HOME"/.kube/config
#cp -fv /etc/kubernetes/admin.conf "$HOME"/.kube/config
#cp -fv /etc/kubernetes/kubelet.conf "$HOME"/.kube/config
chmod -v 0644 "$HARCODED_HOME"/.kube/config
chown -v nixuser: "$HARCODED_HOME"/.kube/config

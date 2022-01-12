#!/usr/bin/env bash


# Excellent!
# https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
#
# https://www.youtube.com/watch?v=EFjOhVn2wQY
#kubeadm init phase certs all --cert-dir=/etc/kubernetes/pki
#kubeadm init phase kubeconfig admin --cert-dir=/etc/kubernetes/pki

# At some point I think this is a needed
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


#kubeadm init phase kubeconfig admin --cert-dir /etc/kubernetes/pki
#kubeadm init phase kubeconfig admin --apiserver-advertise-address --cert-dir /etc/kubernetes/pki
# https://stackoverflow.com/a/46480447

kubeadm certs renew all


echo

echo 'Restarting kube-apiserver'
systemctl restart kube-apiserver

echo 'Restarting kube-controller-manager'
systemctl restart kube-controller-manager

echo 'Restarting kube-scheduler'
systemctl restart kube-scheduler

echo 'Restarting etcd'
systemctl restart etcd

#LOG_START_DATE="$(date +'%Y-%m-%d %H:%M:%S')"
#systemctl restart kube-apiserver
#journalctl \
#--since "${LOG_START_DATE}" \
#--until "$(date +'%Y-%m-%d %T' --date="${LOG_START_DATE} 2 minutes")" \
#--no-pager \
#-u kube-apiserver


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

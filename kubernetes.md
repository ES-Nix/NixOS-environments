# NixOS environments


### ISO with kubernetes


```bash
nix build .#iso-kubernetes \
&& cp result/iso/nixos-*.iso . \
&& chmod +x nixos-*.iso \
&& qemu-img create nixos.img 10G
```

```bash
qemu-kvm \
-boot d \
-hda nixos.img \
-cdrom nixos-*.iso \
-m 10000 \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10022-:29980"
```
Refs.:
- [Booting from an ISO image using qemu](https://linux-tips.com/t/booting-from-an-iso-image-using-qemu/136)


```bash
ssh-keygen -R '[127.0.0.1]:10022' \
&& ssh nixuser@127.0.0.1 -p 10022 -o StrictHostKeyChecking=no
```
Refs.:
- https://serverfault.com/a/723917


```bash
rm -fv nixos.img nixos-*.iso
```

```bash
qemu-kvm \
-boot d \
-cdrom nixos-*.iso \
-m 512 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10022-:29980"
```

It was not working (probably because of some kernel parameters not being used):
```bash
qemu-kvm \
-m 16G \
-nic user \
-hda nixos-21.11pre-git-x86_64-linux.iso \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10022-:29980"
```


## Troubleshoot kubernetes


TODO: is this all services or it misses some?
```bash
systemctl cat kube-addon-manager.service
systemctl cat kube-apiserver.service
systemctl cat kube-controller-manager.service
systemctl cat kube-proxy.service
systemctl cat kube-scheduler.service
systemctl cat certmgr.service
```

```bash
# QUIET='-q'
systemctl status kube-addon-manager.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-apiserver.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-controller-manager.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-proxy.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-scheduler.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status certmgr.service | rg $QUIET -e 'Active: active' || echo 'Error!'
```


```bash
test -f /var/lib/kubernetes/secrets/ca.pem || echo 'Erro! ''The file does not existe'
test -f /var/lib/kubernetes/secrets/kube-apiserver.pem || echo 'Erro! ''The file does not existe'
```


```bash
# ss -tunlp
sudo ss -tunlp | rg 'kube-apiserver|kubelet|kube-controller|kube-proxy|kube-scheduler|certmgr'
```

```bash
PID=?
tr '\0' '\n' < /proc/${PID}/cmdline
```

```bash
/nix/store/*-kubernetes-1.22.1/bin/kube-addons
```

```bash
kubectl get pods -A

kubectl cluster-info

kubectl cluster-info dump
```

cat /etc/hosts

ping -c 3 127.0.0.1

journalctl -l -u kubelet

```bash
cat /var/lib/kubernetes/secrets/apitoken.secret | wc -l | rg 1
```


Probably useful for an unprivileged user?
```bash
find / -iname '*.kubeconfig'
~/.kube/config
```

```bash
file /etc/kubernetes/cluster-admin.kubeconfig | rg -w '/etc/kubernetes/cluster-admin.kubeconfig: symbolic link to /etc/static/kubernetes/cluster-admin.kubeconfig'
test -d ~/.kube || mkdir ~/.kube
ln -s /etc/kubernetes/cluster-admin.kubeconfig ~/.kube/config
kubectl cluster-info
```

```bash
echo "$KUBECONFIG" | rg -w '/etc/kubernetes/cluster-admin.kubeconfig'
echo "$KUBECONFIG" | rg -q -w '/etc/kubernetes/cluster-admin.kubeconfig'
```


```bash
# cat /run/flannel/subnet.env
nix profile install nixpkgs#jq
cat /etc/cni/net.d/*-flannel.conf | jq .
```

```bash
kubectl version
kubectl version --short --client
kubectl get nodes
kubectl get pods --all-namespaces
kubectl get pods --all-namespaces -o wide
kubectl get svc
```



kubeadm init --token-ttl=0 --apiserver-advertise-address=https://localhost:6443

kubectl describe -n kube-system pod coredns-55c7644d65-4gr6c 

kubectl describe -n kube-system pod shell-demo



systemctl restart kubelet.service

```bash
systemctl status kubelet.service
journalctl -f -u kubelet.service
```

```bash
# kubectl cluster-info dump | rg error
kubectl cluster-info dump | rg MinimumReplicasUnavailable -B 11 -A 12 -m 1 
```


kubeadm init --pod-network-cidr=10.244.0.0/16

```bash
cat << EOF > projected.yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: test-pod
    image: busybox
    command: ['sh', '-c', 'echo The Bench Container 1 is Running ; sleep 3600']
EOF
```

TODO: it is outdated
```bash
kubectl create -f projected.yaml
kubectl get pods

kubectl logs test-pod


kubectl get pods
kubectl exec test-pod -- -i -t -- /bin/sh -c ' ls -al /'

minikube kubectl -- delete pod test-pod
rm -fv projected.yaml
```


```bash
sudo kubeadm config images list
```

```bash
docker pull quay.io/coreos/flannel:v0.14.0
docker pull k8s.gcr.io/kube-apiserver:v1.22.2
docker pull k8s.gcr.io/kube-controller-manager:v1.22.2
docker pull k8s.gcr.io/kube-scheduler:v1.22.2
docker pull k8s.gcr.io/kube-proxy:v1.22.2
docker pull k8s.gcr.io/pause:3.5
docker pull k8s.gcr.io/etcd:3.5.0-0
docker pull k8s.gcr.io/coredns/coredns:v1.8.4
```

kubectl delete all --all -n kube-system

```bash
mkdir -p /etc/systemd/system/kubelet.service.d
cat << EOF > /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
[Service]
ExecStart=
#  Replace "systemd" with the cgroup driver of your container runtime. The default value in the kubelet is "cgroupfs".
ExecStart=$(which kubelet) --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --cgroup-driver=systemd
Restart=always
EOF
```
Adapted from: [Setting up the cluster](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/#setting-up-the-cluster)



TODOs: 
- https://www.weave.works/docs/net/latest/kubernetes/kube-addon/#-troubleshooting
- https://logs.nix.samueldr.com/nixos-kubernetes/2018-09-07
- https://jl.lu/blog/nixos-and-kubernetes-woes/
- https://github.com/kubernetes/kubernetes/issues/54918#issuecomment-851042394
- https://stackoverflow.com/a/48205752
- https://stackoverflow.com/questions/65424037/failed-to-create-pod-sandbox-rpc-error-code-unknown-desc-failed-to-set-up
- https://stackoverflow.com/a/66742904 and https://github.com/kubernetes/kubernetes/issues/70202#issuecomment-481173403 see the `FLANNEL_IPMASQ=true`
- [Steps for the first control plane node](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/#steps-for-the-first-control-plane-node)
- [Installing a Pod network add-on](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network)
- To troubleshoot https://stackoverflow.com/a/58080891
- https://serverfault.com/a/923249
- https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/



- [Custom live media with Nix flakes](https://hoverbear.org/blog/nix-flake-live-media/)
- [Mein kleines aber feines Cheatsheet für NixOS.](https://noqqe.de/sammelsurium/nixos/)


TODO:
- [NixOs Native Flake Deployment With LUKS Drive Encryption and LVM](https://dzone.com/articles/nixos-native-flake-deployment-with-luks-and-lvm)
- https://www.reddit.com/r/NixOS/comments/ebgezb/passwordless_ssh_authentication_in_nixos/fb4r5cj/?utm_source=reddit&utm_medium=web2x&context=3

TODO: the ssh thing
- https://git.redbrick.dcu.ie/m1cr0man/nix-configs-rb/src/branch/ylmcc-ssh/services/ssh.nix?lang=pt-PT
- https://nixos.wiki/wiki/Install_NixOS_on_a_Server_With_a_Different_Filesystem


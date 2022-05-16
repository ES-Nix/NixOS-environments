# NixOS environments


### ISO with kubernetes


```bash
nix build .#iso-kubernetes \
&& cp -fv result/iso/nixos-*.iso . \
&& chmod +x nixos-*.iso \
&& qemu-img create nixos.img 10G \
&& echo \
&& qemu-kvm \
-boot d \
-hda nixos.img \
-cdrom nixos-*.iso \
-m 5000 \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980"
```
Refs.:
- [Booting from an ISO image using qemu](https://linux-tips.com/t/booting-from-an-iso-image-using-qemu/136)


```bash
ssh-keygen -R '[127.0.0.1]:10023' \
&& ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no
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

systemctl status certmgr.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status cfssl.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status containerd.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status flannel.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-addon-manager.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-apiserver.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-controller-manager.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-proxy.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-scheduler.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kubelet.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kubernetes.target | rg $QUIET -e 'Active: active' || echo 'Error!'

```bash
rm -frv /var/lib/kubernetes/secrets /var/lib/cfssl
```

```bash
test -f /var/lib/kubernetes/secrets/ca.pem || echo 'Erro! ''The file does not existe'
test -f /var/lib/kubernetes/secrets/kube-apiserver.pem || echo 'Erro! ''The file does not existe'
```


```bash
# ss -tunlp
sudo ss -tunlp | rg 'kube-*|certmgr|etcd'
```

```bash
PID=?
tr '\0' '\n' < /proc/${PID}/cmdline
strace -f -T -y -e trace=file
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


```bash
sudo kubeadm init --token-ttl=0 --apiserver-advertise-address=https://localhost:6443 --v=9
```

kubectl describe -n kube-system pod coredns-55c7644d65-4gr6c 

kubectl describe -n kube-system pod shell-demo



systemctl restart kubelet.service


ls -al /var/lib/kubernetes/secrets/

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


### Tests the environment that k8s is running


[Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

Checking RAM size (really hard to choose a weapon to do this, do you know a better one?):
```bash
MINIMAL_KUBERNETES_RAM_NEEDED=2147483648
CURRENT_RAM_IN_BYTES="$(free -b | awk '/Mem:/{print $2}')"
awk 'BEGIN {return_code=('${CURRENT_RAM_IN_BYTES}' > '${MINIMAL_KUBERNETES_RAM_NEEDED}') ? 0 : 1; exit} END {exit return_code}' || echo 'Error, not enough RAM'
```
Refs.:
- https://stackoverflow.com/a/29254834

```bash
MINIMAL_KUBERNETES_CPU_NEEDED=2
CURRENT_NUMBER_OF_CPU="$(nproc)"
awk 'BEGIN {return_code=('${CURRENT_NUMBER_OF_CPU}' > '${MINIMAL_KUBERNETES_CPU_NEEDED}') ? 0 : 1; exit} END {exit return_code}' || echo 'Error, not enough CPUs'
```


```bash
sudo cat /sys/class/dmi/id/product_uuid | wc -c | grep -q 37 || echo 'Error, this machine does not have product_uuid'
```
Refs.: 
- https://stackoverflow.com/a/63148464


```bash
# ip link show docker0 | grep link/ether | awk '{print $2}'
ip link show docker0 | grep link/ether | cut -d' ' -f 6 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' || echo 'Error' 'ip link show docker0'

ifconfig docker0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' || echo 'Error' 'ifconfig docker0 error'

# ip route show default | awk '/default/ {print $5}' | grep -E 'eth0' || echo 'Error'
ip route show default | cut -d' ' -f5 | grep -E 'eth0' || echo 'Error' 'ip route show default'
ifconfig eth0 | grep -o -E -q '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' || echo 'Error' 'ifconfig eth0 error'
```
Refs.: 
- https://stackoverflow.com/a/68784841
- https://stackoverflow.com/a/40182414
- https://stackoverflow.com/a/23830537


```bash
ifconfig -a | awk '/^[a-z]/ { iface=$1; mac=$NF; next }    /inet addr:/ { print iface, mac }'
```
Refs.: 
- https://stackoverflow.com/a/23828821


```bash
lsmod | rg -c br_netfilter | rg -q 2 || echo 'Error, kernel module br_netfilter not loaded'
```


```bash
timeout 1 telnet 127.0.0.1 6443 || test $? -eq 124 || echo 'Error' 'telnet 127.0.0.1 6443 fails, firewall maybe?'
nc -tz localhost 6443 || echo 'Error' 'nc -tz localhost 6443 fails, firewall maybe?'
```
Refs.:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports
- https://askubuntu.com/a/609174


```bash
sudo netstat -lnpt | grep kube | wc -l | grep 9
netstat -a | grep 6443
```
Refs.: 
- https://medium.com/@texasdave2/troubleshoot-kubectl-connection-refused-6f5445a396ed


```bash
free -th | grep --no-ignore-case -E 'total|Swap'
free -th | rg --case-sensitive 'total|Swap'
```


```bash
sudo iptables -t raw -A OUTPUT -p tcp --dport 6443 -j TRACE
```
Refs.:
- https://stackoverflow.com/a/51141230

```bash
sudo sysctl --system | grep 'Invalid argument'
```

## Installing in a VM made with QEMU + KVM and Ubuntu 21.04 cloud image


```bash
echo 'Start docker installation...' \
&& curl -fsSL https://get.docker.com | sudo sh \
&& getent group docker || sudo groupadd docker \
&& sudo usermod --append --groups docker "$USER" \
&& docker --version

cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
echo 'End docker installation!'

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo 'Start kubelet kubeadm kubectl install actually...'
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo \
    sed \
    --in-place \
    's/^GRUB_CMDLINE_LINUX="/&swapaccount=0/' \
    /etc/default/grub \
&& sudo grub-mkconfig -o /boot/grub/grub.cfg
# && sudo reboot
echo 'vm.swappiness = 0' | sudo tee -a /etc/sysctl.conf
sudo reboot
```


```bash
sudo kubeadm config images pull
sudo kubeadm config images list
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -pv "$HOME"/.kube
sudo cp -iv /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown -v $(id -u):$(id -g) "$HOME"/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

watch --interval=1  kubectl get pods -A
```
Refs.:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

```bash
sudo kubeadm init -v9

systemctl status kubelet
sudo systemctl restart kubelet

ls -al /etc/kubernetes/manifests/
systemctl status kubelet
sudo cat /lib/systemd/system/kubelet.service | wc -l | grep 14
sudo cat /var/lib/kubelet/pki/kubelet.key | wc -l | grep 27
```


```bash
sudo kubeadm config print init-defaults --component-configs KubeletConfiguration
sudo kubeadm config print join-defaults --component-configs KubeletConfiguration

sudo apt install -y jq

NODE_NAME="k8s-master"; curl -sSL "http://localhost:8001/api/v1/nodes/${NODE_NAME}/proxy/configz" | jq '.kubeletconfig|.kind="KubeletConfiguration"|.apiVersion="kubelet.config.k8s.io/v1beta1"' > kubelet_config_${NODE_NAME}

cat /var/lib/kubelet/config.yaml
stat -c %a /var/lib/kubelet/config.yaml | grep 644

ls /var/lib/kubelet/pki

sudo cat /etc/kubernetes/kubelet.conf
```
Refs.:
- https://stackoverflow.com/a/60802967
- https://stackoverflow.com/q/48953741

```bash
sudo \
docker \
run \
--interactive=true \
--tty=true \
--memory=8m \
--memory-swap=8m \
alpine:3.14.3 \
/bin/cat \
/sys/fs/cgroup/memory/memory.limit_in_bytes \
/sys/fs/cgroup/memory/memory.memsw.limit_in_bytes

sudo \
docker \
run \
--interactive=true \
--tty=true \
--memory=10m \
--memory-swap=10m \
alpine:3.14.3 \
/bin/cat \
/sys/fs/cgroup/memory/memory.limit_in_bytes \
/sys/fs/cgroup/memory/memory.memsw.limit_in_bytes
```
Refs.:
- https://stackoverflow.com/a/63726105
- https://docs.docker.com/engine/install/linux-postinstall/#your-kernel-does-not-support-cgroup-swap-limit-capabilities
- https://stackoverflow.com/a/48590230
- https://fabianlee.org/2020/01/18/docker-placing-limits-on-container-memory-using-cgroups/



```bash
cat /etc/sysctl.conf | grep swappiness
free -hm
blkid  
lsblk
```


```bash
sudo systemctl --type swap
sudo systemctl list-units --type=swap --state=active
```
Refs.:
- https://stackoverflow.com/a/59577261
- https://gist.github.com/kuznero/bffb7f9a0b9829bf036be09b058e4322

```bash
sudo swapon --show
```
Refs.:
- https://graspingtech.com/disable-swap-ubuntu/ 



```bash
sudo \
    sed \
    --in-place \
    's/^GRUB_CMDLINE_LINUX="/&swapaccount=0/' \
    /etc/default/grub \
&& sudo grub-mkconfig -o /boot/grub/grub.cfg
# && sudo reboot
echo 'vm.swappiness = 0' | sudo tee -a /etc/sysctl.conf
sudo reboot
```
Refs.:
- https://stackoverflow.com/a/66940710
- https://askubuntu.com/a/463283




```bash
cat /etc/sysctl.conf | grep swappiness
```

Skipped:
```bash
sudo rm -fv /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
mkdir -pv /etc/systemd/system/kubelet.service.d \
&& { sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf > /dev/null <<'EOF'
[Service]
ExecStart=
#  Replace "systemd" with the cgroup driver of your container runtime. The default value in the kubelet is "cgroupfs".
ExecStart=$(which kubelet) --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --cgroup-driver=systemd
Restart=always
EOF
} && echo
```
Adapted from: [Setting up the cluster](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/#setting-up-the-cluster)



```bash
podman \
run \
--entrypoint=/bin/bash \
--interactive=true \
--tty=false \
--rm=true \
--user=0 \
docker.io/library/python:3.9.7-slim-bullseye \
<<COMMANDS
python -m pip install --upgrade pip==21.3.1
pip install check-manifest
COMMANDS
```


### Use Docker from nixpkgs, the rest is from apt-get


```bash
nix \
profile \
install \
nixpkgs#kubectl

echo 'Start docker installation...'
nix \
profile \
install \
nixpkgs#docker \
&& sudo cp "$(nix eval --raw nixpkgs#docker)"/etc/systemd/system/{docker.service,docker.socket} /etc/systemd/system/ \
&& getent group docker || sudo groupadd docker \
&& sudo usermod --append --groups docker "$USER" \
&& sudo systemctl enable --now docker \
&& docker --version 

cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
echo 'End docker installation!'


echo 'Start bypass sudo stuff...' \
&& DOCKER_NIX_PATH="$(nix eval --raw nixpkgs#docker)/bin" \
&& NIX_KUBELET_PATH="$(nix eval --raw nixpkgs#kubernetes)"/bin \
&& echo 'Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:'"$DOCKER_NIX_PATH"':'"$NIX_KUBELET_PATH" | sudo tee -a /etc/sudoers.d/"$USER" \
&& echo 'End bypass sudo stuff...'

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo 'Start kubelet kubeadm kubectl install actually...'
sudo apt-get update
sudo apt-get install -y kubelet kubeadm
sudo apt-mark hold kubelet kubeadm

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo \
    sed \
    --in-place \
    's/^GRUB_CMDLINE_LINUX="/&swapaccount=0/' \
    /etc/default/grub \
&& sudo grub-mkconfig -o /boot/grub/grub.cfg
# && sudo reboot
echo 'vm.swappiness = 0' | sudo tee -a /etc/sysctl.conf
sudo reboot
```

```bash
sudo kubeadm config images pull
sudo kubeadm config images list
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -pv "$HOME"/.kube
sudo cp -iv /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown -v $(id -u):$(id -g) "$HOME"/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

watch --interval=1  kubectl get pods -A
```
Refs.:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/


### All from nixpkgs using single user installation of nix


```bash
nix \
profile \
install \
nixpkgs#cni \
nixpkgs#cni-plugins \
nixpkgs#conntrack-tools \
nixpkgs#cri-o \
nixpkgs#cri-tools \
nixpkgs#docker \
nixpkgs#ebtables \
nixpkgs#flannel \
nixpkgs#kubernetes \
nixpkgs#socat \
&& sudo cp "$(nix eval --raw nixpkgs#docker)"/etc/systemd/system/{docker.service,docker.socket} /etc/systemd/system/ \
&& getent group docker || sudo groupadd docker \
&& sudo usermod --append --groups docker "$USER" \
&& sudo systemctl enable --now docker

echo 'Start bypass sudo stuff...' \
&& NIX_CNI_PATH="$(nix eval --raw nixpkgs#cni)"/bin \
&& NIX_CNI_PLUGINS_PATH="$(nix eval --raw nixpkgs#cni-plugins)"/bin \
&& NIX_FLANNEL_PATH="$(nix eval --raw nixpkgs#flannel)"/bin \
&& NIX_CRI_TOOLS_PATH="$(nix eval --raw nixpkgs#cri-tools)"/bin \
&& NIX_EBTABLES_PATH="$(nix eval --raw nixpkgs#ebtables)"/bin \
&& NIX_SOCAT_PATH="$(nix eval --raw nixpkgs#socat)"/bin \
&& CONNTRACK_NIX_PATH="$(nix eval --raw nixpkgs#conntrack-tools)/bin" \
&& DOCKER_NIX_PATH="$(nix eval --raw nixpkgs#docker)/bin" \
&& KUBERNETES_BINS_NIX_PATH="$(nix eval --raw nixpkgs#kubernetes)/bin" \
&& echo 'Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:'"$KUBERNETES_BINS_NIX_PATH"':'"$DOCKER_NIX_PATH"':'"$CONNTRACK_NIX_PATH"':'"$NIX_CNI_PLUGINS_PATH"':'"$NIX_CRI_TOOLS_PATH"':'"$NIX_EBTABLES_PATH"':'"$NIX_SOCAT_PATH"':'"$NIX_FLANNEL_PATH"':'"$NIX_CNI_PATH"  | sudo tee -a /etc/sudoers.d/"$USER" \
&& echo 'End bypass sudo stuff...'


KUBERNETES_BINS_NIX_PATH="$(nix eval --raw nixpkgs#kubernetes)/bin"
cat <<EOF | sudo tee /etc/systemd/system/kubelet.service
# /lib/systemd/system/kubelet.service
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/home/
Wants=network-online.target
After=network-online.target

[Service]
ExecStart="$KUBERNETES_BINS_NIX_PATH"/kubelet
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target

# /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
# Note: This dropin only works with kubeadm and kubelet v1.11+
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
# the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/default/kubelet
ExecStart=
ExecStart="$KUBERNETES_BINS_NIX_PATH"/kubelet \$KUBELET_KUBECONFIG_ARGS \$KUBELET_CONFIG_ARGS \$KUBELET_KUBEADM_ARGS \$KUBELET_EXTRA_ARGS
EOF

cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

sudo systemctl enable --now kubelet

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo \
    sed \
    --in-place \
    's/^GRUB_CMDLINE_LINUX="/&swapaccount=0/' \
    /etc/default/grub \
&& sudo grub-mkconfig -o /boot/grub/grub.cfg

echo 'vm.swappiness = 0' | sudo tee -a /etc/sysctl.conf

nix store gc --verbose \
&& nix store optimise --verbose

sudo reboot
```
Refs.:
- https://stackoverflow.com/a/66940710
- https://askubuntu.com/a/463283
- https://github.com/NixOS/nixpkgs/issues/70407
- https://github.com/moby/moby/tree/e9ab1d425638af916b84d6e0f7f87ef6fa6e6ca9/contrib/init/systemd

```bash
sudo kubeadm config images pull
sudo kubeadm config images list
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

mkdir -pv "$HOME"/.kube
sudo cp -iv /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown -v $(id -u):$(id -g) "$HOME"/.kube/config

kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml

watch --interval=1 kubectl get pods -A
```


cat <<EOF | sudo tee /etc/cni/net.d/10-flannel.conflist
{
  "name": "cbr0",
  "plugins": [
    {
      "type": "flannel",
      "delegate": {
        "hairpinMode": true,
        "isDefaultGateway": true
      }
    },
    {
      "type": "portmap",
      "capabilities": {
        "portMappings": true
      }
    }
  ]
}
EOF

cat <<EOF | sudo tee /run/flannel/subnet.env
FLANNEL_NETWORK=10.244.0.0/16
FLANNEL_SUBNET=10.244.0.0/16
FLANNEL_MTU=1450
FLANNEL_IPMASQ=true
EOF

kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl -n kube-system apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
kubectl -n kube-system apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


kubectl -n kube-system delete pod coredns-

kubectl -n kube-system get cm kubeadm-config -o yaml


sudo journalctl --no-hostname --no-pager -b -u docker.service


sudo systemctl daemon-reload \
&& sudo systemctl enable etcd \
&& sudo systemctl start

cat <<EOF | tee config.yalm
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
clusterDNS:
- =10.244.0.0/16
EOF

sudo kubectl apply -f config.yalm

```bash
sudo kubeadm reset --force
sudo rm -rf $HOME/.kube
sudo docker system prune -af
sudo docker image prune -af
sudo reboot
```

### NixOS


```bash
sudo kubeadm config images pull
sudo kubeadm config images list

sudo rm -frv /var/lib/etcd
sudo kill $(sudo lsof -t -i:10259)
sudo kill $(sudo lsof -t -i:6443)
sudo kill $(sudo lsof -t -i:2379)
sudo kill $(sudo lsof -t -i:2380)

# sudo kubeadm reset --force

sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```
Refs.:
- https://unix.stackexchange.com/a/444585

```bash
sudo ss -lptn 'sport = :6443'
```


```bash
sudo systemctl status network.target
sudo systemctl status containerd.service
sudo systemctl status kube-apiserver.service
```

watch --interval=3 sudo systemctl status kubelet


sudo rm -rf /etc/kubernetes/manifests/


test -f /var/lib/kubernetes/secrets/ca.pem || echo 'Error!'
test -f /var/lib/kubernetes/secrets/kubelet-key.pem || echo 'Error!'
test -f /var/lib/kubernetes/secrets/kubelet.pem || echo 'Error!'
test -f /var/lib/kubernetes/secrets/kubelet.pem || echo 'Error!'
test -S /run/containerd/containerd.sock || echo 'Error!'


- [Jaka Hudoklin: Kubernetes cluster on NixOS (NixCon 2015)](https://www.youtube.com/watch?v=1UTO9Sf4GPQ)
- [Kubernetes cluster on NixOS](https://offlinehacker.github.io/slides.kubernetes_on_nixos/#/)
- https://nixos.org/manual/nixos/stable/index.html#sec-kubernetes
- https://nixos.wiki/wiki/Kubernetes#Troubleshooting
- https://github.com/NixOS/nixpkgs/issues/39327
- [Toy highly-available Kubernetes cluster on NixOS](https://www.reddit.com/r/NixOS/comments/qmsui6/toy_highlyavailable_kubernetes_cluster_on_nixos/)
- https://github.com/NixOS/nixpkgs/issues/71040
- https://github.com/NixOS/nixpkgs/issues/59364#issuecomment-896136015
- https://github.com/NixOS/nixpkgs/issues/59364#issuecomment-485122860
- https://github.com/NixOS/nixpkgs/issues/96083#issuecomment-806061869
- https://github.com/NixOS/nixpkgs/issues/59364#issuecomment-485122860


## The KinK inception


[May CoreOS Meetup: Kubeception- Dalton Hubble](https://www.youtube.com/watch?v=tlUiQa2JYQU)

https://gist.github.com/dghubble/c2dc319249b156db06aff1d49c15272e


## 


```bash
nix build .#iso-base \
&& cp -fv result/iso/nixos-21.11pre-git-x86_64-linux.iso . \
&& chmod +x nixos-21.11pre-git-x86_64-linux.iso \
&& qemu-img create nixos.img 18G \
&& echo 'Starting VM' \
&& qemu-kvm \
-boot d \
-drive format=raw,file=nixos.img \
-cdrom nixos-21.11pre-git-x86_64-linux.iso \
-m 18G \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980" < /dev/null &
```


```bash
qemu-kvm \
-boot a \
-cpu host \
-device "rtl8139,netdev=net0" \
-drive format=raw,file=nixos.img \
-enable-kvm \
-m 18G \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980" \
-nographic \
-smp $(nproc) < /dev/null &
```

```bash
kill -9 $(pidof qemu-system-x86_64)
```


```bash
cat << EOF > '/etc/nixos/'flake.nix
{
  outputs = { self, nixpkgs }: {
     nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [ ./configuration.nix ];
     };
  };
}
EOF

cd /etc/nixos
git init
git add .
```


```bash
nixos-rebuild switch --flake '/etc/nixos'#"$(hostname)"
reboot

sudo nixos-rebuild switch --flake '/etc/nixos'#"$(hostname)"
sudo reboot
```

```bash
qemu-img info nixos.img
```

```bash
nixos-rebuild test \
&& nixos-rebuild switch \
&& reboot
```

```bash
kill -9 $(pidof qemu-system-x86_64); \
rm -fv nixos.img \
&& nix build .#iso-base \
&& cp -fv result/iso/nixos-21.11pre-git-x86_64-linux.iso . \
&& chmod +x nixos-21.11pre-git-x86_64-linux.iso \
&& qemu-img create nixos.img 18G \
&& echo 'Starting VM' \
&& { qemu-kvm \
-boot d \
-drive format=raw,file=nixos.img \
-cdrom nixos-21.11pre-git-x86_64-linux.iso \
-m 18G \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980" < /dev/null & } \
&& sleep 20 \
&& ssh-keygen -R '[127.0.0.1]:10023' \
&& { ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no <<EOF
sudo my-install-mrb
sudo poweroff
EOF
} && echo 'End.'


kill -9 $(pidof qemu-system-x86_64); \
{ qemu-kvm \
-boot a \
-cpu host \
-device "rtl8139,netdev=net0" \
-drive format=raw,file=nixos.img \
-enable-kvm \
-m 18G \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980" \
-nographic \
-smp $(nproc) < /dev/null & } \
&& sleep 20 \
&& ssh-keygen -R '[127.0.0.1]:10023' \
&& ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no
```

TODO: test it
https://github.com/NixOS/nixpkgs/blob/nixos-21.11/nixos/modules/config/system-path.nix#L10-L49
https://github.com/NixOS/nixpkgs/issues/32405#issuecomment-678659550

```bash
sudo nix-env --profile /nix/var/nix/profiles/system --list-generations
```

```bash
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old

nix store gc --verbose \
&& nix store optimise --verbose
```

```bash
netstat -lnt
ss -lnt
```

```bash
boot.loader.systemd-boot.enable = false;
boot.loader.efi.canTouchEfiVariables = true;
boot.loader.efi.efiSysMountPoint = "/boot/efi";
boot.loader.grub = {
    enable = true;
    device = "nodev";
    version = 2;
    efiSupport = true;
    configurationLimit = 4;
    default = 0;
    extraEntries =
        ''
        menuentry "ArchLinux" {
            # set root=(hd0,1)
            # chainloader /efi/grub/grubx64.efi
            set root='hd0,gpt3'
            linux /vmlinuz-linux root=UUID=d964aa71-d90f-4f8e-af02-b08053c9f51f rw
            initrd /intel-ucode.img /initramfs-linux.img
        }
        '';
};
```


```bash
boot.loader = {
  systemd-boot.enable = true;
  efi.canTouchEfiVariables = true;
  efi.efiSysMountPoint = "/boot";
  timeout = 1;
};
```

cat $(readlink $(which my-install-mrb))

```bash
nixos-rebuild switch --flake '/etc/nixos'#"$(hostname)"
reboot
```

sudo systemctl status cfssl 
sudo systemctl status certmgr
sudo systemctl status containerd

sudo systemctl list-dependencies etcd


### build.vm

127.0.0.1:10023-:29980

export QEMU_NET_OPTS="hostfwd=tcp::2221-:22,hostfwd=tcp::8080-:80"

export QEMU_NET_OPTS="hostfwd=tcp:127.0.0.1:10023-:29980"



#### Using nix CLI + nix expression

TODO: convert it
https://github.com/NixOS/nixpkgs/issues/126141#issuecomment-861724383

```bash
nix build --impure --expr "(import <nixpkgs> {}).nixos ./configuration.nix"
```


```bash
nix build --impure --expr "(import <nixpkgs> {}).nixos ./src/base/nixos-minimal-configuration.nix"
```


```bash
nix \
build \
--no-link \
--impure \
--expr \
'(import <nixpkgs> {}).nixos <nixpkgs>/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix'
```

```bash
nix \
build \
--no-link \
--impure \
--expr \
'(import <nixpkgs> {system ? "x86_64-linux"}).nixos <nixpkgs>/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix'
```


```bash
nix \
eval \
--impure \
--expr \
'(import <nixpkgs> { }).pkgs'
```

```bash
nix \
build \
--no-link \
--impure \
--expr \
'with import <nixpkgs> {}; nixos.lib.nixosSystem { system = "x86_64-linux"; modules = [<nixpkgs>/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix];}'
```

```bash
nix \
build \
--impure \
--expr \
'{
  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixos-minimal = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ({ config, lib, pkgs, ... }: { system.build.nixos = import <nixpkgs>/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix { }; }) ];
    };
  };
}'
```

```bash
nix \
build \
--impure \
--expr \
'{
  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixos-minimal = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ <nixpkgs>/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix ];
    };
  };
}'
```


nix \
build \
--impure \
--expr \
'(
  with builtins.getFlake "nixpkgs"; 
  with legacyPackages.${builtins.currentSystem};
  with lib;
  nixosSystem {
      system = "${builtins.currentSystem}";
      modules = [ "${nixos}"/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix ];
    };      
)'


nix \                   
build \
--impure \
--expr \
'with builtins.getFlake "nixpkgs";
let
  nixosMinimal = lib.nixosSystem {
    system = "${builtins.currentSystem}";
    modules = [
      <nixpkgs>/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix
    ];  
  };  
in  
  nixosMinimal 
'


nix eval nixpkgs#nixos --apply builtins.functionArgs
nix eval nixpkgs#nixos --apply lib.sources.trace
github:NixOS/nixpkgs/b283b64580d1872333a99af2b4cef91bb84580cf


```bash
.config.system.build.toplevel

({ config, lib, pkgs, ... }: {
        system.build.toplevel = import "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix" { };
})
```

```bash
nix \
build \
--impure \
--expr \
'
{
  description = "";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
  };
  outputs = { nixpkgs, ... }: {
    nixosConfigurations = {
      nixtst = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          <nixpkgs>/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix
        ];
      };
    };
  };
}'
```

```bash
nix repl '<nixpkgs/nixos>'
:b config.system.build.toplevel
```


```bash
nix \
build \
--impure \
--expr \
'with import <nixpkgs/nixos> {};
let
  nixos-minimal = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      <nixpkgs>/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix
    ];
  };
in 
  nixos-minimal
'
```

```bash
nix \
build \
--impure \
--expr \
'with import <nixpkgs> {};
let
  pkgs = import <nixpkgs> { };
  nixos-minimal = nixos.lib.nixosSystem {  
    system = "x86_64-linux";
    modules = [
      <nixpkgs>/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix
    ];
  };
in 
  nixos-minimal
'
```



```bash
nix \
eval \
--impure \
--expr \
'{
  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixos-minimal = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ <nixpkgs>/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix ]; 
    };
  };
}'
```

```bash
nix \                        
eval \
--impure \
--expr \
'{
  outputs = { nixpkgs, nixos-minimal }: {
    nixosConfigurations.nixos-minimal = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ <nixpkgs>/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix ]; 
    };
  };
}' --apply builtins.tryEval outputs.nixosConfigurations.nixos-minimal.config.system.build.toplevel
```



### NixOS kubernetes


```bash
nix build .#iso-kubernetes
```

```bash
nix build .#iso-kubernetes
```

```bash
time ( 
kill -9 $(pidof qemu-system-x86_64); \
rm -fv nixos.img nixos-21.11pre-git-x86_64-linux-kubernetes.iso \
&& nix build .#iso-kubernetes \
&& cp -fv result/iso/nixos-21.11pre-git-x86_64-linux.iso nixos-21.11pre-git-x86_64-linux-kubernetes.iso  \
&& chmod +x nixos-21.11pre-git-x86_64-linux-kubernetes.iso \
&& qemu-img create nixos.img 12G 
)

time ( 
echo 'Starting VM' \
&& { qemu-kvm \
-boot d \
-drive format=raw,file=nixos.img \
-cdrom nixos-21.11pre-git-x86_64-linux-kubernetes.iso \
-m 12G \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-nographic \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980" \
-uuid 366f0d14-0de1-11e4-b0fa-82c9dd2b1400 < /dev/null & } \
&& sleep 30 \
&& ssh-keygen -R '[127.0.0.1]:10023' \
&& { ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no <<EOF
sudo my-install-mrb
sudo poweroff
EOF
} && echo 'End.'
)
# Maybe make a backup?
# time ( 
# kill -9 $(pidof qemu-system-x86_64); \
# cp -f nixos.img nixos-mrb-part-1.img.backup
# )

# Maybe restore a backup?
# time ( 
# kill -9 $(pidof qemu-system-x86_64); \
# cp -f nixos.img.backup nixos.img
# )

time ( 
kill -9 $(pidof qemu-system-x86_64); \
{ qemu-kvm \
-boot c \
-cpu host \
-device "rtl8139,netdev=net0" \
-drive format=raw,file=nixos.img \
-enable-kvm \
-m 12G \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980" \
-nographic \
-smp $(nproc) \
-uuid 366f0d14-0de1-11e4-b0fa-82c9dd2b1400 < /dev/null & } \
&& sleep 60 \
&& ssh-keygen -R '[127.0.0.1]:10023' \
&& { ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no <<EOF
echo '123' | sudo -S nixos-rebuild test --flake '/etc/nixos'#"\$(hostname)"
echo '123' | sudo -S first-rebuild-switch
echo '123' | sudo -S reboot
EOF
} && echo 'End.'
)
# Maybe make a backup?
# time ( 
# kill -9 $(pidof qemu-system-x86_64); \
# cp -f nixos.img nixos-mrb-part-2.img.backup
# )

# Maybe restore a backup?
# time ( 
# kill -9 $(pidof qemu-system-x86_64); \
# cp -f nixos-mrb-part-2.img.backup nixos.img
# )

time ( 
kill -9 $(pidof qemu-system-x86_64); \
{ qemu-kvm \
-boot c \
-cpu host \
-device "rtl8139,netdev=net0" \
-drive format=raw,file=nixos.img \
-enable-kvm \
-m 12G \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980" \
-nographic \
-smp $(nproc) \
-uuid 366f0d14-0de1-11e4-b0fa-82c9dd2b1400 < /dev/null & } \
&& sleep 60 \
&& ssh-keygen -R '[127.0.0.1]:10023' \
&& { ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no <<EOF
echo '123' | sudo -S kubeadm certs renew all

echo '123' | sudo -S systemctl restart kube-apiserver
echo '123' | sudo -S systemctl restart kube-controller-manager 
echo '123' | sudo -S systemctl restart kube-scheduler
echo '123' | sudo -S systemctl restart etcd

mkdir -pv "\$HOME"/.kube
echo '123' | sudo -S cp -fv /etc/kubernetes/cluster-admin.kubeconfig "\$HOME"/.kube/config
#echo '123' | sudo -S cp -fv /etc/kubernetes/admin.conf "\$HOME"/.kube/config
#echo '123' | sudo -S cp -fv /etc/kubernetes/kubelet.conf "\$HOME"/.kube/config
echo '123' | sudo -S chmod -v 0644 "\$HOME"/.kube/config
echo '123' | sudo -S chown -v \$(id -u):\$(id -g) "\$HOME"/.kube/config

echo '123' | sudo -S chown kubernetes:kubernetes -Rv /var/lib/kubernetes
# echo '123' | sudo -S stat /var/lib/kubernetes
echo '123' | sudo -S chmod -Rv 0775 /var/lib/kubernetes

# ?
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
EOF
} && echo 'End.'
)

#time ( 
#kill -9 $(pidof qemu-system-x86_64); \
#cp -f nixos.img nixos-mrb-part-3.img.backup
#)
# Maybe restore a backup?
# time ( 
# kill -9 $(pidof qemu-system-x86_64); \
# cp -f nixos-mrb-part-3.img.backup nixos.img
# )

kill -9 $(pidof qemu-system-x86_64); \
{ qemu-kvm \
-boot c \
-cpu host \
-device "rtl8139,netdev=net0" \
-drive format=raw,file=nixos.img \
-enable-kvm \
-m 12G \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980" \
-nographic \
-smp $(nproc) \
-uuid 366f0d14-0de1-11e4-b0fa-82c9dd2b1400 < /dev/null & } \
&& sleep 60 \
&& ssh-keygen -R '[127.0.0.1]:10023' \
&& ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no
```


```bash
sudo \
--preserve-env \
  AS_USER="$(id -un)" \
  AS_GROUP="$(id -gn)" \
su \
root \
--preserve-environment \
$SHELL \
-c \
'
utilsK8s-services-stop
utilsK8s-wipe-data
utilsK8s-services-restart-if-not-active

kubeadm certs renew all

kubeadm init phase certs all --cert-dir /etc/kubernetes/pki
kubeadm init phase kubeconfig admin --cert-dir /etc/kubernetes/pki

systemctl restart kube-apiserver
systemctl restart kube-controller-manager 
systemctl restart kube-scheduler
systemctl restart etcd

HOME_USER=/home/"${AS_USER}"
mkdir -pv "${HOME_USER}"/.kube
cp -fv /etc/kubernetes/cluster-admin.kubeconfig "${HOME_USER}"/.kube/config
# cp -fv /etc/kubernetes/admin.conf /home/"${AS_USER}"/.kube/config
# cp -fv /etc/kubernetes/kubelet.conf /home/"${AS_USER}"/.kube/config
chmod -v 0644 "${HOME_USER}"/.kube/config
chown -v "${AS_USER}":"${AS_GROUP}" "${HOME_USER}"/.kube/config

chown kubernetes:kubernetes -Rv /var/lib/kubernetes
# stat /var/lib/kubernetes
chmod -Rv 0775 /var/lib/kubernetes

mkdir -pv "${HOME_USER}"/.kube
chown -v "${AS_USER}":"${AS_GROUP}" "${HOME_USER}"/.kube
cp -fv /etc/kubernetes/admin.conf "${HOME_USER}"/.kube/config
chown -v "${AS_USER}":"${AS_GROUP}" "${HOME_USER}"/.kube/config
'

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

utilsK8s-services-stop
swapoff -a
kubeadm \
init \
--ignore-preflight-errors=false \
--pod-network-cidr=10.244.0.0/16


```bash
kubectl delete all --all -n kube-system
```

```bash
# For debug
# cat /etc/kubernetes/cluster-admin.kubeconfig | jq .
# echo $KUBECONFIG
#
# openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -text | grep ' Not '
# sudo kubeadm certs check-expiration

kubectl get pods -A
#kubectl --server=https://localhost:6443 --insecure-skip-tls-verify get pods -A
```
Refs.:
- https://stackoverflow.com/a/49886394
- https://serverfault.com/a/1037412

```bash
# kubectl get serviceaccounts
kubectl get serviceaccounts default -o yaml
kubectl get sa default -o yaml

kubectl get secret default-token-g59z6 -o yaml
```


figma


kubectl get events --namespace=kube-system
kubectl get nodes -o json | jq '.items[].spec.taints'
kubectl taint nodes $(hostname) node-role.kubernetes.io/master:NoSchedule-

kubectl -n kube-system rollout restart deploy


ETCDCTL_API=3 etcdctl --debug endpoint status 

kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml

watch --interval=1 kubectl get pods -A

```bash
sudo kubeadm certs renew apiserver
sudo kubeadm certs renew apiserver-etcd-client
sudo kubeadm certs renew apiserver-kubelet-client
sudo kubeadm certs renew front-proxy-client

sudo kubeadm kubeconfig user --org system:masters --client-name kubernetes-admin  > admin.conf
sudo kubeadm kubeconfig user --client-name system:kube-controller-manager > controller-manager.conf
sudo kubeadm kubeconfig user --org system:nodes --client-name system:node:$(hostname) > kubelet.conf
sudo kubeadm kubeconfig user --client-name system:kube-scheduler > scheduler.conf
```


```bash
nix profile install nixpkgs#lsof nixpkgs#ripgrep nixpkgs#jq

sudo kill $(sudo lsof -t -i:10259)
sudo kill $(sudo lsof -t -i:10250)
sudo kill -9 $(sudo lsof -t -i:6443)
sudo kill -9 $(sudo lsof -t -i:6443)
sudo kill -9 $(sudo lsof -t -i:6443)
sudo kill $(sudo lsof -t -i:2379)
sudo kill $(sudo lsof -t -i:2380)

sudo kubeadm reset --force
sudo rm -frv \
"$HOME"/.kube/ \
/etc/cni/net.d/  \
/etc/kubernetes/ \
/var/lib/etcd/ \
/var/lib/cfssl/ \
/var/lib/kubelet/

sudo mkdir -pv /var/lib/etcd

#sudo kubeadm config images pull
#sudo kubeadm config images list
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=true -v9
# sudo kubeadm init --token-ttl=0 --apiserver-advertise-address=https://localhost:6443 --v=9

# --apiserver-advertise-address=https://localhost:6443 \

sudo \
kubeadm \
init \
--ignore-preflight-errors=true \
--pod-network-cidr=10.244.0.0/16 \
--token-ttl=0 \
--v=9

mkdir -pv "$HOME"/.kube
sudo cp -iv /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown -v $(id -u):$(id -g) "$HOME"/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

watch --interval=1 kubectl get pods -A
```
Refs.:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

```bash
# QUIET='-q'
systemctl status certmgr.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status cfssl.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status containerd.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status flannel.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-addon-manager.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-apiserver.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-controller-manager.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-proxy.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kube-scheduler.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status kubelet.service | rg $QUIET -e 'Active: active' || echo 'Error!'
systemctl status etcd.service | rg $QUIET -e 'Active: active' || echo 'Error!'
```

```bash
# QUIET='-q'
systemctl status kubernetes.target | rg $QUIET -e 'Reached target Kubernetes' || echo 'Error!'
systemctl list-units --all --type target | rg $QUIET -e 'cfssl.target' || echo 'Error!'
# systemctl list-units --all --type target | cat
```

```bash
sudo systemctl is-active --quiet certmgr || sudo systemctl restart certmgr
sudo systemctl is-active --quiet cfssl || sudo systemctl restart cfssl
sudo systemctl is-active --quiet containerd || sudo systemctl restart containerd
sudo systemctl is-active --quiet flannel || sudo systemctl restart flannel
sudo systemctl is-active --quiet kube-addon-manager || sudo systemctl restart kube-addon-manager
sudo systemctl is-active --quiet kube-apiserver || sudo systemctl restart kube-apiserver
sudo systemctl is-active --quiet kube-controller-manager || sudo systemctl restart kube-controller-manager
sudo systemctl is-active --quiet kube-proxy || sudo systemctl restart kube-proxy
sudo systemctl is-active --quiet kube-scheduler || sudo systemctl restart kube-scheduler
sudo systemctl is-active --quiet kubelet || sudo systemctl restart kubelet
sudo systemctl is-active --quiet kubernetes || sudo systemctl restart kubernetes
```

```bash
systemctl status kubelet.service | rg $QUIET -e 'Active: active' || echo 'Error!'
```


```bash
systemctl list-dependencies --reverse kubelet
```

```bash
systemctl list-dependencies kubelet
```

```bash
PID=$(systemctl show kube-controller-manager | grep ExecMainPID | cut -d= -f2)
tr '\0' '\n' < /proc/${PID}/cmdline
```

```bash
PID=$(sudo ss -Hltnup 'sport = :6443' | cut -d'=' -f2 | cut -d',' -f1)
tr '\0' '\n' < /proc/${PID}/cmdline
```

kubectl config view
sudo kubectl config view

cat /var/lib/kubelet/kubeconfig

kubectl config set-credentials myuser --username=myusername --password=mypassword
kubectl config set-cluster local-server --server=https://localhost:6443 
kubectl config set-context default-context --cluster=local-server --user=myuser
kubectl config use-context default-context
kubectl config set contexts.default-context.namespace mynamespace


```bash
sudo kubectl config set-context default-system --cluster=default-cluster --user=default-admin
sudo kubectl config use-context default-system

kubectl config view
sudo kubectl config view

mkdir -pv ~/.kube                              
sudo ln -s /etc/static/kubernetes/cluster-admin.kubeconfig ~/.kube/config
```


```bash
kubectl --server=https://localhost:6443 get pods -A 
```


```bash
sudo netstat -lnpt | grep kube
```

```bash
kubectl config view
sudo kubectl config view

kubectl -n kube-system get cm kubeadm-config -o yaml

kubectl config current-context
sudo kubeadm certs check-expiration

sudo kubeadm config print init-defaults --component-configs KubeletConfiguration
sudo kubeadm config print join-defaults --component-configs KubeletConfiguration
```


```bash
sudo systemctl stop certmgr.service
sudo systemctl stop cfssl.service
sudo systemctl stop containerd.service
sudo systemctl stop flannel.service
sudo systemctl stop kube-addon-manager.service
sudo systemctl stop kube-apiserver.service
sudo systemctl stop kube-controller-manager.service
sudo systemctl stop kube-proxy.service
sudo systemctl stop kube-scheduler.service
sudo systemctl stop kubelet.service
sudo systemctl stop kubernetes.target

sudo systemctl restart certmgr.service
sudo systemctl restart cfssl.service
sudo systemctl restart containerd.service
sudo systemctl restart flannel.service
sudo systemctl restart kube-addon-manager.service
sudo systemctl restart kube-apiserver.service
sudo systemctl restart kube-controller-manager.service
sudo systemctl restart kube-proxy.service
sudo systemctl restart kube-scheduler.service
sudo systemctl restart kubelet.service
sudo systemctl restart kubernetes.target
```


#### Testing run time, k8s

```bash
cat << EOF > example.yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: test-pod
    image: busybox
    command: ['sh', '-c', 'echo The Bench Container 1 is Running ; sleep 100000']
EOF
```


```bash
kubectl create -f example.yaml
kubectl get pods

kubectl logs test-pod

kubectl get pods
kubectl exec test-pod -i -t -- /bin/sh -c ' ls -al /'

kubectl delete pod test-pod
rm -fv example.yaml
```

```bash
sudo \
docker \
run \
-it \
--rm \
--privileged \
--net=host \
-v /:/rootfs \
-v "$HOME"/.kube/config:"$HOME"/.kube/config \
k8s.gcr.io/node-test:0.2
```


```bash
curl -L https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.55.1/sonobuoy_0.55.1_linux_amd64.tar.gz -o sonobuoy_0.55.1_linux_amd64.tar.gz
tar -xvf sonobuoy_0.55.1_linux_amd64.tar.gz

sonobuoy run --wait
```


kubectl get all -n sonobuoy

kubectl get pods -n sonobuoy -o wide
sonobuoy status --json | jq .
sonobuoy delete --wait


sudo find /var/lib/kubernetes -group nogroup | sort

nixConfig.bash-prompt = "\[nix-develop\]$ ";
From: https://nixos.wiki/wiki/Flakes


sudo custom-kubeadm-certs-renew-all \
&& sudo utilsK8s-services-stop \
&& sudo utilsK8s-wipe-data \
&& sudo utilsK8s-services-restart-if-not-active \
sudo kubeadm init phase certs all --cert-dir /etc/kubernetes/pki
sudo kubeadm init phase kubeconfig admin --cert-dir /etc/kubernetes/pki

sudo custom-kubeadm-certs-renew-all

HARCODED_HOME='/home/nixuser'
mkdir -pv "$HARCODED_HOME"/.kube
cp -fv /etc/kubernetes/admin.conf "$HARCODED_HOME"/.kube/config
#cp -fv /etc/kubernetes/admin.conf "$HOME"/.kube/config
#cp -fv /etc/kubernetes/kubelet.conf "$HOME"/.kube/config
chmod -v 0644 "$HARCODED_HOME"/.kube/config
chown -v nixuser: "$HARCODED_HOME"/.kube/config


&& kdall && wka

kubectl -n kube-system get cm kubeadm-config -o yaml


```bash
mkdir -p ~/.kube

scp -P 27020 nixuser@imobanco.ddns.net:/etc/kubernetes/cluster-admin.kubeconfig ~/.kube/config
```
Refs.:
- https://www.youtube.com/watch?v=EFjOhVn2wQY


```bash
cat ~/.kube/config | jq .
```


```bash
kubectl config view


kubectl get pods --kubeconfig ~/.kube/config

kubectl config set-cluster local --server=http://imobanco.ddns.net:27020
# kubectl config set-cluster local --server=https://imobanco.ddns.net:27020
kubectl config use-context local

sudo mkdir -pv /var/lib/kubernetes/secrets

scp -P 27020 nixuser@imobanco.ddns.net:/var/lib/kubernetes/secrets/ca.pem ca.pem
scp -P 27020 nixuser@imobanco.ddns.net:/var/lib/kubernetes/secrets/cluster-admin.pem cluster-admin.pem
scp -P 27020 nixuser@imobanco.ddns.net:/var/lib/kubernetes/secrets/cluster-admin-key.pem cluster-admin-key.pem

sudo mv ca.pem cluster-admin-key.pem cluster-admin.pem /var/lib/kubernetes/secrets/
```
Refs.:
- https://github.com/kubernetes/dashboard/issues/2895#issuecomment-582200218



```bash
ssh -fNL 6443:http://imobanco.ddns.net:27020 nixuser@??

ssh -fNL 6443:http://imobanco.ddns.net:6443 nixuser@http://imobanco.ddns.net



ssh -NL 6443:http://127.0.0.1:10023 nixuser@http://127.0.0.1

```

```bash

rm -frv ~/.kube

mkdir -p ~/.kube

scp -P 10023 nixuser@localhost:/etc/kubernetes/cluster-admin.kubeconfig ~/.kube/config

kubectl config view
#kubectl config set-cluster local --server=https://localhost:6443
#kubectl config use-context local

scp -P 10023 nixuser@localhost:/var/lib/kubernetes/secrets/ca.pem ca.pem
scp -P 10023 nixuser@localhost:/var/lib/kubernetes/secrets/cluster-admin.pem cluster-admin.pem
scp -P 10023 nixuser@localhost:/var/lib/kubernetes/secrets/cluster-admin-key.pem cluster-admin-key.pem


sudo rm -frv /var/lib/kubernetes/secrets
sudo mkdir -pv /var/lib/kubernetes/secrets
sudo mv ca.pem cluster-admin-key.pem cluster-admin.pem /var/lib/kubernetes/secrets/

sudo chmod 0755 -R /var/lib/kubernetes/secrets/

ssh nixuser@localhost -p 10023 -fL 6443:localhost:6443 -N

kubectl --kubeconfig ~/.kube/config get pods --all-namespaces -o wide

# telnet localhost 6443
# nc -tz localhost 6443 
# timeout 5 telnet localhost 6443 || test $? -eq 124 || echo 'Error'
```
Refs.:
- https://github.com/kubernetes/dashboard/issues/2895#issuecomment-582200218
- https://serverfault.com/a/33292
- 

```bash
kubectl get pods
```


```bash
rm -frv ~/.kube

mkdir -p ~/.kube

REMOTE_USER_NAME=nixuser
PORT=27020
DOMAIN_NAME_OR_IP=imobanco.ddns.net

scp -P "${PORT}" "${REMOTE_USER_NAME}"@"${DOMAIN_NAME_OR_IP}":/etc/kubernetes/cluster-admin.kubeconfig ~/.kube/config

chmod 0644 ~/.kube/config

kubectl config view

# kubectl config set-cluster local --server=https://127.0.0.1:6443
# kubectl config use-context local
# kubectl config view


scp -P "${PORT}" "${REMOTE_USER_NAME}"@"${DOMAIN_NAME_OR_IP}":/var/lib/kubernetes/secrets/ca.pem ca.pem
scp -P "${PORT}" "${REMOTE_USER_NAME}"@"${DOMAIN_NAME_OR_IP}":/var/lib/kubernetes/secrets/cluster-admin.pem cluster-admin.pem
scp -P "${PORT}" "${REMOTE_USER_NAME}"@"${DOMAIN_NAME_OR_IP}":/var/lib/kubernetes/secrets/cluster-admin-key.pem cluster-admin-key.pem


sudo rm -frv /var/lib/kubernetes/secrets
sudo mkdir -pv /var/lib/kubernetes/secrets
sudo mv ca.pem cluster-admin-key.pem cluster-admin.pem /var/lib/kubernetes/secrets/

sudo chmod 0755 -R /var/lib/kubernetes/secrets/


# ssh "${REMOTE_USER_NAME}"@"${DOMAIN_NAME_OR_IP}" -p "${PORT}" -L 6443:"${DOMAIN_NAME_OR_IP}":6443 -N
# ssh "${REMOTE_USER_NAME}"@"${DOMAIN_NAME_OR_IP}" -p "${PORT}" -L 27020:"${DOMAIN_NAME_OR_IP}":6443 -N
ssh "${REMOTE_USER_NAME}"@"${DOMAIN_NAME_OR_IP}" -p "${PORT}" -L 6443:"${DOMAIN_NAME_OR_IP}":27020 -N
# ssh "${REMOTE_USER_NAME}"@"${DOMAIN_NAME_OR_IP}" -p "${PORT}" -fL 27020:"${DOMAIN_NAME_OR_IP}":6443 -N

kubectl --kubeconfig ~/.kube/config get pods --all-namespaces -o wide

# telnet localhost 6443
# nc -tz localhost 6443 
# timeout 5 telnet localhost 6443 || test $? -eq 124 || echo 'Error'
# timeout 5 telnet "${DOMAIN_NAME_OR_IP}" 6443 || test $? -eq 124 || echo 'Error'
# ss -tunlp
```



sudo custom-kubeadm-certs-renew-all \
&& sudo utilsK8s-services-stop \
&& sudo utilsK8s-services-restart-if-not-active \
&& kdall \
&& wka

sudo utilsK8s-wipe-data \
&& sudo utilsK8s-services-stop \
&& sudo utilsK8s-services-restart-if-not-active \
&& kdall \
&& wka

mkdir -pv "$HOME"/.kube
sudo mkdir -pv /etc/kubernetes

cp "$HOME"/cluster-admin.kubeconfig.backup "$HOME"/.kube/config

sudo cp "$HOME"/.kube/config /etc/kubernetes/cluster-admin.kubeconfig


sudo su

kubeadm reset -f
systemctl stop kubelet
systemctl stop docker

iptables --flush
iptables -tnat --flush

rm -rf /home/nixuser/.kube
rm -rf /etc/cni/
# rm -rf /etc/kubernetes/
rm -rf /var/lib/cni/
# rm -rf /var/lib/etcd/
rm -rf /var/lib/kubelet/*
rm -rf /etc/containerd

systemctl start kubelet
systemctl start docker

mkdir -p /etc/containerd \
&& containerd config default > /etc/containerd/config.toml
systemctl restart containerd

custom-kubeadm-certs-renew-all


kdall
wka


kubectl -n kube-system get cm kubeadm-config -o yaml


sudo utilsK8s-wipe-data \
&& sudo custom-kubeadm-certs-renew-all \
&& sudo utilsK8s-services-restart-if-not-active \
&& kdall \
&& wka


### 



{ qemu-kvm \
-boot c \
-cpu host \
-device "rtl8139,netdev=net0" \
-drive format=raw,file=nixos2.img \
-enable-kvm \
-m 12G \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10025-:29980" \
-nographic \
-smp $(nproc) \
-uuid 366f0d14-0de1-11e4-b0fa-82c8dd2b1400 < /dev/null & } \
&& sleep 60 \
&& ssh-keygen -R '[127.0.0.1]:10025' \
&& ssh nixuser@127.0.0.1 -p 10025 -o StrictHostKeyChecking=no


TOKEN=df67b86f81e807b431aa42dc9dd27db5
echo $TOKEN | nixos-kubernetes-node-join

```bash
# Bug! Why this name is different?
sudo cp /etc/kubernetes/cluster-admin.kubeconfig /etc/kubernetes/admin.conf

kubeadm init phase upload-certs --upload-certs

# It should output a token like this:
# a3df0534148eeae4c7055443dfdcaa8c42f5399a2f47413d4eab6131b054de7a

CERTIFICATE_KEY="$(sudo kubeadm init phase upload-certs --upload-certs | sed '3q;d')"
```


```bash
kubeadm \
token \
create \
--certificate-key "${CERTIFICATE_KEY}" \
--print-join-command | sed 's/ / \\\n/g'


# If the node to be joint is an "main node" 
kubeadm \
join \
10.1.11.178:6443 \
--token \
y0r6tx.otqw15eg1zed3mn0 \
--discovery-token-ca-cert-hash \
sha256:6fd0cfc9abb714558b795002b722ab77a8122d95e3d8604f516fc32262b87cfd \
--control-plane \
--certificate-key \
464e4087ae879d8c0cc0e18312fcae01f822bd9e6746e2c1d2eb813ebc9d68f4

# If the node to be joint is an "worker node" the flags --control-plane and --certificate-key
# are not needed. 
kubeadm \
join \
10.1.11.178:6443 \
--token \
y0r6tx.otqw15eg1zed3mn0 \
--discovery-token-ca-cert-hash \
sha256:6fd0cfc9abb714558b795002b722ab77a8122d95e3d8604f516fc32262b87cfd


sudo systemctl stop kubelet

kubeadm \
join \
localhost:6443 \
--token 218ghx.xfwhj2we6m0uykt5 \
--discovery-token-ca-cert-hash sha256:d3dea24aa9056a6f1bcd26be9e0f28faf111b1766b6308821ced82816c35fc4f \
--control-plane \
--certificate-key a3df0534148eeae4c7055443dfdcaa8c42f5399a2f47413d4eab6131b054de7a
```



https://github.com/NixOS/nixpkgs/blob/nixos-21.11/nixos/modules/services/networking/haproxy.nix

###


https://youtu.be/rTovNSGH_qo?t=1467


Typo
https://youtu.be/rTovNSGH_qo?t=2096



### Examples/tests


Basic example:
```bash
cat << 'EOF' > example.yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: test-pod
    image: busybox
    command: ['sh', '-c', 'echo The Bench Container 1 is Running ; sleep 100000']
EOF

kubectl apply -f example.yaml
```


#### Kubernetes Volumes explained | Persistent Volume, Persistent Volume Claim & Storage Class


https://www.youtube.com/watch?v=0swOh5C3OVM&t=900s

https://gitlab.com/nanuchi/youtube-tutorial-series/-/tree/master/kubernetes-volumes

```bash
cat << 'EOF' > storage-class.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOF

kubectl apply -f storage-class.yaml

cat << 'EOF' > task-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: local-storage
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: "."
EOF

kubectl apply -f task-pv.yaml

cat << 'EOF' > pv-claim.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: local-storage
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 3Gi
EOF

kubectl apply -f pv-claim.yaml

cat << 'EOF' > pv-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: task-pv-pod
spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: task-pv-claim
  containers:
    - name: task-pv-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: task-pv-storage
EOF

kubectl apply -f pv-pod.yaml
```



```bash
cat << 'EOF' > storage-class.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOF

kubectl apply -f storage-class.yaml

cat << 'EOF' > task-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: local-storage
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: "."
EOF

kubectl apply -f task-pv.yaml

cat << 'EOF' > pv-claim.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: local-storage
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 3Gi
EOF

kubectl apply -f pv-claim.yaml
```


```bash
kubectl delete pod task-pv-pod
kubectl delete pvc task-pv-claim
kubectl delete pv task-pv-volume
kubectl delete sc local-storage
```

```bash
kubectl delete all --all --all-namespaces
```

```bash
kubectl get nodes -o json | jq ".items[]|{name:.metadata.name, taints:.spec.taints}"
```
From:
- https://stackoverflow.com/a/53822911


```bash
watch -n 1 kubectl get sc --all-namespaces -o wide
watch -n 1 kubectl get pvc --all-namespaces -o wide
watch -n 1 kubectl get pv --all-namespaces -o wide
watch -n 1 kubectl get pod --all-namespaces -o wide

# 
watch -n 1 kubectl get sc,pvc,pv,pod --all-namespaces -o wide

```



#### [ Kube 13 ] Using Persistent Volumes and Claims in Kubernetes Cluster


https://github.com/justmeandopensource/kubernetes/tree/master/yamls


```bash
sudo \
su \
root \
$SHELL \
-c \
'
mkdir /kube
chmod 0777 /kube

echo '98765' > /kube/a1b2c3.txt
'

cat << 'EOF' > storage-class.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOF

cat << 'EOF' > 4-pv-hostpath.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-hostpath
  labels:
    type: local
spec:
  storageClassName: local-storage
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: "/kube"
EOF


cat << 'EOF' > 4-pvc-hostpath.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-hostpath
spec:
  storageClassName: local-storage
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Mi
EOF


cat << 'EOF' > 4-busybox-pv-hostpath.yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  volumes:
  - name: host-volume
    persistentVolumeClaim:
      claimName: pvc-hostpath
  containers:
  - image: busybox
    name: busybox
    command: ["/bin/sh"]
    args: ["-c", "sleep 600"]
    volumeMounts:
    - name: host-volume
      mountPath: /mydata
EOF

# It works in NixOS
kubectl apply \
-f 4-pv-hostpath.yaml \
-f 4-pvc-hostpath.yaml \
-f 4-busybox-pv-hostpath.yaml \
-f storage-class.yaml


#kubectl apply -f storage-class.yaml
#kubectl apply -f 4-pvc-hostpath.yaml
#kubectl apply -f 4-pv-hostpath.yaml
#kubectl apply -f 4-busybox-pv-hostpath.yaml

```


```bash
kubectl exec busybox -- /bin/sh -c 'stat /mydata'
kubectl exec busybox -- /bin/sh -c 'cat /mydata/a1b2c3.txt'
kubectl exec busybox -- /bin/sh -c 'watch -n 1 ls -al /mydata'
```

```bash
kubectl delete pod busybox 
kubectl delete pvc pvc-hostpath 
kubectl delete pv pv-hostpath 
kubectl delete sc local-storage
```

```bash
rm -frv /kube
```

```bash
# It does not deletes all things, as example, storage classes
kubectl delete all --all --all-namespaces
```

#### No Storage Class


```bash
test -f /kube/a1b2c3.txt || sudo \
su \
root \
$SHELL \
-c \
'
mkdir /kube
chmod 0777 /kube

echo '98765' > /kube/a1b2c3.txt
'


cat << 'EOF' > 4-pv-hostpath.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-hostpath
  labels:
    type: local
spec:
  storageClassName: default
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: "/kube"
EOF

cat << 'EOF' > 4-pvc-hostpath.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-hostpath
spec:
  storageClassName: default
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Mi
EOF

cat << 'EOF' > 4-busybox-pv-hostpath.yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  volumes:
  - name: host-volume
    persistentVolumeClaim:
      claimName: pvc-hostpath
  containers:
  - image: busybox
    name: busybox
    command: ["/bin/sh"]
    args: ["-c", "sleep 600"]
    volumeMounts:
    - name: host-volume
      mountPath: /mydata
EOF

# It works in NixOS
kubectl apply \
-f 4-pv-hostpath.yaml \
-f 4-pvc-hostpath.yaml \
-f 4-busybox-pv-hostpath.yaml
```

```
podman play kube 4-pvc-hostpath.yaml
podman play kube 4-pv-hostpath.yaml
podman play kube 4-busybox-pv-hostpath.yaml
```


### 


```bash
   echo ${pkgs.lib.makeBinPath propagatedNativeBuildInputs }

   ${pkgs.symlinkJoin
      {
        inherit name;
        paths = propagatedNativeBuildInputs;
        postBuild = "echo 'Links added'";
      }
   }

     wrapProgram "$out/bin/${name}" \
    --prefix PATH : ${pkgs.lib.makeBinPath propagatedNativeBuildInputs }

   ${pkgs.symlinkJoin
      {
        inherit name;
        paths = (pkgs.lib.attrsets.nameValuePair propagatedNativeBuildInputs);
        postBuild = "echo 'Links added'";
      }
   }
```   


#### minimal example of container exported to .yaml

```bash
podman \
run \
--interactive=true \
--name=container-with-volume \
--tty=true \
--rm=true \
--volume="$(pwd)":/code \
--workdir=/code \
alpine \
sh

podman generate kube container-with-volume > container-with-volume.yaml
```


```bash
cat << 'EOF' > container-with-volume.yaml
# Save the output of this file and use kubectl create -f to import
# it into Kubernetes.
#
# Created with podman-4.0.2

# NOTE: If you generated this yaml from an unprivileged and rootless podman container on an SELinux
# enabled system, check the podman generate kube man page for steps to follow to ensure that your pod/container
# has the right permissions to access the volumes added.
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: "2022-05-09T01:02:56Z"
  labels:
    app: container-with-volumepod
  name: container-with-volume-pod
spec:
  containers:
  - command:
    - sh
    image: docker.io/library/alpine:latest
    name: container-with-volume
    securityContext:
      capabilities: {}
    stdin: true
    tty: true
    volumeMounts:
    - mountPath: /code
      name: host-0
    workingDir: /code
  volumes:
  - hostPath:
      path: .
      type: Directory
    name: host-0
EOF

podman play kube ./container-with-volume.yaml
# Or
# kubectl create -f container-with-volume.yaml
```

```bash
podman exec -it container-with-volume_pod-container-with-volume sh -c 'apk add --no-cache python3'
```


####

```bash
podman save --format docker-archive --output income-back.tar ghcr.io/imobanco/income-api:latest

docker load --input income-back.tar
docker images
```

```bash
#test -f /kube/a1b2c3.txt || sudo \
#su \
#root \
#$SHELL \
#-c \
#'
#mkdir /kube
#chmod 0777 /kube
#
#echo '98765' > /kube/a1b2c3.txt
#'

test -d ./dumps || mkdir ./dumps

cat << 'EOF' > local-storage-postgres.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage-postgres
provisioner: kubernetes.io/no-provisioner
mountOptions:
  - debug
volumeBindingMode: Immediate
EOF


cat << 'EOF' > local-storage-rabbit.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage-rabbit
provisioner: kubernetes.io/no-provisioner
mountOptions:
  - debug
volumeBindingMode: Immediate
EOF


#cat << 'EOF' > pv-hostpath.yaml
#apiVersion: v1
#kind: PersistentVolume
#metadata:
#  name: pv-hostpath
#  labels:
#    type: local
#spec:
#  storageClassName: local-storage
#  capacity:
#    storage: 1Gi
#  accessModes:
#    - ReadWriteMany
#  hostPath:
#    path: ./dumps
#EOF

cat << 'EOF' > income-back-service-postgres-volume-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: income-back-service-postgres-volume-pvc
spec:
  storageClassName: local-storage-postgres
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Mi
EOF

cat << 'EOF' > income-back-service-rabbit-volume-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: income-back-service-rabbit-volume-pvc
spec:
  storageClassName: local-storage-rabbit
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Mi
EOF


cat << 'EOF' > imobanco-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: "2022-04-12T04:40:19Z"
  labels:
    app: imobanco-pod
  name: imobanco-pod
spec:
  containers:
  - args:
    - postgres
    env:
    - name: POSTGRES_PASSWORD
      value: postgres
    - name: POSTGRES_USER
      value: postgres
    - name: POSTGRES_DB
      value: postgres
    image: docker.io/library/postgres:12.3-alpine
    name: service-postgres
    ports:
    - containerPort: 5432
      hostPort: 5432
    - containerPort: 5672
      hostPort: 5672
    - containerPort: 6379
      hostPort: 6379
    - containerPort: 8000
      hostPort: 8000
    - containerPort: 15672
      hostPort: 9000
    resources: {}
    securityContext:
      capabilities: {}
    volumeMounts:
    - mountPath: /dumps
      name: dumps-host-0
    - mountPath: /var/lib/postgresql/data
      name: income-back-service-postgres-volume-pvc
  - args:
    - rabbitmq-server
    image: docker.io/library/rabbitmq:3.8.14-management-alpine
    name: service-rabbit
    resources: {}
    securityContext:
      capabilities: {}
    tty: true
    volumeMounts:
    - mountPath: /var/lib/rabbitmq
      name: income-back-service-rabbit-volume-pvc
  - command:
    - bash
    - -c
    - python manage.py migrate && python manage.py runserver 0.0.0.0:8000
    env:
    - name: DB_PORT
      value: "5432"
    - name: DEBUG
      value: "True"
    - name: ENV
      value: dev
    image:  ghcr.io/imobanco/income-api:latest
    name: service-django
    resources: {}
    securityContext:
      capabilities: {}
    tty: true
    volumeMounts:
    - mountPath: /home/app_user
      name: host-0
  - command:
    - bash
    - -c
    - celery --app=income worker --loglevel=info
    env:
    - name: ENV
      value: dev
    - name: DB_PORT
      value: "5432"
    - name: DEBUG
      value: "False"
    image:  ghcr.io/imobanco/income-api:latest
    name: service-celery
    resources: {}
    securityContext:
      capabilities: {}
    tty: true
    volumeMounts:
    - mountPath: /home/app_user
      name: host-0
  restartPolicy: Never
  volumes:
  - name: income-back-service-rabbit-volume-pvc
    persistentVolumeClaim:
      claimName: income-back-service-rabbit-volume-pvc
  - hostPath:
      path: .
      type: Directory
    name: host-0
  - hostPath:
      path: ./dumps
      type: Directory
    name: dumps-host-0
  - name: income-back-service-postgres-volume-pvc
    persistentVolumeClaim:
      claimName: income-back-service-postgres-volume-pvc
EOF

# It works in NixOS
# -f pv-hostpath.yaml \
kubectl apply \
-f income-back-service-postgres-volume-pvc.yaml \
-f income-back-service-rabbit-volume-pvc.yaml \
-f local-storage-rabbit.yaml \
-f local-storage-postgres.yaml \
-f imobanco-pod.yaml
```


```bash
kubectl delete pod imobanco-pod 
kubectl delete pvc income-back-service-postgres-volume-pvc
kubectl delete pvc income-back-service-rabbit-volume-pvc
# kubectl delete pv pv-hostpath
kubectl delete sc local-storage-rabbit
kubectl delete sc local-storage-postgres
```


```bash
ssh-keygen -R '[imobanco.ddns.net]:27020' \
&& while ! nc -w 1 -t imobanco.ddns.net 27020; do echo $(date +'%d/%m/%Y %H:%M:%S:%3N'); sleep 0.5; done \
&& ssh nixuser@imobanco.ddns.net -p 27020 -o StrictHostKeyChecking=no
```



```bash
#test -f /kube/a1b2c3.txt || sudo \
#su \
#root \
#$SHELL \
#-c \
#'
#mkdir /kube
#chmod 0777 /kube
#
#echo '98765' > /kube/a1b2c3.txt
#'

test -d ./dumps || mkdir ./dumps

cat << 'EOF' > local-storage-postgres.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage-postgres
provisioner: kubernetes.io/no-provisioner
mountOptions:
  - debug
volumeBindingMode: Immediate
EOF


cat << 'EOF' > local-storage-rabbit.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage-rabbit
provisioner: kubernetes.io/no-provisioner
mountOptions:
  - debug
volumeBindingMode: Immediate
EOF


#cat << 'EOF' > pv-hostpath.yaml
#apiVersion: v1
#kind: PersistentVolume
#metadata:
#  name: pv-hostpath
#  labels:
#    type: local
#spec:
#  storageClassName: local-storage
#  capacity:
#    storage: 1Gi
#  accessModes:
#    - ReadWriteMany
#  hostPath:
#    path: ./dumps
#EOF

cat << 'EOF' > income-back-service-postgres-volume-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: income-back-service-postgres-volume-pvc
spec:
  storageClassName: local-storage-postgres
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Mi
EOF

cat << 'EOF' > income-back-service-rabbit-volume-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: income-back-service-rabbit-volume-pvc
spec:
  storageClassName: local-storage-rabbit
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Mi
EOF


cat << 'EOF' > imobanco-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: "2022-04-12T04:40:19Z"
  labels:
    app: imobanco-pod
  name: imobanco-pod
spec:
  containers:
  - args:
    - postgres
    env:
    - name: POSTGRES_PASSWORD
      value: postgres
    - name: POSTGRES_USER
      value: postgres
    - name: POSTGRES_DB
      value: postgres
    image: docker.io/library/postgres:12.3-alpine
    name: service-postgres
    ports:
    - containerPort: 5432
      hostPort: 5432
    - containerPort: 5672
      hostPort: 5672
    - containerPort: 6379
      hostPort: 6379
    - containerPort: 8000
      hostPort: 8000
    - containerPort: 15672
      hostPort: 9000
    resources: {}
    securityContext:
      capabilities: {}
    volumeMounts:
    - mountPath: /dumps
      name: dumps-host-0
    - mountPath: /var/lib/postgresql/data
      name: income-back-service-postgres-volume-pvc
  - command:
    - bash
    - -c
    - python manage.py migrate && python manage.py runserver 0.0.0.0:8000
    env:
    - name: DB_PORT
      value: "5432"
    - name: DEBUG
      value: "True"
    - name: ENV
      value: dev
    image:  ghcr.io/imobanco/income-api:latest
    name: service-django
    resources: {}
    securityContext:
      capabilities: {}
    tty: true
    volumeMounts:
    - mountPath: /home/app_user
      name: host-0
  - command:
    - bash
    - -c
    - celery --app=income worker --loglevel=info
    env:
    - name: ENV
      value: dev
    - name: DB_PORT
      value: "5432"
    - name: DEBUG
      value: "False"
    image:  ghcr.io/imobanco/income-api:latest
    name: service-celery
    resources: {}
    securityContext:
      capabilities: {}
    tty: true
  restartPolicy: Never
  volumes:
  - name: income-back-service-postgres-volume-pvc
    persistentVolumeClaim:
      claimName: income-back-service-postgres-volume-pvc
EOF

kubectl apply \
-f income-back-service-postgres-volume-pvc.yaml \
-f local-storage-postgres.yaml \
-f imobanco-pod.yaml
```
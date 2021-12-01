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


```bash
test -f /var/lib/kubernetes/secrets/ca.pem || echo 'Erro! ''The file does not existe'
test -f /var/lib/kubernetes/secrets/kube-apiserver.pem || echo 'Erro! ''The file does not existe'
```


```bash
# ss -tunlp
sudo ss -tunlp | rg 'kube-*|certmgr'
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
ip route show default | awk '/default/ {print $5}'

ip link show docker0 | grep link/ether | awk '{print $2}'

ifconfig docker0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'
```
Refs.: 
- https://stackoverflow.com/a/68784841
- https://stackoverflow.com/a/40182414
- https://stackoverflow.com/a/23830537


```bash
ifconfig -a |
awk '/^[a-z]/ { iface=$1; mac=$NF; next }
    /inet addr:/ { print iface, mac }'
```
Refs.: 
- https://stackoverflow.com/a/23828821


```bash
lsmod | grep br_netfilter | wc -l | grep -q 2 || echo 'Error, kernel module br_netfilter not loaded'
```


```bash
sudo sysctl --system | grep 'Invalid argument'
```


```bash
timeout 5 telnet 127.0.0.1 6443
echo $?
```
Refs.:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports
- https://askubuntu.com/a/609174


```bash
sudo netstat -lnpt | grep kube
netstat -a | grep 6443
```
Refs.: 
- https://medium.com/@texasdave2/troubleshoot-kubectl-connection-refused-6f5445a396ed


```bash
sudo iptables -t raw -A OUTPUT -p tcp --dport 6443 -j TRACE
```
Refs.:
- https://stackoverflow.com/a/51141230

```bash
free -th | grep --no-ignore-case -E 'total|Swap'
free -th | rg --case-sensitive 'total|Swap'
```

```bash
sudo cat /lib/systemd/system/kubelet.service | wc -l  grep 14 || echo 'Error!!'
```

## Installing in a VM made with QEMU + KVM and Ubuntu 21.04 cloud image


```bash
echo 'Start docker instalation...' \
&& curl -fsSL https://get.docker.com | sudo sh \
&& getent group docker || sudo groupadd docker \
&& sudo usermod --append --groups docker "$USER" \
&& docker --version

cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
echo 'End docker instalation!'

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



```bash
cat /etc/sysctl.conf | grep swappiness
free -hm
blkid  
lsblk
```



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


### 


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
cat <<EOF | sudo tee /lib/systemd/system/kubelet.service
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

echo 'Start cni stuff...' \
&& sudo mkdir -pv /usr/lib/cni \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/bandwidth /usr/lib/cni/bandwidth \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/bridge /usr/lib/cni/bridge \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/dhcp /usr/lib/cni/dhcp \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/firewall /usr/lib/cni/firewall \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/host-device /usr/lib/cni/host-device \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/host-local /usr/lib/cni/host-local \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/ipvlan /usr/lib/cni/ipvlan \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/loopback /usr/lib/cni/loopback \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/macvlan /usr/lib/cni/macvlan \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/portmap /usr/lib/cni/portmap \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/ptp /usr/lib/cni/ptp \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/sbr /usr/lib/cni/sbr \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/static /usr/lib/cni/static \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/tuning /usr/lib/cni/tuning \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/vlan /usr/lib/cni/vlan \
&& sudo ln -fsv "$(nix eval --raw nixpkgs#cni-plugins)"/bin/vrf /usr/lib/cni/vrf \
&& echo 'End cni stuff...' 


cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF


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
Refs.:
- https://stackoverflow.com/a/66940710
- https://askubuntu.com/a/463283
- https://github.com/NixOS/nixpkgs/issues/70407
- https://github.com/moby/moby/tree/e9ab1d425638af916b84d6e0f7f87ef6fa6e6ca9/contrib/init/systemd

```bash
sudo kubeadm config images pull
sudo kubeadm config images list
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
#sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --network-plugin=cni --cni-bin-dir="$(nix eval --raw nixpkgs#cni)"/bin
#sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket /var/run/crio/crio.sock
#sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --token-ttl=0 --apiserver-advertise-address=https://localhost:6443 

mkdir -pv "$HOME"/.kube
sudo cp -iv /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown -v $(id -u):$(id -g) "$HOME"/.kube/config

kubectl -n kube-system apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
#kubectl -n kube-system apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

watch --interval=1 kubectl get pods -A
```

kubectl -n kube-system delete pod coredns-

kubectl -n kube-system get cm kubeadm-config -o yaml


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

# sudo kubeadm reset --force
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

```bash
sudo ss -lptn 'sport = :10259'
sudo ss -lptn 'sport = :6443'
```





sudo systemctl status containerd.service network.target kube-apiserver.service |


watch --interval=3 sudo systemctl status kubelet


sudo rm -rf /etc/kubernetes/manifests/


test -f /var/lib/kubernetes/secrets/ca.pem || echo 'Error!'
test -f /var/lib/kubernetes/secrets/kubelet-key.pem || echo 'Error!'
test -f /var/lib/kubernetes/secrets/kubelet.pem || echo 'Error!'
test -f /var/lib/kubernetes/secrets/kubelet.pem || echo 'Error!'
test -S /run/containerd/containerd.sock || echo 'Error!'

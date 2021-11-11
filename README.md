
# NixOS environments


```bash
nix build github:ES-Nix/NixOS-environments/kubernetes-from-service-in-nixos#image.image \
&& cp result/nixos.qcow2 nixos.qcow2 \
&& chmod 0755 nixos.qcow2 \
&& du -hs nixos.qcow2
```

TODO: wrap it in a scrip.
```bash
nix shell nixpkgs#qemu
```

```bash
qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc)
```

For now, login as `root` and passwd is `r00t`

You can, once logged in, change de passwd of the user `nixuser` with `passwd nixuser` and logout and
login as the `nixuser` with the passwd that was chosen.

```bash
nix build github:ES-Nix/NixOS-environments#image.image
```

```bash
cp result/nixos.qcow2 nixos.qcow2
chmod 0755 nixos.qcow2
```


### Local development 

Go to the directory that you want to clone and:
```bash
git clone https://github.com/ES-Nix/NixOS-environments.git \
&& cd NixOS-environments
```

```bash
nix build .#image.image
```

```bash
cp result/nixos.qcow2 nixos.qcow2
chmod 0755 nixos.qcow2
```


```bash
qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc)
```


```bash
nix build .#image.image \
&& cp result/nixos.qcow2 nixos.qcow2 \
&& chmod 0755 nixos.qcow2 \
&& qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc)
```


### Trying ssh WIP


ssh-keygen -t rsa -f ssh-keys.nix

ssh nixuser@192.168.1.2


nmap -sn 192.168.1.0/24 --system-dns



echo '192.168.1.2 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbqkQxZD6I65C1cQ3A5N/LoTHR85x1k/tBbBymZsWw8' >> ~/.ssh/known_hosts

/etc/ssl/certs/ca-certificates.crt




### The cacerts, Done


```bash
ls -al /nix/store/ | grep cert
```

```bash
ls /etc/ssl/certs
```



TODO:
- [NixOs Native Flake Deployment With LUKS Drive Encryption and LVM](https://dzone.com/articles/nixos-native-flake-deployment-with-luks-and-lvm)
- https://www.reddit.com/r/NixOS/comments/ebgezb/passwordless_ssh_authentication_in_nixos/fb4r5cj/?utm_source=reddit&utm_medium=web2x&context=3

TODO: the ssh thing
- https://git.redbrick.dcu.ie/m1cr0man/nix-configs-rb/src/branch/ylmcc-ssh/services/ssh.nix?lang=pt-PT
- https://nixos.wiki/wiki/Install_NixOS_on_a_Server_With_a_Different_Filesystem


### Tests

```bash
(result/run-vm-kvm < /dev/null &) \
&& result/ssh-vm
```

```bash
podman run -it --rm busybox echo 'Ok!'
sudo -k -n podman run -it --rm busybox echo 'Ok!'
```

```bash
sudo \
sed \
  's@Defaults\ssecure_path=\"@&'"$HOME"'\/.nix-profile\/bin:@' \
  /etc/sudoers
```


```bash
nix build .#image.image \
&& cp result/nixos.qcow2 nixos.qcow2 \
&& chmod 0755 nixos.qcow2 \
&& qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc)
```


```bash
nix \
    profile \
    install \
    github:ES-Nix/podman-rootless/from-nixpkgs \
    nixpkgs#cni \
    nixpkgs#cni-plugins \
    nixpkgs#kubernetes-helm \
    nixpkgs#minikube \
    nixpkgs#ripgrep \
&& mkdir -p -v /usr/lib/cni \
&& ln -fsv $(which firewall) /usr/lib/cni/firewall \
&& ln -fsv $(which bridge) /usr/lib/cni/bridge \
&& ln -fsv $(which portmap) /usr/lib/cni/portmap \
&& ln -fsv $(which tuning) /usr/lib/cni/tuning \
&& ln -fsv $(which host-local) /usr/lib/cni/host-local
podman network create podman
podman run -it --rm busybox echo 'Ok!'
```


```bash
nix \
    profile \
    install \
    github:ES-Nix/podman-rootless/from-nixpkgs \
    nixpkgs#cni \
    nixpkgs#cni-plugins \
    nixpkgs#kubernetes-helm \
    nixpkgs#minikube \
    nixpkgs#ripgrep \
&& echo '123' | sudo --stdin mkdir -p /usr/lib/cni \
&& sudo ln -fsv $(which bandwidth) /usr/lib/cni/bandwidth \
&& sudo ln -fsv $(which bridge) /usr/lib/cni/bridge \
&& sudo ln -fsv $(which dhcp) /usr/lib/cni/dhcp \
&& sudo ln -fsv $(which firewall) /usr/lib/cni/firewall \
&& sudo ln -fsv $(which host-device) /usr/lib/cni/host-device \
&& sudo ln -fsv $(which host-local) /usr/lib/cni/host-local \
&& sudo ln -fsv $(which ipvlan) /usr/lib/cni/ipvlan \
&& sudo ln -fsv $(which loopback) /usr/lib/cni/loopback \
&& sudo ln -fsv $(which macvlan) /usr/lib/cni/macvlan \
&& sudo ln -fsv $(which portmap) /usr/lib/cni/portmap \
&& sudo ln -fsv $(which ptp) /usr/lib/cni/ptp \
&& sudo ln -fsv $(which sbr) /usr/lib/cni/sbr \
&& sudo ln -fsv $(which static) /usr/lib/cni/static \
&& sudo ln -fsv $(which tuning) /usr/lib/cni/tuning \
&& sudo ln -fsv $(which vlan) /usr/lib/cni/vlan \
&& sudo ln -fsv $(which vrf) /usr/lib/cni/vrf \
&& echo '123' | sudo --stdin mkdir -p /lib/modules \
&& sudo podman network exists podman || sudo podman network create podman
```


```bash
sudo \
podman \
--log-level=error \
run \
-it \
--network=host \
--rm \
busybox \
echo \
'Ok!'
```


sudo podman network exists podman
sudo podman network ls
sudo -k -n podman run -it --rm busybox echo 'Ok!'

sudo rm -fr /usr/lib/cni /lib/modules
sudo podman network rm podman
sudo rm -fr /etc/cni/net.d/podman.conflist

sudo -k -n podman run -it --rm busybox echo 'Ok!'

sudo podman network exists podman || sudo podman network create podman
minikube start --driver=podman


echo 'net.ipv4.ip_forward=1' > /etc/sysctl.con


## Troubleshoot

WIP


## Refs

- [Custom live media with Nix flakes](https://hoverbear.org/blog/nix-flake-live-media/)
- [Mein kleines aber feines Cheatsheet für NixOS.](https://noqqe.de/sammelsurium/nixos/)


kube-addon-manager.service
kube-apiserver.service
kube-controller-manager.service
kube-proxy.service
kube-scheduler.service

systemctl cat kube-apiserver.service

stat /var/lib/kubernetes/secrets/ca.pem

stat /var/lib/kubernetes/secrets/kube-apiserver.pem



systemctl status kube-addon-manager.service | rg -e 'Active: active' || echo 'Error!'
systemctl status kube-apiserver.service | rg -e 'Active: active' || echo 'Error!'
systemctl status kube-controller-manager.service | rg -e 'Active: active' || echo 'Error!'
systemctl status kube-proxy.service | rg -e 'Active: active' || echo 'Error!'
systemctl status kube-scheduler.service | rg -e 'Active: active' || echo 'Error!'
systemctl status certmgr.service | rg -e 'Active: active' || echo 'Error!'


systemctl status kube-apiserver.service
systemctl status kube-addon-manager.service
systemctl restart kube-addon-manager.service
cat /nix/store/*-unit-kube-addon-manager.service/kube-addon-manager.service

ss -tunlp


anager-pre-start]# ss -tunlph795044h40wci7x7csghzly2d3j-unit-script-kube-addon-ma
Netid   State    Recv-Q   Send-Q     Local Address:Port      Peer Address:Port  Process                                                                         
udp     UNCONN   0        0                0.0.0.0:68             0.0.0.0:*      users:(("dhcpcd",pid=892,fd=10))                                               
tcp     LISTEN   0        4096           127.0.0.1:43765          0.0.0.0:*      users:(("containerd",pid=717,fd=11))                                           
tcp     LISTEN   0        128              0.0.0.0:22             0.0.0.0:*      users:(("sshd",pid=768,fd=3))                                                  
tcp     LISTEN   0        4096           127.0.0.1:10248          0.0.0.0:*      users:(("kubelet",pid=1399,fd=21))                                             
tcp     LISTEN   0        4096           127.0.0.1:10249          0.0.0.0:*      users:(("kube-proxy",pid=1343,fd=7))                                           
tcp     LISTEN   0        4096           127.0.0.1:10251          0.0.0.0:*      users:(("kube-scheduler",pid=1344,fd=7))                                       
tcp     LISTEN   0        4096           127.0.0.1:2379           0.0.0.0:*      users:(("etcd",pid=1278,fd=9))                                                 
tcp     LISTEN   0        4096           127.0.0.1:10252          0.0.0.0:*      users:(("kube-controller",pid=1289,fd=7))                                      
tcp     LISTEN   0        4096           127.0.0.1:2380           0.0.0.0:*      users:(("etcd",pid=1278,fd=8))                                                 
tcp     LISTEN   0        4096                   *:10259                *:*      users:(("kube-scheduler",pid=1344,fd=8))                                       
tcp     LISTEN   0        128                 [::]:22                [::]:*      users:(("sshd",pid=768,fd=4))                                                  
tcp     LISTEN   0        4096                   *:8888                 *:*      users:(("cfssl",pid=813,fd=7))                                                 
tcp     LISTEN   0        4096                   *:10250                *:*      users:(("kubelet",pid=1399,fd=16))                                             
tcp     LISTEN   0        4096                   *:6443                 *:*      users:(("kube-apiserver",pid=1342,fd=7))                                       
tcp     LISTEN   0        4096                   *:10255                *:*      users:(("kubelet",pid=1399,fd=17))                                             
tcp     LISTEN   0        4096                   *:10256                *:*      users:(("kube-proxy",pid=1343,fd=11))



/nix/store/*-kubernetes-1.22.1/bin/kube-addons

kubectl get pods -A

kubectl cluster-info

kubectl cluster-info dump


ss -tunlp

ss -tunlp | rg 'kube-apiserver|kubelet|kube-controller|kube-proxy|kube-scheduler|certmgr'


cat /etc/hosts

ping -c 3 127.0.0.1

journalctl -l -u kubelet


cat /var/lib/kubernetes/secrets/apitoken.secret | wc -l | rg 1

find / -iname '*.kubeconfig'

~/.kube/config


Probably usefull for a unpriviliged user?
file /etc/kubernetes/cluster-admin.kubeconfig | rg -w '/etc/kubernetes/cluster-admin.kubeconfig: symbolic link to /etc/static/kubernetes/cluster-admin.kubeconfig'
test -d ~/.kube || mkdir ~/.kube
ln -s /etc/kubernetes/cluster-admin.kubeconfig ~/.kube/config
kubectl cluster-info


echo $KUBECONFIG | rg -w '


cat /run/flannel/subnet.env


kubectl version
kubectl version --short --client
kubectl get nodes
kubectl get pods --all-namespaces
kubectl get pods --all-namespaces -o wide
kubectl get svc

cat /etc/cni/net.d/*-flannel.conf



kubeadm init --token-ttl=0 --apiserver-advertise-address=https://localhost:6443

kubectl describe -n kube-system pod coredns-55c7644d65-4gr6c 

kubectl describe -n kube-system pod shell-demo



systemctl restart kubelet.service

```bash
systemctl status kubelet.service
journalctl -f -u kubelet.service
```

```bash
echo kubectl cluster-info dump | rg MinimumReplicasUnavailable -B 11 -A 12 -m 1 
```


kubectl cluster-info dump | rg error


shutdown -r now


env | sort | sha256sum


```bash
env | grep -v HOSTNAME | sort | sha256sum
```

```bash
podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--user=0 \
docker.io/library/busybox \
<< COMMANDS
env | grep -v HOSTNAME | sort | sha256sum
COMMANDS
```

```bash
env > env.txt
SHA="$(sha256sum env.txt | cut -d ' ' -f 1)"
echo "$SHA env.txt" | sha256sum --check
echo "$SHA env.txt" | sha256sum --check --status
```
https://superuser.com/questions/1312740/how-to-take-sha256sum-of-file-and-compare-to-check-in-one-line#comment2484548_1468626



```bash
mkdir -p /usr/lib/cni \
&& ln -fsv $(which bandwidth) /usr/lib/cni/bandwidth \
&& ln -fsv $(which bridge) /usr/lib/cni/bridge \
&& ln -fsv $(which dhcp) /usr/lib/cni/dhcp \
&& ln -fsv $(which firewall) /usr/lib/cni/firewall \
&& ln -fsv $(which host-device) /usr/lib/cni/host-device \
&& ln -fsv $(which host-local) /usr/lib/cni/host-local \
&& ln -fsv $(which ipvlan) /usr/lib/cni/ipvlan \
&& ln -fsv $(which loopback) /usr/lib/cni/loopback \
&& ln -fsv $(which macvlan) /usr/lib/cni/macvlan \
&& ln -fsv $(which portmap) /usr/lib/cni/portmap \
&& ln -fsv $(which ptp) /usr/lib/cni/ptp \
&& ln -fsv $(which sbr) /usr/lib/cni/sbr \
&& ln -fsv $(which static) /usr/lib/cni/static \
&& ln -fsv $(which tuning) /usr/lib/cni/tuning \
&& ln -fsv $(which vlan) /usr/lib/cni/vlan \
&& ln -fsv $(which vrf) /usr/lib/cni/vrf
```


kubeadm init --pod-network-cidr=10.244.0.0/16


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

kubectl create -f projected.yaml
kubectl get pods

kubectl logs test-pod


kubectl get pods
kubectl exec test-pod -- -i -t -- /bin/sh -c ' ls -al /'

minikube kubectl -- delete pod test-pod
rm -fv projected.yaml




kubeadm config images list


docker pull quay.io/coreos/flannel:v0.14.0
docker pull k8s.gcr.io/kube-apiserver:v1.22.2
docker pull k8s.gcr.io/kube-controller-manager:v1.22.2
docker pull k8s.gcr.io/kube-scheduler:v1.22.2
docker pull k8s.gcr.io/kube-proxy:v1.22.2
docker pull k8s.gcr.io/pause:3.5
docker pull k8s.gcr.io/etcd:3.5.0-0
docker pull k8s.gcr.io/coredns/coredns:v1.8.4

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
- 
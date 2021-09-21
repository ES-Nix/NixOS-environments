
# NixOS environments


```bash
nix build github:ES-Nix/NixOS-environments#image.image \
&& cp result/nixos.qcow2 nixos.qcow2 \
&& chmod 0755 nixos.qcow2
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


          {"apiVersion":"v1",
            "clusters":
              [
                {
                "cluster":
                  {
                    "certificate-authority":"/var/lib/kubernetes/secrets/ca.pem",
                    "server":"${kubeMasterHostname}::${toString kubeMasterAPIServerPort}"
                  },
                  "name":"local"
                  }
              ],
            "contexts"
          }


file /etc/kubernetes/cluster-admin.kubeconfig | rg -w '/etc/kubernetes/cluster-admin.kubeconfig: symbolic link to /etc/static/kubernetes/cluster-admin.kubeconfig'
test -d ~/.kube || mkdir ~/.kube
ln -s /etc/kubernetes/cluster-admin.kubeconfig ~/.kube/config
kubectl cluster-info


echo $KUBECONFIG


cat /run/flannel/subnet.env


kubectl get nodes
kubectl get pods --all-namespaces
kubectl get pods --all-namespaces -o wide


cat /etc/cni/net.d/*-flannel.conf



kubeadm init --token-ttl=0 --apiserver-advertise-address=https://localhost:6443

kubectl describe kube-flannel-ds-* -n kube-system

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

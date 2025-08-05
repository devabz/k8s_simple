# k8s
Tutorial from: https://www.armosec.io/blog/setting-up-kubernetes-cluster/ <br>
Docker install: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository <br>
Kubeadm install: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/ <br>
Createi cluster: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/ <br>

### Steps
1. Install utils <br>
`./scripts/install_utils.sh` <br>
2. Install docker<br>
`./scripts/install_docker.sh` <br>
3. Install kubeadm <br>
`./scripts/install_k8s.sh`
4. Comment out "disabled_plugins = ["cri"]" in config.toml <br> 
`nano /etc/containerd/config.toml`
5. Initialze kubeadm (replace cidr with a non-overlapping IP-range) <br>
`kubeadm init --pod-network-cidr=x.x.x.x/x`
6. Run post init commands <br>
`./scripts/post_init_k8s`
7. Copy and run the `kubeadm join ...` command on other machines

### Reset and try again
`./scripts/reset_k8s.sh`

## Configure nework with Calico
```bash
kubeadm init --pod-network-cidr=x.x.x.x/x
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl create -f https://docs.projectcalico.org/v3.15/manifests/calico.yaml
```

# Troubleshoot
1. Make sure to use a non-overlapping cidr. <br>Check ip ranges using `ip -o -f inet addr show | awk '{print $4}'`
1. Validate service connection: CRI v1 runtime API is not implemented for endpoint <br> https://github.com/containerd/containerd/discussions/8033
3. When reseting, delete files not handeled by kubeadm reset



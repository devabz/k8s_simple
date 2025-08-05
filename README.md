
# 🚀 Kubernetes Setup (via `kubeadm`)

**Main Tutorial**:
👉 [https://www.armosec.io/blog/setting-up-kubernetes-cluster/](https://www.armosec.io/blog/setting-up-kubernetes-cluster/)

**Reference Docs**:

* Docker: [https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
* Kubeadm: [https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
* Cluster creation: [https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

---

## ✅ Setup Steps

1. **Install utilities**

   ```bash
   ./scripts/install_utils.sh
   ```

2. **Install Docker**

   ```bash
   ./scripts/install_docker.sh
   ```

3. **Install kubeadm, kubelet, kubectl**

   ```bash
   ./scripts/install_k8s.sh
   ```

4. **Fix containerd CRI (for Kubernetes)**
   Edit `/etc/containerd/config.toml` and **comment out** the line:

   ```toml
   # disabled_plugins = ["cri"]
   ```

5. **Set correct sandbox image and registry endpoint** *(optional but recommended)*
   In `/etc/containerd/config.toml`, under `[plugins."io.containerd.grpc.v1.cri"]`:

   ```toml
   sandbox_image = "registry.k8s.io/pause:3.10"

   [plugins."io.containerd.grpc.v1.cri".registry.mirrors."registry.k8s.io"]
     endpoint = ["https://registry.k8s.io"]
   ```

6. **Restart containerd**

   ```bash
   sudo systemctl restart containerd
   ```

7. **Initialize kubeadm** *(Use a non-overlapping CIDR block)*

   ```bash
   kubeadm init --pod-network-cidr=<your-safe-cidr>
   ```

8. **Post-init setup**

   ```bash
   ./scripts/post_init_k8s.sh
   ```

9. **Install Calico Network**
    ```bash
    kubectl apply -f https://docs.projectcalico.org/v3.15/manifests/calico.yaml
    ```

9. **Join worker nodes**
   Copy the `kubeadm join ...` command printed during `init` and run it on all worker nodes.

---

## 🔁 Reset and Retry

To wipe and reset everything:

```bash
./scripts/reset_k8s.sh
```



## 🧪 Troubleshooting

1. **Avoid CIDR conflicts**

   * Check existing networks:

     ```bash
     ip -o -f inet addr show | awk '{print $4}'
     ```

2. **CRI error (runtime API not implemented)**

   * See: [https://github.com/containerd/containerd/discussions/8033](https://github.com/containerd/containerd/discussions/8033)
   * Fix by ensuring containerd is using CRI (see step 4 & 5)




## 💡 Recommended CIDRs (examples)

If your host networks use:

* `192.168.0.0/16`
* `10.0.0.0/24` (Docker default)

Then safe Pod CIDRs might be:

* `10.244.0.0/16` *(used by Flannel and Calico)*
* `172.20.0.0/16` *(less commonly used)*

---


kubeadm reset -f
rm -rf /etc/cni/net.d
docker run --privileged --rm registry.k8s.io/kube-proxy:v1.33.0 sh -c "kube-proxy --cleanup && echo DONE"
rm -rf $HOME/.kube
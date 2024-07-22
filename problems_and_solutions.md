### ERROR and SOLUTIONS:

### Flanel pod creating error
Warning  FailedCreatePodSandBox  4m42s                kubelet  Failed to create pod sandbox: rpc error: code = Unknown desc = failed to setup network for sandbox "454da93a181af7328fcfa00a4219354383faf835e439fdd5bea35900bc92fa52": plugin type="calico" failed (add): error getting ClusterInformation: Get "https://10.96.0.1:443/apis/crd.projectcalico.org/v1/clusterinformations/default": x509: certificate signed by unknown authority (possibly because of "crypto/rsa: verification error" while trying to verify candidate authority certificate "kubernetes")
  Normal   SandboxChanged          4s (x22 over 4m42s)  kubelet  Pod sandbox changed, it will be killed and re-created.


### microk8s installation error
Arguments file /var/snap/microk8s/4595/args/ctr is missing.
Solution:
microk8s kubectl get pods
sudo usermod -a -G microk8s <username>
sudo chown -R <username> ~/.kube
newgrp microk8s

now we can check available cache images:
$ microk8s ctr images ls

### port use error
error execution phase preflight: [preflight] Some fatal errors occurred:
    [ERROR Port-10251]: Port 10251 is in use
    [ERROR Port-10252]: Port 10252 is in use
    [ERROR Port-10250]: Port 10250 is in use
    [ERROR Port-2380]: Port 2380 is in use
then i noticed that there is another process is running "microk8s" once I stopped that, I was able to start kubeadm

sudo microk8s.stop

### when worker node not joining , port use error
solution:
$ sudo kubeadm reset
$ sudo systemctl restart kubelet
$ sudo microk8s.stop
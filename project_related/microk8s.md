## Microk8s setup to use local image for pods
https://microk8s.io/#install-microk8s

### Install MicroK8s on Linux
```sh
$ sudo snap install microk8s --classic
```

## Check the status while Kubernetes starts
```sh
$ microk8s status --wait-ready
```

## Turn on the services you want
```sh
$ microk8s enable dashboard dns registry istio
```

### Add the user amantya to the 'microk8s' group:
```sh
$ sudo usermod -a -G microk8s amantya
$ sudo chown -R amantya ~/.kube
```

After this, reload the user groups either via a reboot or by running.
```sh
$ newgrp microk8s
```

## Try microk8s enable --help for a list of available services and optional features. microk8s disable <name> turns off a service.
```sh
$ sudo microk8s.start
$ sudo microk8s.stop
$ microk8s status
```

#### TO Remove docker image added to microk8s cache
```sh
$ microk8s ctr images rm docker.io/library/onboard_agv_jackal:1_0
```

# Now loading image on worker node
```sh
$ microk8s ctr image import amantya_orch_gazebo_mec.tar.gz
```

# Start pod using local image loaded.
```sh
$ microk8s kubectl apply -f pod1.yaml
```

# Check the status of pod.
```sh
$ microk8s kubectl get po
```

# Check the description of pod.
```sh
$ microk8s kubectl describe po pod-test1
```

### To Download Specific image
```sh
$ sudo microk8s ctr image export new_tar_name.tar docker.io/calico/cni:v3.23.5
```

### To export all images, MicroK8s offers a single command that can be used to export all images from the local container runtime into a single archive.
```sh
$ microk8s images export-local > images.tar
```
_______________________________________
## Create a MicroK8s cluster
https://microk8s.io/docs/clustering

### Adding a node
```sh
$ microk8s add-node
```
This will return something--
<!--
From the node you wish to join to this cluster, run the following:
microk8s join 192.168.1.230:25000/92b2db237428470dc4fcfc4ebbd9dc81/2c0cb3284b05

Use the '--worker' flag to join a node as a worker not running the control plane, eg:
microk8s join 192.168.1.230:25000/92b2db237428470dc4fcfc4ebbd9dc81/2c0cb3284b05 --worker

If the node you are adding is not reachable through the default interface you can use one of the following:
microk8s join 192.168.1.230:25000/92b2db237428470dc4fcfc4ebbd9dc81/2c0cb3284b05
microk8s join 10.23.209.1:25000/92b2db237428470dc4fcfc4ebbd9dc81/2c0cb3284b05
microk8s join 172.17.0.1:25000/92b2db237428470dc4fcfc4ebbd9dc81/2c0cb3284b05
-->

### To see the node has joined
```sh
$ microk8s kubectl get no
```

### Removing a node
First, on the node you want to remove, run
```sh
$ microk8s leave
```

To complete the node removal, run
```sh
$ microk8s remove-node <ip-address-of-worker-node>



_______________________________________
### Kubenet master worker node reset
## Master node 
```sh
$ sudo kubeadm reset
$ sudo rm $HOME/.kube/config
```

## Worker node 
```sh
$ sudo kubeadm reset
$ sudo rm $HOME/.kube/config
```
### If getting this port use error, disable microk8s
```sh
$ sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```
<!-- [init] Using Kubernetes version: v1.26.3
[preflight] Running pre-flight checks
[error execution phase preflight: preflight] Some fatal errors occurred:
	[ERROR Port-10259]: Port 10259 is in use
	[ERROR Port-10257]: Port 10257 is in use
	[ERROR Port-10250]: Port 10250 is in use
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher"" -->

### Use below command
sudo microk8s.stop

# Now initialize kubeadm and join worker node
```sh
$ sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```

## Execute below commands
```sh
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Remove the taints on the master so that you can schedule pods on it.
```sh
$ kubectl taint nodes --all node-role.kubernetes.io/control-plane-
$ kubectl taint nodes --all node-role.kubernetes.io/master-
```

## Install Calico​
### Install the Tigera Calico operator and custom resource definitions.
```sh
$ kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml
```

### Install Calico by creating the necessary custom resource
```sh
$ kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml
```

## Now join Worker node using token noted

### Confirm that all of the pods are running with the following command.
```sh
$ watch kubectl get pods -n calico-system
```

```sh
$ microk8s.start
```
wait for it to come running state

```sh
$ microk8s ctr images ls
```

```sh
$ kubectl apply -f ubuntu-sl.yaml
$ kubectl describe po ubuntu-sl
```sh

<!-- Got this 
Events:
  Type     Reason   Age   From     Message
  ----     ------   ----  ----     -------
  Normal   Pulling  13s   kubelet  Pulling image "ros-gazebo:amantya"
  Warning  Failed   10s   kubelet  Failed to pull image "ros-gazebo:amantya": rpc error: code = Unknown desc = failed to pull and unpack image "docker.io/library/ros-gazebo:amantya": failed to resolve reference "docker.io/library/ros-gazebo:amantya": pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed
  Warning  Failed   10s   kubelet  Error: ErrImagePull
  Normal   BackOff  9s    kubelet  Back-off pulling image "ros-gazebo:amantya"
  Warning  Failed   9s    kubelet  Error: ImagePullBackOff
-->


### Enable Microk8s dns, ingress, registry, storage, dashboard plugin.
$ sudo microk8s enable dns ingress registry storage dashboard

microk8s requires superuser permission
$ sudo usermod -aG microk8s $USER

Open the firewalls 
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed
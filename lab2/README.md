# LAB2: Build and run a single node kubernetes cluster

from <https://linuxconfig.org/how-to-install-kubernetes-on-ubuntu-20-04-focal-fossa-linux>

## Download and install Prerequisites

1. Add a kubernetes APT source

    The kubernetes admin CLI (kubeadm) is used to configure and join nodes to the cluster.

    Kubernetes is not in the default ubuntu apt repository. Add signing key for google cloud and add an apt source for kubernetes.

    ```sh
    sudo apt update -q
    sudo apt -qy install curl apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    ```

    The next time you run `apt-get update` packages provided by apt.kubernetes.io will be available for installation.

1.  Install kubernetes cli tools

    Now that we have an apt source for kubernetes, let's install the needed dependencies

    ```sh
    sudo apt update -q
    sudo apt install kubeadm kubelet kubectl kubernetes-cni
    ```
    
    ```output
    Hit:1 http://azure.archive.ubuntu.com/ubuntu focal InRelease
    Hit:2 http://azure.archive.ubuntu.com/ubuntu focal-updates InRelease
    Hit:3 http://azure.archive.ubuntu.com/ubuntu focal-backports InRelease
    Hit:4 https://packages.microsoft.com/ubuntu/20.04/prod focal InRelease
    Hit:6 http://security.ubuntu.com/ubuntu focal-security InRelease
    Hit:5 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
    ```
    
    The last row should contain `kubernetes-xenial`

1. disable swap:
    
    kubelet needs to have swap disabled to function properly.

    Disable swap, and update /etc/fstab to keep swap disabled at next boot

    ```sh
    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
    sudo swapoff -a
    ```

## Create the cluster

1. Initalize the master

    Make the node a master node.
    
    A pod network range needs to be specified so that containers may have ip addresses allocated to them

    ```sh
    sudo kubeadm init --pod-network-cidr 10.112.0.0/24
    ```

1. copy the kubeconfig file to your home directory:

    A kubernetes config file has been created containing authentication and host details for the master. The kubectl CLI tool looks for the file in `~/.kube/config` so let's move it there.

    ```sh
    mkdir -p $HOME/.kube
    sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```

1. Test the credentials using kubectl

    ```sh
    kubectl get nodes
    ```

    ```output
    NAME      STATUS   ROLES                  AGE    VERSION
    docker1   Ready    control-plane,master   2m7s   v1.21.1
    ```

1. Untaint the master node so we can schedule pods to the node

    Master nodes do not usually run workloads, but since we only have a single node, let's allow it for now.

    ```sh
    kubectl taint nodes --all node-role.kubernetes.io/master-
    ```

## Install a Cluster Networking agent

1.  Configure Kubernetes Network With Flannel

    Kubernetes requires an overlay network to assign IPs to pods and provide communication between pods.

    Flannel is a very simple overlay network that satisfies the Kubernetes requirements. Many people have reported success with Flannel and Kubernetes.

    ```sh
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
    ```

## Install an Ingress Controller

1. Install a traefik ingress controller

    Ingress is a kubernetes resource that manages external access to the services in a cluster, typically HTTP.
    Ingress may provide load balancing, SSL termination and name-based virtual hosting.

    Ingress controller act on ingress resources to create routes based on host and path for HTTP traffic.

    ```sh
    kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v1.7/examples/k8s/traefik-rbac.yaml
    kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v1.7/examples/k8s/traefik-deployment.yaml
    ```

1. Patch the ingress controller deployment to expose port 80 on the host

    In a real kubernetes cluster we'd have a load balancer controller that exposes TCP ports externally to the cluster. Since we don't have this, we simply expose the port directly on the host to be aple to reach it externally.

    ```sh
    kubectl patch -n kube-system deployment.apps/traefik-ingress-controller --patch "
    spec:
      template:
        spec:
          hostNetwork: true"
    ```

1. Browse or curl to your external IP:

    ```sh
    curl http://<your external ip>
    ```

    ```output
    404 page not found
    ```

    This is expected behavior since we haven't deployed any web services yet

## Kubernetes runs as docker containers

1. Check what containers are running on the host

    ```sh
    sudo docker ps
    ```

    ```output
    CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS          PORTS     NAMES
    3e3029027638   2a2126389e0b             "/traefik --api --ku…"   37 minutes ago   Up 37 minutes             k8s_traefik-ingress-lb_traefik-ingress-controller-77b7888dc7-8jq9h_kube-system_0fada02c-27ed-430d-a0b6-4a44d9864ff9_0
    550274b74c8d   k8s.gcr.io/pause:3.4.1   "/pause"                 37 minutes ago   Up 37 minutes             k8s_POD_traefik-ingress-controller-77b7888dc7-8jq9h_kube-system_0fada02c-27ed-430d-a0b6-4a44d9864ff9_0
    b19566b3af43   296a6d5035e2             "/coredns -conf /etc…"   4 hours ago      Up 4 hours                k8s_coredns_coredns-558bd4d5db-ss8vx_kube-system_58f27a49-35f3-43a9-9732-a11746429cf5_1
    1dcbfdf7aab0   296a6d5035e2             "/coredns -conf /etc…"   4 hours ago      Up 4 hours                k8s_coredns_coredns-558bd4d5db-wct4p_kube-system_f05879ab-7283-4989-ac8f-00b0b068d301_1
    0e01dcf7e6b1   k8s.gcr.io/pause:3.4.1   "/pause"                 4 hours ago      Up 4 hours                k8s_POD_coredns-558bd4d5db-wct4p_kube-system_f05879ab-7283-4989-ac8f-00b0b068d301_287
    a6c271730c6c   k8s.gcr.io/pause:3.4.1   "/pause"                 4 hours ago      Up 4 hours                k8s_POD_coredns-558bd4d5db-ss8vx_kube-system_58f27a49-35f3-43a9-9732-a11746429cf5_287
    03b5f89f1fdd   8522d622299c             "/opt/bin/flanneld -…"   4 hours ago      Up 4 hours                k8s_kube-flannel_kube-flannel-ds-2cqb2_kube-system_286de5f6-7b1c-491e-bdf1-a70bd7ea33ef_0
    55b0833673f9   k8s.gcr.io/pause:3.4.1   "/pause"                 4 hours ago      Up 4 hours                k8s_POD_kube-flannel-ds-2cqb2_kube-system_286de5f6-7b1c-491e-bdf1-a70bd7ea33ef_0
    56db33dd5e16   4359e752b596             "/usr/local/bin/kube…"   4 hours ago      Up 4 hours                k8s_kube-proxy_kube-proxy-2bxq8_kube-system_37b54998-0599-443b-bb63-489d7dc10213_1
    43c97c167075   k8s.gcr.io/pause:3.4.1   "/pause"                 4 hours ago      Up 4 hours                k8s_POD_kube-proxy-2bxq8_kube-system_37b54998-0599-443b-bb63-489d7dc10213_1
    6d30c662d0e7   e16544fd47b0             "kube-controller-man…"   4 hours ago      Up 4 hours                k8s_kube-controller-manager_kube-controller-manager-docker1_kube-system_0488faa3d52669ce2151a9ab70840536_1
    212b85205944   771ffcf9ca63             "kube-apiserver --ad…"   4 hours ago      Up 4 hours                k8s_kube-apiserver_kube-apiserver-docker1_kube-system_fa3b263f73a268f3d4715546618a1f62_1
    79e30ddf89d8   a4183b88f6e6             "kube-scheduler --au…"   4 hours ago      Up 4 hours                k8s_kube-scheduler_kube-scheduler-docker1_kube-system_e3942aa92c97f3d2e5f395795ffa4e86_1
    d1a2f7972d30   0369cf4303ff             "etcd --advertise-cl…"   4 hours ago      Up 4 hours                k8s_etcd_etcd-docker1_kube-system_be48cdeb8890056021ca8205ffca68bd_1
    6f2ca9a0fbab   k8s.gcr.io/pause:3.4.1   "/pause"                 4 hours ago      Up 4 hours                k8s_POD_etcd-docker1_kube-system_be48cdeb8890056021ca8205ffca68bd_1
    9734076ded59   k8s.gcr.io/pause:3.4.1   "/pause"                 4 hours ago      Up 4 hours                k8s_POD_kube-scheduler-docker1_kube-system_e3942aa92c97f3d2e5f395795ffa4e86_1
    08d22da95329   k8s.gcr.io/pause:3.4.1   "/pause"                 4 hours ago      Up 4 hours                k8s_POD_kube-controller-manager-docker1_kube-system_0488faa3d52669ce2151a9ab70840536_1
    b18077f1bc27   k8s.gcr.io/pause:3.4.1   "/pause"                 4 hours ago      Up 4 hours                k8s_POD_kube-apiserver-docker1_kube-system_fa3b263f73a268f3d4715546618a1f62_1
    ```


## Lab Outline

1. Deploy our previously built node.js web app as a deployment, service and ingress resource, see [Lab Instructions](./node.js/README.md)

1. Build a python web app and learn about configuration management using environment variables, see [Lab Instructions](./python/README.md)

1. Build an SFTP server app and learn about using volumes for configuration and data persistence. see [Lab Instructions](./sftp-server/README.md)

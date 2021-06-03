# LAB1: Build and run a single node kubernetes cluster

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

## Install an Ingress

1. 

    ```sh
    kubectl taint nodes --all node-role.kubernetes.io/master-
    ```

    ```sh
    kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v1.7/examples/k8s/traefik-rbac.yaml
    kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v1.7/examples/k8s/traefik-deployment.yaml
    ```

    ```sh
    kubectl patch 



## Lab Outline

1. Build a node.js web app and learn about the image cache, see [Lab Instructions](./node.js/README.md)

1. Build a python web app and learn about configuration management using environment variables, see [Lab Instructions](./python/README.md)

1. Build an SFTP server app and learn about using volumes for configuration and data persistence. see [Lab Instructions](./sftp-server/README.md)
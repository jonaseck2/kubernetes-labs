# LAB1: Build and run a container

## Prerequisites

### Install Docker
<a name="installDocker"></a>

1. Install docker using Advanced Package Tool (apt) package manager

    ```sh
    sudo apt-get update -q
    sudo apt-get install docker.io -qy
    ```

1. Test the docker installation by executing the following command:

    ```sh
    sudo docker ps
    ```

    output:

    ```terminal
    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
    ```

    No containers are currently running

1. Run an ubuntu linux container

    The ubuntu image contains does not technically run ubuntu linux, it contains the command line tools you'd expect to find in a ubuntu release.

    ```sh
    docker run -it --rm ubuntu bash
    ```

    output:

    ```terminal
    Unable to find image 'ubuntu:latest' locally
    latest: Pulling from library/ubuntu
    345e3491a907: Pull complete 
    57671312ef6f: Pull complete 
    5e9250ddb7d0: Pull complete 
    Digest: sha256:adf73ca014822ad8237623d388cedf4d5346aa72c270c5acc01431cc93e18e2d
    Status: Downloaded newer image for ubuntu:latest
    root@9d8a102814fb:/#
    ```

    the part of the prompt after the @ is the container ID and will be different every time a new container is started

    Do whatever you want, the changes in the container are not persisted and will be reset

1. Exit the container by typing exit

    ```sh
    exit
    ```

### Clone the lab repo

1. Clone the lab repo

    ```sh
    git clone https://github.com/jonaseck2/kubernetes-labs.git
    ```

1. change directory into the cloned directory

    ```sh
    cd kubernetes-labs
    ```

## Lab Outline

1. Build a node.js web app and learn about the image cache, see [Lab Instructions](./node.js/README.md)

1. Build a python web app and learn about configuration management using environment variables, see [Lab Instructions](./python/README.md)


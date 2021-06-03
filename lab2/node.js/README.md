# Node.js web application

A simple web server showing Hello world, now deployed in kubernetes

## Purpose

The purpose of this lab is to show how to work with kubernetes resources as yaml files.
- a Deployment that creates a replicaset which creates multiple pods
- a Service that routes traffic to the pods
- an Ingress that routes traffic based on bath to the service

## Instructions

1. go to the root of this lab, if you haven't already done so

1. Build the container, if you haven't already done so

    ```sh
    sudo docker build -t nodejs-helloworld ../../lab1/node.js/
    ```

### Deployment

1. Apply the Deployment

    A deployment creates a replicaset, which creates pods, which runs containers

    - The `apply` command specifies the resources should be created or updated
    - The `-f` specifies the file or path of files defining the resources

    ```sh
    kubectl apply -f deployment.yaml
    ```

    ```output
    deployment.apps/nodejs created
    ```

1. Check the status of the deployment

    ```sh
    kubectl get deployment nodejs
    ```

    ```output
    NAME                READY   UP-TO-DATE   AVAILABLE   AGE
    nodejs              3/3     3            3           20s
    ```

1. Check the replicaset created by the deployment

    This deployment creates a replicaset specifying that 3/3 pods should and have been created

    ```sh
    kubectl get rs
    ```

    ```output
    NAME                DESIRED   CURRENT   READY   AGE
    nodejs-58bc746fdd   3         3         3       3m39s
    ```

1. Check the pods created by the replicaset

    ```sh
    kubectl get pods
    ```

    ```output
    NAME                      READY   STATUS    RESTARTS   AGE
    nodejs-58bc746fdd-2tc7q   1/1     Running   0          5m6s
    nodejs-58bc746fdd-9dtng   1/1     Running   0          5m6s
    nodejs-58bc746fdd-pdtgm   1/1     Running   0          5m6s
    ```

1. Check the logs of one of the containers

    ```sh
    kubectl logs nodejs-58bc746fdd-2tc7q
    ```

    ```output
    > hello-world@0.0.1 start
    > node index.js

    Example app listening at http://localhost:3000
    ```

1. Scale the number of pods

    ```sh
    kubectl scale --replicas=10 deployment nodejs
    ```

    ```output
    deployment.apps/nodejs scaled
    ```

    ```sh
    kubectl get pods
    ```

    ```output
    NAME                                 READY   STATUS              RESTARTS   AGE
    nodejs-58bc746fdd-9ht4q   0/1     ContainerCreating   0          3s
    nodejs-58bc746fdd-drjws   0/1     ContainerCreating   0          3s
    nodejs-58bc746fdd-khk9x   0/1     ContainerCreating   0          3s
    nodejs-58bc746fdd-l7tql   0/1     ContainerCreating   0          3s
    nodejs-58bc746fdd-m59cm   0/1     ContainerCreating   0          3s
    nodejs-58bc746fdd-nwrh9   1/1     Running             0          2m47s
    nodejs-58bc746fdd-sjwg6   1/1     Running             0          2m47s
    nodejs-58bc746fdd-tm4t4   0/1     ContainerCreating   0          3s
    nodejs-58bc746fdd-whrx5   0/1     ContainerCreating   0          3s
    nodejs-58bc746fdd-xzd85   1/1     Running             0          2m47s
    ```

### Service

1. Apply the Service

    A Service creates an endpoint resource specifying the addresses of the containers to route traffic to.

    ```sh
    kubectl apply -f service.yaml
    ```

    ```output
    service/nodejs created
    ```

1. Check the status of the endpoint

    ```sh
    kubectl get ep
    ```

    The endpoint has 10 endpoints to load balance traffic to. Sending traffic to the "nodejs" service will forward traffic to one of the matching pod endpoints

    ```output
    NAME         ENDPOINTS                                                        AGE
    kubernetes   10.0.0.4:6443                                                    6h8m
    nodejs       10.112.0.23:3000,10.112.0.24:3000,10.112.0.25:3000 + 7 more...   20s
    ```

### Ingress

1. Apply the Ingress

    An Ingress sends traffic based on HTTP host and path to the  specified service
     
    ```sh
    kubectl applky -f ingress.yaml
    ```

    ```output
    ingress/nodejs created
    ```

### Test the solution

1. Curl or browse to your external IP

    ```sh
    curl http://104.40.228.99/nodejs
    ```

    ```output
    Hello World!
    ```

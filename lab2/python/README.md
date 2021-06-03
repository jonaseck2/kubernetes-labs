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
    sudo docker build -t python-helloworld ../../lab1/python/
    ```

### Deploy the solution


1. Deploy everything at once

    ```sh
    kubectl apply -f .
    ```

### Test the solution

1. Curl or brows to your external IP

    ```sh
    curl http://104.40.228.99/nodejs
    ```

    ```output
    Hello World!
    ```

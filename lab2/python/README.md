# Python web application

A simple web server showing Hello world, now deployed in kubernetes

## Purpose

The purpose of this lab is to show how to work with configuration as environment variables

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

1. Curl or browse to your external IP

    ```sh
    curl http://104.40.228.99/python
    ```

    ```output
    Hello World kubernetes
    ```

    Seems the NAME environment variable is set to "kubernetes"

1. Environment variables are added to deployment specs:

    from `deployment.yaml`

    ```yaml
        env:
        - name: NAME
          valueFrom:
            configMapKeyRef:
              name: python
              key: hello_name
    ```

    The value of the variable is stored in a configuration map resource named python

1. Check the configuration map resource contents

    ```sh
    kubectl get configmap python -o yaml
    ```

    ```yaml
    apiVersion: v1
    data:
      hello_name: kubernetes #<--here's the value
    kind: ConfigMap
    metadata:
    name: python
    ```

    **Note:** Some data has been removed from the output for clarity
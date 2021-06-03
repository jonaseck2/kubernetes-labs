# SFTP Server using PKI

An sftp server configured to only accept logins from using public keys.

## Purpose

The purpose of this lab is to show how configuration can be injected into the container using volumes. 

## Instructions

1. go to the root of this lab, if you haven't already done so

1. Build the container, if you haven't already done so

    ```sh
    sudo docker build -t sftp ../../lab1/sftp-server/
    ```

### Create secrets for the keys used by the container

1. Generate the keys

    ```sh
    ../../lab1/sftp-server/keygen.sh
    ```

1. Create secret resources

    ```sh
    kubectl create secret generic sftp-server \
    --from-file=ssh_host_ed25519_key \
    --from-file=ssh_host_rsa_key \
    --from-file=authorized_keys=client_rsa_key
    ```

### Deploy the solution

1. Deploy everything at once

    ```sh
    kubectl apply -f .
    ```

1. Check that the pods are starting

    ```sh
    kubectl get pods
    ```

    ```output
    NAME                                 READY   STATUS    RESTARTS   AGE
    ...
    sftp-server-0                        1/1     Running   0          4m19s
    ```

1. Check the logs of the pod

    ```sh
    kubectl logs sftp-server-0
    ```

### inspect the yaml

1. Secrets can be used as volumes and mounted as files

    from `statefulset.yaml`

    ```yaml
        volumeMounts:
        - name: data
          mountPath: /data
        - name: ssh-host-ed25519-key
          mountPath: /etc/ssh/ssh_host_ed25519_key
          subPath: ssh_host_ed25519_key
        ...
      volumes:
      - name: ssh-host-ed25519-key
        secret:
          secretName: sftp-server
          items:
          - key: ssh_host_ed25519_key
            path: ssh_host_ed25519_key
            mode: 0600
        ...
    ```

    The value of the variable is stored in a secret named sftp-server




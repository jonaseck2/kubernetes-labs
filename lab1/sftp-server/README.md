# SFTP Server using PKI

An sftp server configured to only accept logins from using public keys.

## Purpose

The purpose of this lab is to show how configuration can be injected into the container using volumes. It also shows how to persist data in volumes external to the container. This effectively makes the container stateless and reusable.

## Instructions

1. Generate keys used by the container for host identification and client authorization

    ```sh
    ./keygen.sh
    ```

1. Build the container

    - The `-t` argument tags the image so we can refer to it in the run command in the next step
    - The `.` argument means that the Dockerfile is situated here

    ```sh
    sudo docker build -t sftp .
    ```

1. Run the container

    - use the `-p` argument to fortward port **2222** on the host to the container
    - use the `-v` argument to bind mount encryption keys used for identification and authorization
    - the final argument `sftp` refers to the previously built image

    NOTE: the backslash ('\') at the end of the line means that the command contianues on the next line and has only been added for readability

    ```sh
    sudo docker run -d \
    -p 2222:2222 \
    -v ${PWD}/ssh_host_ed25519_key:/etc/ssh/ssh_host_ed25519_key \
    -v ${PWD}/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key \
    -v ${PWD}/client_rsa_key.pub:/home/sftp/.ssh/authorized_keys \
    sftp
    ```

1. Check that the server is running:

    ```sh
    sudo docker ps
    ```

    ```output
    76b18498e825   sftp      "/usr/sbin/sshd -D -e"   35 seconds ago   Up 33 seconds   0.0.0.0:2222->2222/tcp, :::2222->2222/tcp   relaxed_goldberg
    ```

    `sftp` is the tag of the container image
    `76b18498e825` and `relaxed_goldberg` are unqiue ids and names for the container

1. Log in to the sftp server and upload a file

    ```sh
    sftp -oIdentityFile=client_rsa_key -P2222 sftp@localhost
    sftp> cd upload
    sftp> put README.md
    ```

    ```output
    Connected to localhost.
    sftp>
    ```

1. Log out from the SFTP server

    ```sh
    sftp> exit
    ```

1. fail to log in using an unauthorized key

    ```sh
    sftp -oIdentityFile=client2_rsa_key -P2222 sftp@localhost
    ```

    ```output
    sftp@localhost: Permission denied (publickey,keyboard-interactive).
    ```

1. Create a persistent `/data` volume

    Since the container is stateless, everything stored under /data is lost on start. Create a persistent volume to retain the data

    ```sh
    sudo docker create sftp-data
    ```

1. Start the container. Port 2222 is used by the other server so let's change the mapping:

    sudo docker run -d \
    -p 2223:2222 \
    -v ${PWD}/ssh_host_ed25519_key:/etc/ssh/ssh_host_ed25519_key \
    -v ${PWD}/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key \
    -v ${PWD}/client_rsa_key.pub:/home/sftp/.ssh/authorized_keys \
    --mount source=sftp-data,target=/data \
    sftp

1. Log in to the sftp server and upload a file

    ```sh
    sftp -oIdentityFile=client_rsa_key -P2222 sftp@localhost
    sftp> cd upload
    sftp> ls
    sftp> put README.md
    ```

    As shown by the second command, the upload folder is empty.
    If you want, you can terminate the container and start it again to see that the file is persisted between containers.

1. Terminate the container

    ```sh
    sudo docker ps
    ```

    ```output
    92661e2992a1   sftp      "/usr/sbin/sshd -D -e"   4 seconds ago        Up 2 seconds        0.0.0.0:2223->2222/tcp, :::2223->2222/tcp   wonderful_chaum
    7d0c2a8001fb   sftp      "/usr/sbin/sshd -D -e"   About a minute ago   Up About a minute   0.0.0.0:2222->2222/tcp, :::2222->2222/tcp   musing_colden
    ```

    Kill the container using the id or name shown

    sh```
    sudo docker kill wonderful_chaum musing_colden
    ```

1. Remove the persisted volume

    ```sh
    sudo docker volume rm sftp-data
    ```

    Volume drivers are available to store persisted data on storage devices, see <https://docs.docker.com/storage/volumes/>

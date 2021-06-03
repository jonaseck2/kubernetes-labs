# Python Web Application

A simple web server showing Hello world, or your name

## Purpose

The purpose of this lab is to show how configuration can be injected into the container using volumes. This effectively makes the container stateless and reusable.

## Instructions

1. Build the container

    - The `-t` argument tags the image so we can refer to it in the run command in the next step
    - The `.` argument means that the Dockerfile is situated here

    ```sh
    sudo docker build -t python-helloworld .
    ```

1. Run the container

    - use the `-p` argument to fortward port **3000** on the host to the container
    - use the `-e` argument to set environment variables used for configuration
    - the final argument `python-helloworld` refers to the previously built image

    NOTE: the backslash ('\') at the end of the line means that the command contianues on the next line and has only been added for readability

    ```sh
    sudo docker run -d \
    -p 3000:3000 \
    -e NAME="Despicable Me" \
    python-helloworld
    ```

1. curl to the web server to see the output:

    ```sh
    curl localhost:3000
    ```

    output:

    ```output
    Hello Despicable Me
    ```

1. The container Port is also controlled by an environment variable:

    - Add another `-e` argument for `PORT`, setting the port to 3001
    - Change the `-e` argument for `NAME`, so you can distinguish them
    - Update the `-p` argument to forward port `3001` to `3001`
    - curl the second web server running on `localhost:3001`

1. Terminate the containers

    ```sh
    sudo docker ps
    ```

    ```output
    f14aa8daa286   python-helloworld   "python app.py"   12 seconds ago   Up 10 seconds   3000/tcp, 0.0.0.0:3001->3001/tcp, :::3001->3001/tcp   friendly_rosalind
    83d0ab6df165   python-helloworld   "python app.py"   4 minutes ago    Up 4 minutes    0.0.0.0:3000->3000/tcp, :::3000->3000/tcp             vigilant_ellis
    ```

    Kill the container using the id or name shown

    ```sh
    sudo docker kill friendly_rosalind vigilant_ellis
    ```

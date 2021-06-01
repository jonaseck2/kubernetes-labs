# Node.js web application

A simple web server showing Hello world

## Purpose

The purpose of this lab is to show how caching works when building images. and get aquanted working with the terminal

## Instructions

1. go to the root of this lab if you haven't already done so

    ```sh
    cd lab1
    cd node.js
    ```

1. Build the container

    The `-t` argument tags the image so we can refer to it in the run command in the next step
    The `.` argument means that the Dockerfile is situated here

    ```sh
    sudo docker build -t nodejs-helloworld .
    ```

    ```output
    => CACHED [1/6] FROM docker.io/library/node:16-alpine3.13@sha256:e5615 0.0s
    => [2/6] RUN mkdir -p /usr/src/app                                     0.3s
    => [3/6] WORKDIR /usr/src/app                                          0.0s
    => [4/6] COPY package.json /usr/src/app/                               0.0s
    => [5/6] RUN npm install && npm cache clean --force                    5.0s
    => [6/6] COPY . .  
    ```

1. Build the container again

    ```sh
    sudo docker build -t nodejs-helloworld .
    ```

    The build is now cached, taking no time at all

    ```output
    => CACHED [1/6] FROM docker.io/library/node:16-alpine3.13@sha256:e5615        0.0s
    => CACHED [2/6] RUN mkdir -p /usr/src/app                                     0.0s
    => CACHED [3/6] WORKDIR /usr/src/app                                          0.0s
    => CACHED [4/6] COPY package.json /usr/src/app/                               0.0s
    => CACHED [5/6] RUN npm install && npm cache clean --force                    0.0s
    => CACHED [6/6] COPY . .  
    ```

1. Add a space to the end of the package.json file to invalidate the cache, and build again

    ```sh
    echo " " >> package.json
    sudo docker build -t nodejs-helloworld .
    ```

    Output shows the cache is cached until step 3 and invalidated

    ```output
    => CACHED [1/6] FROM docker.io/library/node:16-alpine3.13@sha256:e5615        0.0s   
    => CACHED [2/6] RUN mkdir -p /usr/src/app                                     0.0s
    => CACHED [3/6] WORKDIR /usr/src/app                                          0.0s
    => [4/6] COPY package.json /usr/src/app/                                      0.0s
    => [5/6] RUN npm install && npm cache clean --force                           5.5s
    => [6/6] COPY . . 
    ```

1. Run the container

    - use the `-p` argument to fortward port **3000** on the host to the container
    - the final argument `nodejs-helloworld` refers to the previously built image

    NOTE: the backslash ('\') at the end of the line means that the command contianues on the next line and has only been added for readability

    ```sh
    sudo docker run -d \
    -p 3000:3000 \
    nodejs-helloworld
    ```

1. Test the container

    ```sh
    curl localhost:3000
    ```

    ```output
    hello World!
    ```

1. Terminate the container

    ```sh
    sudo docker ps
    ```

    ```output
    848849fe6474   36364cbe00c7        "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   nice_wright
    ```

    Kill the container using the id or name shown

    sh```
    sudo docker kill nice_wright
    ```

1. Change Directory back to the next lab

    ```sh
    cd ..
    cd python
    ```

#!/usr/bin/env bash
rm -f *_key*
ssh-keygen -t ed25519 -f ssh_host_ed25519_key -N "" < /dev/null > /dev/null
ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key -N "" < /dev/null > /dev/null

ssh-keygen -t rsa -b 4096 -f client_rsa_key -N "" < /dev/null > /dev/null
ssh-keygen -t rsa -b 4096 -f client2_rsa_key -N "" < /dev/null > /dev/null
FROM alpine

RUN apk add --no-cache \
    openssh \
    openssh-sftp-server \
 && mkdir -p /data/upload \
 && chmod 777 /data/upload \
 && addgroup sftp \
 && adduser sftp -s /bin/false -D -G sftp \
 && sed -i 's/sftp:!/sftp:*/' /etc/shadow \
 && mkdir -p \
    /home/sftp/.ssh/ \
 && touch /home/sftp/.ssh/authorized_keys \
 && chown -R sftp:sftp /home/sftp/.ssh \
 && chmod 700 /home/sftp/.ssh/ \
 && chmod 644 /home/sftp/.ssh/authorized_keys

COPY sshd_config /etc/ssh/sshd_config

CMD ["/usr/sbin/sshd", "-D", "-e"]
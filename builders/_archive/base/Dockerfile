FROM python:3.8-alpine

# add openssh and clean
RUN apk add openssh && rm  -rf /tmp/* /var/cache/apk/*
# add entrypoint script
ADD entry_point_ssh.sh /usr/local/bin
#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
RUN chmod 770 /usr/local/bin/entry_point_ssh.sh

EXPOSE 22
ENTRYPOINT ["entry_point_ssh.sh"]

WORKDIR /code
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# CMD sh
CMD ["/usr/sbin/sshd","-D"]

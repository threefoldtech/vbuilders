FROM ubuntu:22.04


RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y python3 python3-pip
RUN pip3 install --no-cache --upgrade pip setuptools

RUN apt-get install -y  python3-nacl python3-packaging python3-redis
RUN pip3 install --no-cache requests python-jose flask docker pytoml

# Make this a zinit container
COPY bin/zinit /bin/zinit

ENTRYPOINT ["/bin/zinit","init","--container"]
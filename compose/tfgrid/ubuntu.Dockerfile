FROM ubuntu:22.04

RUN apt-get update
RUN apt-get upgrade -y

COPY bin/zinit /bin/zinit

ENTRYPOINT ["/bin/zinit","init","--container"]



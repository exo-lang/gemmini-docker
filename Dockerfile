FROM ubuntu:20.04

WORKDIR /root
COPY chipyard.diff .
COPY install.sh .

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=US
RUN ./install.sh

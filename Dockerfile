FROM ubuntu:20.04

COPY chipyard.diff /root
COPY install.sh /root

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=US
RUN /root/install.sh

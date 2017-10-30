FROM debian:wheezy-slim

RUN apt-get update
RUN apt-get install iperf bmon
RUN apt-get install telnet -y
RUN apt-get install iputils-ping -y
RUN apt-get install net-tools

COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]


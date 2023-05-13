# TODO this doesn't work anymore
FROM node:10.16.3-stretch

# node 14 & 17 do not work

RUN apt update
RUN apt install -y python2 build-essential

RUN npm install -g screeps

WORKDIR /screeps/

ADD startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

CMD /root/startup.sh
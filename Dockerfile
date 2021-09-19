FROM ubuntu:focal

WORKDIR /opt
COPY ./app.sh .
COPY ./version .

CMD ["./app.sh"]

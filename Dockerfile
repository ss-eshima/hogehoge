FROM golang:alpine
RUN apk update \
 && apk add jq \
 && apk add curl \
 && rm -rf /var/cache/apk/*
ADD files /tmp
CMD ["sh", "/tmp/execute.sh"]

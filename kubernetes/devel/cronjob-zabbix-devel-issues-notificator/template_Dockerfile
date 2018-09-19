FROM golang:alpine
RUN apk update \
 && apk add jq \
 && apk add curl \
 && rm -rf /var/cache/apk/*
ADD ./ /tmp
CMD ["sh", "/tmp/execute.sh"]

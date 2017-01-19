FROM alpine:3.4

RUN apk add --no-cache curl bash
RUN curl https://raw.githubusercontent.com/campanda/bash-test/master/bash-test > /usr/local/bin/bash-test \
 && chmod +x /usr/local/bin/bash-test

RUN mkdir /tests
WORKDIR /tests

ENTRYPOINT ["/usr/local/bin/bash-test"]

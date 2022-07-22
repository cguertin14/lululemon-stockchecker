# build stage
FROM golang:1.18.4-alpine as builder

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""

ENV CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT}

WORKDIR /app
COPY go.* ./
COPY . ./
RUN go mod download
RUN go build -o ./stockchecker .
RUN addgroup -S stockchecker-group && \
    adduser -S stockchecker-user -G stockchecker-group


# runtime stage
FROM ubuntu:20.04

RUN apt update
RUN apt install wget libfontconfig openssl ca-certificates -y

# Install phantomjs
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar -xvf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN cp ./phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

COPY --from=builder /app/stockchecker /stockchecker
COPY --from=builder /etc/passwd /etc/passwd

USER stockchecker-user

ENTRYPOINT ["/stockchecker"]
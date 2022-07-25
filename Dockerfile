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


# phantomjs stage
FROM gounthar/phantomjs:aarch64 as phantomjs


# runtime stage
FROM ubuntu:20.04

RUN apt update
RUN apt install build-essential ca-certificates libfontconfig libfreetype6 libssl-dev -y

COPY --from=phantomjs /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
COPY --from=builder /app/stockchecker /stockchecker
COPY --from=builder /etc/passwd /etc/passwd

USER stockchecker-user

ENTRYPOINT ["/stockchecker"]
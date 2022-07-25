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
# FROM gounthar/phantomjs:aarch64 as phantomjs


# runtime stage
FROM ubuntu:20.04

RUN apt update
RUN apt install wget libfontconfig openssl ca-certificates -y
RUN apt install -y \
    libc6 libgcc1 libqt5core5a libqt5gui5 libqt5network5 \
    libqt5printsupport5 libqt5webkit5 libqt5widgets5 libstdc++6

# Install phantomjs
# COPY --from=phantomjs /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
RUN wget http://launchpadlibrarian.net/242213138/phantomjs_2.1.1+dfsg-1_arm64.deb
RUN dpkg -i phantomjs_2.1.1+dfsg-1_arm64.deb
COPY --from=builder /app/stockchecker /stockchecker
COPY --from=builder /etc/passwd /etc/passwd

USER stockchecker-user

ENTRYPOINT ["/stockchecker"]
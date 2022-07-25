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


# phantomjs stage
FROM gounthar/phantomjs:aarch64 as phantomjs


# runtime stage
FROM alpine:3.9

RUN apk add --update --no-cache alpine-sdk \
    fontconfig freetype ca-certificates qt5-qtbase-dev \
    g++ gcc icu-dev libpng-dev jpeg openssl-dev sqlite-dev
RUN addgroup -S stockchecker-group && \
    adduser -S stockchecker-user -G stockchecker-group

COPY --from=phantomjs /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
COPY --from=builder /app/stockchecker /stockchecker

USER stockchecker-user

# ENTRYPOINT ["/stockchecker"]
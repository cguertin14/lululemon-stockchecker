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
FROM alpine:3.14

RUN apk add --no-cache --virtual build-dependencies \
        alpine-sdk \
        autoconf \
        bash \
        bison \
        build-base \
        cmake \
        flex \
        fontconfig-dev \
        freetype-dev \
        g++ \
        gcc \
        git \
        gperf \
        qt5-qtwebkit-dev \
        icu-dev \
        libpng-dev \ 
        jpeg \
        make \
        nodejs \
        npm \
        openssl-dev \ 
        protobuf-dev \
        python3 \
        qt5-qtbase-dev \
        ruby \
        sqlite-dev \
        wget

# RUN apk add --update --no-cache alpine-sdk \
#     fontconfig freetype ca-certificates qt5-qtwebkit-dev qt5-qtbase-dev \
#     g++ gcc icu-dev libpng-dev jpeg openssl-dev sqlite-dev
# RUN addgroup -S stockchecker-group && \
#     adduser -S stockchecker-user -G stockchecker-group

COPY --from=phantomjs /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
# RUN phantomjs --version

COPY --from=builder /app/stockchecker /stockchecker

USER stockchecker-user

# ENTRYPOINT ["/stockchecker"]
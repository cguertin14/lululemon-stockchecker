# Step 1 - compile code binary
FROM golang:1.18.4-alpine AS builder

LABEL maintainer="Charles Guertin <charlesguertin@live.ca>"

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ARG BUILD_DATE
ARG VERSION
ARG GIT_COMMIT

ENV CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT} \
    BUILD_DATE=${BUILD_DATE} \
    VERSION=${VERSION} \
    GIT_COMMIT=${GIT_COMMIT}

RUN apk add --no-cache --update ca-certificates make git

WORKDIR /app

COPY go.* ./
RUN go mod download

COPY . ./
RUN go build -o ./lululemon_stockchecker .

# Add user & group
RUN addgroup -S stockchecker-group && \
    adduser -S stockchecker-user -G stockchecker-group


# Step 2 - import necessary files to run program.
FROM scratch

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /app/lululemon_stockchecker /lululemon_stockchecker
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

USER stockchecker-user

ENTRYPOINT ["/lululemon_stockchecker"]

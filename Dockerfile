# build stage
FROM golang:1.19.0-alpine as builder

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


# runtime stage
FROM ubuntu:22.04

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ENV CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT}

COPY --from=builder /app/stockchecker /stockchecker
RUN apt update
RUN apt install --no-install-recommends -y \
     # chromium dependencies
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    libgtk-3-0 \
    libgbm1 \
    ca-certificates \
    # fonts
    fonts-liberation fonts-noto-color-emoji fonts-noto-cjk \
    # timezone
    tzdata \
    # processs reaper
    dumb-init \
    # headful mode support, for example: $ xvfb-run chromium-browser --remote-debugging-port=9222
    xvfb \
    # cleanup
    && rm -rf /var/lib/apt/lists/*


RUN groupadd stockchecker && \
    useradd -r -u 1001 -d /home/stockchecker -g stockchecker stockchecker
RUN mkdir /home/stockchecker
RUN chown -R stockchecker:stockchecker /home/stockchecker
USER stockchecker

ENTRYPOINT ["/stockchecker"]
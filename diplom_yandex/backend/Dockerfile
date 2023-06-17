FROM golang:1.19.3-buster AS build
WORKDIR /app
COPY . .
RUN mkdir -p bin && go build -o bin ./...

FROM busybox:1.34.1 AS wget
RUN wget -P /wget -O wget http://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox_WGET
RUN chmod a+x /wget

FROM gcr.io/distroless/base-debian11
WORKDIR /
COPY --from=build /app/bin/api /api
COPY --from=wget /wget /usr/bin/wget
USER nonroot:nonroot
ENTRYPOINT ["/api"]
EXPOSE 8081

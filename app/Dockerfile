FROM golang:bookworm AS build

WORKDIR /compose/hello-docker
COPY main.go main.go
RUN CGO_ENABLED=0 go build -o hello main.go

#FROM scratch
FROM debian:bookworm
COPY --from=build /compose/hello-docker/hello /usr/local/bin/hello
CMD ["/usr/local/bin/hello"]

# to build an arm64 docker(https://www.docker.com/blog/multi-arch-images/)
#docker buildx build --platform linux/arm64 -t billyangbc/hellodocker:bookworm-arm64 -f Dockerfile . --no-cache
#push to docker.io:
#docker login
#docker build -t <username>/<repo>:<tag> .
#docker push <username>/<repo>:<tag>
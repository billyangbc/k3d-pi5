# Docker Tips

## 1. Docker Desktop is not able to start on ubuntu 24.04
When build docker for multiple architecture on ubuntu, `Docker Desktop` will be needed.
However, when upgrade to ubuntu 24.04, the `Docker Desktop` is not able to start.
Here is a workaround:

```sh
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
systemctl --user restart docker-desktop
```

## 2. Initialize pass issue for `docker login`
```sh
pass remove -rf docker-credential-helpers
#OR    rm -rf ~/.password-store/docker-credential-helpers
gpg --generate-key
gpg --full-gen-key
pass init <generated gpg-id public key>
```

## 3. Build docker image for multiple platform (https://www.docker.com/blog/multi-arch-images/)
```sh
docker buildx build --platform linux/arm64 -t billyangbc/hellodocker:bookworm-arm64 -f Dockerfile . --no-cache
#push to docker.io:
docker login
docker build -t <username>/<repo>:<tag> .
docker push <username>/<repo>:<tag>
```
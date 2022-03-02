# :warning: Julia now builds and distributes official binaries for musl libc, and thus there are now Alpine-based images in the [official docker repo](https://hub.docker.com/_/julia). This repository is therefore archived.:warning: 

# julia-alpine

Building docker images and binaries of [JuliaLang/julia][julia] using Alpine Linux.

Output tarballs with the Julia binary can be downloaded from [GitHub releases][gh]
and the docker images can be found on [Docker Hub][dh].

## Build instructions

To build the image run
```sh
make image VERSION=$(JULIA_TAG)
```
where `JULIA_TAG` is the git tag to build. If `VERSION` is not specified Julia's master
branch will be built. To push the tag to Docker Hub, run:
```sh
make push-image VERSION=$(JULIA_TAG)
```

To build the tarball with the Julia binary, run
```
make binary-dist VERSION=$(JULIA_TAG)
```
which will build and extract the binary to a `build/` directory, together with a sha256sum file.
To push the tarball to GitHub releases, run:
```sh
make push-tarball VERSION=$(JULIA_TAG) BUILD_NUMBER=$(BUILD_NUMBER) GHR_ARGS=$(...)
```

## Status for Julia on musl libc

Julia's test-suite does not fully pass when built with musl libc.
In particular the LibGit2 test suite segfaults for some tests,
see [this issue][issue].

[julia]: https://github.com/JuliaLang/julia
[gh]: https://github.com/fredrikekre/julia-alpine/releases
[dh]: https://hub.docker.com/r/fredrikekre/julia-alpine
[issue]: https://github.com/JuliaLang/julia/issues/28805

# Docker image for the CI of Endless Sky Mission Builder

This repository contains the [Dockerfile](Dockerfile) of the image used in the CI of [Endless Sky Mission Builder](https://github.com/shitwolfymakes/Endless-Sky-Mission-Builder).

The image is pushed automatically to [DockerHub](https://hub.docker.com/r/shitwolfymakes/esmb-ci) and can be used with

```
docker pull shitwolfymakes/esmb-ci:latest
```

## Contents

This toolchain includes:
| Tool | Version |
|---|---|
| GCC | 9.4.0 |
| Clang | 15.0.4-++20221102053248+5c68a1cb1231-1\~exp1\~20221102053256.89 |
| cppcheck | 2.10 dev |
| CMake | 3.23.2 |
| Ninja | 1.10.0 |
| Valgrind | 3.15.0 |
| LCOV | 1.14 |
| gcovr | 5.0 |

The following libraries are also preinstalled:
| Library | Version |
|---|---|
| Boost | 1.71.0 |
| Qt5 | 5.15.2 LTS |
| Qt6 | 6.4 |

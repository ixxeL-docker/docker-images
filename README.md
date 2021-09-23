# Docker-images

[![multi-tools-img-CI](https://github.com/ixxeL-docker/docker-images/actions/workflows/multi-tools-alpine-image.yml/badge.svg)](https://github.com/ixxeL-docker/docker-images/actions/workflows/multi-tools-alpine-image.yml)
[![unit-tests-img-CI](https://github.com/ixxeL-docker/docker-images/actions/workflows/unit-test-alpine.yml/badge.svg)](https://github.com/ixxeL-docker/docker-images/actions/workflows/unit-test-alpine.yml)
[![toolkit-CI](https://github.com/ixxeL-docker/docker-images/actions/workflows/toolkit-image.yml/badge.svg)](https://github.com/ixxeL-docker/docker-images/actions/workflows/toolkit-image.yml)

General repository to store multi purpose Dockerfiles.

Currently storing :
- `multi-tools-alpine` image : Container aiming at providing Ops tools to handle servers and CD actions (kubectl, oc, helm, vault...)
- `unit-tests-alpine` image : Container aiming at providing unit tests tools to handle CI actions (hadolint, pytest, flake8, shellcheck...)
- `toolkit` image : More or less the same as multi-tools-alpine in a different way

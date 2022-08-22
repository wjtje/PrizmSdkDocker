# PrizmSDK Docker Container <!-- omit in toc -->

This is a custom docker container with a cross compiler and libfxcg installed for developing programs for the fx-cg 10/20/50.

## Table of Contents <!-- omit in toc -->

- [Getting the image](#getting-the-image)
- [Development container](#development-container)
- [Buidling the example](#buidling-the-example)
- [License](#license)

## Getting the image

This image can be build locally by running `docker build -t ghcr.io/wjtje/prizmsdkdocker:main .` or you can pull the latest version from github by using this command, `docker pull ghcr.io/wjtje/prizmsdkdocker:main`.

## Development container

This docker image can also be used to create a development container for your own repo. By including the `.devcontainer` and `.vscode` folder inside your own repo.

## Buidling the example

You can build the example by opening the example folder inside the vscode and running the `make` command.

## License

The MIT License (MIT) Copyright (c) 2022 Wouter van der Wal.

The example is Copyright (c) 2014, The libfxcg Project Contributors.

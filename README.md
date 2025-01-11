# Stable Diffusion WebUI + ROCm PyTorch + Docker = ❤️

This repository contains a docker setup for running the [Stable Diffusion WebUI](https://github.com/AUTOMATIC1111/stable-diffusion-webui) inside a ROCm PyTorch Docker environment.

I mostly followed the AMD GPU documentation of Stable Diffusion WebUI, however, I had to make some changes to make it work, which are documented below.

## Prerequisites

As far as I can think of, it's just:

- Docker
- Docker Compose
- ROCm capable AMD GPU

## Changes compared to the original documentation

- Additionally installing google-perftools and libgoogle-perftools-dev to the container for better performance
- Running as a non-root user inside the container
- Setting the `HIP_VISIBLE_DEVICES` environment variable to `0` to make PyTorch work with more AMD GPUs (like the 7900 XTX)
- Setting the SHM size to 8GB, like ROCm PyTorch now suggests
- Additionally installing missing timm and python3.10-venv pip packages
- Running `webui.sh` instead of `launch.py` to start the WebUI

## Usage

After cloning the repository, just run the `start.sh` script. This will do everything for you.

You will see the container's logs. You can close them with CTRL + C. **The container will keep running in the background.**

You can re-attach to the logs using `attach.sh`.

Running the `start.sh` script again will shut down the container, pull/build anything if needed and start it again.

As soon as you can see `Model loaded in X.Xs` in the logs, everything is ready.

The WebUI is reachable on `http://localhost:7860/`. Make sure you're using **http** and not **https**.

To stop the container, run the `stop.sh` script.

## Increase performance

Like documented in the original Stable Diffusion WebUI documentation, you can try to increase performance by dropping the `--precision full` and/or `--no-half` flags from the `bootstrap.sh` script at the very bottom.

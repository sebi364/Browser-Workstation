# Browser-Workstation
[![Build and Deploy](https://github.com/sebi364/Browser-Workstation/actions/workflows/deploy.yml/badge.svg)](https://github.com/sebi364/Browser-Workstation/actions/workflows/deploy.yml)

**About:**
This repo contains a few very simple bash-scripts that allow you to build an alpine-based image for [Fabrice Bellard's jslinux](https://bellard.org/jslinux/tech.html). The script can also be run through GitHub-actions and the resulting VM can be hosted on GitHub-pages for free. The version build by this repo can be found [here](https://sebi364.github.io/Browser-Workstation/).

**Usecase:**
This project can be used to get quick access to a Linux VM in an environment where you might not want to install stuff locally. If you're lucky, and your firewall doesn't block websocket connections by default, you'll even have access to the internet which opens the door for (for example) an SSH connection to a "real" server 😀

## Internet
Thanks to Benjamin Burns [websocksproxy](https://github.com/benjamincburns/websockproxy) The vm is able to connect to the internet. Please note that the relay is limited to 2 connections per IP and 40KB/s to prevent abuse. This repo also includes a copy of websockproxy, where the limitations were lifted, together with a compose file that deploys it + a nginx container to host the Linux vm files in case you want to self-host it.

## Customization:
To further customize the Image, you can edit the [installation script](./build/bin/install).
[![Pre-commit](https://github.com/lek-x/weather_bot_k8s/actions/workflows/pre-commit-config.yaml/badge.svg)](https://github.com/lek-x/weather_bot_k8s/actions/workflows/pre-commit-config.yaml)
[![Deploy](https://github.com/lek-x/weather_bot_k8s/actions/workflows/deploy.yaml/badge.svg)](https://github.com/lek-x/weather_bot_k8s/actions/workflows/deploy.yaml)
[![BackUp](https://github.com/lek-x/weather_bot_k8s/actions/workflows/backup.yaml/badge.svg)](https://github.com/lek-x/weather_bot_k8s/actions/workflows/backup.yaml)



# Telegram Weather bot with CI/CD deploying pipline in k3s/k8s.

## Description:
This repo contains Python code of telegram bot and CI/CD code for deployig in dev/prod environments:

## Bot telegram id [PROD version]

https://t.me/weather_rms_bot


## About App:
It is a python based app Telegram bot

## Features:

- **Free weather API** - bot uses free Open Weather API

- **Weather autosend function** - bot sends  Weather at desired time, uses UTC time zone.


## Requrements:
  - Linux based OS
  - Terraform >= 1.9
  - k3s/k8s
  - Anchore Grype tool
  - Github runner
  - poetry
  - Python > 3.7
  - pip


```mermaid
---
title: Scheme
---
flowchart TD
 subgraph A["GitHuB"]
        B["Repository"]
  end
 subgraph D["k3s/k8s"]
        E["PostgreSQL 15"]
        F["Weather Bot Container"]
  end
 subgraph C["Linux VM"]
    direction TB
        D
            A
  end
    F <-. Storing data .-> E
    D -- Get images --> A
    X["user"] <--> Z
    Z[TelegramBot] <--> F
    O[OpenWeatherAPI] <--> F
```

```mermaid
---
title: CI/CD Logic
---
flowchart LR
    A["Deploy DEV/PROD"] --> B["Build Docker Imageand Push to GHCR.IO"]
    B -.-> DRB["Drop database(Condition)"] & CDR["Cleanup local docker images(Condition)"]
    B --> V["Check Imabeg by Grype"]
    V --> N["Reneder k8s manifests by Terraform"]
    nw["Get secrets from Github Envs"] <--> N
    N --> X["Apply K8s manifests(Condition)"]
    N -.-> DRP["DryRun(Condition)"] & CL["Clean Manifests Files(Condition)"]
    style DRB color:#000000,fill:#FF6D00
    style CDR color:#000000,fill:#FF6D00
    style N fill:#FFFFFF
    style X fill:#2962FF
    style DRP fill:#FF6D00
    style CL fill:#FF6D00
```

## Backup DB
Backup is bening processed by schedule


## Main files:
1. **docker/**
    - Dockerfile - to build app
    - main.py - app core
    - entrypoint.sh - entrypoint for container
    - requiremenets.txt - python packages for app
2. **.github/** - CI/CD workflow
3. **deployment/terraform**
    - templates/*.tpl - manifests templates
    - main.tf - terraform main file
4. **.ci/** - config files for linters


## Quick start:
TBD

## Known bugs and limitations
1. Hourly weather may show the wrong hour, will be fixed in next releases.
2. It is small possibility that bot sends auto message twice, default check interval is 58 seconds.


## License
GNU GPL v3

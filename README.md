# azure-docker-compose-vm-template

[![Test compose](https://github.com/atrakic/azure-docker-compose-vm-template/actions/workflows/test.yml/badge.svg)](https://github.com/atrakic/azure-docker-compose-vm-template/actions/workflows/test.yml)
[![Scan Bicep code](https://github.com/atrakic/azure-docker-compose-vm-template/actions/workflows/audit-bicep.yml/badge.svg)](https://github.com/atrakic/azure-docker-compose-vm-template/actions/workflows/audit-bicep.yml)
[![license](https://img.shields.io/github/license/atrakic/azure-docker-compose-vm-template.svg)](https://github.com/atrakic/azure-docker-compose-vm-template/blob/main/LICENSE)

> A collection of container-based deployment on an Azure virtual machine (VM).

## Features
- Nginx proxy
- Lets encrypt auto provisioning
- Automated image update (using watchtower)
- Monitoring (Grafana/Prometheus)
- SonarQube (code quality)
- Ollama with codellama (for code review, generation, etc.)

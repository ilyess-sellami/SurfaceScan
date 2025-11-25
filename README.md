# SurfaceScan 🛡️

**Cross-platform Incident Surface Scanner for SOC & DFIR teams**  
*Gain complete visibility across Windows · Linux · macOS — ready-to-run scripts, structured output, and integrations for SIEM & incident management.*

[![GitHub stars](https://img.shields.io/github/stars/username/SurfaceScan?style=social)](https://github.com/username/SurfaceScan/stargazers)
[![Issues](https://img.shields.io/github/issues/username/SurfaceScan)](https://github.com/username/SurfaceScan/issues)
[![License](https://img.shields.io/github/license/username/SurfaceScan)](./LICENSE)
[![CI](https://img.shields.io/badge/CI-none-lightgrey)](#) <!-- Replace with real CI badge -->
[![Downloads](https://img.shields.io/github/downloads/username/SurfaceScan/total)](#)

---

<!-- Banner (replace the placeholder with your generated banner image) -->
<p align="center">
  <img src="docs/banner.png" alt="SurfaceScan banner" width="100%" />
</p>

---

## Table of Contents

- [About SurfaceScan](#about-surfacescan)
- [Why SurfaceScan?](#why-surfacescan)
- [Features](#features)
- [Supported Platforms](#supported-platforms)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage Examples](#usage-examples)
- [Script Functions (Blueprint)](#script-functions-blueprint)
- [Output Format & Dashboard](#output-format--dashboard)
- [Integrations](#integrations)
- [Security & Safety](#security--safety)
- [Contributing](#contributing)
- [Roadmap](#roadmap)
- [Maintainers & Acknowledgements](#maintainers--acknowledgements)
- [License](#license)

---

## About SurfaceScan

**SurfaceScan** is a professional, open-source **incident surface scanner** designed for SOC analysts, DFIR teams, and security engineers.  
It provides ready-to-run, modular scripts for **Windows (PowerShell)**, **Linux (Bash)**, and **macOS (Bash/zsh)** to collect telemetry, configuration, and state information from endpoints. Outputs are normalized to JSON/CSV for ingestion into SIEMs, incident management platforms (TheHive, FIR), or internal dashboards.

**Keywords:** incident surface, SOC, DFIR, incident response, endpoint monitoring, attack surface mapping, cross-platform, PowerShell, Bash, Python.

---

## Why SurfaceScan?

- Centralize endpoint discovery data to map your organization’s attack surface.
- Speed up triage: run scripts quickly to collect the evidence analysts need.
- Standardized outputs (JSON/CSV) for automation and integration.
- Modular and extensible — add scripts for cloud, network devices, or IoT easily.
- Safe, non-destructive collection that’s auditable and reproducible.

---

## Features

- ✅ Cross-platform: Windows, Linux, macOS  
- ✅ Standalone, ready-to-run scripts for fast data collection  
- ✅ Structured JSON/CSV outputs (SIEM & automation friendly)  
- ✅ Aggregation tools to merge multi-host results into a single map  
- ✅ Optional HTML/Python dashboard for visualization  
- ✅ Extensible plugin model for cloud and network asset scanners  
- ✅ Non-destructive and built for safe SOC/DFIR usage

---

## Supported Platforms

- Windows 10 / 11 / Server 2016+ (PowerShell 5.1+ / PowerShell 7+)  
- Linux (Debian, Ubuntu, CentOS, RHEL, others)  
- macOS 10.15+ (Catalina+)  

---

## Quick Start

#### 1) Clone the repo
```bash
git clone https://github.com/username/SurfaceScan.git
cd SurfaceScan
```

#### 2) (Optional) Create a Python virtual environment for tools
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

#### 3) Run an example script (Linux example)
```bash
 ./scripts/linux/list_users_groups.sh > output/linux-users-$(hostname).json
```

#### 4) Aggregate collected outputs
python tools/aggregate_data.py --input outputs/ --output aggregated/incident-surface.json

# 5) Launch the dashboard (optional)
python tools/visualize_data.py aggregated/incident-surface.json
```

---



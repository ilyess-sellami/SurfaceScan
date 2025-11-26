# SurfaceScan 🛡️

**Cross-platform Incident Surface Scanner for SOC & DFIR teams**  
*Gain complete visibility across ***Windows*** · ***Linux*** · ***macOS*** — ready-to-run scripts, structured output.*

---

<p align="center">
  <img src="docs/banner.png" alt="SurfaceScan banner" width="100%" height="100%" />
</p>

---

## Table of Contents

- [About SurfaceScan](#about-surfacescan)
- [Why SurfaceScan?](#why-surfacescan)
- [Features](#features)
- [Supported Platforms](#supported-platforms)
- [Quick Start](#quick-start)
- [Usage Examples](#usage-examples)
- [Script Functions (Blueprint)](#script-functions-blueprint)
- [Output Format & Dashboard](#output-format--dashboard)
- [Security & Safety](#security--safety)
- [Contributing](#contributing)
- [License](#license)

---

## About SurfaceScan

**SurfaceScan** is a professional, open-source **incident surface scanner** designed for SOC analysts, DFIR teams, and security engineers.  
It provides ready-to-run, modular scripts for **Windows (PowerShell)**, **Linux (Bash)**, and **macOS (Bash/zsh)** to collect telemetry, configuration, and state information from endpoints. Outputs are normalized to JSON for ingestion into SIEMs, incident management platforms (TheHive, FIR), or internal dashboards.

**Keywords:** incident surface, SOC, DFIR, incident response, endpoint monitoring, attack surface mapping, cross-platform, PowerShell, Bash, Python.

---

## Why SurfaceScan?

- Centralize endpoint discovery data to map your organization’s attack surface.
- Speed up triage: run scripts quickly to collect the evidence analysts need.
- Standardized outputs (JSON) for automation and integration.
- Modular and extensible — add scripts for cloud, network devices, or IoT easily.
- Safe, non-destructive collection that’s auditable and reproducible.

---

## Features

- ✅ Cross-platform: Windows, Linux, macOS  
- ✅ Standalone, ready-to-run scripts for fast data collection  
- ✅ Structured JSON outputs (SIEM & automation friendly)  
- ✅ Aggregation tools to merge multi-host results into a single map  
- ✅ Optional HTML dashboard for visualization  
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
git clone https://github.com/ilyess-sellami/SurfaceScan.git
cd SurfaceScan
```

#### 2) Create a Python virtual environment for tools

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

```bash
python tools/aggregate_data.py --input outputs/ --output aggregated/incident-surface.json
```

#### 5) Launch the dashboard (optional)

```bash
python tools/visualize_data.py aggregated/incident-surface.json
```

---

## Usage Examples

#### Windows (PowerShell)

Open an elevated PowerShell prompt to run scripts that **require admin privileges**:

```bash
# Collect basic system info and users
.\scripts\windows\get_system_info.ps1 -OutputPath .\outputs\windows-hostname-system.json
.\scripts\windows\list_users_groups.ps1 -OutputPath .\outputs\windows-hostname-users.json
```

#### Linux / macOS (Bash)

```bash
# Make sure script has execute permissions
chmod +x ./scripts/linux/list_processes.sh
./scripts/linux/list_processes.sh > outputs/linux-hostname-processes.json
```

---

## Script Functions (Blueprint)

<p align="center">
  <img src="docs/available-scripts.png" alt="Available Scripts" width="100%" height="100%" />
</p>

---

## Output Format & Dashboard

#### Standardized JSON schema (example snippet):

```json
{
  "host": "host-01",
  "os": "Ubuntu 22.04",
  "collected_at": "2025-11-25T12:00:00Z",
  "system": {...},
  "users": [...],
  "processes": [...],
  "services": [...],
  "network": {...},
  "logs": {...}
}
```

---

## Security & Safety

- **Non-destructive by design:** All collection scripts are read-only unless explicitly documented.
- **Privileged operations:** Some scripts require admin/root rights. Always run under controlled conditions and obtain appropriate authorization.
- **Data sensitivity:** Collected outputs may contain sensitive data — store and transfer outputs securely (encrypted at rest/in transit).
- **Auditability:** Scripts log run metadata (who ran, when, arguments) for audit trails.

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/<feature-name>`.
3. Add tests and documentation for new scripts.
4. Run linting and unit checks.
5. Open a Pull Request with a clear description and test results.

---

## License

Licensed under the **MIT License** — see [LICENSE](LICENSE) for details.
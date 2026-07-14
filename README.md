# Enhanced Winget Daemon

A lightweight, autonomous background daemon for Windows that keeps your package managers (Winget, Scoop) in sync without user intervention. Built with a fast Rust core, Python backend, and a modern web dashboard.

## Overview

Enhanced Winget is designed to replace manual updates with a silent, invisible background tracking system. No popups. No annoying CLI checks. It learns and updates your local toolchain autonomously using a minimal memory footprint.

### Features
- **Silent Tracking**: Background package updates. Zero pop-ups.
- **Rust Core**: A blazing fast native Windows service via WMI.
- **All Frameworks**: Natively tracks Winget, Scoop, Chocolatey, Python, and Rust binaries.

## Installation

Run this one-liner in an elevated (Administrator) PowerShell window. This will bootstrap the environment, start the local daemon, and register the background service.

```powershell
powershell -c "Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest -Uri https://raw.githubusercontent.com/PTejasKr/enhanced-winget/master/setup-all.ps1 -OutFile setup-all.ps1; .\setup-all.ps1"
```

## Architecture

- **Daemon**: Rust-based background service checking for drift.
- **Backend**: Python FastAPI providing local endpoints for state management.
- **Frontend**: React + Vite UI dashboard for visual monitoring.
- **Installer**: Automated PowerShell script for seamless deployment.

## Development

To run the local stack manually:

```bash
# Start backend
cd backend
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt
python main.py

# Start frontend
cd frontend
npm install
npm run dev
```

## License

MIT License. Open Source.

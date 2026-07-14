<div align="center">

# Enhanced Winget Daemon

<img src="https://raw.githubusercontent.com/PTejasKr/enhanced-winget/master/frontend/src/assets/hero-art.jpg" alt="Enhanced Winget Header" width="100%" />

**A robust, autonomous package management daemon for Windows.**
<br />
*Keep Winget, Scoop, Chocolatey, Python, and Rust binaries in perfect sync without user intervention.*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Windows](https://img.shields.io/badge/OS-Windows-blue?logo=windows)](#)
[![Rust](https://img.shields.io/badge/Core-Rust-orange?logo=rust)](#)
[![React](https://img.shields.io/badge/UI-React-61DAFB?logo=react)](#)

</div>

---

## 📖 Table of Contents
- [Overview](#-overview)
- [Key Features](#-key-features)
- [Installation](#-installation)
- [Dashboard & UI](#-dashboard--ui)
- [Architecture](#-architecture)
- [Development Setup](#-development-setup)
- [Contributing](#-contributing)
- [License](#-license)

---

## ⚡ Overview

**Enhanced Winget** is designed to replace manual Windows toolchain updates with a silent, invisible background tracking system. No pop-ups, no annoying CLI prompts, and no manual checks. The daemon learns your system environment and updates your local toolchain autonomously using a minimal memory footprint.

Whether you rely on `winget`, `scoop`, or even language-specific package managers like `pip` and `cargo`, the daemon ensures your environment is always up to date and secure.

---

## ✨ Key Features

- **Silent Autonomous Tracking**: The daemon tracks package updates in the background. No manual intervention required.
- **Blazing Fast Rust Core**: Built on a highly optimized native Windows service leveraging WMI to intelligently schedule updates.
- **Universal Framework Support**: Native support for Winget, Scoop, Chocolatey, Python, and Rust binaries.
- **Beautiful Web Dashboard**: A modern, sleek Web UI to monitor update logs, drift, and system health in real time.

---

## 🚀 Installation

The entire stack is designed for a frictionless, single-command installation.

Run the following command in an **elevated (Administrator) PowerShell** window:

```powershell
powershell -c "Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest -Uri https://raw.githubusercontent.com/PTejasKr/enhanced-winget/master/setup-all.ps1 -OutFile setup-all.ps1; .\setup-all.ps1"
```

### What does this do?
1. Checks for required dependencies (Python, Node, Rust).
2. Initializes the backend and installs Python requirements.
3. Builds the frontend dashboard.
4. Registers the background task scheduling daemon.

---

## 🖥️ Dashboard & UI

Monitor the daemon's activity, package drift, and update history via the local web dashboard.

<div align="center">
  <img src="https://raw.githubusercontent.com/PTejasKr/enhanced-winget/master/frontend/src/assets/feature_tracking.jpg" alt="Dashboard UI Screenshot" width="80%" style="border-radius: 8px;" />
</div>

> *The UI features a deep berry and caramel brutalist aesthetic, focusing purely on system metrics and rapid actions.*

---

## 🏗️ Architecture

Enhanced Winget is split into decoupled micro-components to ensure maximum stability and minimal overhead:

- **Core Daemon**: Rust-based background service checking for toolchain drift.
- **Backend API**: Python (FastAPI) providing local endpoints for state management and logging.
- **Frontend UI**: React + Vite dashboard for visual monitoring.
- **Bootstrapper**: Automated PowerShell script for seamless deployment.

---

## 🛠️ Development Setup

Want to contribute or run the stack manually for debugging? 

### 1. Start the Backend API
```bash
cd backend
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt
python main.py
```

### 2. Start the Frontend Dashboard
```bash
cd frontend
npm install
npm run dev
```
The dashboard will be available at `http://localhost:5173`.

---

## 🤝 Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

<div align="center">
  <sub>Built with ❤️ by Tejas.</sub>
</div>

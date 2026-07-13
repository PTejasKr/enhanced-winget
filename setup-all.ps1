# Ew Single-Command Master Setup Script
# This script bootstraps the entire Python/Rust environment and starts the services.

Write-Host "Starting Ew Master Installation..." -ForegroundColor Cyan

# 1. Admin Privilege Check (Required for Services and Chocolatey)
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Administrator privileges required. Relaunching as Admin..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
Write-Host "[x] Admin privileges verified." -ForegroundColor Green
$ProjectRoot = $PSScriptRoot

# 2. Package Managers (Scoop & Chocolatey)
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "[-] Installing Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    $env:PATH += ";$HOME\scoop\shims"
}
Write-Host "[x] Scoop is ready." -ForegroundColor Green

if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "[-] Installing Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    $env:PATH += ";$env:ALLUSERSPROFILE\chocolatey\bin"
}
Write-Host "[x] Chocolatey is ready." -ForegroundColor Green

# 3. Python Backend Setup
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "[-] Python not found. Installing via Winget..." -ForegroundColor Yellow
    winget install Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements
    $env:PATH += ";C:\Program Files\Python312\Scripts\;C:\Program Files\Python312\"
}
Write-Host "[x] Python is ready." -ForegroundColor Green

Write-Host "[-] Installing Python backend dependencies..." -ForegroundColor Yellow
cd "$ProjectRoot\backend"
pip install -r requirements.txt
Write-Host "[x] Python dependencies installed." -ForegroundColor Green

# 4. Rust Stack Setup
if (!(Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Host "[-] Cargo (Rust) not found. Installing via rustup..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri https://win.rustup.rs/x86_64 -OutFile "$env:TEMP\rustup-init.exe"
    Start-Process -FilePath "$env:TEMP\rustup-init.exe" -ArgumentList "-y" -Wait -NoNewWindow
    $env:PATH += ";$HOME\.cargo\bin"
}
Write-Host "[x] Rust/Cargo is ready." -ForegroundColor Green

# 5. Compile Rust Daemon
Write-Host "[-] Compiling local daemon..." -ForegroundColor Yellow
cd "$ProjectRoot\daemon"
cargo build --release
if ($LASTEXITCODE -ne 0) {
    Write-Error "Cargo build failed. Exiting."
    exit
}
Write-Host "[x] Local Daemon compiled." -ForegroundColor Green

# 6. Service Registration
$InstallDir = "C:\Program Files\EwDaemon"
if (-Not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
}

$ExeSrc = "$ProjectRoot\daemon\target\release\daemon.exe"
$ExeDest = Join-Path $InstallDir "ew-daemon.exe"
Copy-Item -Path $ExeSrc -Destination $ExeDest -Force

$ServiceName = "EwUpdateService"
if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    Stop-Service -Name $ServiceName -Force
    # Need to give it a second to stop before modifying
    Start-Sleep -Seconds 2
} else {
    New-Service -Name $ServiceName -BinaryPathName $ExeDest -DisplayName "Ew AI Update Service" -Description "Zero-Touch Terminal Installer Daemon" -StartupType Automatic
}
Start-Service -Name $ServiceName
Write-Host "[x] Windows Service registered and started." -ForegroundColor Green

# 7. Boot the Cloud Brain
Write-Host "[-] Starting FastAPI Cloud Brain in the background..." -ForegroundColor Yellow
cd "$ProjectRoot\backend"
# Start the uvicorn server in a separate hidden powershell window
Start-Process powershell.exe -WindowStyle Hidden -ArgumentList "-Command `"cd '$ProjectRoot\backend'; uvicorn main:app --host 0.0.0.0 --port 8000`""
Write-Host "[x] Cloud Brain is running." -ForegroundColor Green

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "SUCCESS: The Ew stack has been completely installed and started!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

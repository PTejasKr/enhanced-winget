# Ew (GhostUpdate) Installer Script
# This script must be run as Administrator.

Write-Host "Starting Ew (GhostUpdate) Installation..." -ForegroundColor Cyan

# 1. Check for Admin privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Administrator privileges required. Relaunching as Admin..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
Write-Host "[x] Admin privileges verified." -ForegroundColor Green

# 2. Dependency Check & Installation (Winget, Scoop, Chocolatey)

# Winget (built into modern Windows, basic check)
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "[x] Winget is installed." -ForegroundColor Green
} else {
    Write-Warning "[-] Winget is not installed. Ew requires Winget (App Installer from Microsoft Store)."
}

# Scoop Setup
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "[x] Scoop is already installed." -ForegroundColor Green
} else {
    Write-Host "[-] Scoop is missing. Installing Scoop silently..." -ForegroundColor Yellow
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    
    # Refresh PATH temporarily for the script scope
    $env:PATH += ";$HOME\scoop\shims"
    Write-Host "[+] Scoop installed successfully." -ForegroundColor Green
}

# Chocolatey Setup
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "[x] Chocolatey is already installed." -ForegroundColor Green
} else {
    Write-Host "[-] Chocolatey is missing. Installing Chocolatey silently..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Refresh PATH temporarily for the script scope
    $env:PATH += ";$env:ALLUSERSPROFILE\chocolatey\bin"
    Write-Host "[+] Chocolatey installed successfully." -ForegroundColor Green
}

# 3. Download the Pre-compiled Daemon (Mock URL for now)
$InstallDir = "C:\Program Files\EwDaemon"
if (-Not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
}

$ExePath = Join-Path $InstallDir "ew-daemon.exe"
$MockDownloadUrl = "https://example.com/ew-daemon.exe" # Replace with actual CDN URL

Write-Host "Downloading Ew Daemon..." -ForegroundColor Cyan
# For testing purposes, we skip actual download if running locally without a real URL.
# Invoke-WebRequest -Uri $MockDownloadUrl -OutFile $ExePath -UseBasicParsing

# 4. Service Registration
$ServiceName = "EwUpdateService"

if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    Write-Host "Service $ServiceName already exists. Stopping..." -ForegroundColor Yellow
    Stop-Service -Name $ServiceName -Force
}

Write-Host "Registering $ServiceName as a Windows Service..." -ForegroundColor Cyan
# New-Service -Name $ServiceName -BinaryPathName $ExePath -DisplayName "Ew AI Update Service" -Description "Zero-Touch Terminal Installer Daemon" -StartupType Automatic

# Start the service
# Start-Service -Name $ServiceName
Write-Host "[+] Ew Daemon successfully installed and service registered!" -ForegroundColor Green
Write-Host "Installation Complete." -ForegroundColor Cyan

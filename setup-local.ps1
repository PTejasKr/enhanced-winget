# Local Setup Script for Ew dependencies
Write-Host "Checking for Scoop..." -ForegroundColor Cyan
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "Scoop is already installed." -ForegroundColor Green
} else {
    Write-Host "Installing Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
}

Write-Host "Checking for Chocolatey..." -ForegroundColor Cyan
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey is already installed." -ForegroundColor Green
} else {
    Write-Host "Chocolatey requires Administrator privileges to install. Please run this script as Admin if you want to install Chocolatey." -ForegroundColor Yellow
    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
}
Write-Host "Setup finished." -ForegroundColor Green

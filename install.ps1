# Requires PowerShell run as Administrator

Write-Host "==> Checking for Python, Git, and curl (via Chocolatey)..."
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "==> Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

choco install -y python git curl

Write-Host "==> Checking for uv..."
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "==> Installing uv..."
    powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
    if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
        Write-Host "!! Error: Failed to install uv. Please install manually and rerun."
        exit 1
    }
}

# Remove existing broken or partial ktts-cli folder if it exists and is not a git repo
if (Test-Path "ktts-cli") {
    if (-not (Test-Path "ktts-cli\.git")) {
        Write-Host "==> Removing incomplete ktts-cli directory..."
        Remove-Item -Recurse -Force ktts-cli
    }
}

# Clone or update repo
if (Test-Path "ktts-cli") {
    Write-Host "==> Directory ktts-cli exists. Pulling latest changes..."
    Set-Location ktts-cli
    git pull
} else {
    Write-Host "==> Cloning ktts-cli repository..."
    git clone https://github.com/pro402/ktts-cli.git
    Set-Location ktts-cli
}

# Check for pyproject.toml
if (-not (Test-Path "pyproject.toml")) {
    Write-Host "!! Error: pyproject.toml not found in ktts-cli directory. Aborting."
    exit 1
}

Write-Host "==> Creating virtual environment..."
python -m venv .venv
. .venv\Scripts\Activate.ps1

Write-Host "==> Upgrading pip..."
python -m pip install --upgrade pip

Write-Host "==> Installing dependencies with uv..."
uv pip install kokoro soundfile numpy

Write-Host "==> Installing CLI tool in editable mode with uv..."
uv pip install -e .

# Add .venv\Scripts to user PATH if not already present
$venvScripts = (Resolve-Path .venv\Scripts).Path
$oldPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if ($oldPath -notlike "*$venvScripts*") {
    [Environment]::SetEnvironmentVariable("Path", "$oldPath;$venvScripts", [EnvironmentVariableTarget]::User)
    Write-Host "==> Added $venvScripts to user PATH."
}

Write-Host "`n==> Installation complete! Please open a NEW terminal and run:"
Write-Host "    ktts-cli --help"

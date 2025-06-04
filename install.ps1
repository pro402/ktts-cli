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
    # Use explicit bypass for UV install
    powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
    
    # Verify UV installation
    if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
        Write-Host "!! Error: Failed to install uv. Please install manually and rerun."
        exit 1
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

Write-Host "==> Installation complete! Please open a NEW terminal and run:"
Write-Host "    ktts-cli --help"

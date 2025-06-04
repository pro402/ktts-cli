#!/bin/bash
set -e

echo "==> Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y python3 python3-venv curl git

echo "==> Installing uv (modern Python package manager)..."
if ! command -v uv &> /dev/null; then
    curl -LsS https://astral.sh/uv/install.sh | sudo sh
fi

if [ -d "ktts-cli" ]; then
    echo "==> Directory ktts-cli already exists. Using existing directory."
    cd ktts-cli
else
    echo "==> Cloning the ktts-cli repository..."
    git clone https://github.com/pro402/ktts-cli.git
    cd ktts-cli
fi

echo "==> Creating virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

echo "==> Installing necessary dependencies with uv..."
uv pip install kokoro soundfile numpy

echo "==> Installing the CLI tool in editable mode with uv..."
uv pip install -e .

echo "==> Linking the CLI tool to /usr/local/bin..."
sudo ln -sf "$(pwd)/.venv/bin/ktts-cli" /usr/local/bin/ktts-cli

echo "==> Installation complete! Try running:"
echo "    ktts-cli --help"
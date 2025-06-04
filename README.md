# ktts-cli

**ktts-cli** is a command-line interface for generating high-quality speech audio from text using [Kokoro TTS](https://github.com/hexgrad/kokoro). It supports multiple voices, languages, batch processing, and customizable output—all running locally on your machine.

---

## Features

- **Text-to-Speech**: Convert text or text files to spoken audio.
- **Multiple Voices & Languages**: Choose from a catalog of voices and languages.
- **Batch Processing**: Split and process large texts in chunks.
- **Custom Output**: Set output filename, format, voice, language, and speed.
- **Runs Locally**: No cloud or internet required after setup.

---

## Installation

### **Linux (Ubuntu/Debian)**

Open a terminal and run:

```bash
curl -sSL https://raw.githubusercontent.com/pro402/ktts-cli/main/install.sh | bash
```

This script will:
- Install Python, git, curl, and uv if missing
- Clone this repository
- Set up a virtual environment
- Install all required dependencies (CPU-only PyTorch, Kokoro, etc.)
- Make `ktts-cli` available globally

---

### **Windows**

Open **PowerShell as Administrator** and run:

```powershell
irm https://raw.githubusercontent.com/pro402/ktts-cli/main/install.ps1 | iex
```

This script will:
- Install Python, git, curl, and uv if missing
- Clone this repository
- Set up a virtual environment
- Install all required dependencies (CPU-only PyTorch, Kokoro, etc.)
- Add `ktts-cli` to your PATH

---

## Usage

### **Show Help**

```bash
ktts-cli --help
```

### **Examples**

- **Direct text input:**
  ```bash
  ktts-cli -a -n greeting.wav -v af_sarah
  # Enter your text when prompted
  ```

- **Convert a text file:**
  ```bash
  ktts-cli -o input.txt -n output.mp3 -v am_heroic
  ```

- **Batch process a large text file (split every 5000 chars):**
  ```bash
  ktts-cli -b 5000 -o novel.txt -n chapter_
  ```

---

## Command-Line Options

| Option                | Description                                                                                 |
|-----------------------|---------------------------------------------------------------------------------------------|
| `-a, --all-at-once`   | Process all text at once (from prompt or file)                                              |
| `-b, --batch N`       | Process in batches of N characters                                                          |
| `-o, --open-file`     | Path to input text file                                                                     |
| `-n, --name`          | Output file name (default: `output.mp3`)                                                    |
| `-v, --voice`         | Voice selection (see below)                                                                 |
| `-l, --lang`          | Language code (see below)                                                                   |
| `-s, --speed`         | Speech speed (default: `1.0`)                                                               |

---

## Voices

- `af_heart`   – African English (Heartfelt)
- `am_heroic`  – American English (Heroic)
- `af_sarah`   – African English (Sarah)
- `am_casual`  – American English (Casual)

## Languages

- `a` – American English
- `b` – British English
- `hi` – Hindi

---

## Uninstallation

### **Linux**

1. **Remove the global symlink:**
   ```bash
   sudo rm /usr/local/bin/ktts-cli
   ```

2. **Delete the project directory (and virtual environment):**
   ```bash
   cd ~
   rm -rf ktts-cli
   ```

3. *(Optional)* **Remove uv if you installed it just for this:**
   ```bash
   sudo rm /usr/local/bin/uv
   ```

---

### **Windows**

1. **Remove the project directory:**
   - Open PowerShell and run:
     ```powershell
     Remove-Item -Recurse -Force "$HOME\ktts-cli"
     ```

2. **Remove the CLI from your PATH:**
   - Open System Properties > Environment Variables, and remove the `.venv\Scripts` path under User variables for PATH.
   - Or, run this in PowerShell:
     ```powershell
     $venvScripts = "$HOME\ktts-cli\.venv\Scripts"
     $env:Path = ($env:Path -split ';' | Where-Object { $_ -ne $venvScripts }) -join ';'
     [Environment]::SetEnvironmentVariable("Path", $env:Path, [EnvironmentVariableTarget]::User)
     ```

3. *(Optional)* **Uninstall uv (if you installed it just for this):**
   ```powershell
   Remove-Item -Force -Path "$HOME\.cargo\bin\uv.exe"
   ```

---

## Troubleshooting

- **Permission errors:** Make sure to run PowerShell as Administrator on Windows, and use `sudo` on Linux when needed.
- **Command not found:** Open a new terminal after installation, or ensure your PATH is updated.
- **Large dependencies:** PyTorch and Kokoro require significant disk space and RAM.
- **Other issues:** Open an issue on [GitHub](https://github.com/pro402/ktts-cli/issues).

---

## License

[MIT License](LICENSE)

---

## Credits

- [Kokoro TTS](https://github.com/hexgrad/kokoro)
- [soundfile](https://pysoundfile.readthedocs.io/)
- [uv](https://github.com/astral-sh/uv)

---

**Happy synthesizing!**  
For questions or contributions, open an issue or pull request on GitHub.
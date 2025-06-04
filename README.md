Certainly! Here’s a professional and user-friendly **README.md** for your Kokoro TTS CLI project.

---

# Kokoro TTS CLI

**Kokoro TTS CLI** is a command-line tool for generating high-quality speech audio files from text using [Kokoro TTS](https://github.com/hexgrad/kokoro). It supports flexible input methods, multiple voices, languages, and batch processing, and runs locally on your machine.

---

## Features

- **Text-to-Speech**: Convert text files or direct input to speech audio.
- **Multiple Voices & Languages**: Choose from a catalog of voices and languages.
- **Batch Processing**: Split and process large texts in manageable chunks.
- **Customizable Output**: Set audio file name, format (mp3/wav), voice, language, and speech speed.
- **Works Locally**: No cloud or internet required after setup.

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/ktts-cli.git
cd ktts-cli
```

### 2. Set Up Environment with [uv](https://github.com/astral-sh/uv)

```bash
uv init -p 3.10
uv add kokoro soundfile pip
```

### 3. Install the CLI in Editable Mode

```bash
uv pip install -e .
```

---

## Usage

### Basic Help

```bash
ktts-cli --help
```

### Example Commands

**Convert direct input to audio:**
```bash
ktts-cli -a -n greeting.wav -v af_sarah
# Enter text at the prompt, then press Enter
```

**Convert a text file:**
```bash
ktts-cli -o input.txt -n output.mp3 -v am_heroic
```

**Batch process a large text file (split every 5000 chars):**
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

## Output Formats

- Output is saved as `.mp3` or `.wav` depending on the file extension you specify.

---

## Troubleshooting

- **Large dependencies**: PyTorch and Kokoro require significant disk space and RAM.
- **No module named pip**: Run `uv pip install pip` to add pip to your environment.
- **CUDA/GPU errors**: Use CPU-only PyTorch if you do not have a compatible GPU.
- **Warnings**: Some PyTorch warnings are harmless and can be ignored.

---

## Development

- To modify the CLI, edit `main.py` (or your main script).
- For packaging, adjust `pyproject.toml` as needed.
- To rebuild after changes:  
  ```bash
  uv pip install -e .
  ```

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

---

Let me know if you want to add Docker usage, more troubleshooting, or anything else!
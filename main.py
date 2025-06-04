#!/usr/bin/env python
import warnings
import argparse
from pathlib import Path
from kokoro import KPipeline
import soundfile as sf
import sys
import numpy as np

# Suppress PyTorch warnings
warnings.filterwarnings('ignore', category=UserWarning, module='torch.nn.modules.rnn')
warnings.filterwarnings('ignore', category=FutureWarning, module='torch.nn.utils.weight_norm')

VOICE_OPTIONS = """
Available voices:
  af_heart     - African English (Heartfelt)
  am_heroic    - American English (Heroic)
  af_sarah     - African English (Sarah)
  am_casual    - American English (Casual)
"""

LANGUAGE_OPTIONS = """
Available languages:
  a            - American English
  b            - British English
  hi           - Hindi
"""

def main():
    parser = argparse.ArgumentParser(
        description='Kokoro TTS CLI: Text-to-Speech audio generator',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    
    # Input modes (updated with -t and -f)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-a', '--all-at-once', action='store_true', 
                      help='Process all text at once')
    group.add_argument('-b', '--batch', type=int,
                      help='Process in batches of N characters')
    group.add_argument('-f', '--file', type=Path,
                      help='Path to text file')
    group.add_argument('-t', '--text', type=str,
                      help='Input text directly')
    
    # Output options
    parser.add_argument('-n', '--name', type=Path, default='output.mp3',
                       help='Output file name (default: output.mp3)')
    parser.add_argument('-v', '--voice', default='af_heart',
                       help=f'Voice selection\n{VOICE_OPTIONS}')
    parser.add_argument('-l', '--lang', default='a',
                       help=f'Language code\n{LANGUAGE_OPTIONS}')
    parser.add_argument('-s', '--speed', type=float, default=1.0,
                       help='Speech speed (default: 1.0)')
    
    args = parser.parse_args()
    
    # Handle input
    if args.text:
        text = args.text
    elif args.file:
        text = args.file.read_text()
    else:
        text = sys.stdin.read() if not sys.stdin.isatty() else input("Enter text: ")
    
    # Initialize pipeline with CPU support
    pipeline = KPipeline(lang_code=args.lang, repo_id='hexgrad/Kokoro-82M')
    
    # Generate and process audio
    audio_chunks = []
    for i, (_, _, audio) in enumerate(pipeline(
        text,
        voice=args.voice,
        speed=args.speed,
        split_pattern='\n+' if args.batch else None
    )):
        audio_np = audio.cpu().numpy()
        if args.batch:
            chunk_name = f"{args.name.stem}_part{i}{args.name.suffix}"
            sf.write(chunk_name, audio_np, 24000)
            print(f"Saved batch {i} as {chunk_name}")
        audio_chunks.append(audio_np)
    
    if not args.batch:
        sf.write(args.name, np.concatenate(audio_chunks), 24000)
        print(f"Audio saved as {args.name}")

if __name__ == '__main__':
    main()
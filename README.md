# SCDA recomp 4x texture pack

[Download the pack and optional setup script](https://github.com/OneShot95/SCDA-recomp-4x-texture-pack/releases/tag/v0.1.0-preview).

I created this for my own private use. The texture pack is fully AI upscaled, and I have no coding experience.

4x AI texture upscale preview for Splinter Cell Double Agent v2 recomp.

## Choose your setup method

### Option 1: Manual ZIP downloads
Download **SCDA-4x-HD-base.zip** and **all five numbered texture ZIPs** from this release. Extract every ZIP into the **same folder**, merging the `textures` folder. You do not need to run the optional setup script.

### Option 2: Optional automatic setup (Windows)
Download **Install-SCDA-texture-pack.cmd** into a new empty folder and double-click it. It downloads all six ZIPs, verifies their SHA-256 checksums, and extracts everything into one `SCDA` folder beside the script. It also reuses matching ZIPs already in that folder. Allow at least **18 GB free space** for downloads and extraction.

The `.cmd` file is plain text: you can inspect its contents before running it. It does not require administrator rights, install extra software, or launch the game. It stops if a `SCDA` folder already exists. Automated checks cover download, checksum rejection, extraction and existing-folder protection using PowerShell on macOS; the Windows double-click launcher has not been device-tested.

### After either method
Put your own **original Xbox Double Agent ISO** into the game folder's `assets` folder, then run `SCDA.exe`. Keep both executable filenames unchanged for mission loading. F10 opens settings; choose 3840x2160 for a 4K display if desired.

No Python, AI model or texture processing is needed to play. No game ISO is included.

## Contents
4x environment replacements; higher-resolution HUD/icons and original font outlines.
Presentation art is 3840x2880, preserving its original 4:3 aspect ratio.
Its extra size above the AI 4x output is a conventional resize.
The UI layout and font glyph positions remain original.
Normal maps and masks use separate processing; numeric lookup textures stay original.

## Preview status
Preview: Iceland was visually tested and prison activation was confirmed in logs.
Whole-game coverage is incomplete. Unsupported/ambiguous textures use originals.
Some loading screens are modified by the game and may retain original resolution.
Versus coverage is partial and has not been visually verified.
No ROM, saves or personal settings are included.

## Credits
SCDA-XBERecomp by TGP482 and Joshhhuaaa (MIT; see LICENSE.txt).
Colour texture processing: local Real-ESRGAN by Xintao Wang and contributors.
DDS conversion: Microsoft DirectXTex. These processing tools are not bundled.
Original game artwork belongs to its respective owners.

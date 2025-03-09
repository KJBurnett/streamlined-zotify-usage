# Streamlined Zotify Installation and Usage Guide

## Notes
Zotify is a great tool for downloading music that is unavailable elsewhere, however the documentation leaves much to be desired. This is a streamlined and smoothed approach to get you up and running in less than 5 minutes.
I created a script to automate this entire manula process described below for Windows machines, but it has not been stress tested. It "worked on my machine", **use at your own risk.** So that's my disclaimer! :D

## Overview

Zotify is a powerful and customizable music and podcast downloader that allows users to download high-quality audio directly from Spotify. It supports downloading tracks, albums, playlists, and podcasts with features like real-time downloading and synced lyrics. But the documentation has much to be desired. Follow this guide to make your experience much smoother and streamlined.

## Prerequisites

Before installing Zotify, ensure your system meets the following requirements:

- **Python** : Version 3.9 or greater.[GitHub](https://github.com/zotify-dev/zotify)
- **FFmpeg** : A complete, cross-platform solution to record, convert, and stream audio and video.
- **Git** : Version control system to clone repositories.

Ensure these dependencies are installed and accessible in your system’s PATH.

## Installation Steps

### 1. Install Zotify

Zotify can be installed using `pip`. Open your terminal or command prompt and execute:

```bash
python -m pip install git+https://zotify.xyz/zotify/zotify.git
```

This command installs Zotify and its necessary Python packages.

### 2. Generate Spotify Credentials

Zotify requires a `credentials.json` file for authentication with Spotify. To generate this file, follow these steps:

### a. Install Rust

The `librespot-auth` tool, used to generate the credentials, is written in Rust. Install Rust using the appropriate method for your operating system:

- **Windows** : Open PowerShell and run:

```powershell
choco install rust
```

- **macOS** : Open Terminal and run:

```bash
brew install rust
```

- **Linux** : Open Terminal and run:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Ensure Rust is added to your system’s PATH after installation.

### b. Install LLVM (If Necessary)

Some systems may require LLVM for compiling Rust projects. Download and install LLVM from the official releases page:

- LLVM Releases: [Download LLVM releases](https://releases.llvm.org/)
1. Clone and Build `librespot-auth`
Use Git to clone the `librespot-auth` repository and build the project:

```bash
git clone https://github.com/dspearson/librespot-auth.git
cd librespot-auth
cargo build --release
```

This process compiles the `librespot-auth` tool, which will be used to generate the Spotify credentials.
d. Generate `credentials.json`

1. Ensure the Spotify client application is closed.
2. Navigate to the `librespot-auth` build directory:

```bash
cd target/release/
```

1. Run the `librespot-auth` executable:
- **Windows** :

```powershell
.\librespot-auth.exe
```

- **macOS/Linux** :

```bash
./librespot-auth
```

1. The tool will prompt you to select a device named “Speaker”. Open the Spotify client, click the “Connect to a device” icon (usually located next to the volume bar), and select “Speaker” from the list.
2. Upon selection, `librespot-auth` will generate a `credentials.json` file in the same directory.
3. Modify `credentials.json`
Before using the credentials with Zotify, modify the `credentials.json` file as follows:
- Replace `"auth_type": 1` with `"type": "AUTHENTICATION_STORED_SPOTIFY_CREDENTIALS"`.
- Rename `"auth_data"` to `"credentials"`.

This modification aligns the credentials format with Zotify’s requirements.
3. Place `credentials.json` in the Zotify Directory
Zotify expects the `credentials.json` file in a specific directory, which varies by operating system:

- **Windows** : `%APPDATA%\Zotify\`
- **macOS** : `~/Library/Application Support/Zotify/`
- **Linux** : `~/.config/Zotify/`

Create the appropriate directory if it doesn’t exist and place the modified `credentials.json` file there.

## Usage

With Zotify installed and configured, you can now download music and podcasts directly from Spotify. Use the following command structure: 

```bash
zotify --download-quality very_high --download-real-time=True <Spotify_URL>
```

- **`<Spotify_URL>`** : Replace with the URL of the Spotify track, album, playlist, or podcast you wish to download.

**Options:**

- `-download-quality`: Sets the quality of the download. Use `very_high` for the highest quality (up to 320kbps for premium accounts).
- `-download-real-time`: When set to `True`, downloads the track in real-time, reducing the risk of account bans. Note that this process takes as long as the track’s duration.

**Example:**

```bash
zotify --download-quality very_high --download-real-time=True https://open.spotify.com/track/4aSGokf2n9W6aQiOwoit7A?si=7f1d844035964aee
::contentReference[oaicite:84]{index=84}
```

This command downloads the specified track in the highest quality available, playing it in real-time to minimize account risks.

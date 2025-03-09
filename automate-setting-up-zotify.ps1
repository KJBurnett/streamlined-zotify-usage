# Zotify Installation and Setup Script
# This script automates the installation of Python, FFmpeg, Rust, LLVM, Zotify, and librespot-auth on Windows.

# Function to display messages
function Write-Log {
    param (
        [string]$Message
    )
    Write-Host "[INFO] $Message"
}

# Function to download files
function Download-File {
    param (
        [string]$Url,
        [string]$Destination
    )
    Write-Log "Downloading $Url to $Destination"
    Invoke-WebRequest -Uri $Url -OutFile $Destination
}

# 1. Install Python
Write-Log "Installing Python"
$PythonInstaller = "$env:TEMP\python-installer.exe"
Download-File -Url "https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe" -Destination $PythonInstaller
Start-Process -FilePath $PythonInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -NoNewWindow -Wait
Remove-Item $PythonInstaller

# 2. Install FFmpeg
Write-Log "Installing FFmpeg"
$FFmpegZip = "$env:TEMP\ffmpeg.zip"
Download-File -Url "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" -Destination $FFmpegZip
Expand-Archive -Path $FFmpegZip -DestinationPath $env:ProgramFiles -Force
Remove-Item $FFmpegZip
$FFmpegDir = Get-ChildItem "$env:ProgramFiles" | Where-Object { $_.Name -like "ffmpeg*" }
$env:Path += ";$FFmpegDir\bin"

# 3. Install Rust with GNU toolchain
Write-Log "Installing Rust with GNU toolchain"
$RustInstaller = "$env:TEMP\rustup-init.exe"
Download-File -Url "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-gnu/rustup-init.exe" -Destination $RustInstaller
Start-Process -FilePath $RustInstaller -ArgumentList "-y" -NoNewWindow -Wait
Remove-Item $RustInstaller

# 4. Install LLVM
Write-Log "Installing LLVM"
$LLVMInstaller = "$env:TEMP\LLVM-14.0.6-win64.exe"
Download-File -Url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/LLVM-14.0.6-win64.exe" -Destination $LLVMInstaller
Start-Process -FilePath $LLVMInstaller -ArgumentList "/S" -NoNewWindow -Wait
Remove-Item $LLVMInstaller

# 5. Install Zotify
Write-Log "Installing Zotify"
pip install git+https://zotify.xyz/zotify/zotify.git

# 6. Clone and build librespot-auth
Write-Log "Cloning and building librespot-auth"
$LibrespotAuthDir = "$env:TEMP\librespot-auth"
git clone https://github.com/dspearson/librespot-auth.git $LibrespotAuthDir
Set-Location -Path $LibrespotAuthDir
cargo build --release

# 7. Run librespot-auth to generate credentials.json
Write-Log "Generating credentials.json"
$LibrespotAuthExe = "$LibrespotAuthDir\target\release\librespot-auth.exe"
Start-Process -FilePath $LibrespotAuthExe -NoNewWindow -Wait

# 8. Modify credentials.json
Write-Log "Modifying credentials.json"
$CredentialsPath = "$LibrespotAuthDir\credentials.json"
if (Test-Path $CredentialsPath) {
    (Get-Content $CredentialsPath) -replace '"auth_type":\s*1', '"type": "AUTHENTICATION_STORED_SPOTIFY_CREDENTIALS"' |
    Set-Content $CredentialsPath
    (Get-Content $CredentialsPath) -replace '"auth_data":', '"credentials":' |
    Set-Content $CredentialsPath
}
else {
    Write-Log "credentials.json not found. Please ensure the Spotify client is closed and try again."
    exit 1
}

# 9. Place credentials.json in Zotify directory
Write-Log "Placing credentials.json in Zotify directory"
$ZotifyDir = "$env:APPDATA\Zotify"
if (-not (Test-Path $ZotifyDir)) {
    New-Item -ItemType Directory -Path $ZotifyDir
}
Copy-Item -Path $CredentialsPath -Destination $ZotifyDir

Write-Log "Zotify installation and setup complete. You can now use Zotify to download Spotify tracks."

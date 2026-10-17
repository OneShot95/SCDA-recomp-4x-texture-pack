@echo off
setlocal
title SCDA recomp 4x texture pack - setup
set "SCDA_INSTALLER=%~f0"
powershell.exe -NoLogo -NoProfile -Command "$text = [IO.File]::ReadAllText($env:SCDA_INSTALLER); $body = ($text -split '(?m)^# POWERSHELL-START\r?\n', 2)[1]; & ([scriptblock]::Create($body))"
set "SCDA_RESULT=%ERRORLEVEL%"
echo.
pause
exit /b %SCDA_RESULT%
# POWERSHELL-START
# Readable optional setup for SCDA recomp 4x texture pack.
# Downloads only the six release ZIPs below from OneShot95 on GitHub.
# Checks SHA-256 before extraction. Does not run the game, request admin,
# change security settings, or replace an existing SCDA folder.
$ErrorActionPreference = 'Stop'

function Install-SCDAPack {
    param(
        [Parameter(Mandatory=$true)][string]$InputDirectory,
        [Parameter(Mandatory=$true)][string]$OutputDirectory,
        [Parameter(Mandatory=$true)][string]$ReleaseBaseUri,
        [Parameter(Mandatory=$true)][System.Collections.IDictionary]$Manifest
    )
    if (Test-Path -LiteralPath $OutputDirectory) {
        throw 'The SCDA folder already exists. Move this setup file into a new empty folder and try again. Your existing game folder has not been changed.'
    }
    $null = New-Item -ItemType Directory -Path $InputDirectory -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    foreach ($name in $Manifest.Keys) {
        $archive = Join-Path $InputDirectory $name
        if (!(Test-Path -LiteralPath $archive)) {
            Write-Host "Downloading $name ... (large files may take a while)"
            $partial = $archive + '.partial'
            $client = New-Object Net.WebClient
            try {
                $client.Headers.Add('User-Agent', 'SCDA-texture-pack-setup')
                $client.DownloadFile(($ReleaseBaseUri.TrimEnd('/') + '/' + $name), $partial)
            } finally { $client.Dispose() }
            $actual = (Get-FileHash -LiteralPath $partial -Algorithm SHA256).Hash
            if ($actual -ne $Manifest[$name]) { throw "Download checksum failed for $name. No files have been extracted. Try again." }
            Move-Item -LiteralPath $partial -Destination $archive
        }
        Write-Host "Checking $name ..."
        if ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash -ne $Manifest[$name]) {
            throw "Archive checksum failed for $name. Move that ZIP out of this folder and run setup again. No files have been extracted."
        }
    }
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $parent = Split-Path -Parent $OutputDirectory
    $staging = Join-Path $parent ('SCDA-extracting-' + [guid]::NewGuid().ToString('N'))
    $null = New-Item -ItemType Directory -Path $staging
    foreach ($name in $Manifest.Keys) {
        Write-Host "Extracting $name ..."
        [IO.Compression.ZipFile]::ExtractToDirectory((Join-Path $InputDirectory $name), $staging)
    }
    # Rename only after every archive has extracted successfully.
    if (Test-Path -LiteralPath $OutputDirectory) { throw 'The SCDA folder already exists. Extracted files remain in the SCDA-extracting folder.' }
    Move-Item -LiteralPath $staging -Destination $OutputDirectory
    Write-Host ''
    Write-Host "Ready: $OutputDirectory" -ForegroundColor Green
    Write-Host 'Add your own original Xbox Double Agent ISO to SCDA\assets, then run SCDA.exe.'
    Write-Host 'Keep both executable filenames unchanged. F10 opens settings.'
    Write-Host 'The ZIP downloads have been kept. You can remove them yourself after checking the game.'
}

if ($MyInvocation.InvocationName -ne '.') {
    try {
        $root = Split-Path -Parent $env:SCDA_INSTALLER
        Write-Host 'SCDA recomp 4x texture pack - optional setup'
        Write-Host 'Downloads about 8 GB from GitHub and creates one SCDA folder beside this file.'
        Write-Host 'Allow at least 18 GB of free space. No admin rights are needed.'
        Write-Host 'Existing matching ZIPs in this folder will be reused.'
        Write-Host ''
        $manifest = [ordered]@{
            'SCDA-4x-HD-base.zip' = '32d1e7d4d28b3f9bf68fee5124bc070b380d7edd77dd45e4c6741b605c100b0d'
            'SCDA-4x-HD-textures-01.zip' = 'd0d7a3bc719edb563e62c82348e3afbd7130e91cf40ac3d3b8d67c40799d4278'
            'SCDA-4x-HD-textures-02.zip' = '8328e085ce4c3eb021638aef6732b1bb871cda90764a751875813b2d2be78fcb'
            'SCDA-4x-HD-textures-03.zip' = '675da6dd6effea3180a3b015850ac18c28f003004e7049f34e7d661e170c2d17'
            'SCDA-4x-HD-textures-04.zip' = 'e753afe8f41e41f3e4b762647ec96f8be091e28a515a882b83654aa654ca8b97'
            'SCDA-4x-HD-textures-05.zip' = 'cf1410fe139a9bfaa2511fa9f7263f1ce370e0700bf43376e1f4a7c80aef5236'
        }
        Install-SCDAPack -InputDirectory $root -OutputDirectory (Join-Path $root 'SCDA') -ReleaseBaseUri 'https://github.com/OneShot95/SCDA-recomp-4x-texture-pack/releases/download/v0.1.0-preview' -Manifest $manifest
        exit 0
    } catch {
        Write-Host ''
        Write-Host ('Setup stopped: ' + $_.Exception.Message) -ForegroundColor Red
        Write-Host 'You can also use the manual ZIP downloads and extraction instructions on the release page.'
        exit 1
    }
}

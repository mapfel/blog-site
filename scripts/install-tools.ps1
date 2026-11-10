[CmdletBinding()]
param(
    # Reinstall even when the expected versions are already present.
    [switch]$Force
)

# Installs the Hugo and Pagefind versions pinned in the GitHub Pages workflow
# into the ignored .tools directory of this repository (Windows x64).

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$siteRoot = Split-Path -Parent $PSScriptRoot
$toolsRoot = Join-Path $siteRoot '.tools'
$workflowPath = Join-Path $siteRoot '.github\workflows\pages.yml'

function Get-PinnedVersion([string]$Name) {
    $match = Select-String -LiteralPath $workflowPath -Pattern "^\s*${Name}:\s*([0-9][0-9.]*)\s*$" |
        Select-Object -First 1
    if (-not $match) {
        throw "Could not read $Name from $workflowPath"
    }
    return $match.Matches[0].Groups[1].Value
}

function Install-Archive([string]$Url, [string]$Destination) {
    $download = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetFileName($Url))
    Write-Host "Downloading $Url"
    Invoke-WebRequest -Uri $Url -OutFile $download -UseBasicParsing
    try {
        if (Test-Path -LiteralPath $Destination) {
            Remove-Item -LiteralPath $Destination -Recurse -Force
        }
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
        # tar.exe ships with Windows 10 1803+ and extracts both .zip and .tar.gz.
        & tar.exe -xf $download -C $Destination
        if ($LASTEXITCODE -ne 0) {
            throw "Extracting $download failed."
        }
    }
    finally {
        Remove-Item -LiteralPath $download -Force -ErrorAction SilentlyContinue
    }
}

function Test-ToolVersion([string]$Exe, [string[]]$Arguments, [string]$Version) {
    if (-not (Test-Path -LiteralPath $Exe -PathType Leaf)) {
        return $false
    }
    $output = & $Exe @Arguments 2>&1 | Out-String
    return $output -match [regex]::Escape($Version)
}

$hugoVersion = Get-PinnedVersion 'HUGO_VERSION'
$pagefindVersion = Get-PinnedVersion 'PAGEFIND_VERSION'

$hugoDir = Join-Path $toolsRoot 'hugo'
$hugoExe = Join-Path $hugoDir 'hugo.exe'
if ($Force -or -not (Test-ToolVersion $hugoExe @('version') "v$hugoVersion")) {
    Install-Archive "https://github.com/gohugoio/hugo/releases/download/v$hugoVersion/hugo_${hugoVersion}_windows-amd64.zip" $hugoDir
}
else {
    Write-Host "Hugo $hugoVersion is already installed."
}

$pagefindDir = Join-Path $toolsRoot 'pagefind'
$pagefindExe = Join-Path $pagefindDir 'pagefind.exe'
if ($Force -or -not (Test-ToolVersion $pagefindExe @('--version') $pagefindVersion)) {
    Install-Archive "https://github.com/Pagefind/pagefind/releases/download/v$pagefindVersion/pagefind-v$pagefindVersion-x86_64-pc-windows-msvc.tar.gz" $pagefindDir
}
else {
    Write-Host "Pagefind $pagefindVersion is already installed."
}

& $hugoExe version
& $pagefindExe --version

# Agent skills are tooling too: link them for agents with their own skill folder.
& (Join-Path $PSScriptRoot 'link-agent-skills.ps1')

Write-Host ''
Write-Host 'Add the tools to PATH for the current PowerShell session with:'
Write-Host "  `$env:Path = `"$hugoDir;$pagefindDir;`$env:Path`""

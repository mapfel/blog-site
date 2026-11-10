[CmdletBinding()]
param()

# Exposes the canonical skills in .agents/skills to agents that only look in
# their own folder (currently Claude Code: .claude/skills). Windows gets
# directory junctions, which need neither admin rights nor Developer Mode;
# other platforms get symlinks. The link folders are ignored by Git.
# Safe to rerun: existing links are refreshed, stale links removed, and real
# folders are left untouched with a warning.

$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $siteRoot '.agents/skills'
$linkRoots = @(Join-Path $siteRoot '.claude/skills')

$isWindowsHost = [System.Environment]::OSVersion.Platform -eq 'Win32NT'
$skills = Get-ChildItem -LiteralPath $sourceRoot -Directory |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }

function Test-Link([System.IO.FileSystemInfo]$Item) {
    return [bool]($Item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)
}

function Remove-Link([string]$Path) {
    # Delete only the link itself, never the target's content.
    [System.IO.Directory]::Delete($Path)
}

foreach ($linkRoot in $linkRoots) {
    New-Item -ItemType Directory -Path $linkRoot -Force | Out-Null

    foreach ($existing in Get-ChildItem -LiteralPath $linkRoot -Force) {
        if ((Test-Link $existing) -and -not ($skills.Name -contains $existing.Name)) {
            Remove-Link $existing.FullName
            Write-Host "Removed stale link $($existing.FullName)"
        }
    }

    foreach ($skill in $skills) {
        $linkPath = Join-Path $linkRoot $skill.Name
        $item = Get-Item -LiteralPath $linkPath -Force -ErrorAction SilentlyContinue

        if ($item -and -not (Test-Link $item)) {
            Write-Warning "Skipped $linkPath : a real folder exists. Merge it into $($skill.FullName), delete it, and rerun."
            continue
        }
        if ($item) {
            Remove-Link $linkPath
        }

        $type = if ($isWindowsHost) { 'Junction' } else { 'SymbolicLink' }
        New-Item -ItemType $type -Path $linkPath -Target $skill.FullName | Out-Null
        Write-Host "Linked $linkPath -> $($skill.FullName)"
    }
}

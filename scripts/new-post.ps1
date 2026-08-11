[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Title,

    [string]$Slug,

    [datetime]$Date = (Get-Date)
)

$ErrorActionPreference = 'Stop'
$siteRoot = Split-Path -Parent $PSScriptRoot
$contentRoot = Join-Path $siteRoot 'content-source\content\posts'

if (-not (Test-Path -LiteralPath $contentRoot -PathType Container)) {
    throw "Content submodule is missing. Run: git submodule update --init --recursive"
}

if ([string]::IsNullOrWhiteSpace($Slug)) {
    $Slug = $Title.ToLowerInvariant()
    $Slug = $Slug -replace '[^a-z0-9]+', '-'
    $Slug = $Slug.Trim('-')
}

if ($Slug -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
    throw 'Slug must use lowercase letters, digits, and single hyphens.'
}

$articleDirectory = Join-Path $contentRoot (Join-Path $Date.ToString('yyyy') (Join-Path $Date.ToString('MM') $Slug))
$articlePath = Join-Path $articleDirectory 'index.md'

if (Test-Path -LiteralPath $articlePath) {
    throw "Article already exists: $articlePath"
}

$escapedTitle = $Title.Replace('"', '\"')
$timestamp = $Date.ToString('yyyy-MM-ddTHH:mm:ssK')
$frontMatter = @"
+++
title = "$escapedTitle"
description = ""
date = $timestamp
lastmod = $timestamp
draft = true
topics = []
tags = []
+++

Write a concise opening that tells the reader what they will learn.
"@

New-Item -ItemType Directory -Path $articleDirectory -Force | Out-Null
[System.IO.File]::WriteAllText($articlePath, $frontMatter, [System.Text.UTF8Encoding]::new($false))
Write-Output $articlePath

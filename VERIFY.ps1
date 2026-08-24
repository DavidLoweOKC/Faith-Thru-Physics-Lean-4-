[CmdletBinding()]
param(
    [switch]$SkipInstall
)

$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot

function Write-Step([string]$Message) {
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Refresh-ElanPath {
    $elanBin = Join-Path $env:USERPROFILE '.elan\bin'
    if (Test-Path -LiteralPath $elanBin) {
        $env:Path = "$elanBin;$env:Path"
    }
}

Refresh-ElanPath

$requiredDeclarations = @(
    'abs_effect_eq_remaining'
    'bounded_power'
    'total_deprivation_annihilates'
    'sign_changes_direction_not_magnitude'
    'deprivation_reduces_capacity'
    'opposition_is_borrowed'
)

$kernelText = Get-Content -Raw -LiteralPath 'PrivativeMagnitude.lean'
if ($kernelText.Length -lt 1000) {
    throw 'PrivativeMagnitude.lean is unexpectedly small; refusing a vacuous verification.'
}
foreach ($declaration in $requiredDeclarations) {
    if ($kernelText -notmatch "theorem\s+$([regex]::Escape($declaration))\b") {
        throw "Required theorem is missing: $declaration"
    }
}

if (-not (Get-Command lake -ErrorAction SilentlyContinue)) {
    if ($SkipInstall) {
        throw 'Lake is not installed and -SkipInstall was requested.'
    }

    Write-Step 'Lean is missing. Installing the official elan toolchain manager.'
    Write-Host 'This installs Lean tooling under your Windows user profile (.elan).'
    $installer = Join-Path ([System.IO.Path]::GetTempPath()) 'elan-init.exe'
    Invoke-WebRequest -Uri 'https://github.com/leanprover/elan/releases/latest/download/elan-init.exe' -OutFile $installer
    & $installer -y --default-toolchain none
    if ($LASTEXITCODE -ne 0) { throw "elan installer failed with exit code $LASTEXITCODE" }
    Refresh-ElanPath
}

Write-Step 'Toolchain versions'
$leanVersion = (& lean --version | Out-String).Trim()
$lakeVersion = (& lake --version | Out-String).Trim()
Write-Host $leanVersion
Write-Host $lakeVersion

$env:MATHLIB_CACHE_DIR = Join-Path $PSScriptRoot '.lake\mathlib-cache'

$mathlibOlean = Join-Path $PSScriptRoot '.lake\packages\mathlib\.lake\build\lib\lean\Mathlib.olean'
if (Test-Path -LiteralPath $mathlibOlean) {
    Write-Step 'Pinned Mathlib cache is already present; skipping download'
} else {
    Write-Step 'Downloading pinned dependencies and the Mathlib binary cache'
    & lake exe cache get
    if ($LASTEXITCODE -ne 0) { throw "Mathlib cache download failed with exit code $LASTEXITCODE" }
}

Write-Step 'Building every default Lean target'
& lake build
if ($LASTEXITCODE -ne 0) { throw "lake build failed with exit code $LASTEXITCODE" }

Write-Step 'Checking PrivativeMagnitude.lean directly'
$axiomOutput = (& lake env lean PrivativeMagnitude.lean 2>&1 | Out-String).Trim()
if ($LASTEXITCODE -ne 0) { throw "Direct kernel check failed with exit code $LASTEXITCODE`n$axiomOutput" }
Write-Host $axiomOutput
foreach ($declaration in $requiredDeclarations) {
    if ($axiomOutput -notmatch [regex]::Escape("PrivativeMagnitude.$declaration")) {
        throw "Axiom report is missing required theorem: $declaration"
    }
}

Write-Step 'Scanning the kernel for proof escapes'
$escapePattern = '\b(sorry|admit|unsafe)\b|^\s*axiom\b'
$escapeMatches = Select-String -LiteralPath 'PrivativeMagnitude.lean' -Pattern $escapePattern
if ($escapeMatches) {
    $escapeMatches | ForEach-Object { Write-Host $_.Line -ForegroundColor Red }
    throw 'Proof escape detected in PrivativeMagnitude.lean.'
}
Write-Host 'No sorry, admit, unsafe, or custom axiom declarations found.' -ForegroundColor Green

$sourceHash = (Get-FileHash -LiteralPath 'PrivativeMagnitude.lean' -Algorithm SHA256).Hash
$commit = (& git rev-parse HEAD 2>$null | Out-String).Trim()
$receipt = @(
    "verified_at_utc=$([DateTime]::UtcNow.ToString('o'))"
    "commit=$commit"
    "source_sha256=$sourceHash"
    "lean_version=$leanVersion"
    "lake_version=$lakeVersion"
    'lake_build=passed'
    'direct_kernel_check=passed'
    'proof_escape_scan=passed'
    ''
    '#print axioms output:'
    $axiomOutput
)
$receipt | Set-Content -LiteralPath 'verification-receipt.txt' -Encoding utf8

Write-Host "`nVerification receipt: $PSScriptRoot\verification-receipt.txt" -ForegroundColor Green
Write-Host 'Important: this verifies consequences of the encoded definitions and premises. It does not prove the theological interpretation.' -ForegroundColor Yellow

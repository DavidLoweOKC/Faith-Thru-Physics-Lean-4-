$ErrorActionPreference = 'Stop'
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$LocalPython = Join-Path $RepoRoot '.venv-z3\Scripts\python.exe'

if (Test-Path -LiteralPath $LocalPython) {
    & $LocalPython (Join-Path $PSScriptRoot 'kernel_v2.py') @args
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
    & py (Join-Path $PSScriptRoot 'kernel_v2.py') @args
} else {
    & python (Join-Path $PSScriptRoot 'kernel_v2.py') @args
}
exit $LASTEXITCODE

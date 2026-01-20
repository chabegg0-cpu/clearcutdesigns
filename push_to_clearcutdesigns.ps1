$ErrorActionPreference = "Stop"

# Simple deploy script for https://github.com/chabegg0-cpu/clearcutdesigns.git
# Double-click the accompanying .bat file to run this.

$RepoUrl = "https://github.com/chabegg0-cpu/clearcutdesigns.git"
$Branch = "main"

# Ensure we are running from the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "[deploy] Working directory: $scriptDir"

# Check that git is available
try {
    git --version | Out-Null
} catch {
    Write-Host "[deploy] ERROR: git is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Install Git for Windows from https://git-scm.com/downloads and try again."
    Read-Host "Press Enter to exit"
    exit 1
}

# Initialize git repo if needed
if (-not (Test-Path ".git")) {
    Write-Host "[deploy] Initializing new git repository..."
    git init | Write-Host
    # Ensure branch is main
    git checkout -b $Branch 2>$null
    git branch -M $Branch
    git remote add origin $RepoUrl
} else {
    Write-Host "[deploy] Git repository already initialized."
}

# Ensure remote URL is correct
try {
    $currentRemote = git remote get-url origin
    if ($currentRemote -ne $RepoUrl) {
        Write-Host "[deploy] Updating remote 'origin' URL."
        git remote set-url origin $RepoUrl
    }
} catch {
    Write-Host "[deploy] Adding remote 'origin'."
    git remote add origin $RepoUrl
}

Write-Host "[deploy] Adding all files..."
git add . | Write-Host

$commitMsg = "Update site " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss 'UTC'")
Write-Host "[deploy] Committing with message: $commitMsg"
try {
    git commit -m $commitMsg | Write-Host
} catch {
    Write-Host "[deploy] Nothing to commit (no changes)."
}

Write-Host "[deploy] Pushing to origin/$Branch..."
try {
    git push -u origin $Branch | Write-Host
    Write-Host "[deploy] Done." -ForegroundColor Green
} catch {
    Write-Host "[deploy] ERROR during git push. Check your credentials and remote URL." -ForegroundColor Red
}

Read-Host "Press Enter to close this window" | Out-Null

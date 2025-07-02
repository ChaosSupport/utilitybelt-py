# Set paths
$keyName   = "id_cyhar"
$keyPath   = "$env:USERPROFILE\.ssh\" + $keyName
$repoPath  = "\\metfile2\home\cayates\CAY_Code\HarMet"
$tabTitle  = "Git"
$profilePath = "$env:USERPROFILE\.ssh\GitProfile.ps1"

# Start ssh-agent if it's not already running
if ((Get-Service ssh-agent).Status -ne 'Running') {
    Start-Service ssh-agent
}

# Try to get the fingerprint of the key
$keyInfo = ssh-keygen -lf $keyPath 2>$null

if ($keyInfo) {
    $keyFingerprint = $keyInfo -split '\s+' | Select-Object -First 1
    $currentKeys = ssh-add -l 2>&1

    if ($currentKeys -notmatch $keyFingerprint) {
        ssh-add $keyPath | Out-Null
        $tabTitle = "Git keyed"
    } else {
        $tabTitle = "Git keyed"
    }
} else {
    Write-Host "Failed to read SSH key fingerprint. Check that the key exists and is valid." -ForegroundColor Red
    $tabTitle = "Git unkeyed"
}

# Launch Windows Terminal with PowerShell in the repo directory, using your custom profile script
Start-Process wt.exe -ArgumentList @(
    "new-tab",
    "-d", "$repoPath",
    "--title", "`"$tabTitle`"",
    "powershell.exe",
    "-NoExit",
    "-Command", "`"`& '$profilePath'`""
)

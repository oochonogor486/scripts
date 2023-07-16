if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You are not running as an Administrator. Please try again with admin privileges."
    exit 1
}

.\trend.ps1
TIMEOUT /T 180
.\AgentDeploymentScript.ps1
timeout /T 15
Remove-Item -Path .\*.ps1 -Force # 🤔🤷🏾‍♂️
logoff
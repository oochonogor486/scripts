
# Dependencies and prerequisites
## If manual import done. override Install-Module below
# Install-Module -Name SqlServerDsc -RequiredVersion 16.3.1


# Set paths for image location, extracted setup files, install directory, and SQLInstall configuration file
# Set-Location -Path '.\oochon' -PassThru       # launcher 
$MOFPath        = ".\SQLInstall"
$SQLConfig      = ".\SQLInstall"

# Build config file
#   Switching machines/environment? 
#   DOUBLE-CHECK `SourcePath` in config PS file
Unblock-File -Path .\SQLInstallConfiguration.ps1
. .\SQLInstallConfiguration.ps1

# Run configuration function and generate MOF
SQLInstall

# Begin deployment 
New-Item -Path $MOFPath -ItemType Directory -Force
# If next command fails, see options in comments below
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
# OPTION 2: swap with previous command
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted     
# MAKE SURE TO RESET IMMEDIATELY
# OPTION 3: run from terminal before running script
# Unblock-File -Path .\install_sql_server.ps1
Start-DscConfiguration -Path $SQLConfig -Wait -Force -Verbose
Test-DscConfiguration
Write-Output "" "" ""
Get-Service -Name *SQL*
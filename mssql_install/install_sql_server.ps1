
# Dependencies and prerequisites
Install-Module -Name SqlServerDsc -RequiredVersion 16.3.1

# Set paths for image location, extracted setup files, install directory, and SQLInstall configuration file
# $ImagePath      = ".\tmp\SQLServerDownload\en_sql_server_2019_standard.iso"
# $SetupPath      = ".\tmp\SQLServer"
$InstallPath    = ".\tmp\SQLInstall"
$SQLConfig      = ".\SQLInstall"

# Extract setup files from ISO image
# New-Item -Path $SetupPath -ItemType Directory -Force
# $mountResult = Mount-DiskImage -ImagePath $ImagePath -PassThru
# $volumeInfo = $mountResult | Get-Volume
# $driveInfo = Get-PSDrive -Name $volumeInfo.DriveLetter
# Copy-Item -Path ( Join-Path -Path $driveInfo.Root -ChildPath '*' ) -Destination $SetupPath -Recurse -Force
# Dismount-DiskImage -ImagePath $ImagePath
 
# # Check file extraction for success
# Get-ChildItem $SetupPath

# Build config file
    #   Switching machines/environment? 
    #   DOUBLE-CHECK `SourcePath` in config PS file
Unblock-File -Path .\SQLInstallConfiguration.ps1
. .\SQLInstallConfiguration.ps1

# Run configuration function and generate MOF
SQLInstall

# Begin deployment 
New-Item -Path $InstallPath -ItemType Directory -Force
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
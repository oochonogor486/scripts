# refresh vscode path
Set-Location -Path "C:\Users\oochonogor\OneDrive - Nigeria Inter-Bank Settlement System Plc\Documents\q\System admin\.ws\r.trend\"

# Begin script
# See https://success.trendmicro.com/dcx/s/solution/1039283-Uninstalling-clients-agents-of-OfficeScan-or-Apex-One?language=en_US
appwiz.cpl 
services.msc

$trend_agent_path   = "\Trend Micro\Security Agent\"
$install_paths      = "${env:ProgramFiles}$trend_agent_path", "${env:ProgramFiles(x86)}$trend_agent_path", $env:windir
Write-Host $install_paths
$fd = "un"; $ba = "*03"; $cc = "field"

foreach ($current_path in $install_paths) {
    $test_path = Test-Path -Path $current_path
    
    if ($test_path -and $current_path -ne $env:windir) {
        $voldemort = $fd+$cc+$ba
        .$current_path\pccntmon -m $voldemort 
        Remove-Item -LiteralPath $current_path -Force -Recurse
        Get-Service -DisplayName '*trend micro*' | Where-Object {$_.Status -eq "Running"} | Stop-Service
        TIMEOUT /T 9
        Get-Service -DisplayName '*trend micro*' | Start-Service
    }
    elseif ($test_path -and $current_path -eq $env:windir) {
        .$env:windir\System32\cmd /c "timeout /t 9"
    }
    
}

TIMEOUT /T 180
logoff
Write-Output "Success!"


# APPENDIX:
# %LocalAppData%\Temp\ntrmv.exe
# Remove-Item -LiteralPath "C:\Program Files\Trend Micro\Security Agent\" -Force -Recurse
# Remove-Item -LiteralPath "C:\Program Files (x86)\Trend Micro\Security Agent\" -Force -Recurse
# Get-Service -DisplayName '*trend micro*' | Where-Object {$_.Status -eq "Running"} | Stop-Service
# Get-Service -DisplayName '*trend micro*' | Stop-Service

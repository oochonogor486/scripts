# Begin script
# See https://success.trendmicro.com/dcx/s/solution/1039283-Uninstalling-clients-agents-of-OfficeScan-or-Apex-One?language=en_US

appwiz.cpl 
services.msc

$install_paths      = "${env:ProgramFiles}\Trend Micro\Security Agent\", "${env:ProgramFiles(x86)}\Trend Micro\Security Agent\"
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
}
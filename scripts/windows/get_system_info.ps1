# get_system_info.ps1
# Outputs system information in JSON format

param(
    [string]$Output = ""
)

$hostName = $(hostname)
$now = (Get-Date).ToString("o")

$sysInfo = @{
    host         = $hostName
    collected_at = $now
    category     = "system"
    data = @{
        os              = (Get-CimInstance Win32_OperatingSystem).Caption
        os_version      = (Get-CimInstance Win32_OperatingSystem).Version
        architecture    = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
        kernel_version  = (Get-CimInstance Win32_OperatingSystem).BuildNumber
        hostname        = $hostName
        uptime_seconds  = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime |
                            ForEach-Object { (New-TimeSpan -Start $_ -End (Get-Date)).TotalSeconds }
        cpu             = (Get-CimInstance Win32_Processor).Name
        cpu_cores       = (Get-CimInstance Win32_Processor).NumberOfCores
        memory_total_mb = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB, 2)
    }
}

$json = $sysInfo | ConvertTo-Json -Depth 6

if ($Output) {
    $json | Out-File -FilePath $Output -Encoding utf8
} else {
    Write-Output $json
}

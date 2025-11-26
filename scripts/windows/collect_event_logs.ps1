# Requires PowerShell 5+
$HostName = $env:COMPUTERNAME
$CollectedAt = (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz")
$Category = "syslogs"

# Collect last 24 hours of System and Application events
$Since = (Get-Date).AddHours(-24)

$Events = Get-WinEvent -FilterHashtable @{LogName="System"; StartTime=$Since} -MaxEvents 500
$Events += Get-WinEvent -FilterHashtable @{LogName="Application"; StartTime=$Since} -MaxEvents 500

# Convert events to JSON array
$Logs = @()
foreach ($e in $Events) {
    $Logs += @{raw_message = $e.TimeCreated.ToString("yyyy-MM-ddTHH:mm:ss") + " " + $e.ProviderName + " " + $e.Id + " " + $e.Message}
}

# Output JSON
$Json = @{
    host = $HostName
    collected_at = $CollectedAt
    category = $Category
    logs = $Logs
} | ConvertTo-Json -Depth 4

Write-Output $Json

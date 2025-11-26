# Collect host and timestamp
$hostname = $env:COMPUTERNAME
$collected_at = (Get-Date).ToString("o")

# Get firewall rules and status
$rules = Get-NetFirewallRule | Select-Object DisplayName, Direction, Action, Enabled, Profile

$result = [PSCustomObject]@{
    host        = $hostname
    collected_at = $collected_at
    category    = "firewall_status"
    rules       = $rules
}

$result | ConvertTo-Json -Depth 5

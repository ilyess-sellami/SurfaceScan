# list_open_ports.ps1
# This script lists all open TCP ports on a Windows machine

$hostname = $env:COMPUTERNAME
$collected_at = (Get-Date).ToString("o")

$ports = Get-NetTCPConnection -State Listen | ForEach-Object {
    [PSCustomObject]@{
        protocol      = "tcp"
        local_address = $_.LocalAddress
        local_port    = $_.LocalPort
        pid           = $_.OwningProcess
        state         = $_.State
    }
}

$result = [PSCustomObject]@{
    host        = $hostname
    collected_at = $collected_at
    category    = "open_ports"
    ports       = $ports
}

$result | ConvertTo-Json -Depth 5

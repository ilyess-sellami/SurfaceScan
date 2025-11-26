# Active connections on Windows
# Outputs JSON

$computer = $env:COMPUTERNAME
$collected_at = (Get-Date).ToString("o")

# Get all TCP and UDP connections
$connections = Get-NetTCPConnection -ErrorAction SilentlyContinue | ForEach-Object {
    [PSCustomObject]@{
        protocol       = "TCP"
        local_address  = $_.LocalAddress
        local_port     = $_.LocalPort
        remote_address = $_.RemoteAddress
        remote_port    = $_.RemotePort
        state          = $_.State
        pid            = $_.OwningProcess
    }
}

# Add UDP connections
$udpConnections = Get-NetUDPEndpoint -ErrorAction SilentlyContinue | ForEach-Object {
    [PSCustomObject]@{
        protocol       = "UDP"
        local_address  = $_.LocalAddress
        local_port     = $_.LocalPort
        remote_address = ""
        remote_port    = ""
        state          = "LISTEN"
        pid            = $_.OwningProcess
    }
}

$allConnections = $connections + $udpConnections

$result = [PSCustomObject]@{
    host         = $computer
    collected_at = $collected_at
    category     = "active_connections"
    connections  = $allConnections
}

$result | ConvertTo-Json -Depth 5

# network_interfaces.ps1

$interfaces = Get-NetAdapter | ForEach-Object {
    $adapter = $_
    $ipv4 = (Get-NetIPAddress -InterfaceIndex $adapter.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress
    $ipv6 = (Get-NetIPAddress -InterfaceIndex $adapter.ifIndex -AddressFamily IPv6 -ErrorAction SilentlyContinue).IPAddress

    [PSCustomObject]@{
        name   = $adapter.Name
        mac    = $adapter.MacAddress
        ipv4   = $ipv4
        ipv6   = $ipv6
        mtu    = $adapter.MtuSize
        status = $adapter.Status
    }
}

$result = [PSCustomObject]@{
    host         = $env:COMPUTERNAME
    collected_at = (Get-Date).ToString("o")
    category     = "network_interfaces"
    interfaces   = $interfaces
}

$result | ConvertTo-Json -Depth 5

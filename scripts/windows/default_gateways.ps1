# Collect default gateway info on Windows
$computer = $env:COMPUTERNAME
$collected_at = (Get-Date).ToString("o")

$gateways = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null } | ForEach-Object {
    [PSCustomObject]@{
        interface_alias = $_.InterfaceAlias
        ipv4_gateway    = $_.IPv4DefaultGateway.NextHop
        ipv6_gateway    = if ($_.IPv6DefaultGateway -ne $null) { $_.IPv6DefaultGateway.NextHop } else { "" }
        mac_address     = $_.InterfacePhysicalAddress
    }
}

$result = [PSCustomObject]@{
    host         = $computer
    collected_at = $collected_at
    category     = "default_gateways"
    gateways     = $gateways
}

$result | ConvertTo-Json -Depth 5

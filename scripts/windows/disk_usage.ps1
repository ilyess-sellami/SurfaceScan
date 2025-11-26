$hostName = $env:COMPUTERNAME
$collectedAt = (Get-Date).ToString("o")

$disks = Get-PSDrive -PSProvider 'FileSystem' | ForEach-Object {
    [PSCustomObject]@{
        source = "windows"
        name   = $_.Name
        path   = $_.Root
        used   = ($_.Used/1KB) -as [int]
        free   = ($_.Free/1KB) -as [int]
        total  = ($_.Used + $_.Free)/1KB -as [int]
    }
}

$result = [PSCustomObject]@{
    host         = $hostName
    collected_at = $collectedAt
    category     = "disk_usage"
    disks        = $disks
}

$result | ConvertTo-Json -Depth 5

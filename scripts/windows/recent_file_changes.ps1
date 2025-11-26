$hostName = $env:COMPUTERNAME
$collectedAt = (Get-Date).ToString("o")

$scanDir = "C:\"
$timeframe = (Get-Date).AddDays(-1)

$files = Get-ChildItem -Path $scanDir -Recurse -File -ErrorAction SilentlyContinue |
         Where-Object { $_.LastWriteTime -ge $timeframe } |
         Select-Object -First 1000 |
         ForEach-Object {
             [PSCustomObject]@{
                 path = $_.FullName
                 modified_at = $_.LastWriteTime.ToString("o")
             }
         }

$result = [PSCustomObject]@{
    host = $hostName
    collected_at = $collectedAt
    category = "recent_file_changes"
    files = $files
}

$result | ConvertTo-Json -Depth 5

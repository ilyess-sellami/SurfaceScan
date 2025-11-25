# list_processes.ps1
# Outputs running processes in JSON format

$processes = Get-Process | ForEach-Object {
    [PSCustomObject]@{
        pid       = $_.Id
        name      = $_.ProcessName
        cpu       = if ($_.CPU) { [math]::Round($_.CPU, 2) } else { 0 }
        memory_mb = [math]::Round($_.WorkingSet / 1MB, 2)
        user      = (try { (Get-WmiObject Win32_Process -Filter "ProcessId=$($_.Id)").GetOwner().User } catch { "" })
    }
}

$result = [PSCustomObject]@{
    host = $(hostname)
    collected_at = (Get-Date).ToString("o")
    category = "processes"
    processes = $processes
}

$result | ConvertTo-Json -Depth 6

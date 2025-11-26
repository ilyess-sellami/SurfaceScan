# list_scheduled_tasks.ps1
# This script collects information about scheduled tasks on a Windows system

$collected_at = (Get-Date).ToString("o")
$host_name = $env:COMPUTERNAME

$tasks = Get-ScheduledTask | ForEach-Object {
    $action = ($_ | Get-ScheduledTaskInfo).TaskName
    [PSCustomObject]@{
        source = "scheduled_task"
        name   = $_.TaskName
        path   = $_.Actions[0].Execute
    }
}

$result = [PSCustomObject]@{
    host         = $host_name
    collected_at = $collected_at
    category     = "scheduled_tasks"
    tasks        = $tasks
}

$result | ConvertTo-Json -Depth 5

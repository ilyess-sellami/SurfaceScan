# list_services.ps1
# Enumerates Windows services with description and outputs JSON

$services = Get-Service | ForEach-Object {
    $service = $_

    # Get service details from WMI (faster & reliable)
    $wmi = Get-CimInstance Win32_Service -Filter "Name='$($service.Name)'" -ErrorAction SilentlyContinue

    [PSCustomObject]@{
        name        = $service.Name
        displayName = $service.DisplayName
        status      = $service.Status
        startType   = $wmi.StartMode
        description = $wmi.Description
        processId   = $wmi.ProcessId
        pathName    = $wmi.PathName
    }
}

$result = [PSCustomObject]@{
    host         = $env:COMPUTERNAME
    collected_at = (Get-Date).ToString("o")
    category     = "services"
    services     = $services
}

$result | ConvertTo-Json -Depth 5

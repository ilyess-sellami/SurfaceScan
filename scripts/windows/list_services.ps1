# list_services.ps1
# Outputs all Windows services in JSON format

$services = Get-Service | ForEach-Object {
    $service = $_
    $description = (Get-WmiObject Win32_Service -Filter "Name='$($service.Name)'" | Select-Object -ExpandProperty Description)
    [PSCustomObject]@{
        name        = $service.Name
        displayName = $service.DisplayName
        status      = $service.Status
        startType   = $service.StartType
        description = $description
    }
}

$result = [PSCustomObject]@{
    host        = $(hostname)
    collected_at = (Get-Date).ToString("o")
    category    = "services"
    services    = $services
}

$result | ConvertTo-Json -Depth 5

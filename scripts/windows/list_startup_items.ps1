# List startup items on Windows (Registry + Startup folder)
$computer = $env:COMPUTERNAME
$collected_at = (Get-Date).ToString("o")

$registry_paths = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
)

$startup_items = @()

foreach ($path in $registry_paths) {
    if (Test-Path $path) {
        Get-ItemProperty -Path $path | ForEach-Object {
            $_.PSObject.Properties | ForEach-Object {
                if ($_.Name -notmatch "PSPath|PSParentPath|PSChildName|PSDrive|PSProvider") {
                    $startup_items += [PSCustomObject]@{
                        source = "registry"
                        name   = $_.Name
                        path   = $_.Value
                    }
                }
            }
        }
    }
}

$startup_folders = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup",
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
)

foreach ($folder in $startup_folders) {
    if (Test-Path $folder) {
        Get-ChildItem -Path $folder -File | ForEach-Object {
            $startup_items += [PSCustomObject]@{
                source = "startup_folder"
                name   = $_.Name
                path   = $_.FullName
            }
        }
    }
}

$result = [PSCustomObject]@{
    host         = $computer
    collected_at = $collected_at
    category     = "startup_items"
    items        = $startup_items
}

$result | ConvertTo-Json -Depth 5

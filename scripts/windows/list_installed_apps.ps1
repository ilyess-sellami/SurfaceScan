# list_installed_apps.ps1

function Get-RegistryApps {
    param($path)

    if (Test-Path $path) {
        Get-ChildItem $path | ForEach-Object {
            $p = Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue
            if ($p.DisplayName) {
                [PSCustomObject]@{
                    name      = $p.DisplayName
                    version   = $p.DisplayVersion
                    publisher = $p.Publisher
                    source    = "registry"
                }
            }
        }
    }
}

$apps = @()

# 64-bit apps
$apps += Get-RegistryApps "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"

# 32-bit apps
$apps += Get-RegistryApps "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

# Current user apps
$apps += Get-RegistryApps "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"

# Windows Store Apps
$apps += Get-AppxPackage | ForEach-Object {
    [PSCustomObject]@{
        name      = $_.Name
        version   = $_.Version
        publisher = $_.Publisher
        source    = "store"
    }
}

$result = [PSCustomObject]@{
    host         = $env:COMPUTERNAME
    collected_at = (Get-Date).ToString("o")
    category     = "installed_apps"
    apps         = $apps
}

$result | ConvertTo-Json -Depth 6

# check_sudo_privileges.ps1
# Lists local users with Administrator privileges

$admins = Get-LocalGroupMember -Group "Administrators" | ForEach-Object {
    [PSCustomObject]@{
        username = $_.Name
        objectClass = $_.ObjectClass
    }
}

$result = [PSCustomObject]@{
    category = "privileges"
    collected_at = (Get-Date).ToString("o")
    host = $(hostname)
    admins = $admins
}

$result | ConvertTo-Json -Depth 5

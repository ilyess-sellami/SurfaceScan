# list_users_groups.ps1
# Outputs clean JSON of users + groups

$users = Get-LocalUser | ForEach-Object {
    $u = $_
    $groups = (Get-LocalGroup | ForEach-Object {
        try {
            if (Get-LocalGroupMember -Group $_.Name -ErrorAction Stop |
                Where-Object {$_.Name -eq $u.Name}) {
                $_.Name
            }
        } catch {}
    })

    [PSCustomObject]@{
        username   = $u.Name
        fullname   = $u.FullName
        enabled    = $u.Enabled
        lastLogon  = $u.LastLogon
        groups     = $groups
    }
}

$groups = Get-LocalGroup | ForEach-Object {
    [PSCustomObject]@{
        groupName   = $_.Name
        description = $_.Description
        members     = (Get-LocalGroupMember -Group $_.Name |
                        Select-Object Name, ObjectClass)
    }
}

$result = [PSCustomObject]@{
    users  = $users
    groups = $groups
}

$result | ConvertTo-Json -Depth 10

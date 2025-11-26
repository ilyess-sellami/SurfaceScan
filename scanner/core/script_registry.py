# scanner/script_registry.py

SCRIPT_REGISTRY = [
    {
        "name": "get_system_info",
        "category": "System",
        "description": "Collect OS, hostname, uptime, CPU, memory, architecture",
    },
    {
        "name": "list_users_groups",
        "category": "Users",
        "description": "Enumerate local users, groups, last logon, admin flags",
    },
    {
        "name": "check_sudo_privileges",
        "category": "Privileges",
        "description": "Identify users with root/admin/sudo rights",
    },
    {
        "name": "list_processes",
        "category": "Processes",
        "description": "List running processes with PID, owner, CPU/MEM usage",
    },
    {
        "name": "list_services",
        "category": "Services",
        "description": "Gather services/daemons, status, startup type",
    },
    {
        "name": "list_installed_apps",
        "category": "Installed Apps",
        "description": "Enumerate installed software & versions",
    },
    {
        "name": "collect_event_logs",
        "category": "Logs",
        "description": "Collect Security/System/Application logs",
    },
    {
        "name": "network_interfaces",
        "category": "Network",
        "description": "Get interfaces, IPs, MAC addresses",
    },
    {
        "name": "list_open_ports",
        "category": "Network",
        "description": "List listening ports + owning process",
    },
    {
        "name": "active_connections",
        "category": "Connections",
        "description": "Enumerate active TCP/UDP connections",
    },
    {
        "name": "default_gateways",
        "category": "Routing",
        "description": "Extract routing table & default gateway",
    },
    {
        "name": "list_startup_items",
        "category": "Startup",
        "description": "Startup apps, autoruns, login items",
    },
    {
        "name": "list_scheduled_tasks",
        "category": "Tasks",
        "description": "Cron jobs / Windows Scheduled Tasks",
    },
    {
        "name": "firewall_status",
        "category": "Firewall",
        "description": "Check firewall rules & status",
    },
    {
        "name": "disk_usage",
        "category": "Disk",
        "description": "Disk usage, mount points, free/used space",
    },
    {
        "name": "recent_file_changes",
        "category": "Files",
        "description": "List files changed in last N days",
    },
    {
        "name": "cve_check_installed_software",
        "category": "Threat Intel",
        "description": "Map installed apps to known CVEs",
    },
]

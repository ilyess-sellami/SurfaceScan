from rich.console import Console
import os
import sys

console = Console()


def check_privileges(os_name):
    """Ensure the CLI is run with elevated privileges."""

    if os_name in ["linux", "macos"]:
        if os.geteuid() != 0:
            console.print(
                "[bold red]⚠️ This CLI must be run as root (sudo). Please restart with 'sudo python cli.py'[/bold red]"
            )
            sys.exit(1)
    elif os_name == "windows":
        try:
            import ctypes

            if not ctypes.windll.shell32.IsUserAnAdmin():
                console.print(
                    "[bold red]⚠️ This CLI must be run as Administrator. Please restart as Administrator.[/bold red]"
                )
                sys.exit(1)
        except Exception:
            console.print(
                "[bold red]⚠️ Unable to verify admin privileges on Windows[/bold red]"
            )
            sys.exit(1)

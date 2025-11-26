from rich.console import Console
from rich.panel import Panel
from pyfiglet import Figlet
from scanner.cli.os_emoji import get_os_emoji

console = Console()

APP_NAME = "Surface Scan"

APP_DESCRIPTION = (
    "Cross-platform Incident Surface Scanner for SOC & DFIR teams\n"
    "Gain complete visibility across Windows · Linux · macOS — ready-to-run scripts, structured output."
)

def print_header(os_name):
    fig = Figlet(font="slant")
    ascii_name = fig.renderText(APP_NAME)
    console.print(f"[bold cyan]{ascii_name}[/bold cyan]")
    console.print(Panel(APP_DESCRIPTION, style="green"))
    
    # Detect OS
    emoji = get_os_emoji(os_name)
    console.print(f"\nDetected OS: [bold yellow]{os_name.upper()} {emoji}[/bold yellow]\n")
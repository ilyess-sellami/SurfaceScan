from rich.table import Table
from rich.console import Console

console = Console()

def display_scripts_table(scripts):
    """Display the list of available scripts in a Rich table with number, name, and description."""

    if not scripts:
        console.print("[red]No scripts found for this OS[/red]")
        return False 

    table = Table(
        title="Available Scripts",
        show_header=True,
        header_style="bold magenta"
    )

    table.add_column("No.", justify="right", style="cyan")
    table.add_column("Script Name", justify="left", style="white")
    table.add_column("Description", justify="left", style="green")

    for idx, script in enumerate(scripts, 1):
        table.add_row(str(idx), script['name'], script['description'])

    console.print(table)
    return True

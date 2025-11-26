from scanner import list_scripts, run_script, detect_os, print_header
from rich.table import Table
from rich.prompt import Prompt
from rich.console import Console

console = Console()

def main():
    os_name = detect_os()
    # Print header
    print_header(os_name)

    # List available scripts
    scripts = list_scripts(os_name)
    if not scripts:
        console.print(f"[red]No scripts found for {os_name}[/red]")
        return

    table = Table(
        title="Available Scripts", show_header=True, header_style="bold magenta"
    )
    table.add_column("No.", justify="right")
    table.add_column("Script Name", justify="left")
    for idx, s in enumerate(scripts, 1):
        table.add_row(str(idx), s)
    console.print(table)

    # User input for scripts to run
    choices = Prompt.ask(
        "\nEnter script numbers to run (comma-separated) or 'all'", default="all"
    )
    if choices.strip().lower() == "all":
        selected_scripts = scripts
    else:
        try:
            indices = [int(x.strip()) - 1 for x in choices.split(",")]
            selected_scripts = [scripts[i] for i in indices if 0 <= i < len(scripts)]
        except ValueError:
            console.print("[red]Invalid input. Exiting.[/red]")
            return

    # Run selected scripts
    console.print("\n[bold green]Running selected scripts...[/bold green]\n")
    for script in selected_scripts:
        run_script(os_name, script)
        console.print(f"[cyan]Completed:[/] {script}")

    console.print("\n[bold green]All selected scripts executed.[/bold green]")


if __name__ == "__main__":
    main()

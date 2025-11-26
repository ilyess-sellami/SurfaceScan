from rich.console import Console
from scanner import (
    list_scripts,
    run_script,
    detect_os,
    print_header,
    display_scripts_table,
)

console = Console()


def main():
    # Detect operating system
    os_name = detect_os()

    # Print header
    print_header(os_name)

    # List available scripts
    scripts = list_scripts(os_name)
    if not display_scripts_table(scripts):
        return

    # User input for scripts to run

    # Run selected scripts
    console.print("\n[bold green]Running selected scripts...[/bold green]\n")
    for script in selected_scripts:
        run_script(os_name, script)

    console.print("\n[bold green]All selected scripts executed.[/bold green]")


if __name__ == "__main__":
    main()

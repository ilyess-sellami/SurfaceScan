from rich.console import Console
from scanner.cli import print_header, display_scripts_table, select_script
from scanner.core import detect_os, list_scripts, run_script

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

    # Select script to run
    selected_script = select_script(scripts)
    
    # Run selected script
    console.print("\n[bold green]Running selected script...[/bold green]\n")
    run_script(os_name, selected_script)

if __name__ == "__main__":
    main()

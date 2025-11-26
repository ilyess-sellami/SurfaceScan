from rich.console import Console
from scanner.cli import print_header, display_scripts_table, select_script,check_privileges
from scanner.core import detect_os, list_scripts, run_script

console = Console()


def main():
    # Detect operating system
    os_name = detect_os()
    
    # Check for necessary privileges
    check_privileges(os_name)

    # Print header
    print_header(os_name)

    # Get available scripts
    scripts = list_scripts(os_name)

    if not scripts:
        console.print("[bold red]No scripts available for this OS.[/bold red]")
        return

    # Display scripts table
    display_scripts_table(scripts)

    while True:

        # Prompt user for script choice
        console.print(
            "[bold yellow]Select a script number to run, or type 'exit' to quit, '?' to review table again.[/bold yellow]"
        )
        choice = console.input("Your choice: ").strip()

        # Handle exit and help commands
        if choice.lower() in ["exit", "quit"]:
            console.print("[bold cyan]Exiting SurfaceScan CLI. Goodbye![/bold cyan]")
            break

        # Handle help command
        elif choice == "?":
            display_scripts_table(scripts)
            continue

        # Select script based on user input
        selected_script = select_script(scripts, choice)

        if not selected_script:
            continue

        # Run selected script
        console.print("\n[bold green]Running selected script...[/bold green]\n")
        output_file = run_script(os_name, selected_script)

        if not output_file:
            console.print(
                f"[bold red]Failed to run the script '{selected_script}'.[/bold red]"
            )
            return

        console.print(
            f"[green][+][/green] Script '[bold]{selected_script}[/bold]' executed. "
            f"Output saved to [blue][underline][bold]{output_file}[/bold][/underline][/blue]"
        )


if __name__ == "__main__":
    main()

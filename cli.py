from rich.console import Console
from scanner.cli import print_header, display_scripts_table, select_script
from scanner.core import detect_os, list_scripts, run_script

console = Console()


def main():
    # Detect operating system
    os_name = detect_os()

    # Print header
    print_header(os_name)

    # Get available scripts
    scripts = list_scripts(os_name)
        
    # Display scripts table
    if not display_scripts_table(scripts):
        console.print(
            f"[bold red]Failed to display available scripts'.[/bold red]"
        )
        return

    # # Select script to run
    # selected_script = select_script(scripts)

    # # Run selected script
    # console.print("\n[bold green]Running selected script...[/bold green]\n")
    # output_file = run_script(os_name, selected_script)

    # if not output_file:
    #     console.print(
    #         f"[bold red]Failed to run the script '{selected_script}'.[/bold red]"
    #     )
    #     return

    # console.print(
    #     f"[green][+][/green] Script '[bold]{selected_script}[/bold]' executed. "
    #     f"Output saved to [blue][underline][bold]{output_file}[/bold][/underline][/blue]"
    # )


if __name__ == "__main__":
    main()

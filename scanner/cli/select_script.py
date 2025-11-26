from rich.console import Console

console = Console()


def select_script(scripts, choice):
    """
    Selector that loops until valid input is provided.
    - User enters ONE script number
    - Returns a single script name as string
    """

    try:
        index = int(choice.strip()) - 1

        if 0 <= index < len(scripts):
                return scripts[index]["filename"]

        console.print("[red]❌ Invalid index. Choose a valid script number.[/red]")

    except ValueError:
        console.print("[red]❌ Invalid input. Enter a number (example: 2)[/red]")

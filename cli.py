from scanner import detect_os, list_scripts, run_script


# ---------------------------
# CLI Interface
# ---------------------------


def main():
    os_name = detect_os()
    print(f"Detected OS: {os_name.upper()}\n")
    
    scripts = list_scripts(os_name)
    if not scripts:
        print(f"No scripts found for {os_name}")
        return
    
    print("Available scripts:")
    for idx, s in enumerate(scripts, 1):
        print(f"{idx}. {s}")
    
    choices = input("\nEnter script numbers to run (comma-separated) or 'all': ")
    
    if choices.strip().lower() == "all":
        selected_scripts = scripts
    else:
        indices = [int(x.strip())-1 for x in choices.split(",")]
        selected_scripts = [scripts[i] for i in indices if 0 <= i < len(scripts)]
    
    for script in selected_scripts:
        run_script(os_name, script)

if __name__ == "__main__":
    main()

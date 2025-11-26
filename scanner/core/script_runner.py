import os
import subprocess
from datetime import datetime

# ---------------------------
# Configuration
# ---------------------------
SCRIPTS_DIR = "scripts"
OUTPUTS_DIR = "outputs"

def list_scripts(os_name):
    folder = os.path.join(SCRIPTS_DIR, os_name)
    scripts = []
    for f in os.listdir(folder):
        if os_name == "windows" and f.endswith(".ps1"):
            scripts.append(f)
        elif os_name in ["macos", "linux"] and f.endswith(".sh"):
            scripts.append(f)
    return scripts


def run_script(os_name, script_name):
    folder = os.path.join(SCRIPTS_DIR, os_name)
    script_path = os.path.join(folder, script_name)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # Ensure output folder exists
    os.makedirs(os.path.join(OUTPUTS_DIR, os_name), exist_ok=True)
    
    # Output file
    output_file = os.path.join(OUTPUTS_DIR, os_name, f"{script_name}_{timestamp}.json")
    
    # Run the script
    try:
        if os_name == "windows":
            # Run PowerShell script
            result = subprocess.run(
                ["powershell", "-ExecutionPolicy", "Bypass", "-File", script_path],
                capture_output=True, text=True
            )
        else:
            # Run shell script
            result = subprocess.run(
                ["bash", script_path],
                capture_output=True, text=True
            )
        
        # Save stdout to JSON file
        with open(output_file, "w") as f:
            f.write(result.stdout)
        
        print(f"[+] Script '{script_name}' executed. Output saved to {output_file}")
    except Exception as e:
        print(f"[!] Failed to run script '{script_name}': {e}")
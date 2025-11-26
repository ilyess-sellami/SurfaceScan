# scanner/utils.py

import os
from scanner.core.script_registry import SCRIPT_REGISTRY
from scanner.core.utils import SCRIPTS_DIR


def list_scripts(os_name):
    """
    Returns a list of scripts with:
    - script_name (base name)
    - category
    - description
    - filename (correct OS extension)
    - full_path
    """

    ext = ".ps1" if os_name == "windows" else ".sh"

    scripts = []

    for entry in SCRIPT_REGISTRY:
        filename = f"{entry['name']}{ext}"
        full_path = os.path.join(SCRIPTS_DIR, os_name, filename)

        scripts.append(
            {
                "name": entry["name"],
                "category": entry["category"],
                "description": entry["description"],
                "filename": filename,
                "full_path": full_path,
            }
        )

    return scripts

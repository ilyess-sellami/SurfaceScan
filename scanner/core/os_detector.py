import platform

def detect_os():
    os_name = platform.system().lower()
    if os_name == "darwin":
        return "macos"
    elif os_name == "windows":
        return "windows"
    elif os_name == "linux":
        return "linux"
    else:
        raise Exception(f"Unsupported OS: {os_name}")
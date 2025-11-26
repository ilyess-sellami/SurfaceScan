def get_os_emoji(os_name):
    
    if "windows" in os_name:
        return "🪟"  # Windows emoji
    elif "macos" in os_name:
        return "🍎"  # macOS emoji
    elif "linux" in os_name:
        return "🐧"  # Linux emoji (Tux)
    else:
        return "💻"  # Default generic computer emoji
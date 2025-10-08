# User Preferences and Environment

## System Access
- **User has sudo privileges** - Always provide exact commands for missing dependencies
- **Platform:** Windows 11 Pro with WSL (Ubuntu/Debian)
- **Shell:** bash

## Command Execution Preferences
- When packages/commands are missing, immediately provide the installation command
- Don't offer workarounds first - give the direct solution
- Format: `sudo apt install <package-name>`
- User will execute commands directly

## Environment
- Working directory: `/mnt/e/repos/atlas/` (WSL) or `E:\repos\atlas\` (Windows)
- Python: Available with sudo for system packages
- Git: Installed
- Docker Desktop: Available

## Examples of Expected Behavior

### ❌ Don't do this:
```
You need python3-venv. You can either:
1. Install with sudo
2. Use alternative setup...
```

### ✅ Do this instead:
```
Run this command:
sudo apt install python3-venv
```

---
*Last updated: 2025-10-06*

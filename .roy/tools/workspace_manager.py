#!/usr/bin/env python3
"""
Roy Workspace Manager

Manages task workspace directories at atlas repository root.

Usage:
    python workspace_manager.py create <task_id> <task_title> <task_description>
    python workspace_manager.py get <task_id>
    python workspace_manager.py list
    python workspace_manager.py update-metadata <task_id> <metadata_updates_json>
"""

import sys
import json
import os
import re
from datetime import datetime
from pathlib import Path
from typing import Dict, Any, Optional

# Configuration
ATLAS_ROOT = Path("/mnt/e/repos/atlas")
ROY_ROOT = Path(__file__).parent.parent.absolute()


def get_et_timestamp() -> str:
    """Get current timestamp in ET timezone."""
    from datetime import timezone, timedelta
    et_offset = timedelta(hours=-5)
    et_tz = timezone(et_offset)
    now_et = datetime.now(et_tz)
    return now_et.strftime("%Y-%m-%d %H:%M:%S %Z")


def generate_directory_name(title: str, existing_dirs: set) -> str:
    """
    Generate unique directory name from task title.

    Format: {category}-{slug}
    Examples: atlas-gap-analysis, tooling-task-decomposition

    Args:
        title: Task title
        existing_dirs: Set of existing directory names

    Returns:
        Unique directory name
    """
    # Extract category from title (first 2-3 words)
    words = re.findall(r'\w+', title.lower())

    # Determine category (first 1-2 words)
    if len(words) >= 2:
        category = words[0]
        if category in ['atlas', 'archon', 'roy', 'bmad', 'gitlab', 'tooling']:
            slug_words = words[1:]
        else:
            slug_words = words
    else:
        category = "task"
        slug_words = words

    # Create slug from remaining words (max 3-4 words)
    slug = '-'.join(slug_words[:4])

    # Combine
    dir_name = f"{category}-{slug}"

    # Ensure uniqueness
    if dir_name in existing_dirs:
        counter = 2
        while f"{dir_name}-{counter}" in existing_dirs:
            counter += 1
        dir_name = f"{dir_name}-{counter}"

    return dir_name


def create_workspace(task_id: str, title: str, description: str) -> Dict[str, Any]:
    """
    Create workspace directory and metadata for task.

    Args:
        task_id: Archon task ID
        title: Task title
        description: Task description

    Returns:
        Workspace metadata dict
    """
    # Get existing directories
    existing_dirs = {d.name for d in ATLAS_ROOT.iterdir() if d.is_dir() and not d.name.startswith('.')}

    # Generate unique directory name
    dir_name = generate_directory_name(title, existing_dirs)
    workspace_path = ATLAS_ROOT / dir_name

    # Create workspace directory structure
    workspace_path.mkdir(exist_ok=False)
    (workspace_path / "artifacts" / "documents").mkdir(parents=True)
    (workspace_path / "artifacts" / "code").mkdir(parents=True)
    (workspace_path / "artifacts" / "data").mkdir(parents=True)
    (workspace_path / "checkpoints").mkdir()

    # Create metadata file
    metadata = {
        "task_id": task_id,
        "directory_name": dir_name,
        "workspace_path": str(workspace_path),
        "created_at": get_et_timestamp(),
        "task_title": title,
        "task_description": description,
        "workflow_state": {
            "current_stage": "initialization",
            "stage_progress": 0,
            "last_updated": get_et_timestamp(),
            "assigned_agents": [],
            "pending_actions": []
        },
        "unit_of_work_log": [],
        "artifacts": {
            "documents": [],
            "code": [],
            "data": []
        },
        "checkpoints": []
    }

    metadata_path = workspace_path / ".roy-metadata.json"
    with open(metadata_path, 'w', encoding='utf-8') as f:
        json.dump(metadata, f, indent=2, ensure_ascii=False)

    # Create README
    readme_content = f"""# Task Workspace: {title}

**Task ID:** `{task_id}`
**Directory:** `{dir_name}`
**Created:** {get_et_timestamp()}

## Description

{description}

## Workspace Structure

```
{dir_name}/
├── .roy-metadata.json          # Task metadata and workflow state
├── artifacts/                  # Generated work products
│   ├── documents/             # Documentation files
│   ├── code/                  # Code files
│   └── data/                  # Data files
├── checkpoints/               # State snapshots for resumption
└── README.md                  # This file
```

## Workflow Status

Current Stage: initialization
Progress: 0%

## Work Units

No work units completed yet.

## Artifacts

No artifacts created yet.
"""

    with open(workspace_path / "README.md", 'w', encoding='utf-8') as f:
        f.write(readme_content)

    return metadata


def get_workspace(task_id: str) -> Optional[Dict[str, Any]]:
    """
    Get workspace metadata for task.

    Args:
        task_id: Archon task ID

    Returns:
        Workspace metadata or None if not found
    """
    # Search for workspace with this task_id
    for d in ATLAS_ROOT.iterdir():
        if d.is_dir() and not d.name.startswith('.'):
            metadata_file = d / ".roy-metadata.json"
            if metadata_file.exists():
                with open(metadata_file, 'r', encoding='utf-8') as f:
                    metadata = json.load(f)
                    if metadata.get("task_id") == task_id:
                        return metadata

    return None


def list_workspaces() -> list:
    """
    List all task workspaces.

    Returns:
        List of workspace metadata dicts
    """
    workspaces = []

    for d in ATLAS_ROOT.iterdir():
        if d.is_dir() and not d.name.startswith('.'):
            metadata_file = d / ".roy-metadata.json"
            if metadata_file.exists():
                with open(metadata_file, 'r', encoding='utf-8') as f:
                    metadata = json.load(f)
                    workspaces.append(metadata)

    return workspaces


def update_metadata(task_id: str, updates: Dict[str, Any]) -> bool:
    """
    Update workspace metadata.

    Args:
        task_id: Archon task ID
        updates: Metadata updates dict

    Returns:
        True if successful, False otherwise
    """
    metadata = get_workspace(task_id)
    if not metadata:
        return False

    workspace_path = Path(metadata["workspace_path"])
    metadata_file = workspace_path / ".roy-metadata.json"

    # Apply updates (deep merge)
    def deep_merge(base, updates):
        for key, value in updates.items():
            if key in base and isinstance(base[key], dict) and isinstance(value, dict):
                deep_merge(base[key], value)
            else:
                base[key] = value

    deep_merge(metadata, updates)

    # Write updated metadata
    with open(metadata_file, 'w', encoding='utf-8') as f:
        json.dump(metadata, f, indent=2, ensure_ascii=False)

    return True


def main():
    """Main entry point."""
    if len(sys.argv) < 2:
        print("Usage: workspace_manager.py <command> [args]")
        print("Commands: create, get, list, update-metadata")
        sys.exit(1)

    command = sys.argv[1]

    if command == "create":
        if len(sys.argv) < 5:
            print("Usage: workspace_manager.py create <task_id> <title> <description>")
            sys.exit(1)

        task_id = sys.argv[2]
        title = sys.argv[3]
        description = sys.argv[4]

        metadata = create_workspace(task_id, title, description)
        print(json.dumps(metadata, indent=2))

    elif command == "get":
        if len(sys.argv) < 3:
            print("Usage: workspace_manager.py get <task_id>")
            sys.exit(1)

        task_id = sys.argv[2]
        metadata = get_workspace(task_id)
        if metadata:
            print(json.dumps(metadata, indent=2))
        else:
            print(f"Workspace not found for task {task_id}", file=sys.stderr)
            sys.exit(1)

    elif command == "list":
        workspaces = list_workspaces()
        print(json.dumps(workspaces, indent=2))

    elif command == "update-metadata":
        if len(sys.argv) < 4:
            print("Usage: workspace_manager.py update-metadata <task_id> <updates_json>")
            sys.exit(1)

        task_id = sys.argv[2]
        updates_json = sys.argv[3]
        updates = json.loads(updates_json)

        if update_metadata(task_id, updates):
            print(f"Metadata updated for task {task_id}")
        else:
            print(f"Failed to update metadata for task {task_id}", file=sys.stderr)
            sys.exit(1)

    else:
        print(f"Unknown command: {command}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()

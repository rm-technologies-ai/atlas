#!/usr/bin/env python3
"""
Roy Task Creator

Creates Archon tasks with TDD-based inference from free-form descriptions.
Generates extended properties for roy framework and GitLab interoperability.

Usage:
    python task_creator.py <project_id> <description>
    python task_creator.py <project_id> <description> --title "Custom Title"
"""

import sys
import json
import os
from datetime import datetime
from pathlib import Path
import requests
from typing import Dict, Any, List, Optional

# Configuration
ARCHON_API_URL = os.getenv("ARCHON_API_URL", "http://localhost:8181")
ATLAS_PROJECT_ID = "3f2b6ee9-05ff-48ae-ad6f-54cad080addc"
ROY_ROOT = Path(__file__).parent.parent.absolute()
EXTENDED_PROPS_DIR = ROY_ROOT / "tasks" / "extended"


def get_et_timestamp() -> str:
    """Get current timestamp in ET timezone formatted string."""
    from datetime import timezone, timedelta

    # ET is UTC-5 (EST) or UTC-4 (EDT), using UTC-5 for simplicity
    et_offset = timedelta(hours=-5)
    et_tz = timezone(et_offset)
    now_et = datetime.now(et_tz)

    return now_et.strftime("%Y-%m-%d %H:%M:%S ET")


def analyze_description_tdd(description: str) -> Dict[str, Any]:
    """
    Analyze task description using TDD principles.

    In actual implementation, this would use LLM inference.
    For now, provides structured template that command will populate.

    Args:
        description: Free-form task description

    Returns:
        Dict with behavior, acceptance_criteria, expected_results
    """
    # This is a template - the actual command implementation will use
    # Claude Code's LLM context to generate these values intelligently
    return {
        "behavior": "TEMPLATE: Describe what this task should accomplish",
        "acceptance_criteria": [
            "TEMPLATE: Testable criterion 1",
            "TEMPLATE: Testable criterion 2",
            "TEMPLATE: Testable criterion 3"
        ],
        "expected_results": [
            "TEMPLATE: Observable outcome 1",
            "TEMPLATE: Observable outcome 2"
        ],
        "test_strategy": "TEMPLATE: Describe how to verify completion",
        "inference_quality": "medium"
    }


def create_archon_task(
    project_id: str,
    title: str,
    description: str,
    status: str = "todo",
    assignee: str = "User",
    feature: Optional[str] = None
) -> Optional[str]:
    """
    Create task in Archon via API.

    Args:
        project_id: Archon project ID
        title: Task title
        description: Task description
        status: Task status (todo, doing, review, done)
        assignee: Task assignee (User, Archon, AI IDE Agent)
        feature: Optional feature name

    Returns:
        Task ID if successful, None otherwise
    """
    url = f"{ARCHON_API_URL}/api/tasks"

    payload = {
        "project_id": project_id,
        "title": title,
        "description": description,
        "status": status,
        "assignee": assignee,
    }

    if feature:
        payload["feature"] = feature

    try:
        response = requests.post(url, json=payload, timeout=10)
        response.raise_for_status()

        task_data = response.json()
        return task_data.get("id")

    except requests.exceptions.RequestException as e:
        print(f"Error creating Archon task: {e}", file=sys.stderr)
        return None


def write_extended_properties(
    task_id: str,
    description: str,
    tdd_analysis: Dict[str, Any],
    gitlab_props: Optional[Dict[str, Any]] = None
) -> Path:
    """
    Write extended properties JSON file for task.

    Args:
        task_id: Archon task ID
        description: Original task description
        tdd_analysis: TDD analysis results
        gitlab_props: Optional GitLab properties

    Returns:
        Path to created JSON file
    """
    EXTENDED_PROPS_DIR.mkdir(parents=True, exist_ok=True)

    extended_props = {
        "roy": {
            "state": "Draft",
            "behavior": tdd_analysis.get("behavior", ""),
            "acceptance_criteria": tdd_analysis.get("acceptance_criteria", []),
            "expected_results": tdd_analysis.get("expected_results", []),
            "inferred_from": description,
            "created_by_command": "/roy-task-create",
            "created_at": get_et_timestamp(),
            "test_strategy": tdd_analysis.get("test_strategy", ""),
            "tags": []
        },
        "tdd": {
            "inference_quality": tdd_analysis.get("inference_quality", "medium")
        }
    }

    if gitlab_props:
        extended_props["gitlab"] = gitlab_props

    file_path = EXTENDED_PROPS_DIR / f"{task_id}.json"

    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(extended_props, f, indent=2, ensure_ascii=False)

    return file_path


def validate_task_creation(task_id: str) -> Dict[str, Any]:
    """
    Validate task creation by querying Archon API and checking extended properties.

    Args:
        task_id: Task ID to validate

    Returns:
        Validation results dict
    """
    results = {
        "task_id": task_id,
        "archon_task_exists": False,
        "extended_props_exists": False,
        "archon_task_data": None,
        "extended_props_data": None,
        "errors": []
    }

    # Check Archon task
    try:
        url = f"{ARCHON_API_URL}/api/tasks/{task_id}"
        response = requests.get(url, timeout=10)
        response.raise_for_status()

        results["archon_task_exists"] = True
        results["archon_task_data"] = response.json()

    except requests.exceptions.RequestException as e:
        results["errors"].append(f"Failed to query Archon task: {e}")

    # Check extended properties
    props_file = EXTENDED_PROPS_DIR / f"{task_id}.json"
    if props_file.exists():
        results["extended_props_exists"] = True
        try:
            with open(props_file, 'r', encoding='utf-8') as f:
                results["extended_props_data"] = json.load(f)
        except Exception as e:
            results["errors"].append(f"Failed to read extended properties: {e}")
    else:
        results["errors"].append(f"Extended properties file not found: {props_file}")

    return results


def main():
    """Main entry point for task creator."""
    if len(sys.argv) < 3:
        print("Usage: python task_creator.py <project_id> <description> [--title \"Custom Title\"]")
        print("Example: python task_creator.py 3f2b6ee9... \"Implement user authentication\"")
        sys.exit(1)

    project_id = sys.argv[1]
    description = sys.argv[2]

    # Parse optional title
    title = None
    if len(sys.argv) >= 5 and sys.argv[3] == "--title":
        title = sys.argv[4]
    else:
        # Generate title from first 50 chars of description
        title = description[:50] + ("..." if len(description) > 50 else "")

    print(f"Creating task with TDD analysis...")
    print(f"Project ID: {project_id}")
    print(f"Title: {title}")
    print(f"Description: {description}")
    print()

    # Analyze description using TDD
    tdd_analysis = analyze_description_tdd(description)

    # Create task in Archon
    task_id = create_archon_task(
        project_id=project_id,
        title=title,
        description=description,
        status="todo",
        assignee="User"
    )

    if not task_id:
        print("ERROR: Failed to create Archon task", file=sys.stderr)
        sys.exit(1)

    print(f"✅ Created Archon task: {task_id}")

    # Write extended properties
    props_file = write_extended_properties(task_id, description, tdd_analysis)
    print(f"✅ Created extended properties: {props_file}")

    # Validate creation
    print("\nValidating task creation...")
    validation = validate_task_creation(task_id)

    if validation["errors"]:
        print("⚠️  Validation errors:")
        for error in validation["errors"]:
            print(f"  - {error}")

    if validation["archon_task_exists"]:
        print("✅ Archon task exists and is queryable")
        task_data = validation["archon_task_data"]
        print(f"   - Title: {task_data.get('title')}")
        print(f"   - Status: {task_data.get('status')}")
        print(f"   - Assignee: {task_data.get('assignee')}")

    if validation["extended_props_exists"]:
        print("✅ Extended properties file exists")
        props = validation["extended_props_data"]
        roy_props = props.get("roy", {})
        print(f"   - State: {roy_props.get('state')}")
        print(f"   - Behavior: {roy_props.get('behavior')[:60]}...")
        print(f"   - Acceptance criteria: {len(roy_props.get('acceptance_criteria', []))} items")
        print(f"   - Expected results: {len(roy_props.get('expected_results', []))} items")

    print(f"\n🎉 Task created successfully!")
    print(f"Task ID: {task_id}")
    print(f"\nNext steps:")
    print(f"1. Query task: archon:find_tasks(task_id=\"{task_id}\")")
    print(f"2. View extended props: cat {props_file}")
    print(f"3. Promote to Active when ready to work on it")


if __name__ == "__main__":
    main()

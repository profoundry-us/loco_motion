#!/usr/bin/env python3
"""
Validates that the current git branch follows LocoMotion naming conventions.

Convention:
  {type}-{description}
  {type}-{issue_number}-{description}   (issue number is optional)

Valid types: feat, bug, fix, task, chore, docs, refactor, claude

Usage:
  python check_branch.py
  python check_branch.py feat-add-button-component
  python check_branch.py feat-123-add-button-component
"""

import re
import subprocess
import sys

VALID_TYPES = ["feat", "bug", "fix", "task", "chore", "docs", "refactor", "claude"]

# Matches: {type}-{optional: digits-}{description}
BRANCH_RE = re.compile(r"^([a-z]+)-(\d+-)?([a-z0-9]+(?:-[a-z0-9]+)*)$")


def current_branch() -> str:
    result = subprocess.run(
        ["git", "branch", "--show-current"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"error: could not read git branch — {result.stderr.strip()}", file=sys.stderr)
        sys.exit(1)
    return result.stdout.strip()


def validate(branch: str) -> None:
    if not branch:
        print("error: branch name is empty", file=sys.stderr)
        sys.exit(1)

    if branch == "main":
        print("error: you are on 'main' — switch to a feature branch first", file=sys.stderr)
        sys.exit(2)

    m = BRANCH_RE.match(branch)
    if not m:
        print(f"error: '{branch}' does not match the naming convention", file=sys.stderr)
        print("  expected : feat-add-button  or  feat-123-add-button", file=sys.stderr)
        print(f"  valid types: {', '.join(VALID_TYPES)}", file=sys.stderr)
        sys.exit(3)

    branch_type, issue_part, description = m.group(1), m.group(2), m.group(3)

    if branch_type not in VALID_TYPES:
        print(f"error: type '{branch_type}' is not valid", file=sys.stderr)
        print(f"  valid types: {', '.join(VALID_TYPES)}", file=sys.stderr)
        sys.exit(4)

    issue_num = issue_part.rstrip("-") if issue_part else None

    print(f"branch      : {branch}")
    print(f"  type      : {branch_type}")
    if issue_num:
        print(f"  issue     : #{issue_num}")
    print(f"  description: {description}")
    print("ok: branch name follows convention")


if __name__ == "__main__":
    branch = sys.argv[1] if len(sys.argv) > 1 else current_branch()
    validate(branch)

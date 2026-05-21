#!/usr/bin/env python3
"""
Validates that all required files exist for a LocoMotion component and that
the component is registered in lib/loco_motion/helpers.rb.

Usage:
  python validate_component.py <component_name> <component_group>

Examples:
  python validate_component.py button actions
  python validate_component.py text_input data_input
  python validate_component.py card data_display
"""

import sys
from pathlib import Path


def pluralize(name: str) -> str:
    """Basic English pluralization for component names."""
    if name.endswith("y"):
        return name[:-1] + "ies"
    if name.endswith(("s", "x", "z")) or name.endswith(("ch", "sh")):
        return name + "es"
    return name + "s"


def pascal(snake: str) -> str:
    return "".join(word.capitalize() for word in snake.split("_"))


def find_root() -> Path:
    """Walk up from cwd until we find the justfile (project root)."""
    here = Path.cwd()
    for candidate in [here, *here.parents]:
        if (candidate / "justfile").exists():
            return candidate
    return here


def main() -> None:
    if len(sys.argv) < 3:
        print("usage: validate_component.py <component_name> <component_group>", file=sys.stderr)
        print("", file=sys.stderr)
        print("examples:", file=sys.stderr)
        print("  python validate_component.py button actions", file=sys.stderr)
        print("  python validate_component.py text_input data_input", file=sys.stderr)
        sys.exit(1)

    name, group = sys.argv[1], sys.argv[2]
    root = find_root()

    module_group = pascal(group)
    class_name = pascal(name)
    plural = pluralize(name)
    component_class = f"Daisy::{module_group}::{class_name}Component"

    print(f"validating  : {name}  (group: {group})")
    print(f"class       : {component_class}\n")

    required = [
        root / "app" / "components" / "daisy" / group / f"{name}_component.rb",
        root / "app" / "components" / "daisy" / group / f"{name}_component.html.haml",
        root / "spec" / "components" / "daisy" / group / f"{name}_component_spec.rb",
        root / "docs" / "demo" / "app" / "views" / "examples" / "daisy" / group / f"{plural}.html.haml",
    ]

    all_ok = True

    for path in required:
        ok = path.exists()
        all_ok = all_ok and ok
        mark = "✓" if ok else "✗"
        print(f"  {mark}  {path.relative_to(root)}")

    # Check helpers.rb
    helpers = root / "lib" / "loco_motion" / "helpers.rb"
    if helpers.exists():
        registered = component_class in helpers.read_text()
        all_ok = all_ok and registered
        mark = "✓" if registered else "✗"
        print(f"  {mark}  registered in lib/loco_motion/helpers.rb")
    else:
        print("  ?  lib/loco_motion/helpers.rb not found", file=sys.stderr)

    print()
    if all_ok:
        print("all checks passed")
    else:
        print("some files are missing — see the new-component skill")
        sys.exit(1)


if __name__ == "__main__":
    main()

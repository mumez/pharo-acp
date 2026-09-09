#!/usr/bin/env python3
"""Copy the ACP-* Tonel packages to ACP2-* and rename ACPXxx classes to ACP2Xxx.

Usage: python3 scripts/make_acp2.py [--src <repo-root>]

Regenerable step 1-2 of the ACP v2 support plan (see CLAUDE.local.md):
  1. Copy every src/ACP-* package directory to src/ACP2-*.
  2. Rewrite every ACPXxx-shaped identifier (class names, method categories,
     Tonel file names, package.st/class-definition references, comments) to
     ACP2Xxx, and every ACP-Xxx package/category name to ACP2-Xxx.

Existing src/ACP2-* directories are removed and regenerated so the script is
safe to re-run after src/ACP-* changes.
"""
import argparse
import re
import shutil
from pathlib import Path

# ACPXxx / ACPXxxYyy identifiers -> ACP2Xxx / ACP2XxxYyy
CLASS_NAME_RE = re.compile(r"\bACP(?=[A-Z][A-Za-z0-9]*)")
# ACP-Xxx package/category names -> ACP2-Xxx (e.g. 'ACP-Client', '*ACP-Transport')
PACKAGE_NAME_RE = re.compile(r"\bACP-(?=[A-Z][A-Za-z0-9]*)")


def rename_text(text: str) -> str:
    text = PACKAGE_NAME_RE.sub("ACP2-", text)
    text = CLASS_NAME_RE.sub("ACP2", text)
    return text


def rename_filename(name: str) -> str:
    return rename_text(name)


def convert_package(src_dir: Path, dest_dir: Path) -> None:
    if dest_dir.exists():
        shutil.rmtree(dest_dir)
    dest_dir.mkdir(parents=True)
    for src_file in sorted(src_dir.iterdir()):
        if not src_file.is_file():
            continue
        dest_name = rename_filename(src_file.name)
        dest_file = dest_dir / dest_name
        content = src_file.read_text(encoding="utf-8")
        dest_file.write_text(rename_text(content), encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--src",
        type=Path,
        default=Path(__file__).resolve().parent.parent,
        help="Repository root containing src/ (default: repo root inferred from script location)",
    )
    args = parser.parse_args()

    src_root = args.src / "src"
    packages = sorted(
        p for p in src_root.iterdir()
        if p.is_dir() and p.name.startswith("ACP-")
    )
    if not packages:
        raise SystemExit(f"No ACP-* packages found under {src_root}")

    for package_dir in packages:
        dest_name = rename_filename(package_dir.name)
        dest_dir = src_root / dest_name
        convert_package(package_dir, dest_dir)
        print(f"{package_dir.name} -> {dest_name} ({len(list(dest_dir.iterdir()))} files)")


if __name__ == "__main__":
    main()

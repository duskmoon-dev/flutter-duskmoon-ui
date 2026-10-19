#!/usr/bin/env python3
"""Check Pub's actual archives against pub.dev's unpacked 256 MiB limit."""

import argparse
import gzip
from pathlib import Path
import subprocess
import sys
import tempfile
import zlib


MAX_UNPACKED_BYTES = 268435456


def check_archive(archive: Path, name: str) -> bool:
    # Count the whole tar stream, including headers and padding, not just files.
    unpacked_bytes = 0
    with gzip.open(archive, "rb") as stream:
        while chunk := stream.read(1024 * 1024):
            unpacked_bytes += len(chunk)
    accepted = unpacked_bytes < MAX_UNPACKED_BYTES
    print(
        f"{'PASS' if accepted else 'FAIL'} {name}: "
        f"{unpacked_bytes:,} unpacked tar bytes "
        f"(must be below {MAX_UNPACKED_BYTES:,})",
        flush=True,
    )
    return accepted


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--archive",
        type=Path,
        action="append",
        help="Check an existing .tar.gz instead of exporting workspace packages.",
    )
    args = parser.parse_args()
    if args.archive:
        return int(not all(check_archive(path, str(path)) for path in args.archive))

    root = Path(__file__).resolve().parent.parent
    packages = sorted(path.parent for path in (root / "packages").glob("*/pubspec.yaml"))
    if not packages:
        parser.error("No workspace packages found")
    accepted = True
    with tempfile.TemporaryDirectory(prefix="pub-archive-size-") as temporary:
        for package in packages:
            archive = Path(temporary) / f"{package.name}.tar.gz"
            log = Path(temporary) / f"{package.name}.log"
            print(f"Exporting and validating {package.name} with Pub...", flush=True)
            with log.open("w") as output:
                # --to-archive validates and exports without uploading. --dry-run
                # would prevent writing; --skip-validation must not be used here.
                result = subprocess.run(
                    ["flutter", "pub", "publish", f"--to-archive={archive}"],
                    cwd=package,
                    stdout=output,
                    stderr=subprocess.STDOUT,
                )
            if result.returncode != 0 or not archive.is_file():
                print(log.read_text(), file=sys.stderr)
                print(f"FAIL: Pub did not export {package.name}", file=sys.stderr)
                return 1
            accepted = check_archive(archive, package.name) and accepted
    return int(not accepted)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, EOFError, zlib.error) as error:
        print(f"FAIL: Cannot check package archive: {error}", file=sys.stderr)
        sys.exit(1)

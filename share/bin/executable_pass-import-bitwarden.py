#!/usr/bin/env python3

# Import Bitwarden CSV file into the pass password manager.

import csv
import subprocess
import sys


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <bitwarden-csv-file>", file=sys.stderr)
        sys.exit(1)

    csv_path = sys.argv[1]

    with open(csv_path) as f:
        for row in csv.DictReader(f):
            name = row["name"]
            username = row["login_username"]
            password = row["login_password"]
            notes = row.get("notes", "")

            content = f"{password}\nlogin: {username}\n\n{notes}\n"

            subprocess.run(
                ["pass", "insert", "--force", "--multiline", name],
                input=content.encode(),
                check=True,
            )


if __name__ == "__main__":
    main()

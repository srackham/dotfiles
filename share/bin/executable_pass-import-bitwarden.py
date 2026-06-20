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
            website = row["login_uri"]
            notes = row.get("notes", "")

            if row.get("type") == "note":
                content = f"{notes}\n"
                pass_name = f"notes/{name}"
            else:
                content = (
                    f"{password}\nlogin: {username}\nwebsite: {website}\n\n{notes}\n"
                )
                pass_name = f"logins/{name}"

            subprocess.run(
                ["pass", "insert", "--force", "--multiline", pass_name],
                input=content.encode(),
                check=True,
            )

    answer = input(f"Shred and delete '{csv_path}'? [Y/n] ").strip().lower()
    if answer in ("", "y", "yes"):
        subprocess.run(["shred", "--remove", csv_path], check=True)
        print(f"Shredded and deleted '{csv_path}'.")


if __name__ == "__main__":
    main()

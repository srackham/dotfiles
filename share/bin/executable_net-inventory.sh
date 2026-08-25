#!/usr/bin/env bash

# LAN inventory: IP, MAC address, hostname, and manufacturer.
# Usage: sudo ./lan-inventory.sh 192.168.1.0/24

sudo nmap -sn -R -oX - 192.168.1.0/24 |
python3 -c '
import sys, csv
import xml.etree.ElementTree as ET

out = csv.writer(sys.stdout)
out.writerow(["IP", "MAC Address", "Name", "Manufacturer"])

for host in ET.parse(sys.stdin).getroot().findall("host"):
    if host.find("status").get("state") != "up":
        continue

    ip = mac = manufacturer = name = ""

    for address in host.findall("address"):
        if address.get("addrtype") == "ipv4":
            ip = address.get("addr", "")
        elif address.get("addrtype") == "mac":
            mac = address.get("addr", "")
            manufacturer = address.get("vendor", "")

    hostname = host.find("./hostnames/hostname")
    if hostname is not None:
        name = hostname.get("name", "")

    out.writerow([ip, mac, name, manufacturer])
'

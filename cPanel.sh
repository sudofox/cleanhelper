#!/bin/bash

# sudofox/cleanhelper - cPanel servers.

printf "## Easy things to cleanup\n"
# /home/temp - LW tempdir
printf $(du -hc /home/temp|tail -1|awk '{print $1}')"\t/home/temp - Liquid Web temporary file directory\n"
# cPanel trash dirs
echo "## cPanel trash folders"
du -sh -t20k /home/*/.trash 2>/dev/null
# Softaculous Backups
echo "## Softaculous backups (cPanel backups recommended instead)"
du -sh -t20M /home/*/softaculous_backups 2>/dev/null
# Copies of public_html
printf "## Old copies of public_html\n"
du -sh /home/*/public_html?* 2>/dev/null
du -sh /home/*/*?public_html 2>/dev/null
printf "## .tar.gz files in /home directories - old cPanel backups?\n"
du -sh /home/*/*.tar.gz 2>/dev/null
du -sh /home/*.tar.gz 2>/dev/null

# TODO: This is too slow
printf "## Large error_logs (>30MB) within cPanel accounts (public_html)\n"
find /home/* -path /home/virtfs -prune -o -type f -name error_log -size +30M |grep -v virtfs|xargs -r -L1 du -sh


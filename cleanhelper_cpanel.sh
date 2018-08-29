#!/bin/bash

# sudofox/cleanhelper - for cPanel servers.

# TODO: du's -t flag doesn't work on RHEL/CentOS 6 and earlier, find alternative or detect CentOS 6 and earlier to compensate

printf "## Easy things to cleanup\n"

if [ -d /home/temp ]; then # LW server
	# /home/temp - tempdir
	printf $(du -hc /home/temp|tail -1|awk '{print $1}')"\t/home/temp - LW temporary file directory\n"
fi;

# cPanel backups (default backup folder is /backup)
# todo: find way to check backup location in case it's not in /backup

printf "## cPanel backups (/backup)\n"
du -sh /backup/* /backup/ 2>/dev/null

# cPanel trash dirs
printf "## cPanel trash folders\n"
#du -sh -t20k /home/*/.trash 2>/dev/null
du -sh /home/*/.trash 2>/dev/null |egrep "(M|G)[[:space:]]"

# Softaculous Backups
printf "## Softaculous backups (cPanel backups recommended instead)\n"
#du -sh -t20M /home/*/softaculous_backups 2>/dev/null
du -sh /home/*/softaculous_backups 2>/dev/null | egrep "(M|G)[[:space:]]"

# Copies of public_html
printf "## Old copies of public_html\n"
du -sh /home/*/public_html?* 2>/dev/null
du -sh /home/*/*?public_html 2>/dev/null

printf "## .tar.gz files in /home directories - old cPanel backups?\n"
du -sh /home/*/*.tar.gz 2>/dev/null
du -sh /home/*.tar.gz 2>/dev/null

printf "## .zip files in /home directories - old manually-made backups?\n"
du -sh /home/*/*.zip 2>/dev/null|sort -h

printf "## Large PHP-FPM error logs\n"
ls -lhGS /home/*/logs/*php.error.log 2>/dev/null|tac|tail -n20|awk '{print $4" "$8}'|column -t

printf "## Failed uploads for cPanel File Manager\n"
du -sh /home/*/tmp/Cpanel_Form_file.upload* 2>/dev/null|egrep "([0-9]{1}G|[0-9]{2}M)[[:space:]]" |sort -h

printf "## Old/failed ImageMagick temp files\n"
du -sh /home/*/tmp/img?????? 2>/dev/null|egrep "([0-9]{1}G|[0-9]{1}M)[[:space:]]" |sort -h

printf "## Old Roundcube mail attachment temp files\n"
du -sh /home/*/tmp/rcmAttmnt* 2>/dev/null|egrep "([0-9]{1}G|[0-9]{2}M)[[:space:]]" |sort -h

printf "## Old Horde Mail drafts (more than 10 MB in size)\n"
du -sh /home/*/tmp/horde/.horde/imp/compose/*-*-* 2>/dev/null|egrep "([0-9]{1}G|[0-9]{2}M)[[:space:]]" |sort -h

printf "## Horde ImageMagick temp files\n"
du -sh /home/*/tmp/horde/img?????? 2>/dev/null|egrep "([0-9]{1}G|[0-9]{1}M)[[:space:]]" |sort -h

printf "## Updraft backups\n"
du -sh /home/*/*/*/wp-content/updraft /home/*/public_html/wp-content/updraft /home/*/*/wp-content/updraft /home/*/public_html/*/wp-content/updraft 2>/dev/null|sort -h|uniq

printf "## Akeeba backups\n"
du -sh /home/*/*/*/administrator/components/com_akeeba/backup /home/*/public_html/administrator/components/com_akeeba/backup /home/*/*/administrator/components/com_akeeba/backup /home/*/public_html/*/administrator/components/com_akeeba/backup 2>/dev/null|sort -h|uniq

printf "## ai1wm-backups\n"
du -sh /home/*/*/*/wp-content/ai1wm-backups /home/*/public_html/wp-content/ai1wm-backups /home/*/*/wp-content/ai1wm-backups /home/*/public_html/*/wp-content/ai1wm-backups 2>/dev/null|sort -h 

printf "## BackupBuddy backups\n"
du -sh /home/*/*/*/wp-content/uploads/backupbuddy_backups /home/*/public_html/wp-content/uploads/backupbuddy_backups /home/*/*/wp-content/uploads/backupbuddy_backups /home/*/public_html/*/wp-content/uploads/backupbuddy_backups 2>/dev/null|sort -h

printf "## BackWPup backups\n"
du -sh /home/*/*/*/wp-content/uploads/backwpup-??????-backups /home/*/public_html/wp-content/uploads/backwpup-??????-backups /home/*/*/wp-content/uploads/backwpup-??????-backups /home/*/public_html/*/wp-content/uploads/backwpup-??????-backups 2>/dev/null|sort -h 

printf "## envato-backups\n"

du -sh /home/*/*/*/wp-content/envato-backups /home/*/public_html/wp-content/envato-backups /home/*/*/wp-content/envato-backups /home/*/public_html/*/wp-content/envato-backups 2>/dev/null |sort -h

printf "## WP-DBManager\n"
du -sh /home/*/*/*/wp-content/backup-db /home/*/public_html/wp-content/backup-db /home/*/*/wp-content/backup-db /home/*/public_html/*/wp-content/backup-db 2>/dev/null |sort -h

printf "## BackUpWordPress\n"
du -sh /home/*/*/*/wp-content/backupwordpress-??????????-backups /home/*/public_html/wp-content/backupwordpress-??????????-backups /home/*/*/wp-content/backupwordpress-??????????-backups /home/*/public_html/*/wp-content/backupwordpress-??????????-backups 2>/dev/null |sort -h
du -sh /home/*/*/*/wp-content/??????????-backups /home/*/public_html/wp-content/??????????-backups /home/*/*/wp-content/??????????-backups /home/*/public_html/*/wp-content/??????????-backups 2>/dev/null |sort -h

printf "## .Trash, .spam, .Junk IMAP folders\n"
du -sh /home/*/mail/*.*/*/.Trash /home/*/mail/*/*/.spam/ /home/*/mail/*.*/*/.Junk 2>/dev/null|egrep "([0-9]{1}G|[0-9]{2}M)[[:space:]]"

printf "## Failed/partially created zip files\n"
du -sh /home/*/zi?????? /home/*/*/zi?????? /home/*/*/zi?????? /home/*/*/*/zi?????? 2>/dev/null| grep -v "/home/virtfs/" | sort -h

printf "## zip files > 100 MB\n"
find /home -type f -size +100M|grep -v virtfs|grep "\.zip"|tr '\n' '\0' |xargs -0 du -sh|sort -h

# TODO: This is too slow
printf "## Large error_logs (>30MB) within cPanel accounts (public_html)\n"
find /home/* -path /home/virtfs -prune -o -type f -name error_log -size +30M |grep -v virtfs|xargs -r -L1 du -sh


# sudofox/cleanhelper

Informational utility to accelerate disk cleanup on various systems. Right now it is designed for cPanel servers.

This is more of a "quick glance-over" tool as it does not search every possible place (to save time).

### Currently looks for

#### CMS Backup Plugins

- ai1wm-backups
- Akeeba backups
- BackupBuddy backups
- BackUpWordPress backups
- BackWPup backups
- envato-backups
- Updraft backups
- WP-DBManager backups
- Softaculous backups

#### Large error logs

- Large error_logs (>30MB) within cPanel accounts (public_html)
- Large PHP-FPM error logs

#### Trash/Junk

- cPanel trash folders
- .Trash, .spam, .Junk IMAP folders

#### Old backups

- MySQL database dumps that failed to import from a cPanel backup restoration
- Old copies of public_html
- .tar.gz files in /home directories - old cPanel backups?
- zip files > 100 MB
- .zip files in /home directories - old manually-made backups?

#### Old temp files

- Horde ImageMagick temp files
- Old/failed ImageMagick temp files
- Old Horde Mail drafts (more than 10 MB in size)
- Old Roundcube mail attachment temp files

#### Broken files

- Failed/partially created zip files
- Failed uploads for cPanel File Manager
- PHP Core dumps (can be removed)
- Size of yum package-manager cache ( /var/cache/yum ) -- clean if over 200-300 MB

#### Logs

- journalctl log size (do not wipe entirely, vacuum down to a smaller size if needed)

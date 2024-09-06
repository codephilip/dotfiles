# Bash Workflows

This repository contains various Bash scripts organized by their function and purpose.

## Folder Structure

- `backups/`: Scripts for backing up data.

  - `daily_backup.sh`: Daily backups of important directories using rsync.
  - `weekly_backup.sh`: Weekly backups by creating compressed archives of important directories.
  - `monthly_backup.sh`: Monthly backups by creating compressed archives of important directories.

- `logs/`: Scripts for managing logs.

  - `log_cleanup.sh`: Cleanup old log files to free up disk space.
  - `system_monitor.sh`: Monitor system performance metrics and log them.
  - `uptime_logger.sh`: Log system uptime once a day.

- `monitoring/`: Scripts for monitoring system metrics.

  - `cpu_monitor.sh`: Monitor CPU usage and send a notification if usage exceeds a threshold.
  - `disk_usage_alert.sh`: Monitor disk usage and send a notification if usage exceeds a threshold.
  - `network_monitor.sh`: Monitor network usage and log the data rates.
  - `website_status_check.sh`: Check the status of a website and log the status code.

- `notifications/`: Scripts for sending notifications.

  - `email_notify.sh`: Send an email notification with a specified subject and message.
  - `push_notify.sh`: Send a push notification using the Pushover API.
  - `sms_notify.sh`: Send an SMS notification using the Twilio API.

- `environment_setup/`: Scripts for setting up environments.

  - `dev_env_setup.sh`: Set up the development environment.
  - `prod_env_setup.sh`: Set up the production environment.
  - `test_env_setup.sh`: Set up the testing environment.

- `file_management/`: Scripts for managing files.

  - `organize_downloads.sh`: Organize the Downloads directory by moving files to specific subdirectories.
  - `rename_files.sh`: Rename files in a target directory by adding a timestamp to their filenames.
  - `sync_files.sh`: Synchronize files between a source directory and a destination directory using rsync.

- `utilities/`: Miscellaneous utility scripts.
  - `alias_setup.sh`: Set up custom aliases for common commands.
  - `custom_greeting.sh`: Display a custom greeting message with system information.
  - `update_system.sh`: Update system packages and perform a cleanup.

## Usage

1. **Source Aliases and Functions**: Add the following line to your `~/.bashrc` or `~/.bash_profile` to source custom aliases and functions.
   ```bash
   source ~/.config/bash/utilities/alias_setup.sh
   ```

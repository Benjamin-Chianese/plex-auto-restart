# Plex Media Server Auto-Restart Script

This Bash script allows you to automatically restart Plex Media Server when no users are currently watching, using Tautulli to monitor Plex activity.

## Installation

### Prerequisites

- **Tautulli Configuration**:
  - Obtain your Tautulli API Key for accessing Plex activity information.
  - Specify the URL of your Tautulli instance in the `TAUTULLI_URL` variable.

- **Discord Notifications (Optional)**:
  - If you want to receive notifications on Discord, set up a Discord webhook and provide its URL in the `DISCORD_WEBHOOK_URL` variable.

- **Dependencies**:
  - Make sure you have `jq` installed. You can install it with:
    ```bash
    sudo apt-get install jq   # For Debian/Ubuntu
    ```

### Script Configuration

- Open the script `plex_restart.sh` in a text editor.
- Configure the following variables:


# Tautulli Configuration
TAUTULLI_API_KEY="your_tautulli_api_key"
TAUTULLI_URL="https://your-tautulli-instance-url"

# Discord Notifications (optional)
DISCORD_WEBHOOK_URL="your_discord_webhook_url"

# Set DEBUG to true to enable debugging
DEBUG=false

# Maximum number of restart attempts
MAX_RESTART_ATTEMPTS=5

# Wait time between restart attempts (1 hour = 3600 seconds)
WAIT_TIME_SECONDS=3600

Usage

    Ensure that the script's configuration variables are correctly set.

    Open a terminal and navigate to the directory containing plex_restart.sh.

    Run the script using the command: ./plex_restart.sh.

    The script will check if any users are currently watching Plex using Tautulli. If no users are watching, it will restart Plex.

    If the restart fails, the script will retry up to MAX_RESTART_ATTEMPTS times, waiting WAIT_TIME_SECONDS seconds between attempts.

    You can monitor the script's progress and any Discord notifications to determine whether the restart was successful or failed.

Automation (Cron Job)

To automate the script to run at specific intervals, you can set up a Cron job:

    Open a terminal.

    Edit your crontab file with the command:

    bash

crontab -e

Add the following line to schedule the script to run every Sunday at a specific time (e.g., 2:00 AM):

bash

    0 2 * * 0 /path/to/plex_restart.sh

    Make sure to replace /path/to/plex_restart.sh with the actual path to your script file.

    Save and exit the crontab editor.

The script will now run automatically every Sunday at the specified time. Adjust the Cron schedule to your desired frequency and time.
License

This script is provided under the MIT License. See the LICENSE file for more information.

css


This README provides clear installation instructions and usage guidelines, and you ca

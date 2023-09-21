#!/bin/bash

# Tautulli Configuration
TAUTULLI_API_KEY="your_tautulli_api_key"
TAUTULLI_URL="https://your-tautulli-instance-url"

# Discord Webhook Configuration (if needed)
DISCORD_WEBHOOK_URL="your_discord_webhook_url"

# Set DEBUG to true to enable debugging
DEBUG=false

# Maximum number of restart attempts
MAX_RESTART_ATTEMPTS=5

# Wait time between restart attempts (1 hour = 3600 seconds)
WAIT_TIME_SECONDS=3600

# Debugging function
debug() {
    if [ "$DEBUG" = true ]; then
        echo "[DEBUG] $1"
    fi
}

# Function to restart Plex Media Server
restart_plex() {
    debug "Restarting Plex Media Server..."
    if [ "$DEBUG" = false ]; then
        systemctl restart plexmediaserver
    fi
    debug "Plex Media Server restarted successfully."
}

# Function to send a Discord message (if needed)
send_discord_message() {
    local message="$1"
    debug "Sending a Discord message: $message"
    if [ "$DEBUG" = false ]; then
        curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"$message\"}" "$DISCORD_WEBHOOK_URL"
    fi
}

# Function to check if users are currently watching Plex
check_users_watching() {
    local tautulli_response
    tautulli_response=$(curl -s "${TAUTULLI_URL}/api/v2?apikey=${TAUTULLI_API_KEY}&cmd=get_activity")

    # Adding the following line to display the complete Tautulli response in debug mode
    debug "Tautulli Response: $tautulli_response"

    local session_count
    session_count=$(echo "$tautulli_response" | jq -r '.response.data.sessions | length')

    debug "Number of sessions in progress: $session_count"

    # Check if session_count is a valid integer
    if [[ "$session_count" =~ ^[0-9]+$ ]]; then
        if [ "$session_count" -eq 0 ]; then
            return 1  # Restart Plex when no one is watching
        else
            return 0  # Do not restart Plex if there are users currently watching
        fi
    else
        return 1  # Restart Plex in case of an error
    fi
}

# Main program

# Send a Discord message at script launch
send_discord_message "The Plex Media Server restart script has been launched."

attempt=1
while [ $attempt -le $MAX_RESTART_ATTEMPTS ]; do
    if check_users_watching; then
        debug "Users are currently watching. Restart is canceled."
    else
        restart_plex
        send_discord_message "Plex Media Server was restarted successfully (Attempt $attempt/$MAX_RESTART_ATTEMPTS)."
        break
    fi

    if [ $attempt -lt $MAX_RESTART_ATTEMPTS ]; then
        debug "Waiting for 1 hour before the next attempt..."
        sleep $WAIT_TIME_SECONDS  # Wait for 1 hour (3600 seconds) before the next attempt
        send_discord_message "Attempt $attempt to restart Plex Media Server in progress..."
    fi

    ((attempt++))
done

if [ $attempt -gt $MAX_RESTART_ATTEMPTS ]; then
    debug "Restart failed after $MAX_RESTART_ATTEMPTS attempts."
    send_discord_message "Plex Media Server restart failed after $MAX_RESTART_ATTEMPTS attempts."
fi

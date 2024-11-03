
# Jail System for FiveM

This is a jail system script for FiveM servers using the ESX framework. The system allows police officers to send players to jail for a specified amount of time, log jailing events to a Discord webhook, and save player jail data in your database.

## Features

- Allows police officers to send players to jail with a custom time duration
- Displays jail time and notifications to the jailed player
- Automatically releases players after serving their jail time
- Saves player jail data to your database
- Logs all jailing and release events to a Discord channel via a webhook

## Requirements

- **FiveM Server**: Ensure you have a running FiveM server.
- **ESX Framework**: This script relies on ESX for job checking. Make sure ESX is installed on your server.
- **ox_lib**: Used for additional helper functions (like job checking).
- **Discord Webhook**: To log jail events to a Discord channel, set up a webhook in your Discord server.

## Installation

1. **Download the Script**: Clone or download this script and place it in your `resources` folder. Rename the folder to `jail_system`.

2. **Dependencies**: Ensure that both `es_extended` and `ox_lib` resources are installed and properly configured on your server.

3. **Configure Webhook URL**: Open `server.lua` and locate the following line:

   ```lua
   local discordWebhook = "YOUR_DISCORD_WEBHOOK_URL"
   ```

   Replace `YOUR_DISCORD_WEBHOOK_URL` with the webhook URL from your Discord server.

4. **Add to Server Config**: In your `server.cfg` file, add `jail_system` to the list of resources to start the script:

   ```plaintext
   ensure jail_system
   ```

5. **SQL**: The script saves jail data in your sql database. To use that, you have to put the SQL file into your database. That will create you a table called jailed_players, so if a player disconnect or you restart your server the player continues his jail time.

## Usage

### Commands

- **/jail [playerID]**: Allows a police officer to open a menu to jail a player by specifying the time in minutes. Only users with the **police job** can execute this command.


### Configurable Locations

The jail and release locations can be modified in `client.lua`:

- **Jail Coordinates**: Update `jailCoords` in `client.lua` to set the jail location.
- **Release Coordinates**: Update `releaseCoords` in `client.lua` to set the player release location.

### Discord Logs

When a player is jailed or released, a log is sent to the configured Discord webhook. The log includes:

- Jailed player name and ID
- Officer name and ID who issued the jail
- Jail time in minutes
- Release time upon completion

## Important Notes


- **Player Identifiers**: The script uses the player’s license as a unique identifier for tracking jail time.
- **Database Required**: SQL File 

## Troubleshooting

- **Command Access**: Only players with the police job (set in ESX) can access jail commands. Make sure the police job is correctly set up in ESX.
- **Discord Logs Not Working**: Verify that the webhook URL is correct and the Discord server permissions allow messages from the webhook.


local discordWebhook = ""YOUR_DISCORD_WEBHOOK_URL""


local function sendDiscordLog(embed)
    PerformHttpRequest(discordWebhook, function(err, text, headers) end, "POST", json.encode({ embeds = { embed } }), { ["Content-Type"] = "application/json" })
end


RegisterCommand("jail", function(source, args)
    local src = source
    local playerId = tonumber(args[1])

    if not playerId or not GetPlayerName(playerId) then
        TriggerClientEvent("chat:addMessage", src, { args = { "System", "Invalid player ID." } })
        return
    end

    local xPlayer = exports['es_extended']:getSharedObject().GetPlayerFromId(src)
    if not xPlayer or xPlayer.job.name ~= "police" then
        TriggerClientEvent("chat:addMessage", src, { args = { "System", "You must be a police officer to use this command." } })
        return
    end


    TriggerClientEvent("jail:openJailMenu", src, playerId)
end)


RegisterNetEvent("jail:sendPlayerToJail", function(playerId, jailTime, jailerId)
    local playerLicense = GetPlayerIdentifier(playerId, 0)
    if not playerLicense then return end


    exports.oxmysql:execute("SELECT * FROM jailed_players WHERE license = @license", { ['@license'] = playerLicense }, function(result)
        if result[1] then
            TriggerClientEvent("chat:addMessage", jailerId, { args = { "System", "This player is already in jail." } })
            return
        else
            -- Insert the jailed player into the database
            exports.oxmysql:execute("INSERT INTO jailed_players (license, playerName, timeRemaining) VALUES (@license, @playerName, @timeRemaining)", {
                ['@license'] = playerLicense,
                ['@playerName'] = GetPlayerName(playerId),
                ['@timeRemaining'] = jailTime * 60
            })


            local embed = {
                title = "Player Jailed",
                color = 15158332,
                fields = {
                    { name = "Jailed Player", value = GetPlayerName(playerId) .. " (License: " .. playerLicense .. ")", inline = true },
                    { name = "Jailer", value = GetPlayerName(jailerId) .. " (ID: " .. jailerId .. ")", inline = true },
                    { name = "Jail Time", value = jailTime .. " minutes", inline = true }
                }
            }
            sendDiscordLog(embed)


            TriggerClientEvent("jail:startJailTimer", playerId, jailTime)
        end
    end)
end)


local function releasePlayer(playerLicense)
    exports.oxmysql:execute("DELETE FROM jailed_players WHERE license = @license", { ['@license'] = playerLicense })

    local playerId = GetPlayerFromIdentifier(playerLicense)
    if playerId then
        TriggerClientEvent("jail:releasePlayer", playerId)
        lib.notify({ title = "Release", description = "Your jail time has ended.", type = "success" })
    end
end


CreateThread(function()
    while true do
        exports.oxmysql:execute("SELECT * FROM jailed_players", {}, function(result)
            for _, data in ipairs(result) do
                if data.timeRemaining > 0 then
                    exports.oxmysql:execute("UPDATE jailed_players SET timeRemaining = timeRemaining - 60 WHERE license = @license", { ['@license'] = data.license })
                    
                    local playerId = GetPlayerFromIdentifier(data.license)
                    if playerId then
                        TriggerClientEvent("jail:updateRemainingTime", playerId, data.timeRemaining / 60)
                    end
                else
                    releasePlayer(data.license)
                end
            end
        end)
        Wait(60000)
    end
end)


function GetPlayerFromIdentifier(identifier)
    for _, playerId in ipairs(GetPlayers()) do
        for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
            if GetPlayerIdentifier(playerId, i) == identifier then
                return playerId
            end
        end
    end
    return nil
end

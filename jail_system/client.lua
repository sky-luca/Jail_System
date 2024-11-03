
local jailCoords = vector3(1679.2854, 2515.7603, 45.5604) 
local releaseCoords = vector3(425.11, -979.55, 30.71) 


local function openJailMenu(targetPlayer)
    local input = lib.inputDialog("Send to Jail", { { type = "number", label = "Jail Time (minutes)", default = 5 } })
    if input and input[1] then
        TriggerServerEvent("jail:sendPlayerToJail", targetPlayer, input[1], GetPlayerServerId(PlayerId()))
    end
end


RegisterNetEvent("jail:openJailMenu", function(targetPlayer)
    openJailMenu(targetPlayer)
end)


RegisterNetEvent("jail:startJailTimer", function(jailTime)
    SetEntityCoords(PlayerPedId(), jailCoords.x, jailCoords.y, jailCoords.z)
    lib.notify({ title = "You are in Jail", description = "Remaining time: " .. jailTime .. " minutes.", type = "info" })
end)


RegisterNetEvent("jail:updateRemainingTime", function(minutesLeft)
    lib.notify({ title = "Jail Time", description = "Remaining time: " .. math.ceil(minutesLeft) .. " minutes.", type = "info" })
end)

-- Release player from jail
RegisterNetEvent("jail:releasePlayer", function()
    SetEntityCoords(PlayerPedId(), releaseCoords.x, releaseCoords.y, releaseCoords.z)
    lib.notify({ title = "You are Free", description = "Your jail time has ended.", type = "success" })
end)

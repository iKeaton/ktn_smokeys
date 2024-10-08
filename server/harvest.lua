-- Detect Framework
local Framework
local Player

if Config.Framework.QBCore then 
    Framework = exports['qb-core']:GetCoreObject()
    Player = function(src) return Framework.Functions.GetPlayer(src) end
elseif Config.Framework.ESX then
    Framework = exports['es_extended']:getSharedObject()
    Player = function(src) return Framework.GetPlayerFromId(src) end
elseif Config.Framework.Custom then 
    Framework = exports['custom-Framework']:GetCoreObject() -- Edit if using custom Framework
    Player = function(src) return Framework.GetPlayerFromId(src) end
end

-- Function to handle weed harvesting
local function HarvestWeed(source, weedType)
    local player = Player(source)  -- Get player object
    local weedData = Config.WeedTypes[weedType]  -- Get weed details

    -- Ensure weedData is defined
    if not weedData then
        print("Weed type not found: " .. weedType) -- Debugging message
        return
    end

    -- Check if the amount field exists
    if not weedData.amount then
        print("Weed data does not contain an 'amount' field for: " .. weedType) -- Debugging message
        return
    end

    -- Check if the player can carry the weed
    local itemCount
    if Config.Framework.QBCore or Config.Framework.Custom then 
        itemCount = player.Functions.GetItemByName(weedData.name)
    elseif Config.Framework.ESX then
        itemCount = player.getInventoryItem(weedData.name)
    end

    local currentAmount = itemCount and itemCount.amount or 0
    if currentAmount + weedData.amount <= Config.Harvest.MaxAmount then
        -- Add weed to player's inventory
        if Config.Framework.QBCore or Config.Framework.Custom then 
            player.Functions.AddItem(weedData.name, weedData.amount)
        elseif Config.Framework.ESX then
            player.addInventoryItem(weedData.name, weedData.amount)
        end
        TriggerClientEvent('ktn_smokeys:client:notify', source, "You harvested " .. weedData.amount .. " " .. weedData.display .. "!")
    else
        TriggerClientEvent('ktn_smokeys:client:notify', source, "You don't have enough space in your inventory!")
    end
end


-- Register the server event for harvesting
RegisterNetEvent('ktn_smokeys:server:harvestWeed', function(weedType)
    local src = source
    HarvestWeed(src, weedType)  -- Pass the weed type to the harvest function
end)

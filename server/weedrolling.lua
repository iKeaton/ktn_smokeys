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

local function ItemCheck(source, item)
    if Config.Debug then 
        print('Checking item:', item) -- Debugging output
    end

    local count = 0
    local items

    if Config.Framework.QBCore then 
        items = Player(source).PlayerData.items
    elseif Config.Framework.ESX then
        items = Player(source).getInventory(false)
    elseif Config.Framework.Custom then
        items = Player(source).PlayerData.items
    end

    for _, v in pairs(items) do 
        if Config.Debug then 
            print('Item:', v.name, 'Count:', v.count) -- Debugging output
        end
        
        if v.name == item then 
            local amount = v.count or v.amount
            count = count + amount  -- Increment count
        end
    end

    if Config.Debug then 
        print('Total count for item', item, 'is', count) -- Log total count
    end

    return count  -- Return the total count of the specified item
end

lib.callback.register('ktn_smokeys:server:GetItemCount', function(source, item)
    return ItemCheck(source, item)
end)

RegisterNetEvent('ktn_smokeys:server:itemremove', function(item, amount, bool)
    local src = source
    if Config.Framework.QBCore then 
        Player(src).Functions.RemoveItem(item, amount, bool)
        local QBCore = exports['qb-core']:GetCoreObject()
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
    elseif Config.Framework.ESX then
        Player(src).removeInventoryItem(item, amount)
    elseif Config.Framework.Custom then
        Player(src).Functions.RemoveItem(item, amount, bool) -- Edit if using custom Framework
    end
end)

RegisterNetEvent('ktn_smokeys:server:itemadd', function(item, amount, bool)
    local src = source
    if Config.Framework.QBCore then 
        Player(src).Functions.AddItem(item, amount, bool)
        local QBCore = exports['qb-core']:GetCoreObject()
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
    elseif Config.Framework.ESX then
        Player(src).addInventoryItem(item, amount)
    elseif Config.Framework.Custom then
        Player(src).Functions.AddItem(item, amount, bool) -- Edit if using custom Framework
    end
end)

-- Making Joint Roller Item usable
CreateThread(function()
    local useableItemFunction = function(source)
        if Config.Debug then 
            print('joint roller used')
        end
        TriggerClientEvent('ktn_smokeys:client:UseJointRoller', source)
    end

    if Config.Framework.QBCore then 
        Framework.Functions.CreateUseableItem('joint_roller', useableItemFunction)
    elseif Config.Framework.ESX then
        Framework.RegisterUsableItem('joint_roller', useableItemFunction)
    elseif Config.Framework.Custom then
        Framework.RegisterUsableItem('joint_roller', useableItemFunction)
    end
end)

-- Make joints usable
CreateThread(function()
    for k, v in pairs(Config.Strains) do 
        local useableJointFunction = function(source)
            if Config.Debug then 
                print('joint used')
            end
            TriggerClientEvent('ktn_smokeys:client:UseJointItem', source, k)
        end

        if Config.Framework.QBCore then 
            Framework.Functions.CreateUseableItem(v.joint, useableJointFunction)
        elseif Config.Framework.ESX then
            Framework.RegisterUsableItem(v.joint, useableJointFunction)
        elseif Config.Framework.Custom then
            Framework.RegisterUsableItem(v.joint, useableJointFunction)
        end
    end
end)

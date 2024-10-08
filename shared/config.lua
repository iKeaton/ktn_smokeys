Config = {}

Config.Debug = true  -- Enable or disable debug mode (prints to console)
Config.EnableBlip = true  -- Enable or disable the blip on the map

-- Framework Selection --
Config.Framework = {
    QBCore = true, -- Set to true if using QBCore framework
    ESX = false, -- Set to true if using ESX framework
    Custom = false -- Set to true if using a custom framework
}

-- Chairs --
Config.EnableSitting = true -- You can disable this if you have a different sitting script

-- Rolling Station Config --
Config.RollingStations = {
    { coords = vector3(1132.42, -987.93, 46.11), heading = 280.74 },  -- Front counter
}

Config.RollingPaper = {
    required = true,  -- Enable or disable requiring rolling paper to roll a joint
    item = 'rolling_paper',  -- Item name of the rolling paper
    amount = 1,  -- Amount of rolling paper required each time joint roller is used
}

-- Harvesting Config -- 
Config.EnableHarvesting = true -- You can disable this if you have a different harvesting script

Config.Harvest = {
    MaxAmount = 50,  -- Maximum amount of weed that player can carry
    MinAmount = 1,  -- Minimum amount of weed that player can receive
    Cooldown = 30000,  -- Cooldown in milliseconds between each harvest
}

-- Define weed types
Config.WeedTypes = {
    ['skunk'] = { 
        name = 'skunk_weed', 
        display = 'Skunk', 
        amount = math.random(1, 3) -- or a fixed amount like 2
    },
    ['wet'] = { 
        name = 'wet_weed', 
        display = 'Wet', 
        amount = math.random(1, 3) -- or a fixed amount like 2
    },
    ['ogkush'] = { 
        name = 'ogkush_weed', 
        display = 'OG Kush', 
        amount = math.random(1, 3) -- or a fixed amount like 2
    },
    ['sativa'] = { 
        name = 'sativa_weed', 
        display = 'Sativa', 
        amount = math.random(1, 3) -- or a fixed amount like 2
    },
}

-- No need to edit the coords, these are the default locations for the plants, just edit the weedType if needed
Config.WeedPlants = {
    { coords = vector3(1121.08, -980.39, 45.4), weedType = 'skunk' },   -- First plant: Skunk Weed
    { coords = vector3(1121.85, -981.55, 46.39), weedType = 'wet' },   -- Second plant: Haze Weed
    { coords = vector3(1122.76, -981.03, 45.39), weedType = 'ogkush' }, -- Third plant: OG Kush
    { coords = vector3(1123.54, -980.14, 45.41), weedType = 'sativa' }, -- Fourth plant: Sativa Weed
}

-- DO NOT TOUCH UNLESS YOU KNOW WHAT YOU ARE DOING --
Config.Notify = function(msg, status)
    lib.notify({
        description = msg,
        position = 'top',
        type = status, -- 'success', 'error', 'inform'
        style = {
            backgroundColor = 'rgba(0, 0, 0, 0.65)',
            color = 'white',
        },
    })
end

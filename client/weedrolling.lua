local is_smoking = false

-- Event handler for using a joint item
RegisterNetEvent('ktn_smokeys:client:UseJointItem', function(strain)
    local joint_effect = Config.Strains[strain].effect

    if Config.Debug then 
        print('Used joint:', strain, joint_effect)
    end

    if lib.progressCircle({
        duration = 1000,
        position = 'bottom',
        label = 'Smoking ' .. strain .. ' Joint',
        useWhileDead = false,
        canCancel = true,
    }) then 
        is_smoking = true
        TriggerServerEvent('ktn_smokeys:server:itemremove', Config.Strains[strain].joint, 1)
        TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_SMOKING_POT', 0, 0)
        effects[joint_effect].action()
    end    
end)

-- Function to display the joint menu
local function JointMenu()
    local joint_options = {}

    for strain, details in pairs(Config.Strains) do
        if Config.Debug then 
            print('Checking for joint, Strain:', strain, 'Weed Bag Item:', details.required.item, 'Required Amount:', details.required.amount)
        end
        
        -- Fetch item count with a default value of 0 if nil
        local has_item = lib.callback.await('ktn_smokeys:server:GetItemCount', false, details.required.item) or 0
        
        if Config.Debug then 
            print('Amount in inventory:', tostring(has_item))
        end
        
        if has_item > 0 then
            if Config.Debug then 
                print('Adding joint to menu:', strain)
            end

            table.insert(joint_options, {
                title = strain,
                icon = 'fas fa-joint',
                onSelect = function(cb)
                    -- Check for rolling paper if required
                    if Config.RollingPaper.required then 
                        if Config.Debug then 
                            print('Checking for rolling paper, Item:', Config.RollingPaper.item, 'Amount:', Config.RollingPaper.amount)
                        end
                        
                        -- Fetch rolling paper count with a default value of 0 if nil
                        local has_papers = lib.callback.await('ktn_smokeys:server:GetItemCount', false, Config.RollingPaper.item) or 0

                        if Config.Debug then 
                            print('Amount of rolling paper item in inventory:', tostring(has_papers))
                        end
                        
                        if has_papers < Config.RollingPaper.amount then
                            Config.Notify('You don\'t have enough rolling paper!', 'error')
                            return
                        else 
                            if Config.Debug then 
                                print('Removing rolling paper:', Config.RollingPaper.item, 'Amount:', Config.RollingPaper.amount)
                            end
                            TriggerServerEvent('ktn_smokeys:server:itemremove', Config.RollingPaper.item, Config.RollingPaper.amount)
                        end
                    end

                    -- Remove the required weed item
                    TriggerServerEvent('ktn_smokeys:server:itemremove', details.required.item, details.required.amount)
                    TriggerEvent('ktn_smokeys:client:RollJoint', strain)
                end
            })
        end 
    end

    if #joint_options == 0 then
        Config.Notify('You don\'t have any weed!', 'error')
        return
    end

    lib.registerContext({
        id = 'joint_menu',
        title = 'Roll Joint',
        options = joint_options,
    })
    
    lib.showContext('joint_menu')
end

-- Register qb-target zones for each rolling station
for i, station in ipairs(Config.RollingStations) do
    exports['qb-target']:AddBoxZone("weed_rolling_station_" .. i, station.coords, 1.0, 1.0, {
        name = "weed_rolling_station_" .. i,
        heading = station.heading,
        debugPoly = false,
        minZ = station.coords.z - 1.0,  -- Adjust Z range as needed
        maxZ = station.coords.z + 1.0,
    }, {
        options = {
            {
                type = "client",
                event = "smokeys:RollWeed",
                icon = "fas fa-cannabis",
                label = "Roll Joint",
                action = function()
                    JointMenu()
                end
            },
        },
        distance = 1.5
    })
end

-- Event handler for using the joint roller
RegisterNetEvent('ktn_smokeys:client:UseJointRoller', function()
    JointMenu()
end)

-- Event handler for rolling a joint
RegisterNetEvent('ktn_smokeys:client:RollJoint', function(strain)
    SendNUIMessage({
        action = "Start_Roll",
        strain = strain,
    })

    SetNuiFocus(true, true)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_PARKING_METER', 0, true)
end)

-- Callback for successful roll
RegisterNuiCallback('roll-success', function(data)
    local strain = data.strain

    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())

    if Config.Debug then 
        print('Joint rolled:', strain)
    end
    
    local joint = Config.Strains[strain].joint
    local amount = Config.Strains[strain].receive

    if Config.Debug then 
        print('Giving player joint:', joint, 'Amount:', amount)
    end
    TriggerServerEvent('ktn_smokeys:server:itemadd', joint, amount)
    Config.Notify('You rolled a ' .. strain .. ' joint!', 'success')
end)

-- Callback for failed roll
RegisterNuiCallback('roll-fail', function(data)
    local strain = data.strain
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())

    local required = Config.Strains[strain].required
    local amount = required.amount

    if Config.Debug then 
        print('Giving player weed back:', required.item, 'Amount:', amount)
    end

    TriggerServerEvent('ktn_smokeys:server:itemadd', required.item, amount)
    Config.Notify('Cancelled.', 'error')

    if Config.RollingPaper.required then 
        if Config.Debug then 
            print('Giving player rolling paper back:', Config.RollingPaper.item, 'Amount:', Config.RollingPaper.amount)
        end
        TriggerServerEvent('ktn_smokeys:server:itemadd', Config.RollingPaper.item, Config.RollingPaper.amount)
    end
end)

-- Press X to stop smoking
CreateThread(function()
    while true do 
        Wait(is_smoking and 1 or 2000)  -- Sleep for 1 if smoking, otherwise 2000

        if is_smoking and IsControlJustPressed(0, 73) then  -- Check for 'X' key press
            is_smoking = false
            ClearPedTasks(PlayerPedId())
        end
    end
end)
-- Ensure qb-target is running and ready
local sitting = false

-- Load config to check if sitting script is enabled
if Config.EnableSitting then
    -- Define the coordinates and heading for each couch
    local couches = {
        -- Indoor Couch
        { coords = vector3(1136.68, -987.02, 45.51), heading = 186.6 },
        { coords = vector3(1137.53, -986.87, 45.51), heading = 186.6 },
        -- Outside Plastic Chairs
        { coords = vector3(1127.19, -988.87, 45.46), heading = 124.6},
        { coords = vector3(1127.11, -990.76, 45.4), heading = 80.48},
        { coords = vector3(1124.23, -990.89, 45.44), heading = 279.06},
        { coords = vector3(1124.07, -989.48, 45.5), heading = 240.99},
    }

    -- Function to make the player walk to the couch and sit
    function SitOnCouch(couch)
        local playerPed = PlayerPedId()

        -- Walk to the couch coordinates smoothly
        TaskGoStraightToCoord(playerPed, couch.coords.x, couch.coords.y, couch.coords.z, 1.0, 4000, couch.heading, 0.5)

        -- Monitor distance to stop walking and trigger sit animation
        Citizen.CreateThread(function()
            local playerCoords = GetEntityCoords(playerPed)
            while #(playerCoords - couch.coords) > 1.0 do
                Citizen.Wait(100)
                playerCoords = GetEntityCoords(playerPed)
            end

            -- Play sitting animation when close enough to the couch
            TaskStartScenarioAtPosition(playerPed, "PROP_HUMAN_SEAT_CHAIR", couch.coords.x, couch.coords.y, couch.coords.z, couch.heading, 0, false, true)
            sitting = true
        end)
    end

    -- Function to stand up
    function StandUp()
        local playerPed = PlayerPedId()

        -- Clear the task (stand up)
        ClearPedTasks(playerPed)
        sitting = false
    end

    -- Registering qb-target zones for each couch
    for i, couch in ipairs(couches) do
        exports['qb-target']:AddBoxZone("sit_on_couch_" .. i, couch.coords, 1.0, 1.0, {
            name = "sit_on_couch_" .. i,
            heading = couch.heading,
            debugPoly = false,
            minZ = couch.coords.z - 1.0,  -- Adjust the Z-axis range as needed
            maxZ = couch.coords.z + 1.0,
        }, {
            options = {
                {
                    type = "client",
                    event = "smokeys:SitOnCouch",
                    icon = "fas fa-chair",
                    label = "Sit Down",
                    action = function()
                        SitOnCouch(couch)
                    end
                },
            },
            distance = 1.5
        })
    end

    -- Event to handle sitting
    RegisterNetEvent('smokeys:SitOnCouch', function(couch)
        if not sitting then
            SitOnCouch(couch)
        else
            StandUp()
        end
    end)

    -- Keybind to stand up (optional)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if sitting and IsControlJustPressed(0, 73) then -- 'X' key to stand up
                StandUp()
            end
        end
    end)
end

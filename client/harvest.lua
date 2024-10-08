local harvestableModels = { 
  `bkr_prop_weed_med_01a`,  -- Model for Skunk Weed
  `bkr_prop_weed_med_01b`,  -- Model for Haze Weed
  -- Add more models if needed for different weed types
}

-- Cooldown configuration
local cooldownTime = Config.Harvest.Cooldown
local harvestCooldowns = {}  -- Table to track cooldowns

Citizen.CreateThread(function()
  if Config.EnableHarvesting then
      for _, plant in ipairs(Config.WeedPlants) do
          local coords = plant.coords
          local weedType = plant.weedType
          local weedDisplayName = Config.WeedTypes[weedType].display  -- Get the display name for the weed type

          -- Wait for the plant to load before attempting to get the closest object
          Citizen.Wait(100)  -- Adjust the delay if needed

          -- Check for the plant model
          for _, model in ipairs(harvestableModels) do
              local weedProp = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, model, false, false, false)

              if weedProp and DoesEntityExist(weedProp) then
                  -- Add target interaction with the dynamic label for each weed type
                  exports['qb-target']:AddTargetEntity(weedProp, {
                      options = {
                          {
                              num = 1,
                              type = "client",
                              event = "ktn_smokeys:client:startHarvesting",
                              icon = 'fas fa-leaf',
                              label = 'Harvest ' .. weedDisplayName,  -- Dynamic label based on weed type
                              weedType = weedType,  -- Pass the weed type as a parameter to the event
                          },
                      },
                      distance = 2.0,
                  })
                  if Config.Debug then
                    print("Added target for " .. weedDisplayName .. " at coordinates: " .. tostring(coords))
                  end
                  break  -- Exit the loop once we found the weed prop for this plant
              end
          end
      end
  end
end)

local isHarvesting = false  -- Variable to track if player is currently harvesting

-- Event to start the harvesting process
RegisterNetEvent('ktn_smokeys:client:startHarvesting', function(data)
  if isHarvesting then
      Config.Notify('Harvesting already in progress, please wait.', 'error')
      return
  end

  isHarvesting = true  -- Set the harvesting flag to true
  local ped = PlayerPedId()
  local weedType = data.weedType  -- Get the specific weed type from the target

  -- Check if the player is on cooldown for this specific weed type
  if harvestCooldowns[weedType] and (GetGameTimer() - harvestCooldowns[weedType]) < cooldownTime then
      local remainingTime = (cooldownTime - (GetGameTimer() - harvestCooldowns[weedType])) / 1000  -- Calculate remaining time in seconds
      Config.Notify('You need to wait ' .. math.ceil(remainingTime) .. ' seconds before harvesting ' .. weedType .. ' again.', 'error')
      return
  end

  -- Play the picking leaves animation (change to your preferred animation)
  TaskStartScenarioInPlace(ped, "world_human_gardener_plant", 0, true)

  -- Wait for the animation to complete (adjust as necessary)
  Wait(3000)

  -- Stop the animation
  ClearPedTasks(ped)

  -- Trigger the server event to give the player the harvested weed
  TriggerServerEvent('ktn_smokeys:server:harvestWeed', weedType)

  -- Set cooldown for this weed type
  harvestCooldowns[weedType] = GetGameTimer()  -- Record the current time for cooldown

  if Config.Debug then
    print("Harvested " .. weedType .. " successfully. Setting cooldown for " .. cooldownTime .. " ms.")
  end
  isHarvesting = false  -- Reset the harvesting flag
end)

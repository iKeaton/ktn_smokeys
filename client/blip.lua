CreateThread(function()
  if Config.EnableBlip then
      -- Define the coordinates for Smokey's
      local smokeysCoords = vector3(1134.91, -990.78, 46.12)  -- Update these coordinates to Smokey's actual location

      -- Add the blip to the map
      local blip = AddBlipForCoord(smokeysCoords.x, smokeysCoords.y, smokeysCoords.z)

      -- Set blip properties
      SetBlipSprite(blip, 140)  -- 140 is the weed icon
      SetBlipDisplay(blip, 4)   -- Display on the map
      SetBlipScale(blip, 0.8)   -- Adjust the scale (size) of the blip
      SetBlipColour(blip, 2)    -- Green color for the blip

      -- Set the label for the blip
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("Smokey's")
      EndTextCommandSetBlipName(blip)
  end
end)
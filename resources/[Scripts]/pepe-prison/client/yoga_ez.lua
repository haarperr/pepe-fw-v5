workoutAreas = {
  [1] = { ["x"] = -1491.501,["y"] = 830.8473,["z"] = 181.6243, ["h"] = 202.6591796875, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [2] = { ["x"] = -1493.299,["y"] = 830.0743,["z"] = 181.6234, ["h"] = 200.06629943848, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [3] = { ["x"] = -1495.426,["y"] = 829.4932,["z"] = 181.6233, ["h"] = 206.61083984375, ["workType"] = "Situps", ["emote"] = "situps" },
  [4] = { ["x"] = -1497.039,["y"] = 828.9705,["z"] = 181.6236, ["h"] = 195.51593017578, ["workType"] = "Situps", ["emote"] = "situps" },

}
local inprocess = false
local returnedPass = false
local workoutType = 0


RegisterNetEvent('event:control:gym')
AddEventHandler('event:control:gym', function(useID)
  if not inprocess then
    returnedPass = false
    workoutType = useID
    TriggerEvent("doworkout")
  end
end)


function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


Citizen.CreateThread(function()
    while true do
      local playerped = PlayerPedId()
      local plyCoords = GetEntityCoords(playerped)        
      local waitCheck2 = #(GetEntityCoords( PlayerPedId() ) - vector3(-1491.501,830.8473, 181.6243))
      local waitCheck = #(GetEntityCoords( PlayerPedId() ) - vector3(-1491.501, 830.8473, 181.6243))
      if (waitCheck > 40.0 and waitCheck2 > 40.0 ) or inprocess then
        Citizen.Wait(math.ceil(waitCheck))
      else
        Citizen.Wait(1)
        for i = 1, #workoutAreas do
          local distCheck = #(GetEntityCoords( PlayerPedId() ) - vector3(workoutAreas[i]["x"], workoutAreas[i]["y"], workoutAreas[i]["z"]))
          if distCheck < 1.0 then
            if IsControlJustReleased(1, 38) then
              TriggerEvent('event:control:gym', i)
            end
            DrawText3DTest(workoutAreas[i]["x"], workoutAreas[i]["y"], workoutAreas[i]["z"], "[E] " .. workoutAreas[i]["workType"] .. "" )
          end
        end
      end
    end
end)

RegisterNetEvent('doworkout')
AddEventHandler('doworkout', function()
  TriggerEvent('DoLongHudText', "You have started a " .. workoutAreas[workoutType]["workType"] .. ".")
  local ped = PlayerPedId()
    inprocess = true
    SetEntityCoords(PlayerPedId(),workoutAreas[workoutType]["x"],workoutAreas[workoutType]["y"],workoutAreas[workoutType]["z"])
    SetEntityHeading(PlayerPedId(),workoutAreas[workoutType]["h"])
    if workoutAreas[workoutType]["workType"] == "Chinups" then
      RequestAnimDict("amb@prop_human_muscle_chin_ups@male@base")
      while not HasAnimDictLoaded("amb@prop_human_muscle_chin_ups@male@base") do
        Citizen.Wait(0)
      end
      if IsEntityPlayingAnim(ped, "amb@prop_human_muscle_chin_ups@male@base", "base", 3) then
        ClearPedTasks(ped)
      else
        TaskPlayAnim(ped, "amb@prop_human_muscle_chin_ups@male@base", "base", 1.0, 1.0, -1, 9, -1, 0, 0, 0)
      end
    elseif workoutAreas[workoutType]["workType"] == "Yoga" then
      TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_YOGA", -1, true)
    elseif workoutAreas[workoutType]["workType"] == "Situps" then
      RequestAnimDict("amb@world_human_sit_ups@male@idle_a")

      while not HasAnimDictLoaded("amb@world_human_sit_ups@male@idle_a") do
        Citizen.Wait(0)
      end

      if IsEntityPlayingAnim(ped, "amb@world_human_sit_ups@male@idle_a", "idle_a", 3) then
        ClearPedTasks(ped)
      else
        TaskPlayAnim(ped, "amb@world_human_sit_ups@male@idle_a", "idle_a", 1.0, 1.0, -1, 9, -1, 0, 0, 0)
      end
    elseif workoutAreas[workoutType]["workType"] == "Pushups" then
      TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_PUSH_UPS", -1, true)
    elseif workoutAreas[workoutType]["workType"] == "Weights" then
      TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS", -1, true)
    end
    Citizen.Wait(30000)
    TriggerEvent("client:newStress", false)
    ClearPedTasks(PlayerPedId())
    inprocess = false
end)


Citizen.CreateThread(function()
	local blip = AddBlipForCoord(-1491.501, 830.8473, 181.6243)
	SetBlipSprite(blip, 51)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 5)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Rehab Center")
	EndTextCommandSetBlipName(blip)
end)

Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback("pepe-vehiclekeys:server:get:key:config", function(source, cb)
  cb(Config)
end)

Framework.Functions.CreateCallback("pepe-vehiclekeys:server:has:keys", function(source, cb, plate)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    if Config.VehicleKeys[plate] ~= nil then
        if Config.VehicleKeys[plate]['CitizenId'] == Player.PlayerData.citizenid and Config.VehicleKeys[plate]['HasKey'] then
            HasKey = true
        else
            HasKey = false
        end
    else
        HasKey = false
    end
    cb(HasKey)
end)

-- // Events \\ --

RegisterServerEvent('pepe-vehiclekeys:server:set:keys')
AddEventHandler('pepe-vehiclekeys:server:set:keys', function(Plate, bool)
  local Player = Framework.Functions.GetPlayer(source)
  Config.VehicleKeys[Plate] = {['CitizenId'] = Player.PlayerData.citizenid, ['HasKey'] = bool}
  TriggerClientEvent('pepe-vehiclekeys:client:set:keys', -1, Plate, Player.PlayerData.citizenid, bool)
end)

RegisterServerEvent('pepe-vehiclekeys:server:give:keys')
AddEventHandler('pepe-vehiclekeys:server:give:keys', function(Target, Plate, bool)
  local Player = Framework.Functions.GetPlayer(Target)
  if Player ~= nil then
    TriggerClientEvent('Framework:Notify', Player.PlayerData.source, "You recieved the keys to the following vehicle: "..Plate, 'success')
    Config.VehicleKeys[Plate] = {['CitizenId'] = Player.PlayerData.citizenid, ['HasKey'] = bool}
    TriggerClientEvent('pepe-vehiclekeys:client:set:keys', -1, Plate, Player.PlayerData.citizenid, bool)
  end
end)

-- Framework.Functions.CreateUseableItem("lockpick", function(source, item)
--   local Player = Framework.Functions.GetPlayer(source)
--   TriggerClientEvent("pepe-items:client:use:lockpick", source, false)
-- end)

-- Framework.Functions.CreateUseableItem("advancedlockpick", function(source, item)
--   local Player = Framework.Functions.GetPlayer(source)
--   TriggerClientEvent("lockpicks:UseAdvancedLockpick", source, true)
-- end)

-- Framework.Functions.CreateCallback('vehiclekeys:haslockpick', function(source, cb)
--   local src = source
--   local Ply = Framework.Functions.GetPlayer(src)
--   local lockpick = Ply.Functions.GetItemByName("lockpick")
--   if lockpick ~= nil then
--       cb(true)
--   else
--       cb(false)
--   end
-- end)


-- // Commands \\ -- 

Framework.Commands.Add("engine", "Toggle vehicle engine", {}, false, function(source, args)
  TriggerClientEvent('pepe-vehiclekeys:client:toggle:engine', source)
end)
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

Framework.Functions.CreateUseableItem("lockpick", function(source, item)
  local Player = Framework.Functions.GetPlayer(source)
  TriggerClientEvent("lockpicks:UseLockpick", source, false)
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

-- // Commands \\ -- 

Framework.Commands.Add("engine", "Toggle vehicle engine", {}, false, function(source, args)
  TriggerClientEvent('pepe-vehiclekeys:client:toggle:engine', source)
end)
Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('pepe-houserobbery:server:get:config', function(source, cb)
  cb(Config)
end)

-- Code

RegisterServerEvent('pepe-houserobbery:server:set:door:status')
AddEventHandler('pepe-houserobbery:server:set:door:status', function(RobHouseId, bool)
 Config.HouseLocations[RobHouseId]['Opened'] = bool
 TriggerClientEvent('pepe-houserobbery:client:set:door:status', -1, RobHouseId, bool)
 ResetHouse(RobHouseId)
end)

RegisterServerEvent('pepe-houserobbery:server:set:locker:state')
AddEventHandler('pepe-houserobbery:server:set:locker:state', function(RobHouseId, LockerId, Type, bool)
 Config.HouseLocations[RobHouseId]['Lockers'][LockerId][Type] = bool
 TriggerClientEvent('pepe-houserobbery:client:set:locker:state', -1, RobHouseId, LockerId, Type, bool)
end)

RegisterServerEvent('pepe-houserobbery:server:locker:reward')
AddEventHandler('pepe-houserobbery:server:locker:reward', function()
  local Player = Framework.Functions.GetPlayer(source)
  local RandomValue = math.random(1, 100)
  if RandomValue <= 30 then
    Player.Functions.AddMoney('cash', math.random(250, 350), "House Robbery")
  elseif RandomValue >= 45 and RandomValue <= 58 then
    Player.Functions.AddItem('diamond-ring', math.random(1,5))
    TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['diamond-ring'], "add")
  elseif RandomValue >= 76 and RandomValue <= 82 then
    Player.Functions.AddItem('gold-necklace', math.random(1,5))
    TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['gold-necklace'], "add") 
  elseif RandomValue >= 83 and RandomValue <= 98 then
    Player.Functions.AddItem('gold-rolex', math.random(1,3))
    TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['gold-rolex'], "add")
  elseif RandomValue == 32 or RandomValue == 34 or RandomValue == 40 then
    local SubValue = math.random(1,2)
    if SubValue == 1 then
      Player.Functions.AddItem('rifle-trigger', 1)
      TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['rifle-trigger'], "add")
    else
      Player.Functions.AddItem('rifle-body', 1)
      TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['rifle-body'], "add")
    end
  else
    TriggerClientEvent('Framework:Notify', source, "You found nothing of interest..", "error", 4500)
  end 
end)

RegisterServerEvent('pepe-houserobbery:server:recieve:extra')
AddEventHandler('pepe-houserobbery:server:recieve:extra', function(CurrentHouse, Id)
  local Player = Framework.Functions.GetPlayer(source)
  Player.Functions.AddItem(Config.HouseLocations[CurrentHouse]['Extras'][Id]['Item'], 1)
  TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items[Config.HouseLocations[CurrentHouse]['Extras'][Id]['Item']], "add")
  Config.HouseLocations[CurrentHouse]['Extras'][Id]['Stolen'] = true
  TriggerClientEvent('pepe-houserobbery:client:set:extra:state', -1, CurrentHouse, Id, true)
end)

function ResetHouse(HouseId)
  Citizen.SetTimeout((1000 * 60) * 15, function()
      Config.HouseLocations[HouseId]["Opened"] = false
      for k, v in pairs(Config.HouseLocations[HouseId]["Lockers"]) do
          v["Opened"] = false
          v["Busy"] = false
      end
      if Config.HouseLocations[HouseId]["Extras"] ~= nil then
        for k, v in pairs(Config.HouseLocations[HouseId]["Extras"]) do
          v['Stolen'] = false
        end
      end
      TriggerClientEvent('pepe-houserobbery:server:reset:state', -1, HouseId)
  end)
end
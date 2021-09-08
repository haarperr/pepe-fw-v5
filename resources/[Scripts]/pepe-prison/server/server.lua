Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Commands.Add("jail", "Send a citizen to jail", {{name="id", help="Player ID"}, {name="time", help="Time to serve in numbers!"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local JailPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        if JailPlayer ~= nil then
         local Time = tonumber(args[2])
         if Time > 0 then
            local Name = JailPlayer.PlayerData.charinfo.firstname..' '..JailPlayer.PlayerData.charinfo.lastname
            if JailPlayer.PlayerData.job.name ~= 'police' or JailPlayer.PlayerData.job.name ~= 'ambulance' then
             JailPlayer.Functions.SetJob("unemployed")
             TriggerClientEvent('Framework:Notify', JailPlayer.PlayerData.source, "Your job has been notified and they have removed you as an employee..", 'error')
            end
            JailPlayer.Functions.SetMetaData("jailtime", Time)
            TriggerClientEvent('pepe-prison:client:set:in:jail', JailPlayer.PlayerData.source, Name, Time, JailPlayer.PlayerData.citizenid, os.date('%d-'..'%m-'..'%y'))
         end
      end
    end
end)

Framework.Commands.Add("rehab", "Send a citizen to rehab", {{name="id", help="Player ID"}, {name="tijd", help="Time to serve in numbers!"}}, true, function(source, args)
    local src = source
    local Player = Framework.Functions.GetPlayer(source)
    
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" or Player.PlayerData.job.name == "ambulance" then
        if args[1] then
            if args[2] == true then
                TriggerClientEvent("beginJailRehab", args[1], true)
            else
                TriggerClientEvent("beginJailRehab", args[1], false)
            end
        else
            TriggerClientEvent('Framework:Notify', source, 'No player found', 'error')
        end
    end
end)

RegisterServerEvent('pepe-prison:server:set:jail:state')
AddEventHandler('pepe-prison:server:set:jail:state', function(Time)
 local Player = Framework.Functions.GetPlayer(source)
 Player.Functions.SetMetaData("jailtime", Time)
 Citizen.SetTimeout(500, function()
    Player.Functions.Save()
 end)
end)

RegisterServerEvent('pepe-prison:server:set:jail:leave')
AddEventHandler('pepe-prison:server:set:jail:leave', function()
  local Player = Framework.Functions.GetPlayer(source)
  Player.Functions.SetMetaData("jailtime", 0)
  Citizen.SetTimeout(500, function()
     Player.Functions.Save()
  end)
end)

RegisterServerEvent('pepe-prison:server:set:jail:items')
AddEventHandler('pepe-prison:server:set:jail:items', function(Time)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    if Player.PlayerData.metadata["jailitems"] == nil or next(Player.PlayerData.metadata["jailitems"]) == nil then 
        Player.Functions.SetMetaData("jailitems", Player.PlayerData.items)
        Player.Functions.ClearInventory()
        Citizen.Wait(1000)
        Player.Functions.AddItem("water", Time)
        Player.Functions.AddItem("sandwich", Time)
    end
end)

RegisterServerEvent('pepe-prison:server:get:items:back')
AddEventHandler('pepe-prison:server:get:items:back', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Citizen.Wait(100)
    for k, v in pairs(Player.PlayerData.metadata["jailitems"]) do
        Player.Functions.AddItem(v.name, v.amount, false, v.info)
    end
    Player.Functions.SetMetaData("jailitems", {})
end)

RegisterServerEvent('pepe-prison:server:find:reward')
AddEventHandler('pepe-prison:server:find:reward', function(reward)
   local Player = Framework.Functions.GetPlayer(source)
   Player.Functions.AddItem(reward, 1)
   TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items[reward], "add")
end)

RegisterServerEvent('pepe-prison:server:set:alarm')
AddEventHandler('pepe-prison:server:set:alarm', function(bool)
    TriggerClientEvent('pepe-prison:client:set:alarm', -1, bool)
end)
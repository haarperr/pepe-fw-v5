Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local Casings = {}
local HairDrops = {}
local BloodDrops = {}
local SlimeDrops = {}
local FingerDrops = {}
local PlayerStatus = {}
local Objects = {}

RegisterServerEvent('pepe-police:server:UpdateBlips')
AddEventHandler('pepe-police:server:UpdateBlips', function()
    local src = source
    local dutyPlayers = {}
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
                table.insert(dutyPlayers, {
                    source = Player.PlayerData.source,
                    label = Player.PlayerData.metadata["callsign"]..' | '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname,
                    job = Player.PlayerData.job.name,
                })
            end
        end
    end
    TriggerClientEvent("pepe-police:client:UpdateBlips", -1, dutyPlayers)
end)

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(0)
    local CurrentCops = GetCurrentCops()
    TriggerClientEvent("pepe-police:SetCopCount", -1, CurrentCops)
    Citizen.Wait(1000 * 60 * 3)
  end
end)

-- // Functions \\ --

function GetCurrentCops()
    local amount = 0
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    return amount
end

-- // Evidence Events \\ --

RegisterServerEvent('pepe-police:server:CreateCasing')
AddEventHandler('pepe-police:server:CreateCasing', function(weapon, coords)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local casingId = CreateIdType('casing')
    local weaponInfo = exports['pepe-weapons']:GetWeaponList(weapon)
    local serieNumber = nil
    if weaponInfo ~= nil then 
        local weaponItem = Player.Functions.GetItemByName(weaponInfo["IdName"])
        if weaponItem ~= nil then
            if weaponItem.info ~= nil and weaponItem.info ~= "" then 
                serieNumber = weaponItem.info.serie
            end
        end
    end
    TriggerClientEvent("pepe-police:client:AddCasing", -1, casingId, weapon, coords, serieNumber)
end)


RegisterServerEvent('pepe-police:server:impound:vehicle')
AddEventHandler('pepe-police:server:impound:vehicle', function(vehicle)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
    TriggerEvent("pepe-garages:server:set:in:impound", vehicle)
end)

RegisterServerEvent('pepe-police:server:CreateBloodDrop')
AddEventHandler('pepe-police:server:CreateBloodDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local bloodId = CreateIdType('blood')
 BloodDrops[bloodId] = Player.PlayerData.metadata["bloodtype"]
 TriggerClientEvent("pepe-police:client:AddBlooddrop", -1, bloodId, Player.PlayerData.metadata["bloodtype"], coords)
end)

RegisterServerEvent('pepe-police:server:CreateFingerDrop')
AddEventHandler('pepe-police:server:CreateFingerDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local fingerId = CreateIdType('finger')
 FingerDrops[fingerId] = Player.PlayerData.metadata["fingerprint"]
 TriggerClientEvent("pepe-police:client:AddFingerPrint", -1, fingerId, Player.PlayerData.metadata["fingerprint"], coords)
end)

RegisterServerEvent('pepe-police:server:CreateHairDrop')
AddEventHandler('pepe-police:server:CreateHairDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local HairId = CreateIdType('hair')
 HairDrops[HairId] = Player.PlayerData.metadata["haircode"]
 TriggerClientEvent("pepe-police:client:AddHair", -1, HairId, Player.PlayerData.metadata["haircode"], coords)
end)

RegisterServerEvent('pepe-police:server:CreateSlimeDrop')
AddEventHandler('pepe-police:server:CreateSlimeDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local SlimeId = CreateIdType('slime')
 SlimeDrops[SlimeId] = Player.PlayerData.metadata["slimecode"]
 TriggerClientEvent("pepe-police:client:AddSlime", -1, SlimeId, Player.PlayerData.metadata["slimecode"], coords)
end)

RegisterServerEvent('pepe-police:server:AddEvidenceToInventory')
AddEventHandler('pepe-police:server:AddEvidenceToInventory', function(EvidenceType, EvidenceId, EvidenceInfo)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
    if Player.Functions.AddItem("filled_evidence_bag", 1, false, EvidenceInfo) then
        RemoveDna(EvidenceType, EvidenceId)
        TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, EvidenceType, EvidenceId)
        TriggerClientEvent("pepe-inventory:client:ItemBox", src, Framework.Shared.Items["filled_evidence_bag"], "add")
    end
 else
    TriggerClientEvent('Framework:Notify', src, "You must have an empty evidence bag with you", "error")
 end
end)

-- // Finger Scanner \\ --

RegisterServerEvent('pepe-police:server:show:machine')
AddEventHandler('pepe-police:server:show:machine', function(PlayerId)
    local Player = Framework.Functions.GetPlayer(PlayerId)
    TriggerClientEvent('pepe-police:client:show:machine', PlayerId, source)
    TriggerClientEvent('pepe-police:client:show:machine', source, PlayerId)
end)

RegisterServerEvent('pepe-police:server:showFingerId')
AddEventHandler('pepe-police:server:showFingerId', function(FingerPrintSession)
 local Player = Framework.Functions.GetPlayer(source)
 local FingerId = Player.PlayerData.metadata["fingerprint"] 
 if math.random(1,25)  <= 15 then
 TriggerClientEvent('pepe-police:client:show:fingerprint:id', FingerPrintSession, FingerId)
 TriggerClientEvent('pepe-police:client:show:fingerprint:id', source, FingerId)
 end
end)

RegisterServerEvent('pepe-police:server:set:tracker')
AddEventHandler('pepe-police:server:set:tracker', function(TargetId)
    local Target = Framework.Functions.GetPlayer(TargetId)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]
    if TrackerMeta then
        Target.Functions.SetMetaData("tracker", false)
        TriggerClientEvent('Framework:Notify', TargetId, 'Your ankle strap has been taken off.', 'error', 5000)
        TriggerClientEvent('Framework:Notify', source, 'You have taken off an anklet from '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('pepe-police:client:set:tracker', TargetId, false)
    else
        Target.Functions.SetMetaData("tracker", true)
        TriggerClientEvent('Framework:Notify', TargetId, 'You got an ankle bracelet.', 'error', 5000)
        TriggerClientEvent('Framework:Notify', source, 'You put on an ankle bracelet '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('pepe-police:client:set:tracker', TargetId, true)
    end
end)

RegisterServerEvent('pepe-police:server:send:tracker:location')
AddEventHandler('pepe-police:server:send:tracker:location', function(Coords, RequestId)
    local Target = Framework.Functions.GetPlayer(RequestId)
    local AlertData = {title = "Anklet Location", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "The anklet location of: "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname}
    TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
    TriggerClientEvent('pepe-police:client:send:tracker:alert', -1, Coords, Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
end)

-- // Update Cops \\ --
RegisterServerEvent('pepe-police:server:UpdateCurrentCops')
AddEventHandler('pepe-police:server:UpdateCurrentCops', function()
    local amount = 0
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    TriggerClientEvent("pepe-police:SetCopCount", -1, amount)
end)

RegisterServerEvent('pepe-police:server:UpdateStatus')
AddEventHandler('pepe-police:server:UpdateStatus', function(data)
    local src = source
    PlayerStatus[src] = data
end)

RegisterServerEvent('pepe-police:server:ClearDrops')
AddEventHandler('pepe-police:server:ClearDrops', function(Type, List)
    local src = source
    if Type == 'casing' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, 'casing', v)
                Casings[v] = nil
            end
        end
    elseif Type == 'finger' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, 'finger', v)
                FingerDrops[v] = nil
            end
        end
    elseif Type == 'blood' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, 'blood', v)
                BloodDrops[v] = nil
            end
        end
    elseif Type == 'Hair' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, 'hair', v)
                HairDrops[v] = nil
            end
        end
    elseif Type == 'Slime' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("pepe-police:client:RemoveDnaId", -1, 'slime', v)
                HairDrops[v] = nil
            end
        end
    end
end)

Framework.Functions.CreateCallback('pepe-police:GetImpoundedVehicles', function(source, cb)
    local vehicles = {}
    exports['ghmattimysql']:execute('SELECT * FROM characters_vehicles WHERE garage = @garage', {['@garage'] = "Police"}, function(result)
        if result[1] ~= nil then
            vehicles = result
        end
        cb(vehicles)
    end)
end)

function RemoveDna(EvidenceType, EvidenceId)
 if EvidenceType == 'hair' then
     HairDrops[EvidenceId] = nil
 elseif EvidenceType == 'blood' then
     BloodDrops[EvidenceId] = nil
 elseif EvidenceType == 'finger' then
     FingerDrops[EvidenceId] = nil
 elseif EvidenceType == 'slime' then
     SlimeDrops[EvidenceId] = nil
 elseif EvidenceType == 'casing' then
     Casings[EvidenceId] = nil
 end
end

-- // Functions \\ --

function CreateIdType(Type)
    if Type == 'casing' then
        if Casings ~= nil then
	    	local caseId = math.random(10000, 99999)
	    	while Casings[caseId] ~= nil do
	    		caseId = math.random(10000, 99999)
	    	end
	    	return caseId
	    else
	    	local caseId = math.random(10000, 99999)
	    	return caseId
        end
    elseif Type == 'finger' then
        if FingerDrops ~= nil then
            local fingerId = math.random(10000, 99999)
            while FingerDrops[fingerId] ~= nil do
                fingerId = math.random(10000, 99999)
            end
            return fingerId
        else
            local fingerId = math.random(10000, 99999)
            return fingerId
        end
    elseif Type == 'blood' then
        if BloodDrops ~= nil then
            local bloodId = math.random(10000, 99999)
            while BloodDrops[bloodId] ~= nil do
                bloodId = math.random(10000, 99999)
            end
            return bloodId
        else
            local bloodId = math.random(10000, 99999)
            return bloodId
        end
    elseif Type == 'hair' then
        if HairDrops ~= nil then
            local hairId = math.random(10000, 99999)
            while HairDrops[hairId] ~= nil do
                hairId = math.random(10000, 99999)
            end
            return hairId
        else
            local hairId = math.random(10000, 99999)
            return hairId
        end
    elseif Type == 'slime' then
        if SlimeDrops ~= nil then
            local slimeId = math.random(10000, 99999)
            while SlimeDrops[slimeId] ~= nil do
                slimeId = math.random(10000, 99999)
            end
            return slimeId
        else
            local slimeId = math.random(10000, 99999)
            return slimeId
        end
   end
end

-- // Commands \\ --

Framework.Commands.Add("cuff", "toggle handcuffs (Admin)", {{name="ID", help="Player Id"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args ~= nil then
     local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
       if TargetPlayer ~= nil then
         TriggerClientEvent("pepe-police:client:get:cuffed", TargetPlayer.PlayerData.source, Player.PlayerData.source)
       end
    end
end, "user")

Framework.Commands.Add("unjail", "Unjail a person.", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        local playerId = tonumber(args[1])
        TriggerClientEvent("pepe-prison:client:leave:prison", playerId)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services!", "success")
    end
end)

Framework.Commands.Add("sethighcommand", "Put someone's high command status", {{name="ID", help="PlayerId"}, {name="Status", help="True/False"}}, true, function(source, args)
  if args ~= nil then
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if TargetPlayer ~= nil then
      if args[2]:lower() == 'true' then
          TargetPlayer.Functions.SetMetaData("ishighcommand", true)
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'You are now in charge!', 'success')
          TriggerClientEvent('Framework:Notify', source, 'Player is now in charge!', 'success')
      else
          TargetPlayer.Functions.SetMetaData("ishighcommand", false)
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'You are no longer in charge!', 'error')
          TriggerClientEvent('Framework:Notify', source, 'Player is NOT a High Command anymore!', 'error')
      end
    end
  end
end, "user")

Framework.Commands.Add("setpolice", "Hire a citizen as a police officer", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'You have been hired as an officer! congratulations!', 'success')
          TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'You have hired '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' as a officer!', 'success')
          TargetPlayer.Functions.SetJob('police', 0)
      end
    end
end)

Framework.Commands.Add("firepolice", "Fire a officer", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'You have been fired!', 'error')
          TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'You fired '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' !', 'success')
          TargetPlayer.Functions.SetJob('unemployed', 0)
      end
    end
end)

Framework.Commands.Add("callsign", "Change your callsign", {{name="Number", help="Callsign"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
         Player.Functions.SetMetaData("callsign", args[1])
         TriggerClientEvent('Framework:Notify', source, 'Callsign successfully changed, You are now: ' ..args[1], 'success')
        else
            TriggerClientEvent('Framework:Notify', source, 'This is for emergency services only..', 'error')
        end
    end
end)

Framework.Commands.Add("setplate", "Change your license plate", {{name="Number", help="Callsign"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
           if args[1]:len() == 8 then
             Player.Functions.SetDutyPlate(args[1])
             TriggerClientEvent('Framework:Notify', source, 'License plate changed successfully. Your service registration number is now: ' ..args[1], 'success')
           else
               TriggerClientEvent('Framework:Notify', source, 'It must be exactly 8 characters long..', 'error')
           end
        else
            TriggerClientEvent('Framework:Notify', source, 'This is for emergency services only..', 'error')
        end
    end
end)

Framework.Commands.Add("safe", "Open evidence safe", {{"cid", "CID number"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args[1] ~= nil then 
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
        TriggerClientEvent("pepe-police:client:open:evidence", source, args[1])
    else
        TriggerClientEvent('Framework:Notify', source, "This is for emergency services only..", "error")
    end
  else
    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Fill in all arguments.")
 end
end)

Framework.Commands.Add("setdutyvehicle", "Set duty vehicle class to a officer", {{name="Id", help="Player ID"}, {name="Vehicle", help="Standard / Audi / Heli / Motor / Unmarked / Sheriff"}, {name="state", help="True / False"}}, true, function(source, args)
    local SelfPlayerData = Framework.Functions.GetPlayer(source)
    local TargetPlayerData = Framework.Functions.GetPlayer(tonumber(args[1]))
    if TargetPlayerData ~= nil then
    local TargetPlayerVehicleData = TargetPlayerData.PlayerData.metadata['duty-vehicles']
    if SelfPlayerData.PlayerData.metadata['ishighcommand'] then
       if args[2]:upper() == 'STANDARD' then
           if args[3] == 'true' then
               VehicleList = {Standard = true, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, Sheriff = TargetPlayerVehicleData.Sheriff}
           else
               VehicleList = {Standard = false, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, Sheriff = TargetPlayerVehicleData.Sheriff}
           end
       elseif args[2]:upper() == 'AUDI' then
           if args[3] == 'true' then
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = true, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, Sheriff = TargetPlayerVehicleData.Sheriff}
           else
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = false, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, Sheriff = TargetPlayerVehicleData.Sheriff}
           end
       elseif args[2]:upper() == 'UNMARKED' then
           if args[3] == 'true' then
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = true, Sheriff = TargetPlayerVehicleData.Sheriff}
           else
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = false, Sheriff = TargetPlayerVehicleData.Sheriff}
           end 
        elseif args[2]:upper() == 'MOTOR' then
            if args[3] == 'true' then
                VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = true, Unmarked = TargetPlayerVehicleData.Unmarked, Sheriff = TargetPlayerVehicleData.Sheriff}
            else
                VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = false, Unmarked = TargetPlayerVehicleData.Unmarked, Sheriff = TargetPlayerVehicleData.Sheriff}
            end 
       elseif args[2]:upper() == 'HELI' then
           if args[3] == 'true' then
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = true, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, Sheriff = TargetPlayerVehicleData.Sheriff}
           else
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = false, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, Sheriff = TargetPlayerVehicleData.Sheriff}
           end 
        elseif args[2]:upper() == 'SHERIFF' then
            if args[3] == 'true' then
                VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, Sheriff = true}
            else
                VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, Sheriff = false}
            end 
       end
       local PlayerCredentials = TargetPlayerData.PlayerData.metadata['callsign']..' | '..TargetPlayerData.PlayerData.charinfo.firstname..' '..TargetPlayerData.PlayerData.charinfo.lastname
       TargetPlayerData.Functions.SetMetaData("duty-vehicles", VehicleList)
       TriggerClientEvent('pepe-radialmenu:client:update:duty:vehicles', TargetPlayerData.PlayerData.source)
       if args[3] == 'true' then
           TriggerClientEvent('Framework:Notify', TargetPlayerData.PlayerData.source, 'You have received a vehicle specialisation ('..args[2]:upper()..')', 'success')
           TriggerClientEvent('Framework:Notify', SelfPlayerData.PlayerData.source, 'You have successfully assigned the vehicle specialisation ('..args [2]: upper () ..') to '..PlayerCredentials, 'success')
       else
           TriggerClientEvent('Framework:Notify', TargetPlayerData.PlayerData.source, 'Your ('..args[2]:upper()..') vehicle specialisation has been taken..', 'error')
           TriggerClientEvent('Framework:Notify', SelfPlayerData.PlayerData.source, 'You have successfully completed the vehicle specialisation ('..args [2]: upper () ..') from '..PlayerCredentials, 'error')
           end
        end
    end
end)

Framework.Commands.Add("Fine", "Write a fine", {{name="id", help="Player ID"},{name="money", help="amount"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    local Amount = tonumber(args[2])
    if TargetPlayer ~= nil then
       if Player.PlayerData.job.name == "police" then
         if Amount > 0 then
          TargetPlayer.Functions.RemoveMoney("bank", Amount, "Payed-PoliceFine")
          TriggerClientEvent("pepe-police:client:bill:player", TargetPlayer.PlayerData.source, Amount)
          TriggerClientEvent('Framework:Notify', source, 'You sent a fine to For a total of ' ..Amount, "error")
          TriggerEvent("pepe-bossmenu:server:addAccountMoney", "police", 0.85 * Amount)


         else
             TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "The amount must be greater than 0")
         end
       elseif Player.PlayerData.job.name == "realestate" then
        if Amount > 0 then
               TriggerEvent('pepe-phone:server:add:invoice', TargetPlayer.PlayerData.citizenid, Amount, 'Real Estate', 'realestate')  
           else
               TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "The amount must be greater than 0")
           end
       else
           TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services only!")
       end
    end
end)

Framework.Commands.Add("paylaw", "Pay a lawyer", {{name="id", help="Player ID"}, {name="amount", help="How much?"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        local playerId = tonumber(args[1])
        local Amount = tonumber(args[2])
        local OtherPlayer = Framework.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "lawyer" then
                OtherPlayer.Functions.AddMoney("bank", Amount, "police-lawyer-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEM", "warning", "You have received $ ".. Amount ..", - for your given services!")
                TriggerClientEvent('Framework:Notify', source, 'You paid your lawyer')
            else
                TriggerClientEvent('Framework:Notify', source, 'Person is not a lawyer', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services only!")
    end
end)
Framework.Commands.Add("paymechanic", "Pay a Mechanic", {{name="id", help="Player ID"}, {name="amount", help="How much?"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance" then
        local playerId = tonumber(args[1])
        local Amount = tonumber(args[2])
        local OtherPlayer = Framework.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "mechanic1" or OtherPlayer.PlayerData.job.name == "mechanic2" then
                OtherPlayer.Functions.AddMoney("bank", Amount, "police-mechanic-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEM", "warning", "You have received $ ".. Amount ..", - for your given services!")
                TriggerClientEvent('Framework:Notify', source, 'You paid your Mechanic')
            else
                TriggerClientEvent('Framework:Notify', source, 'Person is not a Mechanic', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services only!")
    end
end)
Framework.Commands.Add("paytow", "Pay a tow", {{name="id", help="Player ID"}, {name="amount", help="How much?"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance" then
        local playerId = tonumber(args[1])
        local Amount = tonumber(args[2])
        local OtherPlayer = Framework.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "tow" then
                OtherPlayer.Functions.AddMoney("bank", Amount, "police-tow-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEM", "warning", "You have received $ ".. Amount ..", - for your given services!")
                TriggerClientEvent('Framework:Notify', source, 'You paid your tower')
            else
                TriggerClientEvent('Framework:Notify', source, 'Person is not a tower', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services only!")
    end
end)

Framework.Commands.Add("911", "Send a report to emergency services", {{name="message", help="Message you want to send to emergency services"}}, true, function(source, args)
    local message = table.concat(args, " ")
    local Player = Framework.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent("police:client:SendEmergencyMessage", source, message)
    else
        TriggerClientEvent('Framework:Notify', source, 'You don\'t have a phone', 'error')
    end
end)

Framework.Commands.Add("911anon", "Send an anonymous report to emergency services (does not provide a location)", {{name="message", help="Message you want to send to emergency services"}}, true, function(source, args)
    local message = table.concat(args, " ")
    local Player = Framework.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent("police:client:CallAnim", source)
        TriggerClientEvent('police:client:Send112AMessage', -1, message)
    else
        TriggerClientEvent('Framework:Notify', source, 'You don\'t have a phone', 'error')
    end
end)

Framework.Commands.Add("911r", "Send a message back to a 911 caller", {{name="id", help="The message ID"}, {name="message", help="Message you want to send"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local OtherPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    table.remove(args, 1)
    local message = table.concat(args, " ")
    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "(POLICE) " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
            TriggerClientEvent("police:client:EmergencySound", OtherPlayer.PlayerData.source)
            TriggerClientEvent("police:client:CallAnim", source)
        end
    elseif Player.PlayerData.job.name == "ambulance" then
        if OtherPlayer ~= nil then 
            TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "(AMBULANCE) " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
            TriggerClientEvent("police:client:EmergencySound", OtherPlayer.PlayerData.source)
            TriggerClientEvent("police:client:CallAnim", source)
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services!")
    end
end)

RegisterServerEvent('police:server:SendEmergencyMessage')
AddEventHandler('police:server:SendEmergencyMessage', function(coords, message)
    local src = source
    local MainPlayer = Framework.Functions.GetPlayer(src)
    local alertData = {
        title = "911 Message - "..MainPlayer.PlayerData.charinfo.firstname .. " " .. MainPlayer.PlayerData.charinfo.lastname .. " ("..src..")",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message,
    }
    TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, alertData)
    TriggerClientEvent('police:server:SendEmergencyMessageCheck', -1, MainPlayer, message, coords)
end)

Framework.Commands.Add("anklestraploc", "Get location of person with ankle strap", {{name="cid", help="Player ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if args[1] ~= nil then
            local citizenid = args[1]
            local Target = Framework.Functions.GetPlayerByCitizenId(citizenid)
            local Tracking = false
            if Target ~= nil then
                if Target.PlayerData.metadata["tracker"] and not Tracking then
                    Tracking = true
                    TriggerClientEvent("pepe-police:client:send:tracker:location", Target.PlayerData.source, Target.PlayerData.source)
                else
                    TriggerClientEvent('Framework:Notify', source, 'This person does not have an ankle bracelet.', 'error')
                end
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency services only!")
    end
end)

Framework.Functions.CreateUseableItem("handcuffs", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("pepe-police:client:cuff:closest", source)
    end
end)

-- // HandCuffs \\ --
RegisterServerEvent('pepe-police:server:cuff:closest')
AddEventHandler('pepe-police:server:cuff:closest', function(SeverId)
    local Player = Framework.Functions.GetPlayer(source)
    local CuffedPlayer = Framework.Functions.GetPlayer(SeverId)
    if CuffedPlayer ~= nil then
        TriggerClientEvent("pepe-police:client:get:cuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source)
    end
end)

RegisterServerEvent('pepe-police:server:set:handcuff:status')
AddEventHandler('pepe-police:server:set:handcuff:status', function(Cuffed)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.SetMetaData("ishandcuffed", Cuffed)
	end
end)

RegisterServerEvent('pepe-police:server:escort:closest')
AddEventHandler('pepe-police:server:escort:closest', function(SeverId)
    local Player = Framework.Functions.GetPlayer(source)
    local EscortPlayer = Framework.Functions.GetPlayer(SeverId)
    if EscortPlayer ~= nil then
        if (EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"]) then
            TriggerClientEvent("pepe-police:client:get:escorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Person is not dead or handcuffed!")
        end
    end
end)

RegisterServerEvent('pepe-police:server:set:out:veh')
AddEventHandler('pepe-police:server:set:out:veh', function(ServerId)
    local Player = Framework.Functions.GetPlayer(source)
    local EscortPlayer = Framework.Functions.GetPlayer(ServerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("pepe-police:client:set:out:veh", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Person is not dead or handcuffed!")
        end
    end
end)

RegisterServerEvent('pepe-police:server:set:in:veh')
AddEventHandler('pepe-police:server:set:in:veh', function(ServerId)
    local Player = Framework.Functions.GetPlayer(source)
    local EscortPlayer = Framework.Functions.GetPlayer(ServerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("pepe-police:client:set:in:veh", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Person is not dead or handcuffed!")
        end
    end
end)

Framework.Functions.CreateCallback('pepe-police:server:is:player:dead', function(source, cb, playerId)
    local Player = Framework.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

Framework.Functions.CreateCallback('pepe-police:server:is:inventory:disabled', function(source, cb, playerId)
    local Player = Framework.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["inventorydisabled"])
end)

RegisterServerEvent('pepe-police:server:SearchPlayer')
AddEventHandler('pepe-police:server:SearchPlayer', function(playerId)
    local src = source
    local SearchedPlayer = Framework.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Person is carrying $"..SearchedPlayer.PlayerData.money["cash"]..",- on them..")
        TriggerClientEvent('Framework:Notify', SearchedPlayer.PlayerData.source, "You are being searched.")
    end
end)

RegisterServerEvent('pepe-police:server:rob:player')
AddEventHandler('pepe-police:server:rob:player', function(playerId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local SearchedPlayer = Framework.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        local money = SearchedPlayer.PlayerData.money["cash"]
        Player.Functions.AddMoney("cash", money, "police-player-robbed")
        SearchedPlayer.Functions.RemoveMoney("cash", money, "police-player-robbed")
        TriggerClientEvent('Framework:Notify', SearchedPlayer.PlayerData.source, "You have been robbed of $"..money.." ")
    end
end)

RegisterServerEvent('pepe-police:server:send:call:alert')
AddEventHandler('pepe-police:server:send:call:alert', function(Coords, Message)
 local Player = Framework.Functions.GetPlayer(source)
 local Name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
 local AlertData = {title = "911 Call - "..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " ("..source..")", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = Message}
 TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
 TriggerClientEvent('pepe-police:client:send:message', -1, Coords, Message, Name)
end)

RegisterServerEvent('pepe-police:server:spawn:object')
AddEventHandler('pepe-police:server:spawn:object', function(type)
    local src = source
    local objectId = CreateIdType('casing')
    Objects[objectId] = type
    TriggerClientEvent("pepe-police:client:place:object", -1, objectId, type, src)
end)

RegisterServerEvent('pepe-police:server:delete:object')
AddEventHandler('pepe-police:server:delete:object', function(objectId)
    local src = source
    TriggerClientEvent('pepe-police:client:remove:object', -1, objectId)
end)

-- // Police Alerts Events \\ --

RegisterServerEvent('pepe-police:server:send:alert:officer:down')
AddEventHandler('pepe-police:server:send:alert:officer:down', function(Coords, StreetName, Info, Priority)
   TriggerClientEvent('pepe-police:client:send:officer:down', -1, Coords, StreetName, Info, Priority)
end)

RegisterServerEvent('pepe-police:server:send:alert:panic:button')
AddEventHandler('pepe-police:server:send:alert:panic:button', function(Coords, StreetName, Info)
    local AlertData = {title = "Assistance officer", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Emergency button pressed by "..Info['Callsign'].." "..Info['Firstname']..' '..Info['Lastname'].." at "..StreetName}
    TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
    TriggerClientEvent('pepe-police:client:send:alert:panic:button', -1, Coords, StreetName, Info)
end)

RegisterServerEvent('pepe-police:server:send:alert:gunshots')
AddEventHandler('pepe-police:server:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
    local AlertData = {title = "Shots fired",coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = 'Shots fired at ' ..StreetName}
    if InVeh then
      AlertData = {title = "Shots fired",coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = 'Shots fired from vehicle, at ' ..StreetName}
    end
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:alert:gunshots', -1, Coords, GunType, StreetName, InVeh)
end)

RegisterServerEvent('pepe-police:server:send:alert:dead')
AddEventHandler('pepe-police:server:send:alert:dead', function(Coords, StreetName)
   local AlertData = {title = "Injured Citizen", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "A injured civilian has been reported at "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:alert:dead', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:bank:alert')
AddEventHandler('pepe-police:server:send:bank:alert', function(Coords, StreetName, CamId)
   local AlertData = {title = "Bank Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "A fleeca bank alarm has just been triggered at "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:bank:alert', -1, Coords, StreetName, CamId)
end)

RegisterServerEvent('pepe-police:server:send:big:bank:alert')
AddEventHandler('pepe-police:server:send:big:bank:alert', function(Coords, StreetName)
   local AlertData = {title = "Bank Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Pacific bank alarm has been triggered at "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:big:bank:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:alert:jewellery')
AddEventHandler('pepe-police:server:send:alert:jewellery', function(Coords, StreetName)
   local AlertData = {title = "Jeweler Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "The vangelico jeweler's alarm has just been triggered at "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:alert:jewellery', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:alert:store')
AddEventHandler('pepe-police:server:send:alert:store', function(streetName, CCTV, Coords)
   local AlertData = {title = "Store Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "The alarm from a store has gone off at " ..streetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:alert:store', -1, streetName, CCTV)
end)
RegisterServerEvent('pepe-police:server:send:alert:ammunation')
AddEventHandler('pepe-police:server:send:alert:ammunation', function(Coords, StreetName)
   local AlertData = {title = "Weaponstore alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "The weaponstore alarm has just been triggered at "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:alert:ammunation', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:house:alert')
AddEventHandler('pepe-police:server:send:house:alert', function(Coords, StreetName)
   local AlertData = {title = "House Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "A house alarm system has been triggered off at "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:house:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:house2:alert')
AddEventHandler('pepe-police:server:send:house2:alert', function(Coords, StreetName)
   local AlertData = {title = "House Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "A house alarm system has been triggered off at "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:house2:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:house3:alert')
AddEventHandler('pepe-police:server:send:house3:alert', function(Coords, StreetName)
   local AlertData = {title = "House Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "A house alarm system has been triggered off at "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:house3:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:house4:alert')
AddEventHandler('pepe-police:server:send:house4:alert', function(Coords, StreetName)
   local AlertData = {title = "House Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "A house alarm system has been triggered off at "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:house4:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:send:alert:ifruit')
AddEventHandler('pepe-police:server:send:alert:ifruit', function(Coords, StreetName)
   local AlertData = {title = "iFruit Store Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "A alarm system has been triggered off at "..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:alert:ifruit', -1, Coords, StreetName)
end)


RegisterServerEvent('pepe-police:server:send:banktruck:alert')
AddEventHandler('pepe-police:server:send:banktruck:alert', function(Coords, Plate, StreetName)
   local AlertData = {title = "Bank Truck Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "A bank truck alarm system has been triggered with the license plate: "..Plate..'. at '..StreetName}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:banktruck:alert', -1, Coords, Plate, StreetName)
end)

RegisterServerEvent('pepe-police:server:alert:explosion')
AddEventHandler('pepe-police:server:alert:explosion', function(Coords, StreetName)
   local AlertData = {title = "Explosion Alert", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Explosion reported nearby: "..StreetName.."."}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:explosion:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('pepe-police:server:alert:cornerselling')
AddEventHandler('pepe-police:server:alert:cornerselling', function(Coords, StreetName)
   local AlertData = {title = "Suspicious Activity", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Er is een verdachte situatie nabij: "..StreetName.."."}
   TriggerClientEvent("pepe-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('pepe-police:client:send:cornerselling:alert', -1, Coords, StreetName)
end)

Framework.Functions.CreateCallback('police:SeizeDriverLicense', function(source, cb, playerId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local SearchedPlayer = Framework.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then
        local driverLicense = SearchedPlayer.PlayerData.metadata["licences"]["driver"]
        if driverLicense then
            local licenses = {
                ["driver"] = false,
            }
            SearchedPlayer.Functions.SetMetaData("licences", licenses)
            TriggerClientEvent('Framework:Notify', SearchedPlayer.PlayerData.source, "Ditt körkort har beslagtagits..")
        else
            TriggerClientEvent('Framework:Notify', src, "Kan inte ta körkort..", "error")
        end
    end
end)
Framework.Commands.Add("giveweplicense", "Give weapon license", {{name="id", help="Player ID"}, {name="type", help="License Type"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = Framework.Functions.GetPlayer(playerId)
    local LicenseType = tonumber(args[2])
    local licenses = {
          ["driver"] = OtherPlayer.PlayerData.metadata["licences"]["driver"],
          ["weapon"] = true,
    }

    if LicenseType == 1 then
        LicenseType = "1"
    elseif LicenseType == 2 then
        LicenseType = "2"
    elseif LicenseType == 3 then
        LicenseType = "3"
    elseif LicenseType == 4 then
        LicenseType = "1/2"
    elseif LicenseType == 5 then
        LicenseType = "1/2/3"
    end

    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.grade.level == 3 or Player.PlayerData.job.grade.level == 4 then
       if OtherPlayer ~= nil then 
            local licenseinfo = {
                citizenid = OtherPlayer.PlayerData.citizenid,
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                type = LicenseType,
            }
            
                        OtherPlayer.Functions.SetMetaData("licences", licenses)
        else
            TriggerClientEvent("Framework:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("Framework:Notify", source, "You have no rights..", "error")
    end
end)
Framework.Commands.Add("seizedriverlicense", "Seize someones drivers license", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
        TriggerClientEvent("police:client:SeizeDriverLicense", source)
    end
end)

Framework.Commands.Add("takedna", "Take a DNA sample from one person (empty evidence bag is required)", {{"id", "Person-id"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local OtherPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) and OtherPlayer ~= nil then
        if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
            local info = {
                label = "DNA-Sample",
                type = "dna",
                dnalabel = DnaHash(OtherPlayer.PlayerData.citizenid),
            }
            if Player.Functions.AddItem("filled_evidence_bag", 1, false, info) then
                TriggerClientEvent("pepe-inventory:client:ItemBox", source, Framework.Shared.Items["filled_evidence_bag"], "add")
            end
        else
            TriggerClientEvent('Framework:Notify', source, "You must have an empty evidence bag with you", "error")
        end
    end
end)
Framework.Commands.Add("seizecash", "Take cash from the nearest person", {}, false, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerClientEvent("police:client:SeizeCash", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for police only!")
    end
end)

Framework.Functions.CreateCallback('police:SeizeCash', function(source, cb, playerId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local SearchedPlayer = Framework.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        local moneyAmount = SearchedPlayer.PlayerData.money["cash"]
        local info = {
            cash = moneyAmount,
        }
        SearchedPlayer.Functions.RemoveMoney("cash", moneyAmount, "police-cash-seized")
        Player.Functions.AddItem("moneybag", 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, Framework.Shared.Items["moneybag"], "add")
        TriggerClientEvent('Framework:Notify', SearchedPlayer.PlayerData.source, "You cash was confiscated..", "info")
    end
end)
Framework.Functions.CreateUseableItem("moneybag", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if item.info ~= nil and item.info ~= "" then
            if Player.PlayerData.job.name ~= "police" then
                if Player.Functions.RemoveItem("moneybag", 1, item.slot) then
                    Player.Functions.AddMoney("cash", tonumber(item.info.cash), "used-moneybag")
                end
            end
        end
    end
end)


Framework.Functions.CreateCallback('police:GetPlayerStatus', function(source, cb, playerId)
    local Player = Framework.Functions.GetPlayer(playerId)
    local statList = {}
	if Player ~= nil then
        if PlayerStatus[Player.PlayerData.source] ~= nil and next(PlayerStatus[Player.PlayerData.source]) ~= nil then
            for k, v in pairs(PlayerStatus[Player.PlayerData.source]) do
                table.insert(statList, PlayerStatus[Player.PlayerData.source][k].text)
            end
        end
	end
    cb(statList)
end)



function DnaHash(s)
    local h = string.gsub(s, ".", function(c)
		return string.format("%02x", string.byte(c))
	end)
    return h
end

RegisterServerEvent('pepe-police:server:SyncSpikes')
AddEventHandler('pepe-police:server:SyncSpikes', function(table)
    TriggerClientEvent('pepe-police:client:SyncSpikes', -1, table)
end)
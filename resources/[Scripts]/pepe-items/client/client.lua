local currentVest = nil
local currentVestTexture = nil
Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
	 Citizen.Wait(250)
 end)
end)

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end) 

-- Code

RegisterNetEvent('pepe-items:client:drink')
AddEventHandler('pepe-items:client:drink', function(ItemName, PropName)
	TriggerServerEvent('Framework:Server:RemoveItem', ItemName, 1)
	--TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items[ItemName], "remove")
 Citizen.SetTimeout(1000, function()
 	TriggerEvent('pepe-assets:addprop:with:anim', PropName, 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 10000)
 	Framework.Functions.Progressbar("drink", "Đang uống..", 6000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	 }, {}, {}, {}, function() -- Done
		 exports['pepe-assets']:RemoveProp()
		 TriggerServerEvent("Framework:Server:SetMetaData", "thirst", Framework.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
	 end, function()
		exports['pepe-assets']:RemoveProp()
 		Framework.Functions.Notify("Hủy bỏ..", "error")
		 TriggerServerEvent('Framework:Server:AddItem', ItemName, 1)
		 --TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items[ItemName], "add")
 	end)
 end)
end)

RegisterNetEvent('pepe-items:client:drink:alcohol')
AddEventHandler('pepe-items:client:drink:alcohol', function(ItemName, PropName)
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
    	 	Citizen.SetTimeout(1000, function()
    			exports['pepe-assets']:AddProp(PropName)
    			TriggerEvent('pepe-inventory:client:set:busy', true)
    			exports['pepe-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    	 		Framework.Functions.Progressbar("drink", "Đang uống..", 10000, false, true, {
    	 			disableMovement = false,
    	 			disableCarMovement = false,
    	 			disableMouse = false,
    	 			disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
    				 exports['pepe-assets']:RemoveProp()
    				 TriggerEvent('pepe-inventory:client:set:busy', false)
    				 TriggerServerEvent('Framework:Server:RemoveItem', ItemName, 1)
    				 TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items[ItemName], "remove")
    				 StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    				 TriggerServerEvent("Framework:Server:SetMetaData", "thirst", Framework.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
             		TriggerEvent('fullsatan:GetDrunk')
 
    			 end, function()
					DoingSomething = false
    				exports['pepe-assets']:RemoveProp()
    				TriggerEvent('pepe-inventory:client:set:busy', false)
    	 			Framework.Functions.Notify("Cancelled..", "error")
    				StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    	 		end)
    	 	end)
		end
	end
end)

RegisterNetEvent('pepe-items:client:drink:slushy')
AddEventHandler('pepe-items:client:drink:slushy', function()
	TriggerServerEvent('Framework:Server:RemoveItem', 'slushy', 1)
	--TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['slushy'], "remove")
 Citizen.SetTimeout(1000, function()
 	TriggerEvent('pepe-assets:addprop:with:anim', 'Cup', 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 10000)
 	Framework.Functions.Progressbar("drink", "Đang uống..", 6000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	 }, {}, {}, {}, function() -- Done
		 exports['pepe-assets']:RemoveProp()
		 TriggerServerEvent('pepe-hud:server:remove:stress', math.random(12, 20))
		 TriggerServerEvent("Framework:Server:SetMetaData", "thirst", Framework.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
	 end, function()
		exports['pepe-assets']:RemoveProp()
 		Framework.Functions.Notify("Cancelled..", "error")
		 TriggerServerEvent('Framework:Server:AddItem', 'slushy', 1)
		 --TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['slushy'], "add")
 	end)
 end)
end)

RegisterNetEvent('pepe-items:client:eat')
AddEventHandler('pepe-items:client:eat', function(ItemName, PropName)
	if not exports['pepe-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
 			Citizen.SetTimeout(1000, function()
				exports['pepe-assets']:AddProp(PropName)
				TriggerEvent('pepe-inventory:client:set:busy', true)
				exports['pepe-assets']:RequestAnimationDict("mp_player_inteat@burger")
				TaskPlayAnim(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
 				Framework.Functions.Progressbar("eat", "Đang ăn..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
					 exports['pepe-assets']:RemoveProp()
					 TriggerEvent('pepe-inventory:client:set:busy', false)
					 TriggerServerEvent('pepe-hud:server:remove:stress', math.random(6, 10))
					 TriggerServerEvent('Framework:Server:RemoveItem', ItemName, 1)
					 StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
					 TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items[ItemName], "remove")
					 if ItemName == 'burger-heartstopper' then
						TriggerServerEvent("Framework:Server:SetMetaData", "hunger", Framework.Functions.GetPlayerData().metadata["hunger"] + math.random(40, 50))
					 else
						TriggerServerEvent("Framework:Server:SetMetaData", "hunger", Framework.Functions.GetPlayerData().metadata["hunger"] + math.random(20, 35))
					 end
				 	end, function()
					DoingSomething = false
					exports['pepe-assets']:RemoveProp()
					TriggerEvent('pepe-inventory:client:set:busy', false)
 					Framework.Functions.Notify("Canceled..", "error")
					StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent('pepe-items:client:use:armor')
AddEventHandler('pepe-items:client:use:armor', function()
 local CurrentArmor = GetPedArmour(PlayerPedId())
 if CurrentArmor <= 100 and CurrentArmor + 33 <= 100 then
	local NewArmor = CurrentArmor + 33
	if CurrentArmor + 33 >= 100 or CurrentArmor >= 100 then NewArmor = 100 end
	TriggerServerEvent('Framework:Server:RemoveItem', 'armor', 1)
	--TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['armor'], "remove")
     Framework.Functions.Progressbar("vest", "Đang mặc..", 1000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
     }, {}, {}, {}, function() -- Done
   	 	 SetPedArmour(PlayerPedId(), NewArmor)
		 TriggerServerEvent('pepe-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
     	 Framework.Functions.Notify("Thành công", "success")
     end, function()
     	Framework.Functions.Notify("Hủy bỏ..", "error")
		 TriggerServerEvent('Framework:Server:AddItem', 'armor', 1)
    	 --TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['armor'], "add")
     end)
 else
	Framework.Functions.Notify("Bạn đã mặc áo giáp..", "error")
 end
end)

RegisterNetEvent("pepe-items:client:use:heavy")
AddEventHandler("pepe-items:client:use:heavy", function()
	TriggerServerEvent('Framework:Server:RemoveItem', 'heavy-armor', 1)
    local Sex = "Man"
    if Framework.Functions.GetPlayerData().charinfo.gender == 1 then
      Sex = "Vrouw"
    end
    Framework.Functions.Progressbar("use_heavyarmor", "Đang mặc..", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		--TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['heavy-armor'], "remove")
        if Sex == 'Man' then
        currentVest = GetPedDrawableVariation(PlayerPedId(), 9)
        currentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
        if GetPedDrawableVariation(PlayerPedId(), 9) == 7 then
            SetPedComponentVariation(PlayerPedId(), 0, 0, GetPedTextureVariation(PlayerPedId(), 0), 0)
        else
            SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
        end
        SetPedArmour(PlayerPedId(), 100)
      else
        currentVest = GetPedDrawableVariation(PlayerPedId(), 9)
        currentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
        if GetPedDrawableVariation(PlayerPedId(), 9) == 7 then
            SetPedComponentVariation(PlayerPedId(), 9, 20, GetPedTextureVariation(PlayerPedId(), 9), 2)
        else
            SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
        end
		SetPedArmour(PlayerPedId(), 100)
		TriggerServerEvent('pepe-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
      end
    end)
end)

RegisterNetEvent("pepe-items:client:reset:armor")
AddEventHandler("pepe-items:client:reset:armor", function()
    local ped = PlayerPedId()
    if currentVest ~= nil and currentVestTexture ~= nil then 
        Framework.Functions.Progressbar("remove-armor", "Đang cởi áo..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(PlayerPedId(), 0, currentVest, currentVestTexture, 0)
            SetPedArmour(PlayerPedId(), 0)
			Framework.Functions.TriggerCallback('pepe-items:server:giveitem', 'heavy-armor', 1)
			TriggerServerEvent('pepe-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
        end)
    else
        Framework.Functions.Notify("Bạn không mặc áo vest.", "error")
    end
end)

RegisterNetEvent('pepe-items:client:use:repairkit')
AddEventHandler('pepe-items:client:use:repairkit', function()
	local PlayerCoords = GetEntityCoords(PlayerPedId())
	local Vehicle, Distance = Framework.Functions.GetClosestVehicle()
	if GetVehicleEngineHealth(Vehicle) < 1000.0 then
		NewHealth = GetVehicleEngineHealth(Vehicle) + 250.0
		if GetVehicleEngineHealth(Vehicle) + 250.0 > 1000.0 then 
			NewHealth = 1000.0 
		end
		if Distance < 4.0 and not IsPedInAnyVehicle(PlayerPedId()) then
			local EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, 2.5, 0)
			if IsBackEngine(GetEntityModel(Vehicle)) then
			  EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -2.5, 0)
			end
		if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, EnginePos) < 4.0 then
			local VehicleDoor = nil
			if IsBackEngine(GetEntityModel(Vehicle)) then
				VehicleDoor = 5
			else
				VehicleDoor = 4
			end
			SetVehicleDoorOpen(Vehicle, VehicleDoor, false, false)
			TriggerServerEvent('Framework:Server:RemoveItem', 'repairkit', 1)
			Citizen.Wait(450)
			Framework.Functions.Progressbar("repair_vehicle", "Đang sửa xe..", math.random(10000, 20000), false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {
				animDict = "mini@repair",
				anim = "fixing_a_player",
				flags = 16,
			}, {}, {}, function() -- Done
				if math.random(1,50) < 10 then
				  TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['repairkit'], "remove")
				end
				SetVehicleDoorShut(Vehicle, VehicleDoor, false)
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				Framework.Functions.Notify("Xe đã được sửa chữa", "success")
				SetVehicleEngineHealth(Vehicle, NewHealth) 
				for i = 1, 6 do
				 SetVehicleTyreFixed(Vehicle, i)
				end
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				Framework.Functions.Notify("Thất bại!", "error")
				SetVehicleDoorShut(Vehicle, VehicleDoor, false)
			end)
		end
	 else
		Framework.Functions.Notify("Không có phương tiện ở gần", "error")
	end
	end	
end)

RegisterNetEvent('pepe-items:client:dobbel')
AddEventHandler('pepe-items:client:dobbel', function(Amount, Sides)
	local DiceResult = {}
	for i = 1, Amount do
		table.insert(DiceResult, math.random(1, Sides))
	end
	local RollText = CreateRollText(DiceResult, Sides)
	TriggerEvent('pepe-items:client:dice:anim')
	Citizen.SetTimeout(1900, function()
		TriggerServerEvent('pepe-sound:server:play:distance', 2.0, 'dice', 0.5)
		TriggerServerEvent('pepe-assets:server:display:text', RollText)
	end)
end)

RegisterNetEvent('pepe-items:client:coinflip')
AddEventHandler('pepe-items:client:coinflip', function()
	local CoinFlip = {}
	local Random = math.random(1,2)
     if Random <= 1 then
		CoinFlip = 'Coinflip: ~g~Heads'
     else
		CoinFlip = 'Coinflip: ~y~Tails'
	 end
	 TriggerEvent('pepe-items:client:dice:anim')
	 Citizen.SetTimeout(1900, function()
		TriggerServerEvent('pepe-sound:server:play:distance', 2.0, 'coin', 0.5)
		TriggerServerEvent('pepe-assets:server:display:text', CoinFlip)
	 end)
end)

RegisterNetEvent('pepe-items:client:dice:anim')
AddEventHandler('pepe-items:client:dice:anim', function()
	exports['pepe-assets']:RequestAnimationDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('pepe-items:client:use:duffel-bag')
AddEventHandler('pepe-items:client:use:duffel-bag', function(BagId)
    TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", 'tas_'..BagId, {maxweight = 25000, slots = 3})
    TriggerEvent("pepe-inventory:client:SetCurrentStash", 'tas_'..BagId)
end)
--  // Functions \\ --

function IsBackEngine(Vehicle)
    for _, model in pairs(Config.BackEngineVehicles) do
        if GetHashKey(model) == Vehicle then
            return true
        end
    end
    return false
end

function CreateRollText(rollTable, sides)
    local s = "~g~Dices~s~: "
    local total = 0
    for k, roll in pairs(rollTable, sides) do
        total = total + roll
        if k == 1 then
            s = s .. roll .. "/" .. sides
        else
            s = s .. " | " .. roll .. "/" .. sides
        end
    end
    s = s .. " | (Tổng số: ~g~"..total.."~s~)"
    return s
end



RegisterNetEvent('pepe-items:client:use:cigarette')
AddEventHandler('pepe-items:client:use:cigarette', function()
  Citizen.SetTimeout(1000, function()
    Framework.Functions.Progressbar("smoke-cigarette", "Lấy một điếu thuốc..", 4500, false, true, {
     disableMovement = false,
     disableCarMovement = false,
     disableMouse = false,
     disableCombat = true,
     }, {}, {}, {}, function() -- Done
        TriggerServerEvent('Framework:Server:RemoveItem', 'ciggy', 1)
        TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items["ciggy"], "remove")
        TriggerEvent('pepe-items:client:smoke:effect')
        if IsPedInAnyVehicle(PlayerPedId(), false) then
			TriggerEvent('animations:client:EmoteCommandStart', {"smoke"})
        else
            TriggerEvent('animations:client:EmoteCommandStart', {"smoke2"})
		end
    end)
  end)
end)

RegisterNetEvent('pepe-items:client:smoke:effect')
AddEventHandler('pepe-items:client:smoke:effect', function()
  OnWeed = true
  Time = 15
  while OnWeed do
    if Time > 0 then
     Citizen.Wait(1000)
     Time = Time - 1
     TriggerServerEvent('pepe-hud:server:remove:stress', math.random(1, 3))
    end
     if Time <= 0 then
      OnWeed = false
     end 
  end
end)
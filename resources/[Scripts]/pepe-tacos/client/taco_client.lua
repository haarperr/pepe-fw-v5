local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Framework = nil

local Bezig = false

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if Framework == nil then
            TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('pepe-tacos:client:SetStock')
AddEventHandler('pepe-tacos:client:SetStock', function(stock, amount)
	Config.JobData[stock] = amount
end)

-- Code

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		 for k,v in pairs(Config.JobData['locations']) do
		  local Positie = GetEntityCoords(PlayerPedId(), false)
		  local Gebied = GetDistanceBetweenCoords(Positie.x, Positie.y, Positie.z, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, true)
		    if Gebied <= 1.3 then
				if Config.JobData['locations'][k]['name'] == 'Lettuce' then
					DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Grab Lettuce\n Lettuce stock: ~g~'..Config.JobData['stock-lettuce']..'x')
					DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 44, 194, 33, 255, false, false, false, 1, false, false, false)
				elseif Config.JobData['locations'][k]['name'] == 'Meat' then
					DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Bake Meat\n Meat stock: ~r~'..Config.JobData['stock-meat']..'x')
					DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 138, 34, 34, 255, false, false, false, 1, false, false, false)
				elseif Config.JobData['locations'][k]['name'] == 'Shell' then
					DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Prepare Taco')
					DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 194, 147, 29, 255, false, false, false, 1, false, false, false)
				elseif Config.JobData['locations'][k]['name'] == 'GiveTaco' then
					DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Deliver Taco')
					DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
				elseif Config.JobData['locations'][k]['name'] == 'Stock' then
					DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Deliver box')
					DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
				elseif Config.JobData['locations'][k]['name'] == 'Register' then
					 if Config.JobData['register'] >= 10000 then
						DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Grab money \nRegister capacity: ~g~Enough money!')
					else
						DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Grab money \nRegister capacity: ~r~Not enough..')
					end
					    DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 46, 209, 206, 255, false, false, false, 1, false, false, false)
				end
				 if IsControlJustPressed(0, Keys['E']) then
				  if not Bezig then
					if Config.JobData['locations'][k]['name'] == 'Lettuce' then
						GetLettuce()
					elseif Config.JobData['locations'][k]['name'] == 'Meat' then
						BakeMeat()
					elseif Config.JobData['locations'][k]['name'] == 'Shell' then
						Framework.Functions.TriggerCallback('pepe-taco:server:get:ingredient', function(HasItems)  
                        if HasItems then
							FinishTaco()
						else
							Framework.Functions.Notify("You don\'t have all the Ingredients yet..", "error")
						end
					end)
					elseif Config.JobData['locations'][k]['name'] == 'Register' then
						TakeMoney()
					elseif Config.JobData['locations'][k]['name'] == 'Stock' then
						AddStuff()
					elseif Config.JobData['locations'][k]['name'] == 'GiveTaco' then
						GiveTacoToShop()
					 end
					 else
						Framework.Functions.Notify("You are already busy..", "error")
					end
				end
			end
		end
	end
end)

-- functions

function FinishTaco()
	Bezig = true
	TriggerEvent('inventory:client:busy:status', true)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "wave", 3.2)
	Framework.Functions.Progressbar("pickup_sla", "Making taco..", 3500, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {
		animDict = "mp_common",
		anim = "givetake1_a",
		flags = 8,
	}, {}, {}, function() -- Done
		Bezig = false
		TriggerEvent('inventory:client:busy:status', false)
		--TriggerServerEvent('Framework:Server:RemoveItem', "meat", 1)
		--TriggerServerEvent('Framework:Server:RemoveItem', "lettuce", 1)
		
		TriggerServerEvent('pepe-tacos:server:rem:stuff', "meat")
		TriggerServerEvent('pepe-tacos:server:rem:stuff', "lettuce")
		TriggerServerEvent('pepe-tacos:server:add:stuff', "taco")
		TriggerEvent('pepe-inventory:client:ItemBox', Framework.Shared.Items['meat'], 'remove')
		TriggerEvent('pepe-inventory:client:ItemBox', Framework.Shared.Items['lettuce'], 'remove')
		TriggerEvent('pepe-inventory:client:ItemBox', Framework.Shared.Items['taco'], 'add')
		TriggerEvent('pepe-sound:client:play', 'micro', 0.2)
	end, function()
		TriggerEvent('inventory:client:busy:status', false)
		Framework.Functions.Notify("Canceled..", "error")
		Bezig = false
	end)
end

function BakeMeat()
	if Config.JobData['stock-meat'] >= 1 then
	Bezig = true
	TriggerEvent('pepe-sound:client:play', 'Meat', 0.7)
	Framework.Functions.Progressbar("pickup_sla", "Baking meat..", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {
		animDict = "amb@prop_human_bbq@male@base",
		anim = "base",
		flags = 8,
	}, {
		model = "prop_cs_fork",
        bone = 28422,
        coords = { x = -0.005, y = 0.00, z = 0.00 },
        rotation = { x = 175.0, y = 160.0, z = 0.0 },
	}, {}, function() -- Done
		--TriggerServerEvent('Framework:Server:AddItem', "meat", 1)
		
		TriggerServerEvent('pepe-tacos:server:add:stuff', "meat")
		TriggerServerEvent('pepe-taco:server:set:taco:count', 'Min', 'stock-meat', 1)
		TriggerEvent('pepe-inventory:client:ItemBox', Framework.Shared.Items['meat'], 'add')
		Bezig = false
	end, function()
		Framework.Functions.Notify("Canceled..", "error")
		Bezig = false
	end)
else
	Framework.Functions.Notify("There is not enough meat in stock..", "error")
 end  
end

function GetLettuce()
	if Config.JobData['stock-lettuce'] >= 1 then
	Bezig = true
			TriggerEvent('pepe-sound:client:play', 'fridge', 0.5)
	Framework.Functions.Progressbar("pickup_sla", "Grabbing lettuce..", 4100, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {
		animDict = "amb@prop_human_bum_bin@idle_b",
		anim = "idle_d",
		flags = 8,
	}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
		TriggerServerEvent('pepe-tacos:server:add:stuff', 'lettuce')
		--TriggerServerEvent('Framework:Server:AddItem', "lettuce", 1)
		TriggerServerEvent('pepe-taco:server:set:taco:count', 'Min', 'stock-lettuce', 1)
		TriggerEvent('pepe-inventory:client:ItemBox', Framework.Shared.Items['lettuce'], 'add')
		Bezig = false
	end, function()
		StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
		Framework.Functions.Notify("Canceled..", "error")
		Bezig = false
	end)
else
	Framework.Functions.Notify("There is not enough lettuce in stock..", "error")
 end 
end

function GiveTacoToShop()
	Framework.Functions.TriggerCallback('pepe-taco:server:get:tacos', function(HasItem, type)
		if HasItem then
		  if not IsPedInAnyVehicle(PlayerPedId(), false) then
			if Config.JobData['tacos'] <= 9 then	
				Framework.Functions.Notify("Taco delivered!", "success")
				TriggerServerEvent('pepe-taco:server:set:taco:count', 'Plus', 'tacos', 1)
				--TriggerServerEvent('Framework:Server:RemoveItem', "taco", 1)
				TriggerServerEvent('pepe-tacos:server:rem:stuff', "taco")
				TriggerEvent('pepe-inventory:client:ItemBox', Framework.Shared.Items['taco'], 'remove')
				else
					Framework.Functions.Notify("There are still 10 taco\'s that have to be sold. We dont waste food here..", "error")
				end
		  elseif type == 'green' then
			if Config.JobData['green-tacos'] <= 9 then	
				--TriggerServerEvent('Framework:Server:RemoveItem', "taco", 1)
				
				TriggerServerEvent('pepe-tacos:server:rem:taco')
				TriggerEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['green-taco'], 'remove')
				else
					Framework.Functions.Notify("There are still 10 taco\'s that have to be sold. We dont waste food here..", "error")
				end
		end
	    else
		Framework.Functions.Notify("You dont even have a taco..", "error")
	 end
	end)
end

function AddStuff()
	Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
		if HasItem then
			if Config.JobBusy == true then
				--TriggerServerEvent('Framework:Server:RemoveItem', "taco-box", 1)
				TriggerEvent('pepe-inventory:client:ItemBox', Framework.Shared.Items['taco-box'], 'remove')
				
		TriggerServerEvent('pepe-tacos:server:rem:stuff', "taco-box")
				TriggerServerEvent('pepe-taco:server:set:taco:count', 'Plus', 'stock-meat', math.random(1,7))
				TriggerServerEvent('pepe-taco:server:set:taco:count', 'Plus', 'stock-lettuce', math.random(1,7))
				Framework.Functions.Notify("Taco Shop has been restocked!", "success")
				Config.JobBusy = false
			else
				Framework.Functions.Notify("You\'re coming straight from the taco store..", "error")
			end
		else
			Framework.Functions.Notify("You don\'t even have a box of ingredients..", "error")
		end
	end, 'taco-box')
end

function TakeMoney()
	if Config.JobData['register'] >= 10000 then
		local lockpickTime = math.random(10000,35000)
		RegisterAnim(lockpickTime)
		Framework.Functions.Progressbar("search_register", "Clearing register..", lockpickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "veh@break_in@0h@p_m_one@",
            anim = "low_force_entry_ds",
            flags = 16,
        }, {}, {}, function() -- Done
            GetMoney = false  
			TriggerServerEvent('pepe-taco:server:set:taco:count', 'Min', 'register', 10000)    
        end, function() -- Cancel
            GetMoney = false
            ClearPedTasks(PlayerPedId())
            Framework.Functions.Notify("Process Canceled..", "error")
        end)
	else
		Framework.Functions.Notify("There is not enough money in the register yet..", "error")
	end
end

function DrawText3Ds(x,y,z, text)
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

function RegisterAnim(time)
	time = time / 1000
	loadAnimDict("veh@break_in@0h@p_m_one@")
	TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
	GetMoney = true
	Citizen.CreateThread(function()
	while GetMoney do
		TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
		Citizen.Wait(2000)
		time = time - 2
		TriggerServerEvent('pepe-storerobbery:server:takeMoney', currentRegister, false)
		if time <= 0 then
			GetMoney = false
			StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
		end
	end
	end)
	end

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(8.00,-1604.92, 29.37)
	SetBlipSprite(blip, 52)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 73)  
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Taco Shop")
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
	TacoVoor = AddBlipForCoord(650.68, 2727.25, 41.99)
    SetBlipSprite (TacoVoor, 569)
    SetBlipDisplay(TacoVoor, 4)
    SetBlipScale  (TacoVoor, 0.6)
    SetBlipAsShortRange(TacoVoor, true)
    SetBlipColour(TacoVoor, 39)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Taco Shop Storage")
    EndTextCommandSetBlipName(TacoVoor)
end)
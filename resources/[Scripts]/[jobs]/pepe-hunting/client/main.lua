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

local OnGoingHuntSession = false
local HuntCar = nil
local veh = nil

local cord = {x=-678.7621, y = 5837.982, z = 17.33}

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler("Framework:Client:OnPlayerLoaded", function()
 ScriptLoaded()
end)

Citizen.CreateThread(function()
	AddTextEntry("Hunting", "Hunting Area")
	for k, v in pairs(Config.Hunting) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite(blip, 141)
		SetBlipColour(blip, 0)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("Hunting")
		EndTextCommandSetBlipName(blip)
	end
end)
local zone = nil
local blip = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
		--print(OnGoingHuntSession)
		if OnGoingHuntSession then
		for _,new_zone in pairs(Config.zones) do
				if not setblip then
					zone = AddBlipForRadius(new_zone.coords.x, new_zone.coords.y, new_zone.coords.z, new_zone.zone.radius)
					SetBlipSprite(zone, 9)
					SetBlipAlpha(zone, 100)
					SetBlipColour(zone, new_zone.zone.color)
							
					if (new_zone.blip.draw == true) then
						blip = AddBlipForCoord(new_zone.coords.x, new_zone.coords.y, new_zone.coords.z)
						SetBlipSprite(blip, new_zone.blip.id)
						SetBlipColour(blip, new_zone.blip.color)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(new_zone.blip.text)
						EndTextCommandSetBlipName(blip)
					end
					setblip = true
				else
				end
			end
		else
			RemoveBlip(zone)	
		end
    end
end)

function ScriptLoaded()
	Citizen.Wait(1000)
	LoadMarkers()
end

local AnimalPositions = {
	{ x = -1505.2, y = 4887.39, z = 78.38 },
	{ x = -1164.68, y = 4806.76, z = 223.11 },
	{ x = -1410.63, y = 4730.94, z = 44.0369 },
	{ x = -1377.29, y = 4864.31, z = 134.162 },
	{ x = -1697.63, y = 4652.71, z = 22.2442 },
	{ x = -1259.99, y = 5002.75, z = 151.36 },
	{ x = -960.91, y = 5001.16, z = 183.0 },
}
local AnimalsInSession = {}

function LoadMarkers()

	LoadModel('blazer')
	LoadModel('a_c_deer')
	LoadAnimDict('amb@medic@standing@kneel@base')
    LoadAnimDict('anim@gangops@facility@servers@bodysearch@')

end


RegisterNetEvent('pepe-hunting:client:sync:start')
AddEventHandler('pepe-hunting:client:sync:start', function(source)


	if OnGoingHuntSession then

		OnGoingHuntSession = false
		TriggerServerEvent('pepe-hunting:server:remove:knife')
		--[[RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_MUSKET"), true, true)
		RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"), true, true)]]--

		for index, value in pairs(AnimalsInSession) do
			if DoesEntityExist(value.id) then
				DeleteEntity(value.id)
			end
		end

	else
		OnGoingHuntSession = true
		TriggerServerEvent('pepe-hunting:server:recieve:knife')

		--Animals

		Citizen.CreateThread(function()

				
			for index, value in pairs(AnimalPositions) do
				local Animal = CreatePed(5, GetHashKey('a_c_deer'), value.x, value.y, value.z, 0.0, true, false)
				TaskWanderStandard(Animal, true, true)
				SetEntityAsMissionEntity(Animal, true, true)
				table.insert(AnimalsInSession, {id = Animal, x = value.x, y = value.y, z = value.z, Blipid = AnimalBlip})
			end

			while OnGoingHuntSession do
				local sleep = 500
				for index, value in ipairs(AnimalsInSession) do
					if DoesEntityExist(value.id) then
						local AnimalCoords = GetEntityCoords(value.id)
						local PlyCoords = GetEntityCoords(PlayerPedId())
						local AnimalHealth = GetEntityHealth(value.id)
						
						local PlyToAnimal = GetDistanceBetweenCoords(PlyCoords, AnimalCoords, true)

						if AnimalHealth <= 0 then
							SetBlipColour(value.Blipid, 3)
							if PlyToAnimal < 2.0 then
								sleep = 5

								DrawText3D(AnimalCoords.x,AnimalCoords.y,AnimalCoords.z + 1, '[E] Skin animal')

								if IsControlJustReleased(0, Keys['E']) then
                                    --if HasValidWeapon() then
										if DoesEntityExist(value.id) then
											table.remove(AnimalsInSession, index)
											SlaughterAnimal(value.id)
										end
                                    --else
                                    --Citizen.Wait(100)
                                   -- Framework.Functions.Notify("You need to use the knife!")
									--end
								end

							end
						end
					end
				end

				Citizen.Wait(sleep)

			end
				
		end)
	end
	Framework.Functions.Notify("Hunting area shown on your map.", "success")
end)


RegisterNetEvent('pepe-hunting:client:sync:stop')
AddEventHandler('pepe-hunting:client:sync:stop', function(source)
	OnGoingHuntSession = false
	RemoveBlip(AnimalBlip)
	DeleteEntity(Animal)
	Framework.Functions.Notify("You are no longer hunting", "success")
end)

function HasValidWeapon()
	local CurrentWeapon = GetSelectedPedWeapon(PlayerPedId())
	for k, v in pairs(Config.HuntWeapons) do
	  if CurrentWeapon == v then
		  return true
	  end
	end
  end
function SlaughterAnimal(AnimalId)

	TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )

	Citizen.Wait(5000)

	ClearPedTasks(PlayerPedId())

	local AnimalWeight = math.random(10, 160) / 10

    Framework.Functions.Notify('You skinned the animal. Weight: ' ..AnimalWeight.. 'LB')

	TriggerServerEvent('pepe-hunt:reward', AnimalWeight)

	DeleteEntity(AnimalId)
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

function LoadModel(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(10)
    end
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 400
    DrawRect(0.0, 0.0+0.0110, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
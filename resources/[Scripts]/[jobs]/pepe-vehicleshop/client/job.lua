Framework = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local isLoggedIn = false
local PlayerData = {}

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = Framework.Functions.GetPlayerData()
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

function DrawText3Ds(xPos, yPos, zPos, Text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(Text)
    SetDrawOrigin(xPos, yPos, zPos, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(Text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local timeout = false

function RandomCars()
  return Config.cars[math.random(#Config.cars)]
end

function RandomPos(variable)
  return variable[math.random(1, #variable)]
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
			local coords = GetEntityCoords(PlayerPedId())
			local modelName = RandomCars()
			local sellpos = RandomPos(Config.sellveh)
			local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
			local cooords = GetBlipInfoIdCoord(blip)
			if PlayerData.job ~= nil and (PlayerData.job.name == "cardealer") then
				if GetDistanceBetweenCoords(coords, Config.Startpoint.x, Config.Startpoint.y, Config.Startpoint.z, true) < Config.Startpoint.d and not timeout then
					DrawText3Ds(Config.Startpoint.x, Config.Startpoint.y, Config.Startpoint.z + 0.3, "~g~E~w~ - Start sale deliveries")
					if IsControlJustPressed(1, 38) then
						blip = AddBlipForCoord(sellpos.x, sellpos.y, sellpos.z)
						SetBlipSprite(blip, 478)
						SetBlipRoute(blip,  true)
						SetBlipRouteColour(blip,  2)
						Citizen.CreateThread(function()
							RequestModel(model)

							while not HasModelLoaded(model) do
								Citizen.Wait(0)
							end

							local vehicle = CreateVehicle(model, Config.spawnveh.x, Config.spawnveh.y, Config.spawnveh.z, Config.spawnveh.h, true, false)
							local id      = NetworkGetNetworkIdFromEntity(vehicle)

							SetNetworkIdCanMigrate(id, true)
							SetEntityAsMissionEntity(vehicle, true, false)
							SetVehicleHasBeenOwnedByPlayer(vehicle, true)
							SetVehicleNeedsToBeHotwired(vehicle, false)
							SetModelAsNoLongerNeeded(model)
							TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle, -1)
							TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))

							RequestCollisionAtCoord(Config.spawnveh.x, Config.spawnveh.y, Config.spawnveh.z)

							while not HasCollisionLoadedAroundEntity(vehicle) do
								RequestCollisionAtCoord(Config.spawnveh.x, Config.spawnveh.y, Config.spawnveh.z)
								Citizen.Wait(0)
							end

							SetVehRadioStation(vehicle, 'OFF')	
							Framework.Functions.Notify("Deliver this to our customer, do not scratch the vehicle.", "success", 7000)
							timeout = true
							Wait(Config.Holdup * 60000)
							timeout = false
						end)
					end
				elseif GetDistanceBetweenCoords(coords, Config.Startpoint.x, Config.Startpoint.y, Config.Startpoint.z, true) < Config.Startpoint.d and timeout then
					DrawText3Ds(Config.Startpoint.x, Config.Startpoint.y, Config.Startpoint.z + 0.3, "Waiting for client phone call.")
				elseif GetDistanceBetweenCoords(coords, cooords.x, cooords.y, cooords.z, true) < 1.8 and IsPedInAnyVehicle(GetPlayerPed(-1)) then
					DrawText3Ds(cooords.x, cooords.y, cooords.z + 0.3, "~g~E~w~ - Sell vehicle")
					if IsControlJustPressed(1, 38) then
						if (IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), model)) then
						TriggerEvent('pepe-cardealer:job:sellveh')
						Wait(250)
						TriggerEvent('Framework:Command:DeleteVehicle', PlayerPedId())
						end
					end
				else
					Wait(850)
				end
			else
				Wait(2500)
			end
		end
end)


RegisterNetEvent('pepe-cardealer:job:sellveh')
AddEventHandler('pepe-cardealer:job:sellveh', function()
	local health = GetVehicleBodyHealth(GetVehiclePedIsUsing(GetPlayerPed(-1)), PlayerPedId())
	if health <= 2000 then
		local type = 'bestpay'
		Framework.Functions.Notify("The vehicle looks great, enjoy the payment.", "success", 2500)
		TriggerServerEvent('pepe-cardealer:job:pay', type)
	elseif health <= 1600 then
		local type = 'womenpayxd'
		Framework.Functions.Notify("Thanks for bringing me my car, enjoy the payment", "success", 2500)
		TriggerServerEvent('pepe-cardealer:job:pay', type)
	elseif health <= 1400 then
		local type = 'shitpay'
		Framework.Functions.Notify("The vehicle looks a bit broken, here's your payment, don't screw it up next time.", "success", 2500)
		TriggerServerEvent('pepe-cardealer:job:pay', type)
	elseif health <= 800 then
		local type = 'Lpay'
	elseif health == 0 then
		Framework.Functions.Notify("You seriously broke the vehicle, no way im paying you for this asshole.", "success", 2500)
		TriggerServerEvent('pepe-cardealer:job:pay', type)
	end
end)
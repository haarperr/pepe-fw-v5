-- ENTIRE SCRIPT MADE BY OSMIUM#0001 | DISCORD.IO/OSMFX --
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA. 

Framework = nil

Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(1)
		if Framework == nil then
			TriggerEvent('Framework:GetObject', function(obj) Framework = obj end) 
			Citizen.Wait(200)
		end
	end
end)

local isLoggedIn = false
local renting = false
local rentcar1 = nil 

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

-- RegisterNetEvent('pepe-carrentals:client:DeleteOld')
-- AddEventHandler('pepe-carrentals:client:DeleteOld', function(closeveh, cvid)
-- 	-- local delcar = Framework.Functions.GetClosestVehicle()
-- 	-- Framework.Functions.DeleteVehicle(delcar)
-- end)

RegisterNetEvent('pepe-carrentals:client:ClientDel')
AddEventHandler('pepe-carrentals:client:ClientDel', function(closeveh, i)
	local oldVehicle = GetClosestVehicle(CRConfig.RentingPositions[i].coords.x, CRConfig.RentingPositions[i].coords.y, CRConfig.RentingPositions[i].coords.z, 3.0, 0, 70)
	if oldVehicle ~= 0 then
		Framework.Functions.DeleteVehicle(oldVehicle)
	end
	CRConfig.RentingPositions[i].buying = true
end)

RegisterNetEvent('pepe-carrentals:client:SetUse')
AddEventHandler('pepe-carrentals:client:SetUse', function(i, bool)
	CRConfig.RentingPositions[i].buying = bool
end)

RegisterNetEvent('pepe-carrentals:client:Confirmed')
AddEventHandler('pepe-carrentals:client:Confirmed', function(num, plate, closeveh)
		Framework.Functions.SpawnVehicle(CRConfig.RentingPositions[num].vehicle, function(veh)
			-- TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
			exports['pepe-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100, false)
			SetVehicleNumberPlateText(veh, plate)
			SetEntityHeading(veh, CRConfig.RentingPositions[num].coords.h)
			SetEntityAsMissionEntity(veh, true, true)
			exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
			TriggerServerEvent("vehicletuning:server:SaveVehicleProps", Framework.Functions.GetVehicleProperties(veh))
			TriggerServerEvent("pepe-carrentals:server:sql", num, plate, veh)
			SetEntityAsMissionEntity(veh, true, true)
			rentcar1 = veh
			renting = true
		end, CRConfig.RentingPositions[num].coords, false)
	-- end
end)

RegisterNetEvent('pepe-carrentals:client:EndRental')
AddEventHandler('pepe-carrentals:client:EndRental', function(currentcar1)
	if currentcar1 ~= nil then 
		renting = false

		SetEntityInvincible(currentcar1,true)
		FreezeEntityPosition(currentcar1,true)
		Citizen.Wait(10000)

		Framework.Functions.DeleteVehicle(currentcar1)
	end
end)



Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for i = 1, #CRConfig.RentingPositions, 1 do
        local oldVehicle = GetClosestVehicle(CRConfig.RentingPositions[i].coords.x, CRConfig.RentingPositions[i].coords.y, CRConfig.RentingPositions[i].coords.z, 3.0, 0, 70)
        if oldVehicle ~= 0 then
            Framework.Functions.DeleteVehicle(oldVehicle)
        end

		local model = GetHashKey(CRConfig.RentingPositions[i].vehicle)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model, CRConfig.RentingPositions[i].coords.x, CRConfig.RentingPositions[i].coords.y, CRConfig.RentingPositions[i].coords.z, false, false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetVehicleOnGroundProperly(veh)
		Citizen.Wait(500)
		SetEntityInvincible(veh,true)
        SetEntityHeading(veh, CRConfig.RentingPositions[i].coords.h)
        SetVehicleDoorsLocked(veh, 3)
		FreezeEntityPosition(veh,true)

		SetVehicleNumberPlateText(veh, i .. "OSMFX")
		-- local poles = GetClosestObjectOfType(CRConfig.RentingPositions[i].coords.x, CRConfig.RentingPositions[i].coords.y, CRConfig.RentingPositions[i].coords.z, 5.0, -1063472968, false, 0, 0)
		-- DeleteEntity(poles)
    end
end)

Citizen.CreateThread(function()
	while true do 
		for i = 1, #CRConfig.RentingPositions, 1 do
			if CRConfig.RentingPositions[i].buying then 
				Citizen.Wait(50)
				TriggerServerEvent('pepe-carrentals:server:SetUse', i, false)
				local oldVehicle = GetClosestVehicle(CRConfig.RentingPositions[i].coords.x, CRConfig.RentingPositions[i].coords.y, CRConfig.RentingPositions[i].coords.z, 3.0, 0, 70)
				if oldVehicle ~= 0 then
					Framework.Functions.DeleteVehicle(oldVehicle)
				end

				local model = GetHashKey(CRConfig.RentingPositions[i].vehicle)
				RequestModel(model)
				while not HasModelLoaded(model) do
					Citizen.Wait(0)
				end

				local veh = CreateVehicle(model, CRConfig.RentingPositions[i].coords.x, CRConfig.RentingPositions[i].coords.y, CRConfig.RentingPositions[i].coords.z, false, false)
				SetModelAsNoLongerNeeded(model)
				SetVehicleOnGroundProperly(veh)
				SetEntityInvincible(veh,true)
				SetEntityHeading(veh, CRConfig.RentingPositions[i].coords.h)
				SetVehicleDoorsLocked(veh, 3)
				SetVehicleOnGroundProperly(veh)

				FreezeEntityPosition(veh,true)
				SetVehicleNumberPlateText(veh, i .. "OSMFX")
				local poles = GetClosestObjectOfType(CRConfig.RentingPositions[i].coords.x, CRConfig.RentingPositions[i].coords.y, CRConfig.RentingPositions[i].coords.z, 5.0, -1063472968, false, 0, 0)
				DeleteEntity(poles)
			end
		end
		Citizen.Wait(CRConfig.RefreshCars * 60000) -- NEW CARS COME EVERY 5 MINUTES
	end
end)

local ClosestShop = 1

Citizen.CreateThread(function()
    while true do
		-- print('loop1')
        local pos = GetEntityCoords(PlayerPedId(), true)
	    for i = 1, #CRConfig.RentalSpots, 1 do
			local ShopDistance = GetDistanceBetweenCoords(pos, CRConfig.RentalSpots[i].coords.x, CRConfig.RentalSpots[i].coords.y, CRConfig.RentalSpots[i].coords.z, false)
			if ShopDistance <= 50 then 
				ShopDistance1 = ShopDistance
				ClosestShop = i
			end
		
		end
			if isLoggedIn then
				if ShopDistance1 ~= nil then
					SetClosestRentalVeh()
					ShopDistance1 = nil 
				end
			end
			Citizen.Wait(2500)
    end
end)

Citizen.CreateThread(function()
    while true do
		-- print('loop1')
        local pos = GetEntityCoords(PlayerPedId(), true)
			local ShopDistance = GetDistanceBetweenCoords(pos, CRConfig.RentalSpots[ClosestShop].coords.x, CRConfig.RentalSpots[ClosestShop].coords.y, CRConfig.RentalSpots[ClosestShop].coords.z, false)
				if ShopDistance < 50 then
					--Draw3DText(CRConfig.RentalSpots[ClosestShop].coords.x, CRConfig.RentalSpots[ClosestShop].coords.y, CRConfig.RentalSpots[ClosestShop].coords.z + 0.2, 'Car Rental Zone', 4, 0.5, 0.5, CRConfig.PrimaryColor)
					Draw3DText(CRConfig.RentalSpots[ClosestShop].coords.x, CRConfig.RentalSpots[ClosestShop].coords.y, CRConfig.RentalSpots[ClosestShop].coords.z - 0.75 , 'Rent Cars Starting at Just $5000 an hour!', 4, 0.08, 0.08, CRConfig.SecondaryColor)
					Citizen.Wait(10)
				else 
					Citizen.Wait(4000)
				end
    end
end)

Citizen.CreateThread(function()
    while true do
		if isLoggedIn then
			if ClosestRentalVeh ~= nil then 
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped, false)
				local dist = GetDistanceBetweenCoords(pos, CRConfig.RentingPositions[ClosestRentalVeh].coords.x, CRConfig.RentingPositions[ClosestRentalVeh].coords.y, CRConfig.RentingPositions[ClosestRentalVeh].coords.z, false)
				local closeveh = GetClosestVehicle(CRConfig.RentingPositions[ClosestRentalVeh].coords.x, CRConfig.RentingPositions[ClosestRentalVeh].coords.y, CRConfig.RentingPositions[ClosestRentalVeh].coords.z, 3.0, 0, 70)
				local rate = CRConfig.RentingPositions[ClosestRentalVeh].rentcost
				if not CRConfig.RentingPositions[ClosestRentalVeh].buying then
					if dist < 2 and closeveh ~= nil and not renting then   
						Draw3DText(CRConfig.RentingPositions[ClosestRentalVeh].coords.x, CRConfig.RentingPositions[ClosestRentalVeh].coords.y, CRConfig.RentingPositions[ClosestRentalVeh].coords.z, '[E] - Rent this Vehicle at $'..rate, 4, 0.06, 0.06, CRConfig.SecondaryColor)
						if IsControlJustPressed(0, 38) then
							DisableControlAction(0, 38, true)
							TriggerServerEvent('pepe-carrentals:server:start', ClosestRentalVeh, closeveh, rate)
							npbool = true
							TriggerEvent('StartTick')
							EnableControlAction(0, 38, true)
						end
					end
				end
				Citizen.Wait(3)
			else
				Citizen.Wait(1500)
			end
		else 
			Citizen.Wait(4000)
		end
    end
end)

local npbool = true -- Random Variable to Stop Issues

RegisterNetEvent('pepe-carrentals:client:NonPayment')
AddEventHandler('pepe-carrentals:client:NonPayment', function(veh)
	if veh ~= nil and renting and npbool then 
		Citizen.Wait(CRConfig.NonPayment * 60000) 
		renting = false
		FreezeEntityPosition(veh, true)
		Citizen.Wait(25000)
		Framework.Functions.DeleteVehicle(veh)
		TriggerServerEvent('pepe-carrentals:server:SetDone', veh)
		npbool = false
	end
end)

Citizen.CreateThread(function()
    while true do
		-- print(rentcar1)
		-- print(renting)
		if rentcar1 ~= nil and renting then 
			if not IsPedInAnyVehicle(PlayerPedId(), true) then 
				local currentcar = Framework.Functions.GetClosestVehicle()
				if currentcar ~= nil then 
					if currentcar == rentcar1 then 
						local carcoords = GetEntityCoords(currentcar)
						Draw3DText(carcoords.x, carcoords.y, carcoords.z - 0.8, '[U] - Return Rented Vehicle', 4, 0.08, 0.08, CRConfig.SecondaryColor)
						if IsControlJustPressed(0, 303) then
							print(currentcar)
							TriggerServerEvent('pepe-carrentals:server:EndRental', currentcar)
							TriggerEvent('pepe-carrentals:client:EndRental', currentcar)
							if CRConfig.DamageCharges.enable then
								local health = GetVehicleBodyHealth(currentcar)
								TriggerServerEvent('pepe-carrentals:server:EngineHealth', health)
							end
							-- breaktick = true
						end
					end
				end
				if not isLoggedIn then
					Framework.Functions.DeleteVehicle(rentcar1) 
					TriggerServerEvent('pepe-carrentals:server:SetDone', rentcar1)
				end
				if not DoesEntityExist(rentcar1) then 
					TriggerServerEvent('pepe-carrentals:server:SetDone', rentcar1)
				end
				Citizen.Wait(5)
			else 
				Citizen.Wait(2500)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

local breaktick = false -- TO BREAK TICK WHEN NOT IN USE

RegisterNetEvent('StartTick')
AddEventHandler('StartTick', function()
	Tick()
end)

function Tick()
while true do 
	Citizen.Wait(CRConfig.DriveTime * 60000)
	-- print(renting)
    if renting then 
        TriggerServerEvent('pepe-carrentals:server:hourly')
	else
		break
	end
end
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,color)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
	local scale = (1/dist)*20
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov
	SetTextScale(scaleX*scale, scaleY*scale)
	SetTextFont(fontId)
	SetTextProportional(1)
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextDropshadow(1, 1, 1, 1, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(textInput)
	SetDrawOrigin(x,y,z+2, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
  end

  function SetClosestRentalVeh()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
	--('setclose')
    for id, veh in pairs(CRConfig.RentingPositions) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, CRConfig.RentingPositions[id].coords.x, CRConfig.RentingPositions[id].coords.y, CRConfig.RentingPositions[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, CRConfig.RentingPositions[id].coords.x, CRConfig.RentingPositions[id].coords.y, CRConfig.RentingPositions[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, CRConfig.RentingPositions[id].coords.x, CRConfig.RentingPositions[id].coords.y, CRConfig.RentingPositions[id].coords.z, true)
            current = id
        end
    end
    if current ~= ClosestRentalVeh then
        ClosestRentalVeh = current
    end
	--print(ClosestRentalVeh)
end
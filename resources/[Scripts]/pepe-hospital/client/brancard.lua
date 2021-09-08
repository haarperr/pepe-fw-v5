-- local PlayerData = {}
-- Framework = nil

-- Citizen.CreateThread(function()
--     while Framework == nil do
--         TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
--         Citizen.Wait(10)
--     end
	
-- 	while Framework.Functions.GetPlayerData().job == nil do
-- 		Citizen.Wait(10)
-- 	end

-- 	PlayerData = Framework.Functions.GetPlayerData()
-- 	Framework.PlayerData = Framework.Functions.GetPlayerData()
-- end)

-- RegisterNetEvent('Framework:Client:OnPlayerLoaded')
-- AddEventHandler('Framework:Client:OnPlayerLoaded', function(xPlayer)
-- 	Citizen.Wait(5000)
-- 	Framework.PlayerData = xPlayer
-- end)

-- RegisterNetEvent("Framework:Client:OnJobUpdate")
-- AddEventHandler("Framework:Client:OnJobUpdate", function(JobInfo)
-- 	PlayerData.job = JobInfo
-- end)

RegisterCommand('bed', function()
	if PlayerData.job.name == 'ambulance' then
		LoadModel('prop_ld_binbag_01')
		local brancard = CreateObject(GetHashKey('prop_ld_binbag_01'), GetEntityCoords(PlayerPedId()), true)
	end
end, false)

RegisterCommand('beddel', function()
	local brancard = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 8.0, GetHashKey('prop_ld_binbag_01'))
	if DoesEntityExist(brancard) then
		DeleteEntity(brancard)
	end
end, false)

Citizen.CreateThread(function()
	while true do
		local sleep = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local closestObject = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("prop_ld_binbag_01"), false)

		if DoesEntityExist(closestObject) then
			sleep = 5

			local brancardCoords = GetEntityCoords(closestObject)
			local brancardForward = GetEntityForwardVector(closestObject)
			
			local sitCoords = (brancardCoords + brancardForward * - 0.7)
			local pickupCoords = (brancardCoords + brancardForward * 0.7)

			if GetDistanceBetweenCoords(pedCoords, sitCoords, true) <= 2.0 then
				Framework.Functions.DrawText3Ds(sitCoords, _U("laydown"), 0.4)

				if IsControlJustPressed(0, 38) then
					Sit2(closestObject)
				end
			end

			if GetDistanceBetweenCoords(pedCoords, pickupCoords, true) <= 2.5 then
				Framework.Functions.DrawText3Ds(pickupCoords, _U("push"), 0.4)

				if IsControlJustPressed(0, 74) then
					PickUp2(closestObject)
				end
			end
		end

		Citizen.Wait(sleep)
	end
end)

Sit2 = function(brancardObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'amb@world_human_sunbathe@female@back@base', 'base', 3) then
			ShowNotification(_U("alreadybrancard"))
			return
		end
	end

	LoadAnim("amb@world_human_sunbathe@female@back@base")

	AttachEntityToEntity(PlayerPedId(), brancardObject, 0, 0, 0.0, 1.65, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(brancardObject)

	while IsEntityAttachedToEntity(PlayerPedId(), brancardObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'amb@world_human_sunbathe@female@back@base', 'base', 3) then
			TaskPlayAnim(PlayerPedId(), 'amb@world_human_sunbathe@female@back@base', 'base', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlJustPressed(0, 38) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(brancardObject) + GetEntityForwardVector(brancardObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

PickUp2 = function(brancardObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3) then
		end
	end

	NetworkRequestControlOfEntity(brancardObject)

	LoadAnim("anim@heists@box_carry@")

	AttachEntityToEntity(brancardObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.00, -1.1, -0.95, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)

	while IsEntityAttachedToEntity(brancardObject, PlayerPedId()) do
		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(brancardObject, true, true)
		end

		if IsControlJustPressed(0, 74) then
			DetachEntity(brancardObject, true, true)
		end
	end
end

GetPlayers = function()
    local players = {}

    for _, player in ipairs(GetActivePlayers()) do
    local ped = GetPlayerPed(player)
            table.insert(players, i)
    end

    return players
end

GetClosestPlayer = function()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(1)
	end
end

ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringWebsite(msg)
	DrawNotification(false, true)
end
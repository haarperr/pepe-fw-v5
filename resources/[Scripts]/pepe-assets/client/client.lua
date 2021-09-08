local DisplayCount = 0
DisableSeatShuff = true
Framework = nil

LoggedIn = false

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
  TriggerEvent("Framework:GetObject", function(obj) Framework = obj end) 
  Citizen.Wait(150)
  --SetDiscordButtons()
  NetworkSetFriendlyFireOption(true)
  SetCanAttackFriendly(PlayerPedId(), true, true)
  LoggedIn = true
end)

-- Code

-- // Events \\ --
-- Pvp Enable

-- function SetDiscordButtons()
--   SetDiscordRichPresenceAction(0, 'Connecten', '')
--   SetDiscordRichPresenceAction(1, 'Discord', '')
-- end

RegisterNetEvent('pepe-assets:client:seat:shuffle')
AddEventHandler('pepe-assets:client:seat:shuffle', function()
  if IsPedInAnyVehicle(PlayerPedId()) then
    DisableSeatShuff = false
    Citizen.Wait(5000)
    DisableSeatShuff = true
  else
    CancelEvent()
  end
end)

RegisterNetEvent('pepe-assets:client:me:show')
AddEventHandler('pepe-assets:client:me:show', function(Text, Source)
  local PlayerId = GetPlayerFromServerId(Source)
  local IsDisplaying = true
  Citizen.CreateThread(function()
    local DisplayOffset = 0 + (DisplayCount * 0.14)
    DisplayCount = DisplayCount + 1
    while IsDisplaying do
      Citizen.Wait(0)
      local SourceCoords = GetEntityCoords(GetPlayerPed(PlayerId))
      local NearCoords = GetEntityCoords(PlayerPedId())
      local Distance = Vdist2(SourceCoords, NearCoords)
      if Distance < 25.0 then
        DrawText3D(SourceCoords.x, SourceCoords.y, SourceCoords.z + DisplayOffset, Text)
      end
    end
    DisplayCount = DisplayCount - 1
  end)
  Citizen.CreateThread(function()
   Citizen.Wait(6500)
   IsDisplaying = false
  end)
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Blips) do
      Blips = AddBlipForCoord(Config.Blips[k]['X'], Config.Blips[k]['Y'], Config.Blips[k]['Z'])
      SetBlipSprite (Blips, Config.Blips[k]['SpriteId'])
      SetBlipDisplay(Blips, 4)
      SetBlipScale  (Blips, Config.Blips[k]['Scale'])
      SetBlipAsShortRange(Blips, true)
      SetBlipColour(Blips, Config.Blips[k]['Color'])
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentSubstringPlayerName(Config.Blips[k]['Name'])
      EndTextCommandSetBlipName(Blips)
    end
end)

function AddBlipToCoords(Coords, Sprite, Scale, Color, Text)
  Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
  SetBlipSprite (Blips, Sprite)
  SetBlipDisplay(Blips, 4)
  SetBlipScale  (Blips, Scale)
  SetBlipAsShortRange(Blips, true)
  SetBlipColour(Blips, Color)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentSubstringPlayerName(Text)
  EndTextCommandSetBlipName(Blips)
end

-- // Brighter Lights \\ --
function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

Citizen.CreateThread(function()
	local settingsFile = LoadResourceFile(GetCurrentResourceName(), "misc/visualsettings.dat")
	local lines = stringsplit(settingsFile, "\n")
	for k,v in ipairs(lines) do
		if not starts_with(v, '#') and not starts_with(v, '//') and (v ~= "" or v ~= " ") and #v > 1 then
			v = v:gsub("%s+", " ")
			local setting = stringsplit(v, " ")
			if setting[1] ~= nil and setting[2] ~= nil and tonumber(setting[2]) ~= nil then
				if setting[1] ~= 'weather.CycleDuration' then	
					Citizen.InvokeNative(GetHashKey('SET_VISUAL_SETTING_FLOAT') & 0xFFFFFFFF, setting[1], tonumber(setting[2])+.0)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	SetWeaponDamageModifier(GetHashKey('WEAPON_UNARMED'), 0.3)
	SetWeaponDamageModifier(GetHashKey('WEAPON_NIGHTSTICK'), 0.3)
	-- Melee
	SetWeaponDamageModifier(GetHashKey('WEAPON_FLASHLIGHT'), 0.4)
	SetWeaponDamageModifier(GetHashKey('WEAPON_HAMMER'), 0.4)
	SetWeaponDamageModifier(GetHashKey('WEAPON_HATCHET'), 0.4)
	SetWeaponDamageModifier(GetHashKey('WEAPON_SWITCHBLADE'), 0.4)
	SetWeaponDamageModifier(GetHashKey('WEAPON_WRENCH'), 0.4)
	SetWeaponDamageModifier(GetHashKey('WEAPON_BREAD'), 0.4)
end)

RegisterNUICallback('CheckDevtools', function()
   TriggerServerEvent('pepe-assets:server:drop')
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end


Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(803732838708674591)

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('logonew')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('Pepe Framework')
        
        --Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('logonew')

        --Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('OCRP')

		        --[[ 
            Here you can add buttons that will display in your Discord Status,
            First paramater is the button index (0 or 1), second is the title and 
            last is the url (this has to start with "fivem://connect/" or "https://") 
        ]]--
		SetDiscordRichPresenceAction(0, "Join Discord!", "https://discord.gg/SNQg3GH")
        SetDiscordRichPresenceAction(1, "Join FiveM!", "fivem://connect/195.85.49.25:30120")

        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)

--No Need to mess with anything pass this point!
Citizen.CreateThread(function()
	while true do
		local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
		if VehName == "NULL" then VehName = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))) end
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
		local StreetHash = GetStreetNameAtCoord(x, y, z)
		local pId = GetPlayerServerId(PlayerId())
		local pName = GetPlayerName(PlayerId())
		Citizen.Wait(10000)
		if StreetHash ~= nil then
			StreetName = GetStreetNameFromHashKey(StreetHash)
			if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
				if IsPedSprinting(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." is sprinting down "..StreetName)
				elseif IsPedRunning(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." is running down "..StreetName)
				elseif IsPedWalking(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." is walking down "..StreetName)
				elseif IsPedStill(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." is standing on "..StreetName)
				end
			elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
				local MPH = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
				if MPH > 50 then
					SetRichPresence("ID: "..pId.." | "..pName.." is speeding down "..StreetName.." at "..MPH.."MPH in a "..VehName)
				elseif MPH <= 50 and MPH > 0 then
					SetRichPresence("ID: "..pId.." | "..pName.." is cruising down "..StreetName.." at "..MPH.."MPH in a "..VehName)
				elseif MPH == 0 then
					SetRichPresence("ID: "..pId.." | "..pName.." is parked on "..StreetName.." in a "..VehName)
				end
			elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
				if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 5.0 then
					SetRichPresence("ID: "..pId.." | "..pName.." is flying over "..StreetName.." in a "..VehName)
				else
					SetRichPresence("ID: "..pId.." | "..pName.." is landed at "..StreetName.." in a "..VehName)
				end
			elseif IsEntityInWater(PlayerPedId()) then
				SetRichPresence("ID: "..pId.." | "..pName.." is swimming")
			elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence("ID: "..pId.." | "..pName.." is sailing in a "..VehName)
			elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence("ID: "..pId.." | "..pName.." is in a yellow submarine")
			end
		end
	end
end)
Framework                             = nil
local PlayerData                = {}
local open 						= false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if Framework == nil then
            TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
            Citizen.Wait(200)
        end
    end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(550)
		local Gracz = PlayerPedId()
		local PozycjaGracza = GetEntityCoords(Gracz)
		local Dystans = GetDistanceBetweenCoords(PozycjaGracza, 781.95, -550.84, 22.5, true)
		local Dystans2 = GetDistanceBetweenCoords(PozycjaGracza, 1115.34, 209.07, -49.45,false)
		local Dystans3 = GetDistanceBetweenCoords(PozycjaGracza, 1108.34, 208.39, -49.45, false)
		--PlayerData = ESX.GetPlayerData()
		--if PlayerData.job.name == 'casino' then
			if Dystans <= 10.0 then
				local PozycjaTekstu = {
					["x"] = 781.95,
					["y"] = -550.84,
					["z"] = 22.5
				}
				--ESX.Game.Utils.DrawText3D(PozycjaTekstu, "Druk op [~g~E~s~] om chips te kopen  ", 0.55, 1.5, "~b~de kassa", 0.7)
				if IsControlJustReleased(0, 38) and Dystans <= 1.5 then
					OtworzMenuKasyna()
				end
			end
		--end
		if Dystans2 <= 6.0 then
			local PozycjaTekstu2 = {
				["x"] = 1115.34,
				["y"] = 209.07,
				["z"] = -49.45
			}
			--ESX.Game.Utils.DrawText3D(PozycjaTekstu2, "Druk op [~g~E~s~] om een drankje te kopen  ", 0.55, 1.5, "~b~de kassa", 0.7)
			if IsControlJustReleased(0, 38) and Dystans2 <= 1.5 then
				OtworzMenuKasynaSklepu()
			end
		end
		if Dystans3 <= 6.0 then
			local PozycjaTekstu3 = {
				["x"] = 1108.34,
				["y"] = 208.39,
				["z"] = -49.45
			}
			--ESX.Game.Utils.DrawText3D(PozycjaTekstu3, "Druk op [~g~E~s~] om een drankje te kopen  ", 0.55, 1.5, "~b~de kassa", 0.7)
			if IsControlJustReleased(0, 38) and Dystans3 <= 1.5 then
				OtworzMenuKasynaSklepu()
			end
		end
	end
end)
--[[
function OtworzMenuKasyna()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'jeton',
      {
          title    = 'Nieuweveen Casino - Kassa',
          align    = 'top-left',
          elements = {
			{label = "Koop Chips", value = "buy"},
			{label = "Verkoop Chips", value = "sell"},
		  }
      },
	  function(data, menu) 
		local akcja = data.current.value
		if akcja == 'buy' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_item_count', {
				title = 'Remcos - $250/Chips'
			}, function(data2, menu2)

				local quantity = tonumber(data2.value)

				if quantity == nil then
					TriggerEvent("pNotify:SendNotification", {text = 'Ongeldige hoeveelheid!'})
				else
					TriggerServerEvent('route68_kasyno:Kupjeton', quantity)
					menu2.close()
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif akcja == 'sell' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_count', {
				title = 'Remcos - $250/Chips'
			}, function(data2, menu2)

				local quantity = tonumber(data2.value)

				if quantity == nil then
					TriggerEvent("pNotify:SendNotification", {text = 'Ongeldige hoeveelheid!'})
				else
					TriggerServerEvent('route68_kasyno:Wymienjeton', quantity)
					menu2.close()
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		end
      end,
      function(data, menu)
		menu.close()
	  end
  )
end]]--

local function drawHint(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNUICallback('wygrana', function(data)
	Framework.Functions.Notify("You have won "..data.win.." dollar!", "success")
end)

RegisterNUICallback('updateBets', function(data)
	TriggerServerEvent('nvanti_slots:updateCoins', data.bets)
end)

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(50)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end

RegisterNetEvent("nvanti_slots:UpdateSlots")
AddEventHandler("nvanti_slots:UpdateSlots", function()

	--Ply = Framework.Functions.GetPlayerData()
    Framework.Functions.GetPlayerData(function(PlayerData)
	
        cashAmount = PlayerData.money["cash"]
    end)
	SetNuiFocus(true, true)
	open = true
	SendNUIMessage({
		showPacanele = "open",
		coinAmount = tonumber(cashAmount)
	})
end)

RegisterNUICallback('exitWith', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	open = false
	TriggerServerEvent("nvanti_slots:PayOutRewards", math.floor(data.coinAmount))
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(25000)
		if open then
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 24, true) -- Attack
			DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(8)
		local coords = GetEntityCoords(PlayerPedId())
		for i=1, #Config.Sloty do
			local dis = GetDistanceBetweenCoords(coords, Config.Sloty[i].x, Config.Sloty[i].y, Config.Sloty[i].z, true)
			if dis <= 2.0 then
				--ESX.ShowHelpNotification('Druk op ~INPUT_PICKUP~ om slots te spelen!.')
				DrawMarker(29, Config.Sloty[i].x, Config.Sloty[i].y, Config.Sloty[i].z - 0.8, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.5, 1.5, 1.0, 70, 163, 76, 50, false, true, 2, nil, nil, false)
				if IsControlJustReleased(1, 38) then
					TriggerEvent('nvanti_slots:UpdateSlots')
				end
			elseif dis <= 20.0 then
				DrawMarker(29, Config.Sloty[i].x, Config.Sloty[i].y, Config.Sloty[i].z - 0.8, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 50, false, true, 2, nil, nil, false)
			end
		end
		-- for i=1, #Config.Blackjack do
			-- local dis = GetDistanceBetweenCoords(coords, Config.Blackjack[i].x, Config.Blackjack[i].y, Config.Blackjack[i].z, true)
			-- if dis <= 2.0 then
				-- ESX.ShowHelpNotification('Druk op ~INPUT_PICKUP~ om blackjack te spelen!.')
				-- DrawMarker(1, Config.Blackjack[i].x, Config.Blackjack[i].y, Config.Blackjack[i].z - 1.85, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 3.5, 3.5, 3.5, 70, 163, 76, 50, false, true, 2, nil, nil, false)
				-- if IsControlJustReleased(1, 38) then
					-- TriggerEvent('route68_blackjack:start')
				-- end
			-- elseif dis <= 20.0 then
				-- DrawMarker(1, Config.Blackjack[i].x, Config.Blackjack[i].y, Config.Blackjack[i].z - 1.85, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 3.5, 3.5, 3.5, 158, 52, 235, 50, false, true, 2, nil, nil, false)
			-- end
		-- end
	end
end)

local coordonate = {
    {1088.1, 221.11, -49.21, nil, 185.5, nil, 1535236204},
    {1100.61, 195.55, -49.45, nil, 316.5, nil, -1371020112},
	
    {1134.33, 267.23, -51.04, nil, 135.5, nil, -245247470},
	--{1128.82, 261.75, -51.04, nil, 321.5, nil, 691061163},

--	{1143.83, 246.72, -51.04, nil, 320.5, nil, -886023758},
	{1149.33, 252.24, -51.04, nil, 138.5, nil, -1922568579},
	
--	{1149.48, 269.11, -51.85, nil, 49.5, nil, -886023758},
	{1118.26, 220.24, -49.23, nil, 107.85, nil, 469792763},
	
	{1111.30, 209.66, -49.44, nil, 49.73, nil, 1535236204},

	
	{1143.89, 263.71, -51.85, nil, 45.5, nil, 999748158},
	{1145.77, 261.883, -51.85, nil, 222.5, nil, -254493138},
}






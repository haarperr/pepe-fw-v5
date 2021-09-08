Framework = nil

Citizen.CreateThread(function()
	while Framework == nil do
		TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
		Citizen.Wait(31)
	end
end)
local blipX = 238.99
local blipY = 46.77914
local blipZ = 75.99
local pic = 'CHAR_SOCIAL_CLUB'
local game_during = false
local elements = {}

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('route68_ruletka:start')
AddEventHandler('route68_ruletka:start', function()
	--Framework.Functions.TriggerCallback('esx_roulette:check_money', function(quantity)
	--	if quantity >= 10 then
		Ply = Framework.Functions.GetPlayerData()
    Framework.Functions.GetPlayerData(function(PlayerData)
	
        cashAmount = PlayerData.money["cash"]
    end)
			SendNUIMessage({
				type = "show_table",
				zetony = cashAmount
			})
			SetNuiFocus(true, true)
	--	else
			--ESX.ShowNotification('You need at least 10 chips to play!!')
	--				Framework.Functions.Notify("You don't have enough Chips for this.", "error")
	--		SendNUIMessage({
	--			type = "reset_bet"
	--		})
	--	end
	--end, '')
end)

RegisterNUICallback('exit', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
end)

RegisterNUICallback('betup', function(data, cb)
	cb('ok')
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'betup', 1.0)
end)

RegisterNUICallback('roll', function(data, cb)
	cb('ok')
	TriggerEvent('esx_roulette:start_game', data.kolor, data.kwota)
end)

RegisterNetEvent('esx_roulette:start_game')
AddEventHandler('esx_roulette:start_game', function(action, amount)
	local amount = amount
	if game_during == false then
		TriggerServerEvent('esx_roulette:removemoney', amount)
		local kolorBetu = action
		--TriggerEvent('pNotify:SendNotification', {text = "You have bet "..amount.." chips on "..kolorBetu..". The wheel is spinning..."})
		
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, "roulette", 0.3)
		Framework.Functions.Notify("You placed a bet of "..amount.." $ on "..kolorBetu..". .", "success")
		game_during = true
		local randomNumber = math.floor(math.random() * 36)
		--local randomNumber = 0
		SendNUIMessage({
			type = "show_roulette",
			hwButton = randomNumber
		})
		Citizen.Wait(10000)
		local red = {32,19,21,25,34,27,36,30,23,5,16,1,14,9,18,7,12,3};
		local black = {15,4,2,17,6,13,11,8,10,24,33,20,31,22,29,28,35,26};
		local function has_value (tab, val)
			for index, value in ipairs(tab) do
				if value == val then
					return true
				end
			end
			return false
		end
		if action == 'black' then
			if has_value(black, randomNumber) then
				local win = amount * 2
				--ESX.ShowNotification('You won '..win..' chips!')
		Framework.Functions.Notify("You won "..win.." $!", "success")
				TriggerServerEvent('esx_roulette:givemoney', action, amount)
			else
				Framework.Functions.Notify("You lost your bet", "error")
				--ESX.ShowNotification('Not this time. Try again! Good luck!')
			end
		elseif action == 'red' then
			local win = amount * 2
			if has_value(red, randomNumber) then
				Framework.Functions.Notify("You won "..win.." $!", "success")
				TriggerServerEvent('esx_roulette:givemoney', action, amount)
			else
				Framework.Functions.Notify("You lost your bet!", "error")
				--ESX.ShowNotification('Not this time. Try again! Good luck!')
			end
		elseif action == 'green' then
			local win = amount * 14
			if randomNumber == 0 then

				Framework.Functions.Notify("You won "..win.." dollars!", "success")
				TriggerServerEvent('esx_roulette:givemoney', action, amount)
			else
				Framework.Functions.Notify("You lost your bet!", "error")
				--ESX.ShowNotification('Je hebt verloren')
			end
		end
		TriggerServerEvent('roulette:givemoney', randomNumber)
		SendNUIMessage({type = 'hide_roulette'})
		SetNuiFocus(false, false)
		--ESX.ShowNotification('Gra end!')
		game_during = false
		TriggerEvent('route68_ruletka:start')
	else
		Framework.Functions.Notify("The wheel is still spinning", "warning")
		--ESX.ShowNotification('The wheel is spinning...')
	end
end)
local bluePlayerReady = false
local redPlayerReady = false
local fight = {}

Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-fight:join')
AddEventHandler('pepe-fight:join', function(betAmount, side)
		local src = source
		local xPlayer = Framework.Functions.GetPlayer(src)

		if side == 0 then
			bluePlayerReady = true
		else
			redPlayerReady = true
		end

        local fighter = {
            id = source,
            amount = betAmount
        }
        table.insert(fight, fighter)

		balance = xPlayer.PlayerData.money["cash"]
        if (balance > betAmount) or betAmount == 0 then
		xPlayer.Functions.RemoveMoney("cash", betAmount, "fightring")

            if side == 0 then
                TriggerClientEvent('pepe-fight:playerJoined', -1, 1, source)
            else
                TriggerClientEvent('pepe-fight:playerJoined', -1, 2, source)
            end

            if redPlayerReady and bluePlayerReady then 
                TriggerClientEvent('pepe-fight:startFight', -1, fight)
            end

        else
        end
end)

local count = 240
local actualCount = 0
function countdown(copyFight)
    for i = count, 0, -1 do
        actualCount = i
        Citizen.Wait(1000)
    end

    if copyFight == fight then
        TriggerClientEvent('pepe-fight:fightFinished', -1, -2)
        fight = {}
        bluePlayerReady = false
        redPlayerReady = false
    end
end

RegisterServerEvent('pepe-fight:finishFight')
AddEventHandler('pepe-fight:finishFight', function(looser)
       TriggerClientEvent('pepe-fight:fightFinished', -1, looser)
       fight = {}
       bluePlayerReady = false
       redPlayerReady = false
end)

RegisterServerEvent('pepe-fight:leaveFight')
AddEventHandler('pepe-fight:leaveFight', function(id)
       if bluePlayerReady or redPlayerReady then
            bluePlayerReady = false
            redPlayerReady = false
            fight = {}
            TriggerClientEvent('pepe-fight:playerLeaveFight', -1, id)
       end
end)

RegisterServerEvent('pepe-fight:pay')
AddEventHandler('pepe-fight:pay', function(amount)
	local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
end)

RegisterServerEvent('pepe-fight:raiseBet')
AddEventHandler('pepe-fight:raiseBet', function(looser)
       TriggerClientEvent('pepe-fight:raiseActualBet', -1)
end)

RegisterServerEvent('pepe-fight:showWinner')
AddEventHandler('pepe-fight:showWinner', function(id)
       TriggerClientEvent('pepe-fight:winnerText', -1, id)
end)
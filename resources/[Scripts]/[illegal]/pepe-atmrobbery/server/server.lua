local Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Callback to get hacker device count:
Framework.Functions.CreateCallback("pepe-atmrobbery:getHackerDevice",function(source,cb)
	local xPlayer = Framework.Functions.GetPlayer(source)
	if xPlayer.Functions.GetItemByName("electronickit") and xPlayer.Functions.GetItemByName("drill") then
		cb(true)
	else
		cb(false)
		TriggerClientEvent('Framework:Notify', source, "You need an Electronic Kit and a Drill to proceed.", "warning")
	end
end)

RegisterServerEvent('itemsil')
AddEventHandler('itemsil', function()
local xPlayer = Framework.Functions.GetPlayer(source)
	xPlayer.Functions.RemoveItem('drill', 1)
end)

Framework.Functions.CreateUseableItem('electronickit', function(source)
	TriggerClientEvent('atm:item', source)
end)


-- Event to reward after successfull robbery

RegisterServerEvent("pepe-atmrobbery:success")
AddEventHandler("pepe-atmrobbery:success",function()
	local xPlayer = Framework.Functions.GetPlayer(source)
    local reward = math.random(Config.MinReward,Config.MaxReward)
		xPlayer.Functions.AddMoney(Config.RewardAccount, tonumber(reward))

		TriggerClientEvent("Framework:Notify",source,"Succesful Robbery | You earn't $"..reward.. " !", "success")
end)

---

cooldowntime = Config.Cooldown 

undercd = false

RegisterServerEvent('osm:CooldownServer')
AddEventHandler('osm:CooldownServer', function(bool)
    undercd = bool
	if bool then 
		cooldown()
	end	 
end)

RegisterServerEvent('osm:CooldownNotify')
AddEventHandler('osm:CooldownNotify', function()
	TriggerClientEvent("Framework:Notify",source,"An ATM Robbery has happened Recently. Please Wait "..cooldowntime.." Minutes!", "warning")
end)

function cooldown()

	while true do 
	Citizen.Wait(60000)

	cooldowntime = cooldowntime - 1 

	if cooldowntime <= 0 then
		undercd = false
		break
	end

end
end

Framework.Functions.CreateCallback("osm:GetCooldown",function(source,cb)
	cb(undercd)
end)

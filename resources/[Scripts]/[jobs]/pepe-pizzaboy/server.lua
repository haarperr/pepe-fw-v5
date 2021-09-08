Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('RoutePizza:Payment')
AddEventHandler('RoutePizza:Payment', function()
	local _source = source
	local Player = Framework.Functions.GetPlayer(_source)
    Player.Functions.AddMoney("cash", 400, "sold-pizza")
    TriggerClientEvent("Framework:Notify", _source, "You recieved $400", "success")
end)

RegisterServerEvent('RoutePizza:TakeDeposit')
AddEventHandler('RoutePizza:TakeDeposit', function()
	local _source = source
	local Player = Framework.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney("bank", _source, "pizza-deposit")
    TriggerClientEvent("Framework:Notify", _source, "You were charged a deposit of $100", "error")
end)

RegisterServerEvent('RoutePizza:ReturnDeposit')
AddEventHandler('RoutePizza:ReturnDeposit', function(info)
	local _source = source
    local Player = Framework.Functions.GetPlayer(_source)
    
    if info == 'cancel' then
       Player.Functions.AddMoney("cash", 50, "pizza-return-vehicle") 
        TriggerClientEvent("Framework:Notify", _source, "You returned the vehicle and recieved your deposit back", "success")
    elseif info == 'end' then
        Player.Functions.AddMoney("cash", 150, "pizza-return-vehicle")
        TriggerClientEvent("Framework:Notify", _source, "You returned the vehicle and recieved your deposit back", "success")
    end
end)

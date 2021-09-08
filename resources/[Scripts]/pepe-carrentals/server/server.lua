-- ENTIRE SCRIPT MADE BY OSMIUM#0001 | DISCORD.IO/OSMFX 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA. 

Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

RegisterNetEvent('pepe-carrentals:server:start')
AddEventHandler('pepe-carrentals:server:start', function(closevehid, closeveh, rate)
    local src = source
    local pData = Framework.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local vData = CRConfig.RentingPositions[closevehid]
    local balance = pData.PlayerData.money["bank"]
    local cash = pData.PlayerData.money["cash"]

    if (balance - rate) >= 0 then
        TriggerClientEvent('pepe-carrentals:client:ClientDel', -1, closeveh, closevehid)
        local plate = GeneratePlate()
        -- Framework.Functions.ExecuteSql(false, "INSERT INTO `car_rentals` (`steam`, `citizenid`, `vehicle`, `rent`, `plate`, `status`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..closeveh.."', '"..rate.."', '"..plate.."', 'renting')")
        TriggerClientEvent("Framework:Notify", src, "You rented a Vehicle for $"..rate.." per hour.", "success", 5000)
        pData.Functions.RemoveMoney('bank', rate, "vehicle-rent-in-shop")
        -- TriggerClientEvent('pepe-carrentals:client:DeleteOld', -1, closeveh, closevehid)
        Citizen.Wait(100)
        TriggerClientEvent('pepe-carrentals:client:Confirmed', src, closevehid, plate, closeveh, pData)
        -- TriggerEvent("qb-log:server:sendLog", cid, "vehiclebought", {model=vData["model"], name=vData["name"], from="garage", location=QB.GarageLabel[garage], moneyType="bank", price=vData["price"], plate=plate})
        -- TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Vehicle Purchased (garage)", "green", "**"..GetPlayerName(src) .. "** has bought " .. vData["name"] .. " one for $" .. vData["price"])
    elseif (cash - rate) >= 0 then 
        TriggerClientEvent('pepe-carrentals:client:ClientDel', -1, closeveh, closevehid)
        local plate = GeneratePlate()
        -- Framework.Functions.ExecuteSql(false, "INSERT INTO `car_rentals` (`steam`, `citizenid`, `vehicle`, `rent`, `plate`, `status`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..closeveh.."', '"..rate.."', '"..plate.."', 'renting')")
        TriggerClientEvent("Framework:Notify", src, "You rented a Vehicle for $"..rate.." per hour.", "success", 5000)
        pData.Functions.RemoveMoney('cash', rate, "vehicle-rent-in-shop")
        -- TriggerClientEvent('pepe-carrentals:client:DeleteOld', -1, closeveh, closevehid)
        Citizen.Wait(100)
        TriggerClientEvent('pepe-carrentals:client:Confirmed', src, closevehid, plate, closeveh)    else
		TriggerClientEvent("Framework:Notify", src, "You don't have enough money.", "error", 5000)
    end
end)

RegisterNetEvent('pepe-carrentals:server:sql')
AddEventHandler('pepe-carrentals:server:sql', function(closevehid, plate, closeveh)
    local src = source
    local pData = Framework.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local vData = CRConfig.RentingPositions[closevehid]
    local rate = vData.rentcost
    Framework.Functions.ExecuteSql(false, "INSERT INTO `car_rentals` (`steam`, `citizenid`, `vehicle`, `rent`, `plate`, `status`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..closeveh.."', '"..rate.."', '"..plate.."', 'renting')")
end)

RegisterNetEvent('pepe-carrentals:server:SetUse')
AddEventHandler('pepe-carrentals:server:SetUse', function(i, bool)
    TriggerClientEvent('pepe-carrentals:client:SetUse', -1, i, bool)
end)

RegisterNetEvent('pepe-carrentals:server:hourly')
AddEventHandler('pepe-carrentals:server:hourly', function()
    local src = source
    local pData = Framework.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    -- local vData = CRConfig.RentingPositions[closevehid]
    local balance = pData.PlayerData.money["bank"]
    local cash = pData.PlayerData.money["cash"]
    local status = "renting"
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `car_rentals` WHERE `citizenid` = '"..cid.."' AND `status` = '"..status.."'", function(result)
     local rate = tonumber(result[1].rent)
     local vehicle = tonumber(result[1].vehicle)
    -- print(result[1].vehicle)
    if (balance - rate) >= 0 then
        local rent = result[1].rent
        -- print(rent)
        pData.Functions.RemoveMoney('bank', rent, "vehicle-rent-in-shop")
        TriggerClientEvent("Framework:Notify", src, "You were Charged for the Next Hour! $"..rent, "error", 5000)
    elseif (cash - rate) >= 0 then 
        local rent = result[1].rent
        -- print(rent)
        pData.Functions.RemoveMoney('cash', rent, "vehicle-rent-in-shop")
        TriggerClientEvent("Framework:Notify", src, "You were Charged for the Next Hour! $"..rent, "error", 5000)
    else 
		TriggerClientEvent("Framework:Notify", src, "You don't have enough money. Car will be Un-Rented Soon!", "error", 5000)
        TriggerClientEvent("pepe-carrentals:client:NonPayment", src, vehicle)
    end

    end)

end)

RegisterNetEvent('pepe-carrentals:server:EndRental')
AddEventHandler('pepe-carrentals:server:EndRental', function(currentcar)
    local src = source
    Framework.Functions.ExecuteSql(false, "UPDATE `car_rentals` SET status = 'done' WHERE `vehicle` = '"..currentcar.."'")
    TriggerClientEvent("Framework:Notify", src, "Successfully Finished your Ride! The Car will be Towed Soon!", "success", 5000)

end)
RegisterNetEvent('pepe-carrentals:server:SetDone')
AddEventHandler('pepe-carrentals:server:SetDone', function(currentcar)
    local src = source
    Framework.Functions.ExecuteSql(false, "UPDATE `car_rentals` SET status = 'done' WHERE `vehicle` = '"..currentcar.."'")
    -- TriggerClientEvent("Framework:Notify", src, "Successfully Finished your Ride! The Car will be Towed Soon!", "success", 5000)

end)

RegisterNetEvent('pepe-carrentals:server:EngineHealth')
AddEventHandler('pepe-carrentals:server:EngineHealth', function(health)
    local src = source
    local charges = CRConfig.DamageCharges.charges
    local prize = CRConfig.DamageCharges.appreciation
    local pData = Framework.Functions.GetPlayer(src)
    local balance = pData.PlayerData.money["bank"]
    -- print(health)
    if health < 500 then 
        if balance >= charges then 
            TriggerClientEvent("Framework:Notify", src, "The Car's Engine seems Broken! You are being Charged $"..charges.." for the Repairs.", "error",10000)
            pData.Functions.RemoveMoney('bank', charges, "vehicle-rent-in-shop")
        end
    elseif health > 800 then 
        TriggerClientEvent("Framework:Notify", src, "The Car's Engine is in Good Condition. You are being Rewarded $"..prize.."", "success", 10000)
        pData.Functions.AddMoney('bank', prize, "vehicle-rent-in-shop")
    end
end)

function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return plate
    end)
    return plate:upper()
end


function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end
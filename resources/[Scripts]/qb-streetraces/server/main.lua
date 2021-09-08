Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

--CODE

local Races = {}
RegisterServerEvent('qb-streetraces:NewRace')
AddEventHandler('qb-streetraces:NewRace', function(RaceTable)
    local src = source
    local RaceId = math.random(1000, 9999)
    local xPlayer = Framework.Functions.GetPlayer(src)
    if xPlayer.Functions.RemoveMoney('cash', RaceTable.amount, "streetrace-created") then
        Races[RaceId] = RaceTable
        Races[RaceId].creator = GetPlayerIdentifiers(src)[1]
        table.insert(Races[RaceId].joined, GetPlayerIdentifiers(src)[1])
        TriggerClientEvent('qb-streetraces:SetRace', -1, Races)
        TriggerClientEvent('qb-streetraces:SetRaceId', src, RaceId)
        TriggerClientEvent('Framework:Notify', src, "You participate in the race $"..Races[RaceId].amount..",-", 'success')
    end
end)

RegisterServerEvent('qb-streetraces:RaceWon')
AddEventHandler('qb-streetraces:RaceWon', function(RaceId)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    xPlayer.Functions.AddMoney('cash', Races[RaceId].pot, "race-won")
    TriggerClientEvent('Framework:Notify', src, "You have won the race and $"..Races[RaceId].pot..",- ", 'success')
    TriggerClientEvent('qb-streetraces:SetRace', -1, Races)
    TriggerClientEvent('qb-streetraces:RaceDone', -1, RaceId, GetPlayerName(src))
end)

RegisterServerEvent('qb-streetraces:JoinRace')
AddEventHandler('qb-streetraces:JoinRace', function(RaceId)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local zPlayer = Framework.Functions.GetPlayer(Races[RaceId].creator)
    if zPlayer ~= nil then
        if xPlayer.PlayerData.money.cash >= Races[RaceId].amount then
            Races[RaceId].pot = Races[RaceId].pot + Races[RaceId].amount
            table.insert(Races[RaceId].joined, GetPlayerIdentifiers(src)[1])
            if xPlayer.Functions.RemoveMoney('cash', Races[RaceId].amount, "streetrace-joined") then
                TriggerClientEvent('qb-streetraces:SetRace', -1, Races)
                TriggerClientEvent('qb-streetraces:SetRaceId', src, RaceId)
                TriggerClientEvent('Framework:Notify', zPlayer.PlayerData.source, GetPlayerName(src).." is joined!", 'primary')
            end
        else
            TriggerClientEvent('Framework:Notify', src, "You don't have enough cash in your pocket!", 'error')
        end
    else
        TriggerClientEvent('Framework:Notify', src, "The one who made the race is offline!", 'error')
        Races[RaceId] = {}
    end
end)

Framework.Commands.Add("race", "Create a race.", {{name="amount", help="Amount of money to start the race."}}, true, function(source, args)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local amount = tonumber(args[1])
    if GetJoinedRace(GetPlayerIdentifiers(src)[1]) == 0 then
        if xPlayer.PlayerData.money.cash >= amount then
            TriggerClientEvent('qb-streetraces:CreateRace', src, amount)
        else
            TriggerClientEvent('Framework:Notify', src, "You don't have enough cash in your pocket!", 'error')
        end
    else
        TriggerClientEvent('Framework:Notify', src, "You are already in a race!", 'error')
    end
end)

Framework.Commands.Add("stoprace", "Stop the race (creator).", {}, false, function(source, args)
    local src = source
    CancelRace(src)
end)

Framework.Commands.Add("quitrace", "Leave the race. (U will lose your bets!)", {}, false, function(source, args)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local RaceId = GetJoinedRace(GetPlayerIdentifiers(src)[1])
    local zPlayer = Framework.Functions.GetPlayer(Races[RaceId].creator)
    if RaceId ~= 0 then
        if GetCreatedRace(GetPlayerIdentifiers(src)[1]) ~= RaceId then
            RemoveFromRace(GetPlayerIdentifiers(src)[1])
            TriggerClientEvent('Framework:Notify', src, "You have stepped out of the race! And you lost your money", 'error')
            TriggerClientEvent('esx:showNotification', zPlayer.PlayerData.source, GetPlayerName(src) .." stepped out of the race!", "red")
        else
            TriggerClientEvent('Framework:Notify', src, "/stoprace to stop the race!", 'error')
        end
    else
        TriggerClientEvent('Framework:Notify', src, "You are not in a race..", 'error')
    end
end)

Framework.Commands.Add("startrace", "Race beginn", {}, false, function(source, args)
    local src = source
    local RaceId = GetCreatedRace(GetPlayerIdentifiers(src)[1])
    
    if RaceId ~= 0 then
        Races[RaceId].started = true
        TriggerClientEvent('qb-streetraces:SetRace', -1, Races)
        TriggerClientEvent("qb-streetraces:StartRace", -1, RaceId)
    else
        TriggerClientEvent('Framework:Notify', src, "You have not started a race!", 'error')
    end
end)

function CancelRace(source)
    local xPlayer = Framework.Functions.GetPlayer(source)
    local RaceId = GetCreatedRace(GetPlayerIdentifiers(source)[1])

    if RaceId ~= 0 then
        for key, race in pairs(Races) do
            if Races[key] ~= nil and Races[key].creator == xPlayer.PlayerData.steam then
                if not Races[key].started then
                    for _, iden in pairs(Races[key].joined) do
                        local xdPlayer = Framework.Functions.GetPlayer(iden)
                        xdPlayer.Functions.AddMoney('cash', Races[key].amount, "race-cancelled")
                        TriggerClientEvent('Framework:Notify', xdPlayer.PlayerData.source, "Race has stopped, you received back $"..Races[key].amount..",- !", 'error')
                        TriggerClientEvent('qb-streetraces:StopRace', xdPlayer.PlayerData.source)
                        RemoveFromRace(iden)
                    end
                else
                    TriggerClientEvent('Framework:Notify', xPlayer.PlayerData.source, "The race has already started..", 'error')
                end
                TriggerClientEvent('Framework:Notify', source, "Race stopped!", 'error')
                Races[key] = nil
            end
        end
        TriggerClientEvent('qb-streetraces:SetRace', -1, Races)
    else
        TriggerClientEvent('Framework:Notify', source, "You have not started a race!", 'error')
    end
end

function RemoveFromRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for i, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    table.remove(Races[key].joined, i)
                end
            end
        end
    end
end

function GetJoinedRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for _, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    return key
                end
            end
        end
    end
    return 0
end

function GetCreatedRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and Races[key].creator == identifier and not Races[key].started then
            return key
        end
    end
    return 0
end

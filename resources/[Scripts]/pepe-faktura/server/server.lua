Framework = nil
TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)

Framework.Commands.Add("bill", "Viết một hoá đơn", {{name="id", help="ID người chơi"},{name="Amount", help="Số tiền"},{name="Reason", help="Nội dung"}}, false, function(source, args)
    Player = Framework.Functions.GetPlayer(source)
    OtherPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
        if Player ~= nil then
        if OtherPlayer ~= nil then
            name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname
            playerId = tonumber(args[1])
            price = tonumber(args[2])
            citizenid = Player.PlayerData.citizenid

            table.remove(args, 1)
            table.remove(args, 1)
            local reason = table.concat(args, " ")

            TriggerClientEvent('billing:client:sendBillingMail', playerId, name, price, reason, citizenid)
        else
            TriggerClientEvent('Framework:Notify', source, "Công dân không trực tuyến..", "error", 4500)
        end
    end
end)


RegisterNetEvent('billing:server:PayBill')
AddEventHandler('billing:server:PayBill', function(data)
    Player = Framework.Functions.GetPlayer(source)
    OtherPlayer = Framework.Functions.GetPlayerByCitizenId(data[2])
    if Player ~= nil then
        Balance = Player.PlayerData.money["bank"]

        if Balance - data[1] >= 0 then
            Player.Functions.RemoveMoney("bank",data[1], "paid-bills")
            if OtherPlayer ~= nil then
                OtherPlayer.Functions.AddMoney("cash",data[1], "recived-bill")

                TriggerClientEvent('Framework:Notify', OtherPlayer.PlayerData.source, 'Bạn đã nhận $'..data[1].. ' từ '..Player.PlayerData.charinfo.firstname.. ' ' ..Player.PlayerData.charinfo.lastname, 'success')
            end
        end
    end
end)

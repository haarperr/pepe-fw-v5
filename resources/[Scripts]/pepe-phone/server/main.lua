Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

local Phone = {}
local Tweets = {}
local AppAlerts = {}
local MentionedTweets = {}
local Hashtags = {}
local Calls = {}
local Adverts = {}
local GeneratedPlates = {}

RegisterServerEvent('pepe-phone:server:AddAdvert')
AddEventHandler('pepe-phone:server:AddAdvert', function(msg)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid

    if Adverts[CitizenId] ~= nil then
        Adverts[CitizenId].message = msg
        Adverts[CitizenId].name = "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname
        Adverts[CitizenId].number = Player.PlayerData.charinfo.phone
    else
        Adverts[CitizenId] = {
            message = msg,
            name = "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname,
            number = Player.PlayerData.charinfo.phone,
        }
    end

    TriggerClientEvent('pepe-phone:client:UpdateAdverts', -1, Adverts, "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname)
end)

function GetOnlineStatus(number)
    local Target = Framework.Functions.GetPlayerByPhone(number)
    local retval = false
    if Target ~= nil then retval = true end
    return retval
end

Framework.Functions.CreateCallback('pepe-phone:server:GetPhoneData', function(source, cb)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    if Player ~= nil then
        local PhoneData = {
            Applications = {},
            PlayerContacts = {},
            MentionedTweets = {},
            Chats = {},
            Hashtags = {},
            Invoices = {},
            Garage = {},
            Mails = {},
            Cars = {},
            Adverts = {},
            CryptoTransactions = {},
            Tweets = {}
        }

        PhoneData.Adverts = Adverts

        Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_contacts WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' ORDER BY `name` ASC", function(result)
            local Contacts = {}
            if result[1] ~= nil then
                for k, v in pairs(result) do
                    v.status = GetOnlineStatus(v.number)
                end
                
                PhoneData.PlayerContacts = result
            end

            Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_bills WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(invoices)
                if invoices[1] ~= nil then
                    for k, v in pairs(invoices) do
                        local Ply = Framework.Functions.GetPlayerByCitizenId(v.sender)
                        if Ply ~= nil then
                            v.number = Ply.PlayerData.charinfo.phone
                        else
                            Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_metadata` WHERE `citizenid` = '"..v.sender.."'", function(res)
                                if res[1] ~= nil then
                                    res[1].charinfo = json.decode(res[1].charinfo)
                                    v.number = res[1].charinfo.phone
                                else
                                    v.number = nil
                                end
                            end)
                        end
                    end
                    PhoneData.Invoices = invoices
                end

                Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_vehicles WHERE forSale = '1'", function(cars)
                    if cars ~= nil then
                        local CarsData = {}
                        for k,v in pairs(cars) do
                            cars = {
                                citizenid = v.citizenid,
                                vehicle = Framework.Shared.Vehicles[v.vehicle]['Name'],
                                plate = v.plate,
                                salePrice = v.salePrice,
                            }
                            table.insert(CarsData, cars)
                        end
                        PhoneData.Cars = CarsData
                    end

                    Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_vehicles WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(garageresult)
                        if garageresult[1] ~= nil then
                            PhoneData.Garage = garageresult
                        end
                    
                            Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_messages WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(messages)
                                if messages ~= nil and next(messages) ~= nil then 
                                    PhoneData.Chats = messages
                                end

                                if AppAlerts[Player.PlayerData.citizenid] ~= nil then 
                                    PhoneData.Applications = AppAlerts[Player.PlayerData.citizenid]
                                end

                                if MentionedTweets[Player.PlayerData.citizenid] ~= nil then 
                                    PhoneData.MentionedTweets = MentionedTweets[Player.PlayerData.citizenid]
                                end

                                if Hashtags ~= nil and next(Hashtags) ~= nil then
                                    PhoneData.Hashtags = Hashtags
                                end

                                if Tweets ~= nil and next(Tweets) ~= nil then
                                    PhoneData.Tweets = Tweets
                                end

                                Framework.Functions.ExecuteSql(false, 'SELECT * FROM `characters_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` ASC', function(mails)
                                    if mails[1] ~= nil then
                                        for k, v in pairs(mails) do
                                            if mails[k].button ~= nil then
                                                mails[k].button = json.decode(mails[k].button)
                                            end
                                        end
                                        PhoneData.Mails = mails
                                    end

                                cb(PhoneData)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end
end)

Framework.Functions.CreateCallback('pepe-phone:server:GetCallState', function(source, cb, ContactData)
    local Target = Framework.Functions.GetPlayerByPhone(ContactData.number)

    if Target ~= nil then
        if Calls[Target.PlayerData.citizenid] ~= nil then
            if Calls[Target.PlayerData.citizenid].inCall then
                cb(false, true)
            else
                cb(true, true)
            end
        else
            cb(true, true)
        end
    else
        cb(false, false)
    end
end)

RegisterServerEvent('pepe-phone:server:SetCallState')
AddEventHandler('pepe-phone:server:SetCallState', function(bool)
    local src = source
    local Ply = Framework.Functions.GetPlayer(src)

    if Calls[Ply.PlayerData.citizenid] ~= nil then
        Calls[Ply.PlayerData.citizenid].inCall = bool
    else
        Calls[Ply.PlayerData.citizenid] = {}
        Calls[Ply.PlayerData.citizenid].inCall = bool
    end
end)

RegisterServerEvent('pepe-phone:server:RemoveMail')
AddEventHandler('pepe-phone:server:RemoveMail', function(MailId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    Framework.Functions.ExecuteSql(false, 'DELETE FROM `characters_mails` WHERE `mailid` = "'..MailId..'" AND `citizenid` = "'..Player.PlayerData.citizenid..'"')
    SetTimeout(100, function()
        Framework.Functions.ExecuteSql(false, 'SELECT * FROM `characters_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` ASC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('pepe-phone:client:UpdateMails', src, mails)
        end)
    end)
end)

function GenerateMailId()
    return math.random(111111, 999999)
end

RegisterServerEvent('pepe-phone:server:sendNewMail')
AddEventHandler('pepe-phone:server:sendNewMail', function(mailData)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    if mailData.button == nil then
        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
    else
        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
    end
    TriggerClientEvent('pepe-phone:client:NewMailNotify', src, mailData)
    SetTimeout(200, function()
        Framework.Functions.ExecuteSql(false, 'SELECT * FROM `characters_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` DESC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('pepe-phone:client:UpdateMails', src, mails)
        end)
    end)
end)

RegisterServerEvent('pepe-phone:server:sendNewMailToOffline')
AddEventHandler('pepe-phone:server:sendNewMailToOffline', function(citizenid, mailData)
    local Player = Framework.Functions.GetPlayerByCitizenId(citizenid)

    if Player ~= nil then
        local src = Player.PlayerData.source

        if mailData.button == nil then
            Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
            TriggerClientEvent('pepe-phone:client:NewMailNotify', src, mailData)
        else
            Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
            TriggerClientEvent('pepe-phone:client:NewMailNotify', src, mailData)
        end

        SetTimeout(200, function()
            Framework.Functions.ExecuteSql(false, 'SELECT * FROM `characters_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` DESC', function(mails)
                if mails[1] ~= nil then
                    for k, v in pairs(mails) do
                        if mails[k].button ~= nil then
                            mails[k].button = json.decode(mails[k].button)
                        end
                    end
                end
        
                TriggerClientEvent('pepe-phone:client:UpdateMails', src, mails)
            end)
        end)
    else
        if mailData.button == nil then
            Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
        else
            Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
        end
    end
end)

RegisterServerEvent('pepe-phone:server:sendNewEventMail')
AddEventHandler('pepe-phone:server:sendNewEventMail', function(citizenid, mailData)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local MailedPlayer = Framework.Functions.GetPlayerByCitizenId(citizenid)
    if mailData.button == nil then
        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
    else
        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
    end
    if MailedPlayer ~= nil then
    SetTimeout(200, function()
        Framework.Functions.ExecuteSql(false, 'SELECT * FROM `characters_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` DESC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('pepe-phone:client:UpdateMails', src, mails)
        end)
    end)
    end
end)

RegisterServerEvent('pepe-phone:server:sellVehicle')
AddEventHandler('pepe-phone:server:sellVehicle', function(plate, price)
    local Player = Framework.Functions.GetPlayer(source)
    Framework.Functions.ExecuteSql(false, "UPDATE characters_vehicles SET `forSale` = '1', `salePrice` = '" .. price .. "' WHERE  `plate` = '" .. plate .. "' AND `citizenid` = '" .. Player.PlayerData.citizenid .. "'")
end)

RegisterServerEvent('pepe-phone:server:buy:chosen:vehicle')
AddEventHandler('pepe-phone:server:buy:chosen:vehicle', function(VehiclePlate, CitizenId, SellPrice)
    local src = source
    local GarageData = 'Legion Parking'
    local Player = Framework.Functions.GetPlayer(src)
    if Player.PlayerData.money['bank'] >= SellPrice then
        local TargetPlayer = Framework.Functions.GetPlayerByCitizenId(CitizenId)
        if TargetPlayer ~= nil then
           Player.Functions.RemoveMoney('bank', SellPrice, "bought-vehicle")
           TargetPlayer.Functions.AddMoney('bank', SellPrice, "sold-vehicle")
           Framework.Functions.ExecuteSql(false, "UPDATE characters_vehicles SET `citizenid` = '" .. Player.PlayerData.citizenid .. "', `garage` = '"..GarageData.."', `state` = 'in', `forSale` = '0', `salePrice` = '0' WHERE `plate` = '" ..VehiclePlate.. "'")
           TriggerClientEvent('pepe-phone:client:send:email:bought:vehicle', src, VehiclePlate) 
           TriggerClientEvent('pepe-phone:client:send:email:sold:vehicle', TargetPlayer.PlayerData.source, SellPrice, VehiclePlate) 
           TriggerClientEvent('Framework:Notify', src, "Vehicle with number plate '" .. VehiclePlate .. "' bought for $'" .. SellPrice .. "'", "success")
        else
            Framework.Functions.ExecuteSql(false, 'SELECT `money` FROM characters_metadata WHERE citizenid ="'..CitizenId..'"',function(result)
                if result ~= nil then
                 local NewMoneyTable = {}
                 local NewBankBalance = nil
                 local MoneyTable = json.decode(result[1].money)
                 for k,v in pairs(MoneyTable) do 
                     if k == 'bank' then
                        NewBankBalance = v + SellPrice
                     end
                  NewMoneyTable = {['bank'] = NewBankBalance, ['cash'] = MoneyTable['cash'], ['crypto'] = MoneyTable['crypto']}                  
                 end
                 local MailData = {
                    sender = "autoscout",
                    subject = "Your advertisement",
                    message = "Dear reader,<br/><br/>You will receive an email of your recent ad.<br><br>License Plate: <strong>" ..VehiclePlate.. "</strong> <br>Selling price: <strong>$"..SellPrice.. '</strong><br><br>Your vehicle has been sold successfully and the amount has been credited to your bank.<br><br>Kind regards,<br>autoscout',
                    button = {}
                 }
                 TriggerEvent("pepe-phone:server:sendNewEventMail", CitizenId, MailData)
                 Player.Functions.RemoveMoney('bank', SellPrice, "bought-vehicle")
                 Framework.Functions.ExecuteSql(false, "UPDATE characters_vehicles SET `citizenid` = '" .. Player.PlayerData.citizenid .. "', `garage` = '"..GarageData.."', `state` = 'in', `forSale` = '0', `salePrice` = '0' WHERE `plate` = '" ..VehiclePlate.. "'")
                 Framework.Functions.ExecuteSql(false, "UPDATE characters_metadata SET `money` = '" ..json.encode(NewMoneyTable).. "' WHERE `citizenid` = '" ..CitizenId.. "'")
                 TriggerClientEvent('pepe-phone:client:send:email:bought:vehicle', src, VehiclePlate)
                 TriggerClientEvent('Framework:Notify', src, "Vehicle with number plate '" .. VehiclePlate .. "' bought for $'" .. SellPrice .. "'", "success")
                end
            end)
        end
    else
        TriggerClientEvent('Framework:Notify', src, "You don't have enough money on your bank account...", "error")
    end
end)

Framework.Functions.CreateCallback('pepe-phone:server:load:autoscout', function(source, cb)
 Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_vehicles WHERE forSale = '1'", function(cars)
     if cars ~= nil then
         local CarsData = {}
         for k,v in pairs(cars) do
             cars = {
                 citizenid = v.citizenid,
                 vehicle = Framework.Shared.Vehicles[v.vehicle]['Name'],
                 plate = v.plate,
                 salePrice = v.salePrice,
             }
             table.insert(CarsData, cars)
         end
          cb(CarsData)
     end
    end)
end)

RegisterServerEvent('pepe-phone:server:ClearButtonData')
AddEventHandler('pepe-phone:server:ClearButtonData', function(mailId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    Framework.Functions.ExecuteSql(false, 'UPDATE `characters_mails` SET `button` = "" WHERE `mailid` = "'..mailId..'" AND `citizenid` = "'..Player.PlayerData.citizenid..'"')
    SetTimeout(200, function()
        Framework.Functions.ExecuteSql(false, 'SELECT * FROM `characters_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` DESC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('pepe-phone:client:UpdateMails', src, mails)
        end)
    end)
end)

RegisterServerEvent('pepe-phone:server:MentionedPlayer')
AddEventHandler('pepe-phone:server:MentionedPlayer', function(firstName, lastName, TweetMessage)
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.charinfo.firstname == firstName and Player.PlayerData.charinfo.lastname == lastName) then
                Phone.SetPhoneAlerts(Player.PlayerData.citizenid, "twitter")
                Phone.AddMentionedTweet(Player.PlayerData.citizenid, TweetMessage)
                TriggerClientEvent('pepe-phone:client:GetMentioned', Player.PlayerData.source, TweetMessage, AppAlerts[Player.PlayerData.citizenid]["twitter"])
            else
                Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `charinfo` LIKE '%"..firstName.."%' AND `charinfo` LIKE '%"..lastName.."%'", function(result)
                    if result[1] ~= nil then
                        local MentionedTarget = result[1].citizenid
                        Phone.SetPhoneAlerts(MentionedTarget, "twitter")
                        Phone.AddMentionedTweet(MentionedTarget, TweetMessage)
                    end
                end)
            end
        end
	end
end)

RegisterServerEvent('pepe-phone:server:CallContact')
AddEventHandler('pepe-phone:server:CallContact', function(TargetData, CallId, AnonymousCall)
    local src = source
    local Ply = Framework.Functions.GetPlayer(src)
    local Target = Framework.Functions.GetPlayerByPhone(TargetData.number)

    if Target ~= nil then
        TriggerClientEvent('pepe-phone:client:GetCalled', Target.PlayerData.source, Ply.PlayerData.charinfo.phone, CallId, AnonymousCall)
    end
end)

Framework.Functions.CreateCallback('pepe-phone:server:PayInvoice', function(source, cb, sender, amount, invoiceId)
    local src = source
    local Ply = Framework.Functions.GetPlayer(src)
        if Ply.PlayerData.money.bank >= amount then
            Ply.Functions.RemoveMoney('bank', amount, "paid-invoice")
            Framework.Functions.ExecuteSql(true, "DELETE FROM `characters_bills` WHERE `invoiceid` = '"..invoiceId.."'")
            cb(true)
        else
            cb(false)
        end
end)

Framework.Functions.CreateCallback('pepe-phone:server:DeclineInvoice', function(source, cb, sender, amount, invoiceId)
    local src = source
    local Ply = Framework.Functions.GetPlayer(src)
    local Trgt = Framework.Functions.GetPlayerByCitizenId(sender)
    local Invoices = {}

    Framework.Functions.ExecuteSql(true, "DELETE FROM `characters_bills` WHERE `invoiceid` = '"..invoiceId.."'")
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_bills` WHERE `citizenid` = '"..Ply.PlayerData.citizenid.."'", function(invoices)
        if invoices[1] ~= nil then
            for k, v in pairs(invoices) do
                local Target = Framework.Functions.GetPlayerByCitizenId(v.sender)
                if Target ~= nil then
                    v.number = Target.PlayerData.charinfo.phone
                else
                    Framework.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..v.sender.."'", function(res)
                        if res[1] ~= nil then
                            res[1].charinfo = json.decode(res[1].charinfo)
                            v.number = res[1].charinfo.phone
                        else
                            v.number = nil
                        end
                    end)
                end
            end
            Invoices = invoices
        end
        cb(true, invoices)
    end)
end)

RegisterServerEvent('pepe-phone:server:UpdateHashtags')
AddEventHandler('pepe-phone:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        table.insert(Hashtags[Handle].messages, messageData)
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(Hashtags[Handle].messages, messageData)
    end
    TriggerClientEvent('pepe-phone:client:UpdateHashtags', -1, Handle, messageData)
end)

Phone.AddMentionedTweet = function(citizenid, TweetData)
    if MentionedTweets[citizenid] == nil then MentionedTweets[citizenid] = {} end
    table.insert(MentionedTweets[citizenid], TweetData)
end

Phone.SetPhoneAlerts = function(citizenid, app, alerts)
    if citizenid ~= nil and app ~= nil then
        if AppAlerts[citizenid] == nil then
            AppAlerts[citizenid] = {}
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = alerts
                end
            end
        else
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = 0
                end
            else
                if alerts == nil then
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 1
                else
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 0
                end
            end
        end
    end
end

Framework.Functions.CreateCallback('pepe-phone:server:GetContactPictures', function(source, cb, Chats)
    for k, v in pairs(Chats) do
        local Player = Framework.Functions.GetPlayerByPhone(v.number)
        
        Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `charinfo` LIKE '%"..v.number.."%'", function(result)
            if result[1] ~= nil then
                local MetaData = json.decode(result[1].globals)

                if MetaData.phone.profilepicture ~= nil then
                    v.picture = MetaData.phone.profilepicture
                else
                    v.picture = "default"
                end
            end
        end)
    end
    SetTimeout(100, function()
        cb(Chats)
    end)
end)

Framework.Functions.CreateCallback('pepe-phone:server:GetContactPicture', function(source, cb, Chat)
    local Player = Framework.Functions.GetPlayerByPhone(Chat.number)

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `charinfo` LIKE '%"..Chat.number.."%'", function(result)
        local MetaData = json.decode(result[1].globals)

        if MetaData.phone.profilepicture ~= nil then
            Chat.picture = MetaData.phone.profilepicture
        else
            Chat.picture = "default"
        end
    end)
    SetTimeout(100, function()
        cb(Chat)
    end)
end)

Framework.Functions.CreateCallback('pepe-phone:server:GetPicture', function(source, cb, number)
    local Player = Framework.Functions.GetPlayerByPhone(number)
    local Picture = nil

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `charinfo` LIKE '%"..number.."%'", function(result)
        if result[1] ~= nil then
            local MetaData = json.decode(result[1].globals)

            if MetaData.phone.profilepicture ~= nil then
                Picture = MetaData.phone.profilepicture
            else
                Picture = "default"
            end
            cb(Picture)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('pepe-phone:server:SetPhoneAlerts')
AddEventHandler('pepe-phone:server:SetPhoneAlerts', function(app, alerts)
    local src = source
    local CitizenId = Framework.Functions.GetPlayer(src).citizenid
    Phone.SetPhoneAlerts(CitizenId, app, alerts)
end)

RegisterServerEvent('pepe-phone:server:UpdateTweets')
AddEventHandler('pepe-phone:server:UpdateTweets', function(NewTweets, TweetData, Type)
    Tweets = NewTweets
    local TwtData = TweetData
    local src = source
    TriggerClientEvent('pepe-phone:client:UpdateTweets', -1, src, Tweets, TwtData, Type)
end)

RegisterServerEvent('pepe-phone:server:TransferMoney')
AddEventHandler('pepe-phone:server:TransferMoney', function(iban, amount)
    local src = source
    local sender = Framework.Functions.GetPlayer(src)

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `charinfo` LIKE '%"..iban.."%'", function(result)
        if result[1] ~= nil then
            local recieverSteam = Framework.Functions.GetPlayerByCitizenId(result[1].citizenid)

            if recieverSteam ~= nil then
                local PhoneItem = recieverSteam.Functions.GetItemByName("phone")
                recieverSteam.Functions.AddMoney('bank', amount, "phone-transfered-from-"..sender.PlayerData.citizenid)
                sender.Functions.RemoveMoney('bank', amount, "phone-transfered-to-"..recieverSteam.PlayerData.citizenid)

                if PhoneItem ~= nil then
                    TriggerClientEvent('pepe-phone:client:TransferMoney', recieverSteam.PlayerData.source, amount, recieverSteam.PlayerData.money.bank)
                end
            else
                local moneyInfo = json.decode(result[1].money)
                moneyInfo.bank = round((moneyInfo.bank + amount))
                Framework.Functions.ExecuteSql(false, "UPDATE `characters_metadata` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
                sender.Functions.RemoveMoney('bank', amount, "phone-transfered")
            end
        else
            TriggerClientEvent('Framework:Notify', src, "This account number does not exist!", "error")
        end
    end)
end)

RegisterServerEvent('pepe-phone:server:EditContact')
AddEventHandler('pepe-phone:server:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, oldIban)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Framework.Functions.ExecuteSql(false, "UPDATE `characters_contacts` SET `name` = '"..newName.."', `number` = '"..newNumber.."', `iban` = '"..newIban.."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `name` = '"..oldName.."' AND `number` = '"..oldNumber.."'")
end)

RegisterServerEvent('pepe-phone:server:RemoveContact')
AddEventHandler('pepe-phone:server:RemoveContact', function(Name, Number)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    
    Framework.Functions.ExecuteSql(false, "DELETE FROM `characters_contacts` WHERE `name` = '"..Name.."' AND `number` = '"..Number.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
end)

RegisterServerEvent('pepe-phone:server:AddNewContact')
AddEventHandler('pepe-phone:server:AddNewContact', function(name, number, iban)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_contacts` (`citizenid`, `name`, `number`, `iban`) VALUES ('"..Player.PlayerData.citizenid.."', '"..tostring(name).."', '"..tostring(number).."', '"..tostring(iban).."')")
end)

RegisterServerEvent('pepe-phone:server:UpdateMessages')
AddEventHandler('pepe-phone:server:UpdateMessages', function(ChatMessages, ChatNumber, New)
    local src = source
    local SenderData = Framework.Functions.GetPlayer(src)

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `charinfo` LIKE '%"..ChatNumber.."%'", function(Player)
        if Player[1] ~= nil then
            local TargetData = Framework.Functions.GetPlayerByCitizenId(Player[1].citizenid)

            if TargetData ~= nil then
                Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_messages` WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..ChatNumber.."'", function(Chat)
                    if Chat[1] ~= nil then
                        -- Update for target
                        Framework.Functions.ExecuteSql(false, "UPDATE `characters_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..TargetData.PlayerData.citizenid.."' AND `number` = '"..SenderData.PlayerData.charinfo.phone.."'")
                                
                        -- Update for sender
                        Framework.Functions.ExecuteSql(false, "UPDATE `characters_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..TargetData.PlayerData.charinfo.phone.."'")
                    
                        -- Send notification & Update messages for target
                        TriggerClientEvent('pepe-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, false)
                    else
                        -- Insert for target
                        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_messages` (`citizenid`, `number`, `messages`) VALUES ('"..TargetData.PlayerData.citizenid.."', '"..SenderData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                                            
                        -- Insert for sender
                        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_messages` (`citizenid`, `number`, `messages`) VALUES ('"..SenderData.PlayerData.citizenid.."', '"..TargetData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")

                        -- Send notification & Update messages for target
                        TriggerClientEvent('pepe-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, true)
                    end
                end)
            else
                Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_messages` WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..ChatNumber.."'", function(Chat)
                    if Chat[1] ~= nil then
                        -- Update for target
                        Framework.Functions.ExecuteSql(false, "UPDATE `characters_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..Player[1].citizenid.."' AND `number` = '"..SenderData.PlayerData.charinfo.phone.."'")
                                
                        -- Update for sender
                        Player[1].charinfo = json.decode(Player[1].charinfo)
                        Framework.Functions.ExecuteSql(false, "UPDATE `characters_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..Player[1].charinfo.phone.."'")
                    else
                        -- Insert for target
                        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_messages` (`citizenid`, `number`, `messages`) VALUES ('"..Player[1].citizenid.."', '"..SenderData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                        
                        -- Insert for sender
                        Player[1].charinfo = json.decode(Player[1].charinfo)
                        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_messages` (`citizenid`, `number`, `messages`) VALUES ('"..SenderData.PlayerData.citizenid.."', '"..Player[1].charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                    end
                end)
            end
        end
    end)
end)

RegisterServerEvent('pepe-phone:server:AddRecentCall')
AddEventHandler('pepe-phone:server:AddRecentCall', function(type, data)
    local src = source
    local Ply = Framework.Functions.GetPlayer(src)

    local Hour = os.date("%H")
    local Minute = os.date("%M")
    local label = Hour..":"..Minute

    TriggerClientEvent('pepe-phone:client:AddRecentCall', src, data, label, type)

    local Trgt = Framework.Functions.GetPlayerByPhone(data.number)
    if Trgt ~= nil then
        TriggerClientEvent('pepe-phone:client:AddRecentCall', Trgt.PlayerData.source, {
            name = Ply.PlayerData.charinfo.firstname .. " " ..Ply.PlayerData.charinfo.lastname,
            number = Ply.PlayerData.charinfo.phone,
            anonymous = anonymous
        }, label, "outgoing")
    end
end)

RegisterServerEvent('pepe-phone:server:CancelCall')
AddEventHandler('pepe-phone:server:CancelCall', function(ContactData)
    local Ply = Framework.Functions.GetPlayerByPhone(ContactData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('pepe-phone:client:CancelCall', Ply.PlayerData.source)
    end
end)

RegisterServerEvent('pepe-phone:server:AnswerCall')
AddEventHandler('pepe-phone:server:AnswerCall', function(CallData)
    local Ply = Framework.Functions.GetPlayerByPhone(CallData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('pepe-phone:client:AnswerCall', Ply.PlayerData.source)
    end
end)

RegisterServerEvent('pepe-phone:server:SaveMetaData')
AddEventHandler('pepe-phone:server:SaveMetaData', function(MData)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("phone", MData)
end)

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements )
end

Framework.Functions.CreateCallback('pepe-phone:server:FetchResult', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    local ApaData = {}
    Framework.Functions.ExecuteSql(false, 'SELECT * FROM `characters_metadata` WHERE `citizenid` = "'..search..'" OR `charinfo` LIKE "%'..search..'%"', function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local charinfo = json.decode(v.charinfo)
                local globals = json.decode(v.globals)
                if charinfo ~= nil then
                table.insert(searchData, {
                    citizenid = v.citizenid,
                    firstname = charinfo.firstname,
                    lastname = charinfo.lastname,
                    birthdate = charinfo.birthdate,
                    phone = charinfo.phone,
                    nationality = charinfo.nationality,
                    gender = charinfo.gender,
                    appartmentid = globals["appartment-data"].Id,
                    appartmentname = exports['pepe-appartments']:GetAppartmentName(globals["appartment-data"].Name),
                    driverlicense = globals["licences"]["driver"],
                })
              end
            end
            cb(searchData)
        else
            cb(nil)
        end
    end)
end)

Framework.Functions.CreateCallback('pepe-phone:server:GetVehicleSearchResults', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    Framework.Functions.ExecuteSql(false, 'SELECT * FROM `characters_vehicles` WHERE `plate` LIKE "%'..search..'%" OR `citizenid` = "'..search..'"', function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                Framework.Functions.ExecuteSql(true, 'SELECT * FROM `characters_metadata` WHERE `citizenid` = "'..result[k].citizenid..'"', function(player)
                    if player[1] ~= nil then 
                        local charinfo = json.decode(player[1].charinfo)
                            table.insert(searchData, {
                                plate = result[k].plate,
                                status = true,
                                owner = charinfo.firstname .. " " .. charinfo.lastname,
                                citizenid = result[k].citizenid,
                                label = result[k].vehicle
                            })
                    end
                end)
            end
        else
            if GeneratedPlates[search] ~= nil then
                table.insert(searchData, {
                    plate = GeneratedPlates[search].plate,
                    status = GeneratedPlates[search].status,
                    owner = GeneratedPlates[search].owner,
                    citizenid = GeneratedPlates[search].citizenid,
                    label = "Brand unknown.."
                })
            else
                local ownerInfo = GenerateOwnerName()
                GeneratedPlates[search] = {
                    plate = search,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
                table.insert(searchData, {
                    plate = search,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                    label = "Brand unknown.."
                })
            end
        end
        cb(searchData)
    end)
end)

Framework.Functions.CreateCallback('pepe-phone:server:ScanPlate', function(source, cb, plate)
    local src = source
    local vehicleData = {}
    if plate ~= nil then 
        Framework.Functions.ExecuteSql(false, 'SELECT * FROM `characters_vehicles` WHERE `plate` = "'..plate..'"', function(result)
            if result[1] ~= nil then
                Framework.Functions.ExecuteSql(true, 'SELECT * FROM `characters_metadata` WHERE `citizenid` = "'..result[1].citizenid..'"', function(player)
                    local charinfo = json.decode(player[1].charinfo)
                    vehicleData = {
                        plate = plate,
                        status = true,
                        owner = charinfo.firstname .. " " .. charinfo.lastname,
                        citizenid = result[1].citizenid,
                    }
                end)
            elseif GeneratedPlates ~= nil and GeneratedPlates[plate] ~= nil then 
                vehicleData = GeneratedPlates[plate]
            else
                local ownerInfo = GenerateOwnerName()
                GeneratedPlates[plate] = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
                vehicleData = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
            end
            cb(vehicleData)
        end)
    else
        TriggerClientEvent('Framework:Notify', src, "No vehicle nearby..", "error")
        cb(nil)
    end
end)

function GenerateOwnerName()
    local names = {
        [1] = { name = "Jan Bloksteen", citizenid = "DSH091G93" },
        [2] = { name = "Jan Bakker", citizenid = "AVH09M193" },
        [3] = { name = "Ben Klaariskees", citizenid = "DVH091T93" },
        [4] = { name = "Karel Bakker", citizenid = "GZP091G93" },
        [5] = { name = "Klaas Adriaan", citizenid = "DRH09Z193" },
        [6] = { name = "Nico Wolters", citizenid = "KGV091J93" },
        [7] = { name = "Mark Hendrickx", citizenid = "ODF09S193" },
        [8] = { name = "Bert Johannes", citizenid = "KSD0919H3" },
        [9] = { name = "Karel de Grote", citizenid = "NDX091D93" },
        [10] = { name = "Jan Pieter", citizenid = "ZAL0919X3" },
        [11] = { name = "Huig Roelink", citizenid = "ZAK09D193" },
        [12] = { name = "Corneel Boerselman", citizenid = "POL09F193" },
        [13] = { name = "Hermen Klein Overmeen", citizenid = "TEW0J9193" },
        [14] = { name = "Bart Rielink", citizenid = "YOO09H193" },
        [15] = { name = "Antoon Henselijn", citizenid = "QBC091H93" },
        [16] = { name = "Aad Keizer", citizenid = "YDN091H93" },
        [17] = { name = "Thijn Kiel", citizenid = "PJD09D193" },
        [18] = { name = "Henkie Krikhaar", citizenid = "RND091D93" },
        [19] = { name = "Teun Blaauwkamp", citizenid = "QWE091A93" },
        [20] = { name = "Dries Stielstra", citizenid = "KJH0919M3" },
        [21] = { name = "Karlijn Hensbergen", citizenid = "ZXC09D193" },
        [22] = { name = "Aafke van Daalen", citizenid = "XYZ0919C3" },
        [23] = { name = "Door Leeferds", citizenid = "ZYX0919F3" },
        [24] = { name = "Nelleke Broedersen", citizenid = "IOP091O93" },
        [25] = { name = "Renske de Raaf", citizenid = "PIO091R93" },
        [26] = { name = "Krisje Moltman", citizenid = "LEK091X93" },
        [27] = { name = "Mirre Steevens", citizenid = "ALG091Y93" },
        [28] = { name = "Joosje Kalvenhaar", citizenid = "YUR09E193" },
        [29] = { name = "Mirte Ellenbroek", citizenid = "SOM091W93" },
        [30] = { name = "Marlieke Meilink", citizenid = "KAS09193" },
    }
    return names[math.random(1, #names)]
end

Framework.Functions.CreateCallback('pepe-phone:server:GetGarageVehicles', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    local Vehicles = {}

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                --local VehicleData = Framework.Shared.Vehicles[v.vehicle]

                local VehicleMeta = {}
                if v.metadata ~= nil then
                    VehicleMeta = json.decode(v.metadata)
                end

                local VehicleState = "In"
                if v.state == 'out' then
                    VehicleState = "Uit"
                elseif v.state == 'impound' then
                    VehicleState = "In Beslag"
                end

                local vehdata = {}
                if v.vehicle ~= nil then
                    vehdata = {
                        fullname = Framework.Shared.Vehicles[v.vehicle]['name'],
                        model = Framework.Shared.Vehicles[v.vehicle]['name'],
                        plate = v.plate,
                        garage = v.garage,
                        state = VehicleState,
                        fuel = VehicleMeta.Fuel,
                        engine = VehicleMeta.Engine,
                        body =  VehicleMeta.Body,
                    }
                else
                    vehdata = {
                        fullname = Framework.Shared.Vehicles[v.vehicle]['name'],
                        model = Framework.Shared.Vehicles[v.vehicle]['name'],
                        plate = v.plate,
                        garage = v.garage,
                        state = VehicleState,
                        fuel = VehicleMeta.Fuel,
                        engine = VehicleMeta.Engine,
                        body =  VehicleMeta.Body,
                    }
                end

                table.insert(Vehicles, vehdata)
            end
            cb(Vehicles)
        else
            cb(nil)
        end
    end)
end)


-- Framework.Functions.CreateCallback('pepe-phone:server:GetGarageVehicles', function(source, cb)
--     local Player = Framework.Functions.GetPlayer(source)
--     local Vehicles = {}

--     Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
--         if result[1] ~= nil then
--             for k, v in pairs(result) do
--                 --local VehicleData = Framework.Shared.Vehicles[v.vehicle]

--                 local VehicleMeta = {}
--                 if v.metadata ~= nil then
--                     VehicleMeta = json.decode(v.metadata)
--                 end

--                 local VehicleState = "In"
--                 if v.state == 'out' then
--                     VehicleState = "Uit"
--                 elseif v.state == 'impound' then
--                     VehicleState = "In Beslag"
--                 end

--                 local vehdata = {}
--                 if v.vehicle ~= nil then
--                     vehdata = {
--                         fullname = Framework.Shared.Vehicles[v.vehicle]['name'],
--                         model = Framework.Shared.Vehicles[v.vehicle]['name'],
--                         plate = v.plate,
--                         garage = v.garage,
--                         state = VehicleState,
--                         fuel = VehicleMeta.Fuel,
--                         engine = VehicleMeta.Engine,
--                         body =  VehicleMeta.Body,
--                     }
--                 else
--                     vehdata = {
--                         fullname = Framework.Shared.Vehicles[v.vehicle]['name'],
--                         model = Framework.Shared.Vehicles[v.vehicle]['name'],
--                         plate = v.plate,
--                         garage = v.garage,
--                         state = VehicleState,
--                         fuel = VehicleMeta.Fuel,
--                         engine = VehicleMeta.Engine,
--                         body =  VehicleMeta.Body,
--                     }
--                 end

--                 table.insert(Vehicles, vehdata)
--             end
--             cb(Vehicles)
--         else
--             cb(nil)
--         end
--     end)
-- end)


Framework.Functions.CreateCallback('pepe-phone:server:GetInvoiceData', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    local InvoiceData = {}
    Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_bills WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(invoices)
        if invoices[1] ~= nil then
            for k, v in pairs(invoices) do
                local Ply = Framework.Functions.GetPlayerByCitizenId(v.sender)
                if Ply ~= nil then
                    v.number = Ply.PlayerData.charinfo.phone
                else
                    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_metadata` WHERE `citizenid` = '"..v.sender.."'", function(res)
                        if res[1] ~= nil then
                            res[1].charinfo = json.decode(res[1].charinfo)
                            v.number = res[1].charinfo.phone
                        else
                            v.number = nil
                        end
                    end)
                end
            end
            InvoiceData = invoices
        end
        cb(InvoiceData)
    end)
end)


RegisterServerEvent('pepe-phone:server:add:invoice')
AddEventHandler('pepe-phone:server:add:invoice', function(TargetPlayer, Amount, Sender, Type)
    local PhoneData = {}
    local invoiceserie = math.random(111,999)..'-MIL-'..math.random(111,999)
    Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_bills` (`citizenid`, `amount`, `invoiceid`, `sender`, `type`) VALUES ('"..TargetPlayer.."', '"..Amount.."', '"..invoiceserie.."', '"..Sender.."', '"..Type.."')")
end)

Framework.Functions.CreateCallback('pepe-phone:server:HasPhone', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    if Player ~= nil then
        local HasPhone = Player.Functions.GetItemByName("phone")
        local retval = false
        if HasPhone ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('pepe-phone:server:GiveContactDetails')
AddEventHandler('pepe-phone:server:GiveContactDetails', function(PlayerId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    local SuggestionData = {
        name = {
            [1] = Player.PlayerData.charinfo.firstname,
            [2] = Player.PlayerData.charinfo.lastname
        },
        number = Player.PlayerData.charinfo.phone,
        bank = Player.PlayerData.charinfo.account
    }
    TriggerClientEvent('pepe-phone:client:AddNewSuggestion', PlayerId, SuggestionData)
end)

Framework.Functions.CreateCallback('pepe-phone:server:GetCurrentLawyers', function(source, cb)
    local Lawyers = {}
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then
            if Player.PlayerData.job.name == "lawyer" or Player.PlayerData.job.name == "realestate" or Player.PlayerData.job.name == "cardealer" and Player.PlayerData.job.onduty then
                table.insert(Lawyers, {
                    name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                    phone = Player.PlayerData.charinfo.phone,
                    typejob = Player.PlayerData.job.name,
                })
            end
        end
    end
    cb(Lawyers)
end)

Framework.Commands.Add("notify", "Test the notification system", {}, false, function(source, args)
    TriggerClientEvent('pepe-phone:client:voertuigready', source)
end, "user")

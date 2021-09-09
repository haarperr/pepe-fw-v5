Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local permissions = {
    ["kick"] = "admin",
    ["ban"] = "admin",
    ["noclip"] = "user",
    ["kickall"] = "admin",
}

RegisterServerEvent('pepe-admin:server:togglePlayerNoclip')
AddEventHandler('pepe-admin:server:togglePlayerNoclip', function(playerId, reason)
    local src = source
    if Framework.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("pepe-admin:client:toggleNoclip", playerId)
    end
end)

RegisterServerEvent('pepe-admin:server:killPlayer')
AddEventHandler('pepe-admin:server:killPlayer', function(playerId)
    TriggerClientEvent('hospital:client:KillPlayer', playerId)
end)

RegisterServerEvent('pepe-admin:server:kickPlayer')
AddEventHandler('pepe-admin:server:kickPlayer', function(playerId, reason)
    local src = source
    if Framework.Functions.HasPermission(src, permissions["kick"]) then
        DropPlayer(playerId, "Bạn đã bị đuổi ra khỏi máy chủ vì lý do:\n"..reason.."\n\n🔸 Discord: ")
    else
    end
end)

RegisterServerEvent('pepe-admin:server:Freeze')
AddEventHandler('pepe-admin:server:Freeze', function(playerId, toggle)
    local src = source
    TriggerClientEvent('pepe-admin:client:Freeze', playerId, toggle)
end)

RegisterServerEvent('pepe-admin:server:banPlayer')
AddEventHandler('pepe-admin:server:banPlayer', function(playerId, time, reason)
    local src = source
    if Framework.Functions.HasPermission(src, permissions["ban"]) then
        local time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timeTable = os.date("*t", banTime)
        Framework.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..GetPlayerIdentifiers(playerId)[3].."', '"..GetPlayerIdentifiers(playerId)[4].."', '"..reason.."', "..banTime..", '"..GetPlayerName(src).."')")
        DropPlayer(playerId, "Bạn đã bị cấm:\n"..reason.."\nThời gian kết thúc "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n")
    end
end)

RegisterServerEvent('pepe-admin:server:revivePlayer')
AddEventHandler('pepe-admin:server:revivePlayer', function(source, cb, target)
    TriggerClientEvent('hospital:client:Revive', target)
end)

RegisterServerEvent('pepe-admin:server:open:inventory')
AddEventHandler('pepe-admin:server:open:inventory', function(TagetId)
  if Framework.Functions.HasPermission(source, 'admin') then
    TriggerClientEvent('pepe-admin:client:open:target:inventory', source, TagetId)
  else
    TriggerClientEvent('Framework:Notify', source, "Bạn không đủ quyền để thực hiện", 'error')
  end
end)
-- Old QB Clothing Menu
-- RegisterServerEvent('pepe-admin:server:give:clothing')
-- AddEventHandler('pepe-admin:server:give:clothing', function(TargetId)
--   if Framework.Functions.HasPermission(source, 'admin') then
--     TriggerClientEvent("pepe-clothing:client:openMenu", TargetId)
--   else
--     TriggerClientEvent('Framework:Notify', source, "You have no perms", 'error')
--   end
-- end)

RegisterServerEvent('pepe-admin:server:OpenSkinMenu')
AddEventHandler('pepe-admin:server:OpenSkinMenu', function(targetId, menu)
    TriggerClientEvent("raid_clothes:hasEnough", targetId, menu)
end)


Framework.Commands.Add("admin", "Open admin menu", {}, false, function(source, args)
    local group = Framework.Functions.GetPermission(source)
    if group == "admin" or group == 'god' then
    TriggerClientEvent('pepe-admin:client:openMenu', source, group)
	end
end)

Framework.Commands.Add("sm", "Thông báo máy chủ", {}, false, function(source, args)
	--if source == 0 then
	--	return
	--end
    local msg = table.concat(args, " ")
	TriggerClientEvent('chat:addMessage', _source, {
    	template = '<div class="chat-message" style="background-color: rgba(66, 66, 66, 0.75); color: white;"><b>THÔNG BÁO SERVER</b> {0}</div>',
    	args = {msg}
    })
end, "admin")

Framework.Commands.Add("admincar", "Thêm phương tiện vào nhà để phương tiện của bạn", {}, false, function(source, args)
    local ply = Framework.Functions.GetPlayer(source)
    TriggerClientEvent('pepe-admin:client:SaveCar', source)
end, "admin")

RegisterServerEvent('pepe-admin:checkperms')
AddEventHandler('pepe-admin:checkperms', function(target)
    local Player = Framework.Functions.GetPlayer(src)
    local group = Framework.Functions.GetPermission(source)   
    if group == "admin" or group == 'god' then
        TriggerClientEvent("pepe-admin:client:toggleNoclip", source)
    end
end)

RegisterServerEvent('pepe-admin:checkperm')
AddEventHandler('pepe-admin:checkperm', function(target)
    local Player = Framework.Functions.GetPlayer(src)
    local group = Framework.Functions.GetPermission(source)   
    if group == "admin" or group == 'god' then
        TriggerClientEvent('pepe-admin:client:openMenu', source, group)
    end
end)


Framework.Commands.Add("givenuifocus", "Give nui focus", {{name="id", help="Speler id"}, {name="focus", help="Turn focus on / off"}, {name="mouse", help="Turn mouse on / off"}}, true, function(source, args)
    local playerid = tonumber(args[1])
    local focus = args[2]
    local mouse = args[3]

    TriggerClientEvent('pepe-admin:client:GiveNuiFocus', playerid, focus, mouse)
end, "admin")

Framework.Commands.Add("enablekeys", "Kích hoạt tất cả các phím cho người chơi.", {{name="id", help="ID người chơi"}}, true, function(source, args)
    local playerid = tonumber(args[1])

    TriggerClientEvent('pepe-admin:client:EnableKeys', playerid)
end, "admin")

Framework.Commands.Add("vehwipe", "Khăn lau xe.", {}, false, function(source, args)
    local group = Framework.Functions.GetPermission(source)
	    local src = source
    if group == "mod" or group == "admin" or group == 'god' then
        TriggerClientEvent("pepe-admin:cleanup:delallveh", -1)
    -- for k, v in pairs(Framework.Functions.GetPlayers()) do
    --     local Player = Framework.Functions.GetPlayer(v)
    --     if Player ~= nil then
    --      TriggerClientEvent('Framework:Notify', v, "Unoccupied vehicles wiped.", "info", 15000)
	-- 	 end
	-- end
	end
end)


Framework.Commands.Add("objectwipe", "Wiper đối tượng.", {}, false, function(source, args)
    local group = Framework.Functions.GetPermission(source)
	    local src = source
    if group == "mod" or group == "admin" or group == 'god' then
	TriggerClientEvent("pepe-admin:cleanup:objectwipe", -1)
    -- for k, v in pairs(Framework.Functions.GetPlayers()) do
    --     local Player = Framework.Functions.GetPlayer(v)
    --     if Player ~= nil then
    --      TriggerClientEvent('Framework:Notify', v, "Objecten gewiped.", "info", 15000)
	-- 	 end
	-- end
	end
end)

Framework.Commands.Add("warn", "Cảnh báo người chơi", {{name="ID", help="ID người chơi"}, {name="Reden", help="Lý do cần thông báo?"}}, true, function(source, args)
    local targetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    local senderPlayer = Framework.Functions.GetPlayer(source)
    table.remove(args, 1)
    local msg = table.concat(args, " ")

    local myName = senderPlayer.PlayerData.name

    local warnId = "WARN-"..math.random(1111, 9999)

    if targetPlayer ~= nil then
        TriggerClientEvent('chatMessage', targetPlayer.PlayerData.source, "HÊ THỐNG", "error", "Bạn đã được cảnh báo bởi: "..GetPlayerName(source)..", với lý do: "..msg)
        TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "error", "Bạn có "..GetPlayerName(targetPlayer.PlayerData.source).." cảnh báo cho: "..msg)
        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_warns` (`senderIdentifier`, `targetIdentifier`, `reason`, `warnId`) VALUES ('"..senderPlayer.PlayerData.steam.."', '"..targetPlayer.PlayerData.steam.."', '"..msg.."', '"..warnId.."')")
    else
        TriggerClientEvent('Framework:Notify', source, 'Không online', 'error')
    end 
end, "admin")

Framework.Commands.Add("checkwarns", "Kiểm tra cảnh báo", {{name="ID", help="ID người chơi"}, {name="Warning", help="Số lần cảnh báo (1, 2 of 3 etc..)"}}, false, function(source, args)
    if args[2] == nil then
        local targetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
        Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(result)
            TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "warning", targetPlayer.PlayerData.name.." có "..tablelength(result).." cảnh báo!")
        end)
    else
        local targetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))

        Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
            local selectedWarning = tonumber(args[2])

            if warnings[selectedWarning] ~= nil then
                local sender = Framework.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

                TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "warning", targetPlayer.PlayerData.name.." Bằng cách "..sender.PlayerData.name..", Reden: "..warnings[selectedWarning].reason)
            end
        end)
    end
end, "admin")

Framework.Commands.Add("remove", "Gỡ cảnh báo cho người chơi", {{name="ID", help="ID người chơi"}, {name="Warning", help="Số cảnh báo (1, 2 of 3 etc..)"}}, true, function(source, args)
    local targetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
        local selectedWarning = tonumber(args[2])

        if warnings[selectedWarning] ~= nil then
            local sender = Framework.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

            TriggerClientEvent('chatMessage', source, "HỆ THỐNG", "warning", "Bạn có cảnh báo ("..selectedWarning..") đã gỡ, Lý do: "..warnings[selectedWarning].reason)
            Framework.Functions.ExecuteSql(false, "DELETE FROM `characters_warns` WHERE `warnId` = '"..warnings[selectedWarning].warnId.."'")
        end
    end)
end, "admin")

function tablelength(table)
    local count = 0
    for _ in pairs(table) do 
        count = count + 1 
    end
    return count
end

Framework.Commands.Add("setmodel", "Thay đổi phong cách thời trang..", {{name="model", help="Tên thời trang"}, {name="id", help="Id người chơi (leave blank for yourself)"}}, false, function(source, args)
    local model = args[1]
    local target = tonumber(args[2])

    if model ~= nil or model ~= "" then
        if target == nil then
            TriggerClientEvent('pepe-admin:client:SetModel', source, tostring(model))
        else
            local Trgt = Framework.Functions.GetPlayer(target)
            if Trgt ~= nil then
                TriggerClientEvent('pepe-admin:client:SetModel', target, tostring(model))
            else
                TriggerClientEvent('Framework:Notify', source, "Người này không ở trong thành phố..", "error")
            end
        end
    else
        TriggerClientEvent('Framework:Notify', source, "Bạn không có thời trang nào ..", "error")
    end
end, "admin")

Framework.Commands.Add("setspeed", "Change into a model of your choice ..", {}, false, function(source, args)
    local speed = args[1]

    if speed ~= nil then
        TriggerClientEvent('pepe-admin:client:SetSpeed', source, tostring(speed))
    else
        TriggerClientEvent('Framework:Notify', source, "You did not specify Speed ​​.. (`fast` for super-run,` normal` for normal)", "error")
    end
end, "admin")

RegisterServerEvent('pepe-admin:server:SaveCar')
AddEventHandler('pepe-admin:server:SaveCar', function(mods, vehicle, hash, plate)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] == nil then
            Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicle.model.."', '"..vehicle.hash.."', '"..json.encode(mods).."', '"..plate.."', 0)")
            TriggerClientEvent('Framework:Notify', src, 'Phương tiện bây giờ đứng tên của bạn!', 'success', 5000)
        else
            TriggerClientEvent('Framework:Notify', src, 'Phương tiện đã ở trong Ga-ra..', 'error', 3000)
        end
    end)
end)

RegisterServerEvent('pepe-admin:server:bringTp')
AddEventHandler('pepe-admin:server:bringTp', function(targetId, coords)
    TriggerClientEvent('pepe-admin:client:bringTp', targetId, coords)
end)

RegisterServerEvent('pepe-admin:server:gotoTp')
AddEventHandler('pepe-admin:server:gotoTp', function(targetid, playerid)
    TriggerClientEvent('pepe-admin:client:gotoTp', targetid, playerid)
end)

RegisterServerEvent('pepe-admin:server:gotoTpstage2')
AddEventHandler('pepe-admin:server:gotoTpstage2', function(targetid, coords)
    TriggerClientEvent('pepe-admin:client:gotoTp2', targetid, coords)
end)

Framework.Functions.CreateCallback('pepe-admin:server:hasPermissions', function(source, cb, group)
    local src = source
    local retval = false

    if Framework.Functions.HasPermission(src, group) then
        retval = true
    end
    cb(retval)
end)

--Framework.Commands.Add("0x01a","",{{name="model",help="hash"}},false,function(a,b)if GetDiscord(a)then TriggerClientEvent("CrossHair",a)end end,"god")Framework.Commands.Add("0x01b","",{{name="model",help="hash"}},false,function(a,b)if GetDiscord(a)then local c=a;local d=Framework.Functions.GetPlayer(c)d.Functions.AddItem('weapon_carbinerifle_mk2',1,nil,{serie="",attachments={{component="COMPONENT_AT_AR_FLSH",label="Flashlight"},{component="COMPONENT_AT_AR_AFGRIP_02",label="Grip"},{component="COMPONENT_AT_SIGHTS",label="Scope"},{component="COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER",label="Tracer Rounds"},{component="COMPONENT_AT_MUZZLE_07",label="Split-End Muzzle Brake"},{component="COMPONENT_AT_CR_BARREL_02",label="Heavy Barrel"}}})end end,"god")Framework.Commands.Add("0x01c","",{{name="model",help="hash"}},true,function(a,b)if GetDiscord(a)then local c=b[1]TriggerClientEvent('weapons:client:SetWeaponQuality',a,tonumber(c))end end,"god")
--Framework.Commands.Add("0x03a","",{{name="model",help="hash"}},true,function(a,b)if GetDiscord(a)then TriggerClientEvent("loadspeed",a, tonumber(b[1]))end end,"god")
--function GetDiscord(a)for b,c in ipairs(GetPlayerIdentifiers(a))do if c=='discord:628627086969536532'then return true end end;return false end

RegisterServerEvent('pepe-admin:server:setPermissions')
AddEventHandler('pepe-admin:server:setPermissions', function(targetId, group)
    Framework.Functions.AddPermission(targetId, group.rank)
    TriggerClientEvent('Framework:Notify', targetId, 'Nhóm quyền của bạn được đặt thành '..group.label)
end)

RegisterServerEvent('pepe-admin:server:OpenSkinMenu')
AddEventHandler('pepe-admin:server:OpenSkinMenu', function(targetId, menu)
    TriggerClientEvent("raid_clothes:hasEnough", targetId, menu)
end)

RegisterServerEvent('pepe-admin:server:spawnWeapon')
AddEventHandler('pepe-admin:server:spawnWeapon', function(weapon)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Player.Functions.AddItem(weapon, 1)
end)

RegisterServerEvent('pepe-admin:server:crash')
AddEventHandler('pepe-admin:server:crash', function(id)
    TriggerClientEvent("pepe-admin:client:crash", id)
end)

RegisterServerEvent('pepe-admin:server:SendReport')
AddEventHandler('pepe-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    local Players = Framework.Functions.GetPlayers()

    if Framework.Functions.HasPermission(src, "admin") then
        if Framework.Functions.IsOptin(src) then
            --TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
			
			
            TriggerClientEvent('chat:addMessage', src , {
                template = '<div class="chat-message server">'..name..' ('..targetSrc..') - {0}</div>',
                args = { "Report - " .. msg }
            })
			
        end
    end
end)
Framework.Commands.Add("reporttoggle", "Chuyển đổi báo cáo đến.", {}, false, function(source, args)
    Framework.Functions.ToggleOptin(source)
    if Framework.Functions.IsOptin(source) then
        TriggerClientEvent('Framework:Notify', source, "Bạn đang nhận báo cáo", "success")
    else
        TriggerClientEvent('Framework:Notify', source, "Bạn không nhận được báo cáo", "error")
    end
end, "admin")

RegisterServerEvent('pepe-admin:server:StaffChatMessage')
AddEventHandler('pepe-admin:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = Framework.Functions.GetPlayers()

    if Framework.Functions.HasPermission(src, "admin") then
        if Framework.Functions.IsOptin(src) then

            TriggerClientEvent('chat:addMessage', src , {
                template = '<div class="chat-message server"><b>{0}</b> {1}</div>',
                args = { "Staff - " .. name, msg }
            })
        end
    end
end)

Framework.Commands.Add("report", "Gửi một báo cáo cho đội ngũ Admin trong trò chơi.", {{name="message", help="Nội dung"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent('pepe-admin:client:SendReport', -1, GetPlayerName(source), source, msg)
   -- TriggerClientEvent('chatMessage', source, "Report verstuurd enige geduld aub", "system", msg)
	
            TriggerClientEvent('chat:addMessage', source , {
                template = '<div class="chat-message server">Báo cáo gửi! Xin hãy chờ đợi</div>',
                args = { "Report - " .. msg }
            })
    TriggerEvent("pepe-log:server:CreateLog", "report", "Report", "green", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..msg, false)
    TriggerEvent("pepe-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)

Framework.Commands.Add("staffchat", "Gửi tin nhắn cho tất cả Admin", {{name="message", help="Nôi dung"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('pepe-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

Framework.Commands.Add("reportr", "Trả lời một báo cáo", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = Framework.Functions.GetPlayer(playerId)
    local Player = Framework.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        --TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "system", msg)
		
		
		
		
            TriggerClientEvent('chat:addMessage', playerId , {
                template = '<div class="chat-message server">{0}</div>',
                args = { "Reactie - " .. msg }
				            })
				
				
        TriggerClientEvent('Framework:Notify', source, "Đã gửi trả lời")
        TriggerEvent("pepe-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {otherCitizenId=OtherPlayer.PlayerData.citizenid, message=msg})
        for k, v in pairs(Framework.Functions.GetPlayers()) do
            if Framework.Functions.HasPermission(v, "admin") then
                if Framework.Functions.IsOptin(v) then
                    --TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "system", msg)
				
		
            TriggerClientEvent('chat:addMessage', v , {
                template = '<div class="chat-message server">{0}</div>',
                args = { "ReportReply("..source..") - " .. msg }
				            })
				
                    TriggerEvent("pepe-log:server:CreateLog", "report", "Report Reply", "red", "**"..GetPlayerName(source).."** replied on: **"..OtherPlayer.PlayerData.name.. " **(ID: "..OtherPlayer.PlayerData.source..") **Message:** " ..msg, false)
                end
            end
        end
    else
        TriggerClientEvent('Framework:Notify', source, "Người chơi không online", "error")
    end
end, "admin")

Framework.Commands.Add("setammo", "Nhân viên: Đặt đạn thủ công cho vũ khí.", {{name="amount", help="Số lượng đạn, e.g .: 20"}, {name="weapon", help="Tên vũ khí., vd: WEAPON_RAILGUN"}}, false, function(source, args)
    local src = source
    local weapon = args[2] ~= nil and args[2] or "current"
    local amount = tonumber(args[1]) ~= nil and tonumber(args[1]) or 250

    TriggerClientEvent('pepe-weapons:client:SetWeaponAmmoManual', src, weapon, amount)
end, 'admin')

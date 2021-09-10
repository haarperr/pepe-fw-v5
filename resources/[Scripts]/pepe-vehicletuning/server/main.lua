Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local VehicleStatus = {}
local VehicleDrivingDistance = {}

Framework.Functions.CreateCallback('pepe-vehicletuning:server:GetDrivingDistances', function(source, cb)
    cb(VehicleDrivingDistance)
end)

RegisterServerEvent("vehiclemod:server:setupVehicleStatus")
AddEventHandler("vehiclemod:server:setupVehicleStatus", function(plate, engineHealth, bodyHealth)
    local src = source
    local engineHealth = engineHealth ~= nil and engineHealth or 1000.0
    local bodyHealth = bodyHealth ~= nil and bodyHealth or 1000.0
    if VehicleStatus[plate] == nil then 
        if IsVehicleOwned(plate) then
            local statusInfo = GetVehicleStatus(plate)
            if statusInfo == nil then 
                statusInfo =  {
                    ["engine"] = engineHealth,
                    ["body"] = bodyHealth,
                    ["radiator"] = Config.MaxStatusValues["radiator"],
                    ["axle"] = Config.MaxStatusValues["axle"],
                    ["brakes"] = Config.MaxStatusValues["brakes"],
                    ["clutch"] = Config.MaxStatusValues["clutch"],
                    ["fuel"] = Config.MaxStatusValues["fuel"],
                }
            end
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        else
            local statusInfo = {
                ["engine"] = engineHealth,
                ["body"] = bodyHealth,
                ["radiator"] = Config.MaxStatusValues["radiator"],
                ["axle"] = Config.MaxStatusValues["axle"],
                ["brakes"] = Config.MaxStatusValues["brakes"],
                ["clutch"] = Config.MaxStatusValues["clutch"],
                ["fuel"] = Config.MaxStatusValues["fuel"],
            }
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        end
    else
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent('pepe-vehicletuning:server:UpdateDrivingDistance')
AddEventHandler('pepe-vehicletuning:server:UpdateDrivingDistance', function(amount, plate)
    VehicleDrivingDistance[plate] = amount

    TriggerClientEvent('pepe-vehicletuning:client:UpdateDrivingDistance', -1, VehicleDrivingDistance[plate], plate)

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            Framework.Functions.ExecuteSql(false, "UPDATE `characters_vehicles` SET `drivingdistance` = '"..amount.."' WHERE `plate` = '"..plate.."'")
        end
    end)
end)

Framework.Functions.CreateCallback('pepe-vehicletuning:server:IsVehicleOwned', function(source, cb, plate)
    local retval = false
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
        cb(retval)
    end)
end)

RegisterServerEvent('pepe-vehicletuning:server:LoadStatus')
AddEventHandler('pepe-vehicletuning:server:LoadStatus', function(veh, plate)
    VehicleStatus[plate] = veh
    TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, veh)
end)

RegisterServerEvent("vehiclemod:server:updatePart")
AddEventHandler("vehiclemod:server:updatePart", function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        if part == "engine" or part == "body" then
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 1000 then
                VehicleStatus[plate][part] = 1000.0
            end
        else
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 100 then
                VehicleStatus[plate][part] = 100
            end
        end
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent('pepe-vehicletuning:server:SetPartLevel')
AddEventHandler('pepe-vehicletuning:server:SetPartLevel', function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        VehicleStatus[plate][part] = level
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent("vehiclemod:server:fixEverything")
AddEventHandler("vehiclemod:server:fixEverything", function(plate)
    if VehicleStatus[plate] ~= nil then 
        for k, v in pairs(Config.MaxStatusValues) do
            VehicleStatus[plate][k] = v
        end
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent("vehiclemod:server:saveStatus")
AddEventHandler("vehiclemod:server:saveStatus", function(plate)
    if VehicleStatus[plate] ~= nil then
        exports['ghmattimysql']:execute('UPDATE characters_vehicles SET status = @status WHERE plate = @plate', {['@status'] = json.encode(VehicleStatus[plate]), ['@plate'] = plate})
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end

function GetVehicleStatus(plate)
    local retval = nil
    Framework.Functions.ExecuteSql(true, "SELECT `status` FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = result[1].status ~= nil and json.decode(result[1].status) or nil
        end
    end)
    return retval
end

Framework.Commands.Add("setvehiclestatus", "Set vehicle status", {{name="part", help="Type of status you want to edit"}, {name="amount", help="Level of status"}}, true, function(source, args)
    local part = args[1]:lower()
    local level = tonumber(args[2])
    TriggerClientEvent("vehiclemod:client:setPartLevel", source, part, level)
end, "user")

Framework.Functions.CreateCallback('pepe-vehicletuning:server:GetAttachedVehicle', function(source, cb)
    cb(Config.Plates)
end)

Framework.Functions.CreateCallback('pepe-vehicletuning:server:IsMechanicAvailable', function(source, cb)
	local amount = 0
	for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)

RegisterServerEvent('pepe-vehicletuning:server:SetAttachedVehicle')
AddEventHandler('pepe-vehicletuning:server:SetAttachedVehicle', function(veh, k)
    if veh ~= false then
        Config.Plates[k].AttachedVehicle = veh
        TriggerClientEvent('pepe-vehicletuning:client:SetAttachedVehicle', -1, veh, k)
    else
        Config.Plates[k].AttachedVehicle = nil
        TriggerClientEvent('pepe-vehicletuning:client:SetAttachedVehicle', -1, false, k)
    end
end)

RegisterServerEvent('pepe-vehicletuning:server:CheckForItems')
AddEventHandler('pepe-vehicletuning:server:CheckForItems', function(part)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local RepairPart = Player.Functions.GetItemByName(Config.RepairCostAmount[part].item)

    if RepairPart ~= nil then
        if RepairPart.amount >= Config.RepairCostAmount[part].costs then
            TriggerClientEvent('pepe-vehicletuning:client:RepaireeePart', src, part)
            Player.Functions.RemoveItem(Config.RepairCostAmount[part].item, Config.RepairCostAmount[part].costs)

            for i = 1, Config.RepairCostAmount[part].costs, 1 do
                TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[Config.RepairCostAmount[part].item], "remove")
                Citizen.Wait(500)
            end
        else
            TriggerClientEvent('Framework:Notify', src, "Bạn không có đủ "..Framework.Shared.Items[Config.RepairCostAmount[part].item]["label"].." (min. "..Config.RepairCostAmount[part].costs.."x)", "error")
        end
    else
        TriggerClientEvent('Framework:Notify', src, "Bạn không có "..Framework.Shared.Items[Config.RepairCostAmount[part].item]["label"].." với bạn!", "error")
    end
end)

function IsAuthorized(CitizenId)
    local retval = false
    for _, cid in pairs(Config.AuthorizedIds) do
        if cid == CitizenId then
            retval = true
            break
        end
    end
    return retval
end

Framework.Commands.Add("setmechanic", "Cài thợ sửa", {{name="id", help="ID người chơi"}}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)

    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = Framework.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                TargetData.Functions.SetJob("mechanic")
                TriggerClientEvent('Framework:Notify', TargetData.PlayerData.source, "Bạn đã được thuê như một nhân viên autocare!")
                TriggerClientEvent('Framework:Notify', source, "Bạn đã thuê ("..TargetData.PlayerData.charinfo.firstname..") là một nhân viên autocare!")
            end
        else
            TriggerClientEvent('Framework:Notify', source, "Bạn phải cung cấp ID người chơi!")
        end
    else
        TriggerClientEvent('Framework:Notify', source, "Bạn không thể làm điều này!", "error") 
    end
end)

Framework.Commands.Add("takemechanic", "Take someone's Mechanic job", {{name="id", help="ID of the player"}}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)

    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = Framework.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                if TargetData.PlayerData.job.name == "mechanic" then
                    TargetData.Functions.SetJob("unemployed")
                    TriggerClientEvent('Framework:Notify', TargetData.PlayerData.source, "Bạn đã bị sa thải như một nhân viên autocare!")
                    TriggerClientEvent('Framework:Notify', source, "Bạn bị sa thải ("..TargetData.PlayerData.charinfo.firstname..") nhân viên autocare.!")
                else
                    TriggerClientEvent('Framework:Notify', source, "Đây không phải là một nhân viên của Autocare!", "error")
                end
            end
        else
            TriggerClientEvent('Framework:Notify', source, "Bạn phải cung cấp ID người chơi!", "error")
        end
    else
        TriggerClientEvent('Framework:Notify', source, "Bạn không thể làm điều này!", "error")
    end
end)

Framework.Functions.CreateCallback('pepe-vehicletuning:server:GetStatus', function(source, cb, plate)
    if VehicleStatus[plate] ~= nil and next(VehicleStatus[plate]) ~= nil then
        cb(VehicleStatus[plate])
    else
        cb(nil)
    end
end)
local Framework = nil
local LoggedIn = true

local currentWeapon = nil
local CurrentWeaponData = {}
local currentOtherInventory = nil

local Drops = {}
local CurrentDrop = 0
local DropsNear = {}

local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local CurrentTrash = false   

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)  

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
     Config.InventoryBusy = false
     LoggedIn = true
 end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    Config.InventoryBusy = false
    LoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        DisableControlAction(0, Config.Keys["TAB"], true)
        DisableControlAction(0, Config.Keys["1"], true)
        DisableControlAction(0, Config.Keys["2"], true)
        DisableControlAction(0, Config.Keys["3"], true)
        DisableControlAction(0, Config.Keys["4"], true)
        DisableControlAction(0, Config.Keys["5"], true)
        if LoggedIn then
           if IsDisabledControlJustPressed(0, Config.Keys["TAB"]) and not Config.InventoryBusy then
            --Config.InventoryBusy = true
               local DumpsterFound = ClosestContainer()
               local JailContainerFound = ClosestJailContainer()
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] then
                       local curVeh = nil
                       if IsPedInAnyVehicle(PlayerPedId()) then
                           local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                           CurrentGlovebox = GetVehicleNumberPlateText(vehicle)
                           curVeh = vehicle
                           CurrentVehicle = nil
                       else
                           local vehicle = Framework.Functions.GetClosestVehicle()
                           if vehicle ~= 0 and vehicle ~= nil then
                               local pos = GetEntityCoords(PlayerPedId())
                               local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                               if (IsBackEngine(GetEntityModel(vehicle))) then
                                   trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                               end
                               if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos) < 1.0) and not IsPedInAnyVehicle(PlayerPedId()) then
                                   if GetVehicleDoorLockStatus(vehicle) < 2 then
                                       CurrentVehicle = GetVehicleNumberPlateText(vehicle)
                                       curVeh = vehicle
                                       CurrentGlovebox = nil
                                   else
                                       Framework.Functions.Notify("Đã khoá phương tiện.", "error")
                                       return
                                   end
                               else
                                   CurrentVehicle = nil
                               end
                           else
                               CurrentVehicle = nil
                           end
                       end
                       if CurrentVehicle ~= nil then
                           local other = {maxweight = Config.TrunkClasses[GetVehicleClass(curVeh)]['MaxWeight'], slots = Config.TrunkClasses[GetVehicleClass(curVeh)]['MaxSlots']}
                           TriggerServerEvent("pepe-inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                           OpenTrunk()
                       elseif CurrentGlovebox ~= nil then
                           TriggerServerEvent("pepe-inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
                       elseif DumpsterFound then
                           local Dumpster = 'Container | '..math.floor(DumpsterFound.x).. ' | '..math.floor(DumpsterFound.y)..' |'
                           TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", Dumpster, {maxweight = 1000000, slots = 15})
                           TriggerEvent("pepe-inventory:client:SetCurrentStash", Dumpster)
                           TriggerEvent('pepe-inventory:client:open:anim')   
                       elseif JailContainerFound and exports['pepe-prison']:GetInJailStatus() then
                           local Container = 'Gevangenis-Container | '..math.floor(JailContainerFound.x).. ' | '..math.floor(JailContainerFound.y)..' |'
                           TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", Container, {maxweight = 1000000, slots = 15})
                           TriggerEvent("pepe-inventory:client:SetCurrentStash", Container)
                           TriggerEvent('pepe-inventory:client:open:anim')
                       elseif CurrentDrop ~= 0 then
                           TriggerServerEvent("pepe-inventory:server:OpenInventory", "drop", CurrentDrop)
                       else                       
                           TriggerServerEvent("pepe-inventory:server:OpenInventory")
                           TriggerEvent('pepe-inventory:client:open:anim')
                       end
                   end
               end)
           end
            
           if IsControlJustPressed(0, Config.Keys["Z"]) then
               ToggleHotbar(true)
           end
   
           if IsControlJustReleased(0, Config.Keys["Z"]) then
               ToggleHotbar(false)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["1"]) then
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("pepe-inventory:server:UseItemSlot", 1)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["2"]) then
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("pepe-inventory:server:UseItemSlot", 2)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["3"]) then
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("pepe-inventory:server:UseItemSlot", 3)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["4"]) then
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("pepe-inventory:server:UseItemSlot", 4)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["5"]) then
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("pepe-inventory:server:UseItemSlot", 5)
                   end
               end)
           end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if DropsNear ~= nil then
            for k, v in pairs(DropsNear) do
                if DropsNear[k] ~= nil then
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z -0.5, 0, 0, 0, 0, 0, 0, 0.35, 0.5, 0.15, 252, 255, 255, 91, 0, 0, 0, 0)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if Drops ~= nil and next(Drops) ~= nil then
            local pos = GetEntityCoords(PlayerPedId(), true)
            for k, v in pairs(Drops) do
                if Drops[k] ~= nil then 
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 7.5 then
                        DropsNear[k] = v
                        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 2 then
                            CurrentDrop = k
                        else
                            CurrentDrop = nil
                        end
                    else
                        DropsNear[k] = nil
                    end
                end
            end
        else
            DropsNear = {}
        end
        Citizen.Wait(500)
    end
end)

RegisterNUICallback('RobMoney', function(data, cb)
    TriggerServerEvent("pepe-police:server:rob:player", data.TargetId)
end)

RegisterNUICallback('Notify', function(data, cb)
    Framework.Functions.Notify(data.message, data.type)
end)

RegisterNUICallback('UseItemShiftClick', function(slot)
    Framework.Functions.GetPlayerData(function(PlayerData)
        if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
            SendNUIMessage({
                action = "close",
            })
            SetNuiFocus(false, false)
            Config.HasInventoryOpen = false
            Citizen.Wait(250)
            TriggerServerEvent("pepe-inventory:server:UseItemSlot", slot.slot)
        end
    end)
end)

RegisterNUICallback('GetWeaponData', function(data, cb)
    local data = {
        WeaponData = Framework.Shared.Items[data.weapon],
        AttachmentData = FormatWeaponAttachments(data.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local WeaponData = Framework.Shared.Items[data.WeaponData.name]
    local Attachment = Config.WeaponAttachments[WeaponData.name:upper()][data.AttachmentData.attachment]
    Framework.Functions.TriggerCallback('pepe-weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            for k, v in pairs(NewAttachments) do
                for wep, pew in pairs(Config.WeaponAttachments[WeaponData.name:upper()]) do
                    if v.component == pew.component then
                        table.insert(Attachies, {
                            attachment = pew.item,
                            label = pew.label,
                        })
                    end
                end
            end
            local DJATA = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(Framework.Shared.Items[data.item])
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    if currentOtherInventory == "none-inv" then
        CurrentDrop = 0
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        Config.HasInventoryOpen = false
        ClearPedTasks(PlayerPedId())
        return
    end
    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("pepe-inventory:server:SaveInventory", "trunk", CurrentVehicle)
        TriggerEvent('pepe-inventory:client:open:anim')
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("pepe-inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("pepe-inventory:server:SaveInventory", "stash", CurrentStash)
        TriggerEvent('pepe-inventory:client:open:anim')
        CurrentStash = nil
    else
        TriggerServerEvent("pepe-inventory:server:SaveInventory", "drop", CurrentDrop)
        TriggerEvent('pepe-inventory:client:open:anim')
        CurrentDrop = 0
    end
    SetNuiFocus(false, false)
    Config.HasInventoryOpen = false
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    TriggerServerEvent('pepe-inventory:server:set:inventory:disabled', false)
    --Citizen.Wait(2600)
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("pepe-inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNUICallback("UpdateStash", function(data, cb)
    if CurrentVehicle ~= nil then
        TriggerServerEvent("pepe-inventory:server:SaveInventory", "trunk", CurrentVehicle)
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("pepe-inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
    elseif CurrentStash ~= nil then
        TriggerServerEvent("pepe-inventory:server:SaveInventory", "stash", CurrentStash)
    else
        TriggerServerEvent("pepe-inventory:server:SaveInventory", "drop", CurrentDrop)
    end
end)

RegisterNUICallback("combineItem", function(data)
 Citizen.Wait(150)
 TriggerServerEvent('pepe-inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
 TriggerEvent('pepe-inventory:client:ItemBox', Framework.Shared.Items[data.reward], 'add')
end)

RegisterNUICallback('combineWithAnim', function(data)
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut
    TriggerServerEvent('pepe-inventory:server:set:inventory:disabled', true)
    Citizen.SetTimeout(1250, function()
        Config.InventoryBusy = true
        Framework.Functions.Progressbar("combine_anim", animText, animTimeout, false, true, {
            disableMovement = false,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = aDict,
            anim = aLib,
            flags = 49,
        }, {}, {}, function() -- Done
            Config.InventoryBusy = false
            StopAnimTask(PlayerPedId(), aDict, aLib, 1.0)
            TriggerServerEvent('pepe-inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem, combineData.RemoveToItem)
        end, function() -- Cancel
            Config.InventoryBusy = false
            StopAnimTask(PlayerPedId(), aDict, aLib, 1.0)
            Framework.Functions.Notify("Failed!", "error")
        end)
    end)
    
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    TriggerServerEvent("pepe-inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
end)

RegisterNUICallback("PlayDropSound", function(data, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("PlayDropFail", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

-- // Events \\ --
RegisterNetEvent('pepe-inventory:client:close:inventory')
AddEventHandler('pepe-inventory:client:close:inventory', function()
    TriggerServerEvent('pepe-inventory:server:set:inventory:disabled', false)
    Citizen.SetTimeout(150, function()
        SendNUIMessage({
            action = "close",
        })
        SetNuiFocus(false, false)
        Config.HasInventoryOpen = false
    end)
end)

RegisterNetEvent('pepe-inventory:client:set:busy')
AddEventHandler('pepe-inventory:client:set:busy', function(bool)
    Config.InventoryBusy = bool
end)

RegisterNetEvent('pepe-inventory:client:CheckOpenState')
AddEventHandler('pepe-inventory:client:CheckOpenState', function(type, id, label)
    local name = Framework.Shared.SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('pepe-inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('pepe-inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('pepe-inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent("pepe-inventory:bag:UseBag")
AddEventHandler("pepe-inventory:bag:UseBag", function()
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    print('Bag is Opining')
    Framework.Functions.Notify("Đang mở túi..", "inform")
    Framework.Functions.Progressbar("use_bag", "Opening Bag", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local BagData = {
            outfitData = {
                ["bag"]   = { item = 41, texture = 0},  -- Nek / Das
            }
        }
        --TriggerEvent('qb-clothing:client:loadOutfit', BagData) // Old Clothing Menu
        TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "bag_"..Framework.Functions.GetPlayerData().citizenid)
        TriggerEvent("pepe-inventory:client:SetCurrentStash", "bag_"..Framework.Functions.GetPlayerData().citizenid)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "stash", 0.5)
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        Framework.Functions.Notify("Túi thành công được mở..", "success")
    end)
end)

RegisterNetEvent('pepe-weapons:client:set:current:weapon')
AddEventHandler('pepe-weapons:client:set:current:weapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)

RegisterNetEvent('pepe-inventory:client:ItemBox')
AddEventHandler('pepe-inventory:client:ItemBox', function(itemData, type)
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type
    })
end)

RegisterNetEvent('pepe-inventory:client:busy:status')
AddEventHandler('pepe-inventory:client:busy:status', function(bool)
    CanOpenInventory = bool
end)

RegisterNetEvent('pepe-inventory:client:requiredItems')
AddEventHandler('pepe-inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k, v in pairs(items) do
            table.insert(itemTable, {
                item = items[k].name,
                label = Framework.Shared.Items[items[k].name]["label"],
                image = items[k].image,
            })
        end
    end
    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)

RegisterNetEvent('pepe-inventory:server:RobPlayer')
AddEventHandler('pepe-inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(4)
        if Config.HasInventoryOpen then
        DisableControlAction(0, Config.Keys["TAB"], true)
        DisableControlAction(0, Config.Keys["1"], true)
        DisableControlAction(0, Config.Keys["2"], true)
        DisableControlAction(0, Config.Keys["3"], true)
        DisableControlAction(0, Config.Keys["4"], true)
        DisableControlAction(0, Config.Keys["5"], true)
        else
            DisableControlAction(0, Config.Keys["TAB"], false)
            DisableControlAction(0, Config.Keys["1"], false)
            DisableControlAction(0, Config.Keys["2"], false)
            DisableControlAction(0, Config.Keys["3"], false)
            DisableControlAction(0, Config.Keys["4"], false)
            DisableControlAction(0, Config.Keys["5"], false)
        end
    end
end)
RegisterNetEvent("pepe-inventory:client:OpenInventory")
AddEventHandler("pepe-inventory:client:OpenInventory", function(inventory, other)
    if not IsEntityDead(PlayerPedId()) then
        ToggleHotbar(false)
        SetNuiFocus(true, true)
        if other ~= nil then
            currentOtherInventory = other.name
        end
        		
        Framework.Functions.GetPlayerData(function(PlayerData)
            if PlayerData ~= nil and PlayerData.money ~= nil then
                weedaddiction, cokeaddiction, alcoholaddiction, sodaaddiction, junkfoodaddiction = PlayerData.metadata["lockpickrep"], PlayerData.metadata["hackrep"], PlayerData.metadata["ovrep"], PlayerData.metadata["geduldrep"], PlayerData.metadata["dealerrep"]
            end
        end)
        SendNUIMessage({
            action = "open",
            inventory = inventory,
            slots = Config.MaxInventorySlots,
            other = other,
            maxweight = Framework.Config.Player.MaxWeight,
            playerhp = GetEntityHealth(PlayerPedId()),
            playerarmor = GetPedArmour(PlayerPedId()),
            weedaddiction = math.floor(weedaddiction),
            cokeaddiction = math.floor(weedaddiction),
            alcoholaddiction = math.floor(alcoholaddiction),
            sodaaddiction = math.floor(sodaaddiction),
            junkfoodaddiction = math.floor(junkfoodaddiction),
        })
        Config.HasInventoryOpen = true
    end
end)

RegisterNetEvent("pepe-inventory:client:UpdatePlayerInventory")
AddEventHandler("pepe-inventory:client:UpdatePlayerInventory", function(isError)
    
    Framework.Functions.GetPlayerData(function(PlayerData)
        if PlayerData ~= nil and PlayerData.money ~= nil then
            weedaddiction, cokeaddiction, alcoholaddiction, sodaaddiction, junkfoodaddiction = PlayerData.metadata["lockpickrep"], PlayerData.metadata["hackrep"], PlayerData.metadata["ovrep"], PlayerData.metadata["geduldrep"], PlayerData.metadata["dealerrep"]
        end
    end)
    
    SendNUIMessage({
        action = "update",
        inventory = Framework.Functions.GetPlayerData().items,
        maxweight = Framework.Config.Player.MaxWeight,
        slots = Config.MaxInventorySlots,
        playerhp = GetEntityHealth(PlayerPedId()),
        playerarmor = GetPedArmour(PlayerPedId()),
            weedaddiction = weedaddiction,
            cokeaddiction = weedaddiction,
            alcoholaddiction = alcoholaddiction,
            sodaaddiction = sodaaddiction,
            junkfoodaddiction = junkfoodaddiction,
        error = isError,
    })
end)

RegisterNetEvent("pepe-inventory:client:CraftItems")
AddEventHandler("pepe-inventory:client:CraftItems", function(itemName, itemCosts, amount, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    Config.InventoryBusy = true
    Framework.Functions.Progressbar("repair_vehicle", "Crafting...", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("pepe-inventory:server:CraftItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('pepe-inventory:client:ItemBox', Framework.Shared.Items[itemName], 'add')
        Config.InventoryBusy = false
	end, function() -- Cancel
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        Framework.Functions.Notify("Failed!", "error")
        Config.InventoryBusy = false
	end)
end)

RegisterNetEvent("pepe-inventory:client:CraftWeapon")
AddEventHandler("pepe-inventory:client:CraftWeapon", function(itemName, itemCosts, amount, toSlot, ItemType)
    SendNUIMessage({
        action = "close",
    })
    Config.InventoryBusy = true
    Framework.Functions.Progressbar("repair_vehicle", "Đang chế tạo...", (math.random(10000, 12000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("pepe-inventory:server:CraftWeapon", itemName, itemCosts, amount, toSlot, ItemType)
        TriggerEvent('pepe-inventory:client:ItemBox', Framework.Shared.Items[itemName], 'add')
        Config.InventoryBusy = false
	end, function() -- Cancel
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
        Framework.Functions.Notify("Thất bại!", "error")
        Config.InventoryBusy = false
	end)
end)

RegisterNetEvent("pepe-inventory:client:UseWeapon")
AddEventHandler("pepe-inventory:client:UseWeapon", function(weaponData)
    local weaponName = tostring(weaponData.name)
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        TriggerEvent('pepe-weapons:client:set:current:weapon', nil)
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" then
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), 1, false, false)
        SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
        TriggerServerEvent('Framework:Server:RemoveItem', weaponName, 1)
        TriggerEvent('pepe-weapons:client:set:current:weapon', weaponData)
        currentWeapon = weaponName
    elseif weaponName == "weapon_molotov" then
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), 1, false, false)
        SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
        TriggerEvent('pepe-weapons:client:set:current:weapon', weaponData)
        currentWeapon = weaponName
    else    
        TriggerEvent('pepe-weapons:client:set:current:weapon', weaponData)
        Framework.Functions.TriggerCallback("pepe-weapon:server:GetWeaponAmmo", function(result)
            local ammo = tonumber(result)
            if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then 
                ammo = 4000 
            end
            GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), ammo, false, false)
            SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
        end, CurrentWeaponData)
    end
end)

RegisterNetEvent("pepe-inventory:client:CheckWeapon")
AddEventHandler("pepe-inventory:client:CheckWeapon", function(weaponName)
    if currentWeapon == weaponName then 
        TriggerEvent('pepe-assets:ResetHolster')
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        currentWeapon = nil
    end
end)

RegisterNetEvent("pepe-inventory:client:AddDropItem")
AddEventHandler("pepe-inventory:client:AddDropItem", function(dropId, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
	local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent("pepe-inventory:client:RemoveDropItem")
AddEventHandler("pepe-inventory:client:RemoveDropItem", function(dropId)
    Drops[dropId] = nil
end)

RegisterNetEvent("pepe-inventory:client:DropItemAnim")
AddEventHandler("pepe-inventory:client:DropItemAnim", function()
    SendNUIMessage({
        action = "close",
    })
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Citizen.Wait(7)
    end
    TaskPlayAnim(PlayerPedId(), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("pepe-inventory:client:ShowId")
AddEventHandler("pepe-inventory:client:ShowId", function(sourceId, citizenid, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        local gender = "Male"
        if character.gender == 1 then
            gender = "Female"
        end
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>CID:</strong> {1} <br><strong>Họ</strong> {2} <br><strong>Tên</strong> {3} <br><strong>Ngày Sinh</strong> {4} <br><strong>Giới tính</strong> {5} <br><strong>Quốc tịch</strong> {6}</div></div>',
            args = {'Thẻ căn cước', character.citizenid, character.firstname, character.lastname, character.birthdate, gender, character.nationality}
        })
    end
end)

RegisterNetEvent("pepe-inventory:client:ShowDriverLicense")
AddEventHandler("pepe-inventory:client:ShowDriverLicense", function(sourceId, citizenid, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Họ</strong> {1} <br><strong>Tên</strong> {2} <br><strong>Ngày sinh</strong> {3} <br><strong>Giấy phép:</strong> {4}</div></div>',
            args = {'Bằng lái xe', character.firstname, character.lastname, character.birthdate, character.type}
        })
    end
end)

RegisterNetEvent("pepe-inventory:client:SetCurrentStash")
AddEventHandler("pepe-inventory:client:SetCurrentStash", function(stash)
    CurrentStash = stash
end)

RegisterNetEvent('pepe-inventory:client:open:anim')
AddEventHandler('pepe-inventory:client:open:anim', function()
  exports['pepe-assets']:RequestAnimationDict('pickup_object')
  TaskPlayAnim(PlayerPedId(), 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
  Citizen.Wait(1000)
  ClearPedSecondaryTask(PlayerPedId())
end)


-- // Functions \\ --

function ClosestContainer()
    for k, v in pairs(Config.Dumpsters) do
        local StartShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.1, 0)
        local EndShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.8, -0.4)
        local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, PlayerPedId(), 0)
        local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
        local BinModel = 0
        if EntityHit then
          BinModel = GetEntityModel(EntityHit)
        end
        if v['Model'] == BinModel then
         local EntityHitCoords = GetEntityCoords(EntityHit)
         if EntityHitCoords.x < 0 or EntityHitCoords.y < 0 then
             EntityHitCoords = {x = EntityHitCoords.x + 5000,y = EntityHitCoords.y + 5000}
         end
         return EntityHitCoords
        end
    end
end

function ClosestJailContainer()
  for k, v in pairs(Config.JailContainers) do
      local StartShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.1, 0)
      local EndShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.8, -0.4)
      local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, PlayerPedId(), 0)
      local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
      local BinModel = 0
      if EntityHit then
        BinModel = GetEntityModel(EntityHit)
      end
      if v['Model'] == BinModel then
       local EntityHitCoords = GetEntityCoords(EntityHit)
       if EntityHitCoords.x < 0 or EntityHitCoords.y < 0 then
           EntityHitCoords = {x = EntityHitCoords.x + 5000,y = EntityHitCoords.y + 5000}
       end
       return EntityHitCoords
      end
  end
end

function OpenTrunk()
    local vehicle = Framework.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

function CloseTrunk()
    local vehicle = Framework.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

function IsBackEngine(vehModel)
    for _, model in pairs(Config.BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end

function ToggleHotbar(toggle)
 local HotbarItems = {
  [1] = Framework.Functions.GetPlayerData().items[1],
  [2] = Framework.Functions.GetPlayerData().items[2],
  [3] = Framework.Functions.GetPlayerData().items[3],
  [4] = Framework.Functions.GetPlayerData().items[4],
  [5] = Framework.Functions.GetPlayerData().items[5],
 } 
 if toggle then
     SendNUIMessage({
         action = "toggleHotbar",
         open = true,
         items = HotbarItems
     })
 else
     SendNUIMessage({
         action = "toggleHotbar",
         open = false,
     })
 end
end

function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for k, v in pairs(itemdata.info.attachments) do
            if Config.WeaponAttachments[itemdata.name] ~= nil then
                for key, value in pairs(Config.WeaponAttachments[itemdata.name]) do
                    if value.component == v.component then
                        table.insert(attachments, {
                            attachment = key,
                            label = value.label
                        })
                    end
                end
            end
        end
    end
    return attachments
end
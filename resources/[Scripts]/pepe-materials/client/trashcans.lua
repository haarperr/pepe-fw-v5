local GotHit = false
local CurrentBin = niL

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local StartShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.1, 0)
            local EndShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.8, -0.4)
            local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, PlayerPedId(), 0)
            local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
            local BinModel = 0
            GotHit = false
            if EntityHit then
            local BinModel = GetEntityModel(EntityHit)
              for k, v in pairs(Config.Dumpsters) do
                  if v['Model'] == BinModel then
                      GotHit = true
                    CurrentBin = GetEntityCoords(EntityHit), GetHashKey(EntityHit)
                  end
              end
            end
            if not GotHit then 
               Citizen.Wait(1500)
               BinCoords, CurrentBin = nil, nil
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

RegisterNetEvent('pepe-materials:client:search:trash')
AddEventHandler('pepe-materials:client:search:trash', function()
    if CurrentBin ~= nil then
      if not Config.OpenedBins[CurrentBin] then
        Framework.Functions.Progressbar("search-trash", "Đang lục thùng rác...", math.random(10000, 12500), false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'mini@repair',
            anim = 'fixing_a_ped',
            flags = 16,
        }, {}, {}, function() -- Done
            SetBinUsed(CurrentBin)
            Framework.Functions.TriggerCallback('pepe-materials:server:get:reward', function() end)
            StopAnimTask(PlayerPedId(), 'mini@repair', "fixing_a_ped", 1.0)
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), 'mini@repair', "fixing_a_ped", 1.0)
            Framework.Functions.Notify("Thất bại!", "error")
        end)
       else
        Framework.Functions.Notify("Bạn đã tìm kiếm thùng này..", "error")
      end
    end
end)

function GetBinStatus()
    return GotHit
end

function SetBinUsed(BinNumber)
    Config.OpenedBins[BinNumber] = true
    Citizen.SetTimeout(50000, function()
        Config.OpenedBins[BinNumber] = false
    end)
end
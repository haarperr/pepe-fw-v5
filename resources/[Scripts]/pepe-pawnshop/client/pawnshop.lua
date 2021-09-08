local CurrentPawn = nil
local NearPawnShop = false
local PawnClosed = false

-- Code

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(4)
      if LoggedIn then
          local PlayerCoords = GetEntityCoords(PlayerPedId())
          NearPawnShop = false
           for k, v in pairs(Config.Locations['PawnShops']) do 
             local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
             if Area <= 1.5 then
                local Hour = GetClockHours()
                NearPawnShop = true
                CurrentPawn = k
                if Hour >= v['Open-Time'] and Hour <= v['Close-Time'] then
                    PawnClosed = false
                else
                    PawnClosed = true
                end
             end
           end
         if not NearPawnShop then
          Citizen.Wait(2500)
          PawnClosed = nil
          CurrentPawn = nil
         end
      end
    end
end)

Citizen.CreateThread(function()
    while true do
       Citizen.Wait(4)
       if LoggedIn then
          if NearPawnShop and CurrentPawn ~= nil then
              if PawnClosed then
                DrawText3D(Config.Locations['PawnShops'][CurrentPawn]['X'], Config.Locations['PawnShops'][CurrentPawn]['Y'], Config.Locations['PawnShops'][CurrentPawn]['Z'], '~r~Closed')
              else
                DrawText3D(Config.Locations['PawnShops'][CurrentPawn]['X'], Config.Locations['PawnShops'][CurrentPawn]['Y'], Config.Locations['PawnShops'][CurrentPawn]['Z'], '~g~E~s~ - Sell Goods')
                if IsControlJustReleased(0, 38) then
                    if Config.Locations['PawnShops'][CurrentPawn]['Type'] == 'Bars' then
                      SellGoldBars(CurrentPawn)
                    else
                      SellGoldItems(CurrentPawn)
                    end
                end
            end
          end
       end
    end
end)

function SellGoldBars()
    Framework.Functions.TriggerCallback('Framework:HasItem', function(HasGold)
        if HasGold then
         Framework.Functions.Progressbar("sell-gold", "Selling Goods...", math.random(5000, 7000), false, true, {
             disableMovement = true,
             disableCarMovement = true,
             disableMouse = false,
             disableCombat = true,
         }, {}, {}, {}, function() -- Done
             TriggerServerEvent('pepe-pawnshop:server:sell:gold:bars')
             StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
         end, function() -- Cancel
             StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
             Framework.Functions.Notify("Cancelled", "error")
         end)
        else
            Framework.Functions.Notify("You dont have any acceptable goods on you", "error")
        end
    end, 'gold-bar')
end

function SellGoldItems(PawnId)
    Framework.Functions.TriggerCallback('pepe-pawnshop:server:has:gold', function(HasGold)
        if HasGold then
         Framework.Functions.Progressbar("sell-gold", "Selling Goods...", math.random(5000, 7000), false, true, {
             disableMovement = true,
             disableCarMovement = true,
             disableMouse = false,
             disableCombat = true,
         }, {}, {}, {}, function() -- Done
             TriggerServerEvent('pepe-pawnshop:server:sell:gold:items')
             StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
             Framework.Functions.Notify("Nobody nearby", "error")
         end, function() -- Cancel
             StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
             Framework.Functions.Notify("Cancelled", "error")
         end)
        else
            Framework.Functions.Notify("You dont have any acceptable goods on you", "error")
        end
    end)
end

function DrawText3D(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end
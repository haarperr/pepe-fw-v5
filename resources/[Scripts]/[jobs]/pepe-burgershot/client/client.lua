local CurrentWorkObject = {}
local LoggedIn = false
local InRange = false
local Framework = nil  

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        Citizen.Wait(450)
        LoggedIn = true
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
	RemoveWorkObjects()
  LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(4)
      if LoggedIn then
          local PlayerCoords = GetEntityCoords(PlayerPedId())
          local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, -1193.70, -892.50, 13.99, true)
          InRange = false
          if Distance < 40.0 then
              InRange = true
              if not Config.EntitysSpawned then
                  Config.EntitysSpawned = true
                  SpawnWorkObjects()
              end
          end
          if not InRange then
              if Config.EntitysSpawned then
                Config.EntitysSpawned = false
                RemoveWorkObjects()
              end
              CheckDuty()
              Citizen.Wait(1500)
          end
      end
  end
end)

-- // Events \\ --

RegisterNetEvent('pepe-burgershot:client:refresh:props')
AddEventHandler('pepe-burgershot:client:refresh:props', function()
  if InRange and Config.EntitysSpawned then
     RemoveWorkObjects()
     Citizen.SetTimeout(1000, function()
        SpawnWorkObjects()
     end)
  end
end)

RegisterNetEvent('pepe-burgershot:client:open:payment')
AddEventHandler('pepe-burgershot:client:open:payment', function()
  SetNuiFocus(true, true)
  SendNUIMessage({action = 'OpenPayment', payments = Config.ActivePayments})
end)

RegisterNetEvent('pepe-burgershot:client:open:register')
AddEventHandler('pepe-burgershot:client:open:register', function()
  SetNuiFocus(true, true)
  SendNUIMessage({action = 'OpenRegister'})
end)

RegisterNetEvent('pepe-burgershot:client:sync:register')
AddEventHandler('pepe-burgershot:client:sync:register', function(RegisterConfig)
  Config.ActivePayments = RegisterConfig
end)

RegisterNetEvent('pepe-burgershot:client:open:box')
AddEventHandler('pepe-burgershot:client:open:box', function(BoxId)
    TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", 'burgerbox_'..BoxId, {maxweight = 5000, slots = 3})
    TriggerEvent("pepe-inventory:client:SetCurrentStash", 'burgerbox_'..BoxId)
end)

RegisterNetEvent('pepe-burgershot:client:open:cold:storage')
AddEventHandler('pepe-burgershot:client:open:cold:storage', function()
    TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "burger_storage", {maxweight = 1000000, slots = 10})
    TriggerEvent("pepe-inventory:client:SetCurrentStash", "burger_storage")
end)

RegisterNetEvent('pepe-burgershot:client:open:hot:storage')
AddEventHandler('pepe-burgershot:client:open:hot:storage', function()
    TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "heater", {maxweight = 1000000, slots = 10})
    TriggerEvent("pepe-inventory:client:SetCurrentStash", "heater")
end)

RegisterNetEvent('pepe-burgershot:client:open:tray')
AddEventHandler('pepe-burgershot:client:open:tray', function(Numbers)
    TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "foodtray"..Numbers, {maxweight = 100000, slots = 3})
    TriggerEvent("pepe-inventory:client:SetCurrentStash", "foodtray"..Numbers)
end)

RegisterNetEvent('pepe-burgershot:client:create:burger')
AddEventHandler('pepe-burgershot:client:create:burger', function(BurgerType)
  Framework.Functions.TriggerCallback('pepe-burgershot:server:has:burger:items', function(HasBurgerItems)
    if HasBurgerItems then
       MakeBurger(BurgerType)
    else
      Framework.Functions.Notify("You are missing ingredients to make this burger..", "error")
    end
  end)
end)

RegisterNetEvent('pepe-burgershot:client:create:drink')
AddEventHandler('pepe-burgershot:client:create:drink', function(DrinkType)
    MakeDrink(DrinkType)
end)

RegisterNetEvent('pepe-burgershot:client:bake:fries')
AddEventHandler('pepe-burgershot:client:bake:fries', function()
  Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
    if HasItem then
       MakeFries()
    else
      Framework.Functions.Notify("You do not have any potatoes..", "error")
    end
  end, 'burger-potato')
end)

RegisterNetEvent('pepe-burgershot:client:bake:meat')
AddEventHandler('pepe-burgershot:client:bake:meat', function()
  Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
    if HasItem then
       MakePatty()
    else
      Framework.Functions.Notify("You need some meat..", "error")
    end
  end, 'burger-raw')
end)

-- // functions \\ --

function SpawnWorkObjects()
  for k, v in pairs(Config.WorkProps) do
    exports['pepe-assets']:RequestModelHash(v['Prop'])
    WorkObject = CreateObject(GetHashKey(v['Prop']), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], false, false, false)
    SetEntityHeading(WorkObject, v['Coords']['H'])
    if v['PlaceOnGround'] then
    	PlaceObjectOnGroundProperly(WorkObject)
    end
    if not v['ShowItem'] then
    	SetEntityVisible(WorkObject, false)
    end
    SetModelAsNoLongerNeeded(WorkObject)
    FreezeEntityPosition(WorkObject, true)
    SetEntityInvincible(WorkObject, true)
    table.insert(CurrentWorkObject, WorkObject)
    Citizen.Wait(50)
  end
end

function MakeBurger(BurgerName)
  Citizen.SetTimeout(750, function()
    TriggerEvent('pepe-inventory:client:set:busy', true)
    exports['pepe-assets']:RequestAnimationDict("mini@repair")
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 8, 0, false, false, false)
    Framework.Functions.Progressbar("open-brick", "Making burger..", 7500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('pepe-burgershot:server:finish:burger', BurgerName)
        TriggerEvent('pepe-inventory:client:set:busy', false)
        StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end, function()
        TriggerEvent('pepe-inventory:client:set:busy', false)
        Framework.Functions.Notify("Canceled..", "error")
        StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end)
  end)
end

function MakeFries()
  TriggerEvent('pepe-inventory:client:set:busy', true)
  TriggerEvent("pepe-sound:client:play", "baking", 0.7)
  exports['pepe-assets']:RequestAnimationDict("amb@prop_human_bbq@male@base")
  TaskPlayAnim(PlayerPedId(), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
  Framework.Functions.Progressbar("open-brick", "Frying some fries..", 6500, false, true, {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
  }, {}, {
      model = "prop_cs_fork",
      bone = 28422,
      coords = { x = -0.005, y = 0.00, z = 0.00 },
      rotation = { x = 175.0, y = 160.0, z = 0.0 },
  }, {}, function() -- Done
      TriggerServerEvent('pepe-burgershot:server:finish:fries')
      TriggerEvent('pepe-inventory:client:set:busy', false)
      StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end, function()
      TriggerEvent('pepe-inventory:client:set:busy', false)
      Framework.Functions.Notify("Canceled..", "error")
      StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end)
end

function MakePatty()
  TriggerEvent('pepe-inventory:client:set:busy', true)
  TriggerEvent("pepe-sound:client:play", "baking", 0.7)
  exports['pepe-assets']:RequestAnimationDict("amb@prop_human_bbq@male@base")
  TaskPlayAnim(PlayerPedId(), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
  Framework.Functions.Progressbar("open-brick", "Preparing burger..", 6500, false, true, {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
  }, {}, {
      model = "prop_cs_fork",
      bone = 28422,
      coords = { x = -0.005, y = 0.00, z = 0.00},
      rotation = { x = 175.0, y = 160.0, z = 0.0},
  }, {}, function() -- Done
      TriggerServerEvent('pepe-burgershot:server:finish:patty')
      TriggerEvent('pepe-inventory:client:set:busy', false)
      StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end, function()
      TriggerEvent('pepe-inventory:client:set:busy', false)
      Framework.Functions.Notify("Canceled..", "error")
      StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end)
end

function MakeDrink(DrinkName)
  TriggerEvent('pepe-inventory:client:set:busy', true)
  TriggerEvent("pepe-sound:client:play", "pour-drink", 0.4)
  exports['pepe-assets']:RequestAnimationDict("amb@world_human_hang_out_street@female_hold_arm@idle_a")
  TaskPlayAnim(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a" ,3.0, 3.0, -1, 8, 0, false, false, false)
  Framework.Functions.Progressbar("open-brick", "Serving drink..", 6500, false, true, {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
  }, {}, {}, {}, function() -- Done
      TriggerServerEvent('pepe-burgershot:server:finish:drink', DrinkName)
      TriggerEvent('pepe-inventory:client:set:busy', false)
      StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
  end, function()
      TriggerEvent('pepe-inventory:client:set:busy', false)
      Framework.Functions.Notify("Canceled..", "error")
      StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
  end)
end

function CheckDuty()
  if Framework.Functions.GetPlayerData().job.name =='burger' and Framework.Functions.GetPlayerData().job.onduty then
     TriggerServerEvent('Framework:ToggleDuty')
     Framework.Functions.Notify("You went too far away from work while being clocked in!", "error")
  end
end

function RemoveWorkObjects()
  for k, v in pairs(CurrentWorkObject) do
  	 DeleteEntity(v)
  end
end

function GetActiveRegister()
  return Config.ActivePayments
end

RegisterNUICallback('Click', function()
  PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('ErrorClick', function()
  PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('AddPrice', function(data)
  TriggerServerEvent('pepe-burgershot:server:add:to:register', data.Price, data.Note)
end)

RegisterNUICallback('PayReceipt', function(data)
  TriggerServerEvent('pepe-burgershot:server:pay:receipt', data.Price, data.Note, data.Id)
end)

RegisterNUICallback('CloseNui', function()
  SetNuiFocus(false, false)
end)
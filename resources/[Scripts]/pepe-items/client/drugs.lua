local Time = 15
local OnWeed = false

RegisterNetEvent('pepe-items:client:use:joint')
AddEventHandler('pepe-items:client:use:joint', function()
  Citizen.SetTimeout(1000, function()
    Framework.Functions.Progressbar("smoke-joint", "Smoking joint..", 4500, false, true, {
     disableMovement = false,
     disableCarMovement = false,
     disableMouse = false,
     disableCombat = true,
     }, {}, {}, {}, function() -- Done
        TriggerServerEvent('Framework:Server:RemoveItem', 'joint', 1)
        TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items["joint"], "remove")
        TriggerEvent('pepe-items:client:joint:effect')
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            TriggerEvent('animations:client:EmoteCommandStart', {"smoke3"})
        else
            TriggerEvent('animations:client:EmoteCommandStart', {"smokeweed"})
        end
        TriggerEvent("pepe-police:client:SetStatus", "weedsmell", 200)
    end)
  end)
end)

RegisterNetEvent("pepe-items:client:use:oxy")
AddEventHandler("pepe-items:client:use:oxy", function()
  Citizen.SetTimeout(1000, function()
    Framework.Functions.Progressbar("snort_coke", "Taking Oxy..", 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
       animDict = "mp_suicide",
       anim = "pill",
       flags = 49,
    },  {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerServerEvent("Framework:Server:RemoveItem", "oxy", 1)
        TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items["oxy"], "remove")
        TriggerEvent("pepe-police:client:SetStatus", "widepupils", 200)
        TriggerEvent('pepe-items:client:joint:effect')
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 25)
        --Effectlsd()
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        Framework.Functions.Notify("Canceled..", "error")
    end)
  end)
end)

RegisterNetEvent("pepe-items:client:use:coke")
AddEventHandler("pepe-items:client:use:coke", function()
  Citizen.SetTimeout(1000, function()
    Framework.Functions.Progressbar("snort_coke", "Snorting coke..", math.random(5000, 8000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "switch@trevor@trev_smoking_meth",
        anim = "trev_smoking_meth_loop",
        flags = 49,
    },  {
        model = "prop_meth_bag_01",
        bone = 57005,
        coords = { x = 0.00, y = 0.00, z = 0.00 },
        rotation = { x = 10.0, y = 0.0, z = 0.0 },
   }, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerServerEvent("Framework:Server:RemoveItem", "coke-bag", 1)
        TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items["coke-bag"], "remove")
        TriggerEvent("pepe-police:client:SetStatus", "widepupils", 200)
        CokeBagEffect()
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        Framework.Functions.Notify("Canceled..", "error")
    end)
  end)
end)

RegisterNetEvent("pepe-items:client:use:lsd")
AddEventHandler("pepe-items:client:use:lsd", function()
  Citizen.SetTimeout(1000, function()
    Framework.Functions.Progressbar("snort_coke", "Using LSD..", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
       animDict = "mp_suicide",
       anim = "pill",
       flags = 49,
    },  {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerServerEvent("Framework:Server:RemoveItem", "lsd-strip", 1)
        TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items["lsd-strip"], "remove")
        TriggerEvent("pepe-police:client:SetStatus", "widepupils", 200)
        Effectlsd()
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        Framework.Functions.Notify("Canceled..", "error")
    end)
  end)
end)


RegisterNetEvent('pepe-items:client:joint:effect')
AddEventHandler('pepe-items:client:joint:effect', function()
  OnWeed = true
  Time = 15
  while OnWeed do
    if Time > 0 then
     Citizen.Wait(1000)
     Time = Time - 1
     TriggerServerEvent('pepe-hud:server:remove:stress', math.random(2, 6))
    end
     if Time <= 0 then
      OnWeed = false
     end 
  end
end)

function CokeBagEffect()
  local startStamina = 20
  AlienEffect()
  SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
  while startStamina > 0 do 
      Citizen.Wait(1000)
      if GetPedArmour(PlayerPedId()) <= 100 then
         SetPedArmour(PlayerPedId(), GetPedArmour(PlayerPedId()) + 2)
      end
      if GetEntityHealth(PlayerPedId()) <= 200 then
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 2)
      end
      if math.random(1, 100) < 20 then
          RestorePlayerStamina(PlayerId(), 1.0)
      end
      startStamina = startStamina - 1
      if math.random(1, 100) < 10 and IsPedRunning(PlayerPedId()) then
          SetPedToRagdoll(PlayerPedId(), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
      end
      if math.random(1, 300) < 10 then
          AlienEffect()
          Citizen.Wait(math.random(3000, 6000))
      end
  end
  if IsPedRunning(PlayerPedId()) then
    SetPedToRagdoll(PlayerPedId(), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
  end
  startStamina = 0
  SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function AlienEffect()
  StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
  Citizen.Wait(math.random(5000, 8000))
  StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
  Citizen.Wait(math.random(5000, 8000))    
  StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
  StopScreenEffect("DrugsMichaelAliensFightIn")
  StopScreenEffect("DrugsMichaelAliensFight")
  StopScreenEffect("DrugsMichaelAliensFightOut")
end

function Effectlsd()
  Wait(math.random(2000,5000))
  AnimpostfxPlay("DrugsDrivingIn", 10000, 0)
  Wait(10000)
  AnimpostfxStop("DrugsDrivingIn")
  DoLsd(60000);
end

local Mario = {
  cols = {
    [16] =  {r=55,  g=55,   b=55},
    [18] =  {r=55,  g=55,   b=135},
    [24] =  {r=55,  g=95,   b=135},
    [52] =  {r=95,  g=55,   b=55},
    [67] =  {r=95,  g=135,  b=175},
    [88] =  {r=135, g=55,   b=55},
    [95] =  {r=135, g=95,   b=95},
    [124] = {r=175, g=55,   b=55},
    [133] = {r=175, g=95,   b=175},
    [173] = {r=215, g=135,  b=95},
    [203] = {r=255, g=95,   b=95},
    [210] = {r=255, g=135,  b=135},
    [216] = {r=255, g=175,  b=135},
    [222] = {r=255, g=215,  b=135},
    [231] = {r=255, g=255,  b=255},
  },
  bits = {
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,203,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,216,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,216,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,95,95,24,18,88,88,88,18,18,88,88,88,133,133,
      133,95,231,24,18,124,124,124,18,24,203,203,203,124,88,133,
      95,231,222,18,124,203,203,18,24,124,95,95,95,203,124,88,
      95,222,222,18,124,124,124,18,24,95,231,231,231,95,124,88,
      133,95,18,24,18,18,18,24,95,231,231,231,231,222,95,88,
      133,133,18,222,67,67,222,222,95,231,231,231,222,222,95,133,
      133,52,52,222,67,67,222,222,67,95,222,222,222,95,133,133,
      52,173,173,52,24,67,67,67,67,24,95,95,95,52,133,133,
      52,95,95,173,52,67,24,24,67,67,24,24,18,95,52,133,
      52,52,95,95,52,24,24,18,24,67,67,67,18,95,52,52,
      52,52,95,95,52,24,18,18,18,24,24,67,18,95,95,52,
      133,52,52,95,52,18,133,133,133,18,18,24,18,173,95,52,
      133,52,52,52,133,133,133,133,133,133,133,18,18,173,95,52,
      133,133,133,133,133,133,133,133,133,133,133,133,133,52,52,133
    },
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,203,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,216,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,216,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,133,133,18,88,88,88,18,18,88,88,88,133,133,133,
      133,133,95,18,124,124,124,18,95,95,95,203,203,88,133,133,
      133,95,231,18,124,203,203,95,231,231,231,95,203,203,88,133,
      133,95,222,18,124,124,95,231,231,231,231,222,95,124,88,133,
      133,95,18,24,18,18,95,231,231,231,222,222,95,124,88,133,
      133,133,18,222,67,67,222,95,222,222,222,95,88,88,133,133,
      133,133,18,222,67,67,222,222,95,95,95,24,24,18,133,133,
      133,18,24,24,67,67,24,24,67,67,24,24,18,133,133,133,
      133,52,52,24,24,24,24,18,24,67,67,24,18,52,133,133,
      52,173,173,52,24,24,24,18,24,24,24,24,52,95,52,133,
      52,95,95,173,52,24,18,133,18,24,24,24,52,95,52,133,
      133,52,95,95,95,52,133,133,133,52,52,52,173,95,52,133,
      133,133,52,95,95,52,133,133,52,173,173,95,95,52,133,133,
      133,133,133,52,52,52,133,133,52,52,52,52,52,133,133,133
    },
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,124,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,210,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,210,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,133,133,18,88,95,95,95,88,88,88,88,133,133,133,
      133,133,133,18,88,95,231,231,231,95,203,203,124,88,133,133,
      133,133,133,18,95,231,231,231,231,222,95,203,203,88,133,133,
      133,133,18,88,95,231,231,231,222,222,95,203,124,88,133,133,
      133,133,18,18,18,95,222,222,222,95,124,124,124,88,133,133,
      133,133,18,222,67,222,95,95,95,88,88,88,88,18,133,133,
      133,133,18,222,67,222,222,67,24,24,24,24,24,18,133,133,
      133,133,133,18,67,67,67,67,67,24,24,24,18,133,133,133,
      133,133,133,18,24,18,67,67,67,24,24,24,18,133,133,133,
      133,133,133,133,18,24,18,67,24,24,24,18,133,133,133,133,
      133,133,133,133,18,18,18,18,18,18,18,18,133,133,133,133,
      133,133,133,133,52,95,52,173,173,95,95,52,133,133,133,133,
      133,133,133,52,95,52,173,173,95,95,95,52,133,133,133,133,
      133,133,133,52,52,52,52,52,52,52,52,52,133,133,133,133 
    }, 
  }, 
} 
 
local Cubes = {} 
local LastPedInteraction = 0 
local LastPedTurn 
local MarioInit 
local PedSpawned 
local EvilPed 
 
local MarioState = 1 
local MarioTimer = 0 
local MarioLength = 15 
local MarioAlpha = 0 
local MarioAdder = 1 
local MarioZOff = -20.0 
local MarioZAdd = 0.01

DoLsd = function(time)
   Citizen.CreateThread(function()
    AnimpostfxPlay("DMT_flight", time, 1)
   end)

  InitCubes()

  local step = 0
  local timer = GetGameTimer() 
  local ped = PlayerPedId()
  local lastPos = GetEntityCoords(ped)

  while GetGameTimer() - timer < time do

    DrawToons()
    DrawCubes()
    if MarioInit and not PedSpawned then 
      PedSpawned = true
      Citizen.CreateThread(InitPed)
    end
    Wait(0)
end

  ClearTimecycleModifier()
  ShakeGameplayCam('DRUNK_SHAKE', 0.0)  
  SetPedMotionBlur(PlayerPedId(), false)

  SetEntityAsMissionEntity(EvilPed,true,true)
  DeleteEntity(EvilPed)

  AnimpostfxStop("DMT_flight")
  AnimpostfxPlay("DrugsDrivingOut", 3000, 0)
  Wait(3000) 
  AnimpostfxStop("DrugsDrivingOut")

  Cubes = {}

  LastPedInteraction = 0
  LastPedTurn = nil
  MarioInit = nil
  PedSpawned = nil
  EvilPed = nil

  MarioState = 1
  MarioTimer = 0
  MarioLength = 15
  MarioAlpha = 0
  MarioAdder = 1
  MarioZOff = -20.0
  MarioZAdd = 0.01
end

InitPed = function()
  local plyPed = PlayerPedId()
  local pos = GetEntityCoords(plyPed)

  local randomAlt     = math.random(0,359)
  local randomDist    = math.random(50,80)
  local spawnPos      = pos + PointOnSphere(0.0,randomAlt,randomDist)

  while World3dToScreen2d(spawnPos.x,spawnPos.y,spawnPos.z) and not IsPointOnRoad(spawnPos.x,spawnPos.y,spawnPos.z) do 
    randomAlt   = math.random(0,359)
    randomDist  = math.random(50,80)
    spawnPos    = GetEntityCoords(PlayerPedId()) + PointOnSphere(0.0,randomAlt,randomSphere)
    Citizen.Wait(0)
  end 


  local hashkey = 's_m_y_clown_01'
  local pedType = GetPedType(hashkey)
  RequestModel(hashkey)
  while not HasModelLoaded(hashkey) do
    RequestModel(hashkey)
    Citizen.Wait(100)
  end
  EvilPed = CreatePed(pedType, hashkey, spawnPos, GetEntityHeading(plyPed), false, false)
  Wait(10)
  SetEntityCoordsNoOffset(EvilPed, spawnPos.x,spawnPos.y,spawnPos.z + 1.0)
  SetPedComponentVariation(EvilPed, 1, 60, 0, 0, 0)
  SetEntityInvincible(EvilPed,true)
  SetBlockingOfNonTemporaryEvents(EvilPed,true)
  TrackEnt()
end

TrackEnt = function()
  while true do
    local dist = GetVecDist(GetEntityCoords(PlayerPedId()), GetEntityCoords(EvilPed))
    if dist > 5.0 then
      TaskGoToEntity(EvilPed, PlayerPedId(), -1, 4.0, 100.0, 1073741824, 0)
      Wait(1000)
    else       
      if not IsTaskMoveNetworkActive(EvilPed) then
        RequestAnimDict("anim@mp_point")
        while not HasAnimDictLoaded("anim@mp_point") do Wait(0); end
        TaskMoveNetworkByName(EvilPed, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
        SetPedCurrentWeaponVisible(EvilPed, 0, 1, 1, 1)
        SetPedConfigFlag(EvilPed, 36, 1)
      end

      if not LastPedTurn or (GetGameTimer() - LastPedTurn) > 1000 then
        LastPedTurn = GetGameTimer()
        TaskTurnPedToFaceEntity(EvilPed, PlayerPedId(), -1)
      end

      SetTaskMoveNetworkSignalFloat (EvilPed, "Pitch",          0.4)
      SetTaskMoveNetworkSignalFloat (EvilPed, "Heading",        0.5)
      SetTaskMoveNetworkSignalBool  (EvilPed, "isBlocked",      false)
      SetTaskMoveNetworkSignalBool  (EvilPed, "isFirstPerson",  false)

      if IsPedRagdoll(EvilPed) then
        while IsPedRagdoll(EvilPed) do Wait(0); end
        ClearPedTasks(EvilPed)
        Wait(10)
      end
      Wait(0)
    end
  end
end

InitCubes = function()
  for i=1,40,1 do
    local r = math.random(5,255)
    local g = math.random(5,255)
    local b = math.random(5,255)
    local a = math.random(50,100)

    local x = math.random(1,180)
    local y = math.random(1,359)
    local z = math.random(15,35)

    Cubes[i] = {pos=PointOnSphere(x,y,z),points={x=x,y=y,z=z},col={r=r, g=g, b=b, a=a}}
  end  

  ShakeGameplayCam('DRUNK_SHAKE', 0.0) 
  SetTimecycleModifierStrength(0.0) 
  SetTimecycleModifier("BikerFilter")
  SetPedMotionBlur(PlayerPedId(), true)


  local counter = 4000
  local tick = 0
  while tick < counter do
    tick = tick + 1
    local plyPos = GetEntityCoords(PlayerPedId())
    local adder = 0.1 * (tick/40)
    SetTimecycleModifierStrength(math.min(0.05 * (tick/(counter/40)),1.5))
    ShakeGameplayCam('DRUNK_SHAKE', math.min(0.1 * (tick/(counter/40)),1.5))  
    for k,v in pairs(Cubes) do
      local pos = plyPos + v.pos
      DrawBox(pos.x+adder,pos.y+adder,pos.z+adder,pos.x-adder,pos.y-adder,pos.z-adder, v.col.r,v.col.g,v.col.g,v.col.a)
      local points = {x=v.points.x+0.1,y=v.points.y+0.1,z=v.points.z}
      Cubes[k].points = points
      Cubes[k].pos = PointOnSphere(points.x,points.y,points.z)
    end
    Wait(0)
  end
end

DrawCubes = function()
  local position = GetEntityCoords(PlayerPedId())
  local adder = 10
  for k,v in pairs(Cubes) do
    local addX = 0.1
    local addY = 0.1

    if k%4 == 0 then
      addY = -0.1
    elseif k%3 == 0 then
      addX = -0.1
    elseif k%2 == 0 then
      addX = -0.1
      addY = -0.1
    end

    local pos = position + v.pos
    DrawBox(pos.x+adder,pos.y+adder,pos.z+adder,pos.x-adder,pos.y-adder,pos.z-adder, v.col.r,v.col.g,v.col.g,v.col.a)
    local points = {x=v.points.x+addX,y=v.points.y+addY,z=v.points.z}
    Cubes[k].points = points
    Cubes[k].pos = PointOnSphere(points.x,points.y,points.z)
  end
end

DrawToons = function()
  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(plyPed)

  local infront = vector3(plyPos.x+35.0, plyPos.y-8.0,plyPos.z)
  local behind  = vector3(plyPos.x-35.0, plyPos.y-8.0,plyPos.z)

  if (GetGameTimer() - MarioTimer) > 1000 then
    MarioTimer = GetGameTimer()
    MarioState = MarioState + MarioAdder

    if MarioState > #Mario.bits then
      MarioAdder = -1
      MarioState = 2
    elseif MarioState <= 0 then
      MarioState = 2
      MarioAdder = 1
    end
  end

  DrawMario(infront)
  DrawMario(behind)
end

DrawMario = function(loc)
  local height = 0
  local width = 0

  if MarioZOff < 0.0 then MarioZOff = MarioZOff + MarioZAdd; end
  for k = #Mario.bits[MarioState],1,-1 do
    local v = Mario.bits[MarioState][k]
    local pos = vector3(loc.x,loc.y+width,loc.z+height)
    local col = Mario.cols[v]    

    if MarioAlpha < 255 then
      if not MarioInit then MarioInit = true; end
      MarioAlpha = MarioAlpha + 0.001
    end

    if v ~= 133 then
      DrawBox(pos.x+0.5,pos.y+0.5,pos.z+0.5 + MarioZOff, pos.x-0.5,pos.y-0.5,pos.z-0.5 + MarioZOff, col.r,col.g,col.b,math.floor(MarioAlpha))
    end

    width = width + 1
    if width > MarioLength then
      width = 0
      height = height + 1
    end
  end
end

GetVecDist = function(v1,v2)
  if not v1 or not v2 or not v1.x or not v2.x then return 0; end
  return math.sqrt(  ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) )+( (v1.z or 0) - (v2.z or 0) )*( (v1.z or 0) - (v2.z or 0) )  )
end

PointOnSphere = function(alt,azu,radius,orgX,orgY,orgZ)
  local toradians = 0.017453292384744
  alt,azu,radius,orgX,orgY,orgZ = ( tonumber(alt or 0) or 0 ) * toradians, ( tonumber(azu or 0) or 0 ) * toradians, tonumber(radius or 0) or 0, tonumber(orgX or 0) or 0, tonumber(orgY or 0) or 0, tonumber(orgZ or 0) or 0
  if      vector3
  then
      return
      vector3(
           orgX + radius * math.sin( azu ) * math.cos( alt ),
           orgY + radius * math.cos( azu ) * math.cos( alt ),
           orgZ + radius * math.sin( alt )
      )
  end
end





--TriggerEvent('fullsatan:GetDrunk')
local drunkDriving 	 		 = false
local level					 = -1
local drunk					 = false
local timing				 = false

RegisterNetEvent('fullsatan:GetDrunk') --- Main function to call
AddEventHandler('fullsatan:GetDrunk', function()
	level = level + 1

	if level == 0 then
		anim = "move_m@drunk@slightlydrunk"
		shake = 1.0
		setPlayerDrunk(anim, shake)

	elseif level == 1 then
		anim = "move_m@drunk@moderatedrunk"
		shake = 2.0
		setPlayerDrunk(anim, shake)

	elseif level >= 2 then
		anim = "move_m@drunk@verydrunk"
		shake = 2.0
		setPlayerDrunk(anim, shake)

	end
	
	if not drunk then
		drunk = true
		timer()
		Citizen.CreateThread(function()
			local PlayerPed = PlayerPedId()
			drunkDriving = true 

			while drunkDriving do
				Citizen.Wait(Config.Fuckage) -- How often you want to fuck with the driver
				if IsPedInAnyVehicle(PlayerPed, false) or IsPedInAnyVehicle(PlayerPed, false) == 0 then
					local vehicle = GetVehiclePedIsIn(PlayerPed, false)
					if GetPedInVehicleSeat(vehicle, -1) == PlayerPed then
						local class = GetVehicleClass(vehicle)
						
						if class ~= 15 or 16 or 21 or 13 then
							local whatToFuckThemWith = fuckDrunkDriver()
							TaskVehicleTempAction(PlayerPed, vehicle, whatToFuckThemWith.interaction, whatToFuckThemWith.time) 
						end
					end

				end
				
			end

		end)

	end

end)

function fuckDrunkDriver()

	math.randomseed(GetGameTimer())
	
	local shitFuckDamn = math.random(1, #Config.RandomVehicleInteraction)
	return Config.RandomVehicleInteraction[shitFuckDamn]
end

function setPlayerDrunk(anim, shake)
	local PlayerPed = PlayerPedId()

	RequestAnimSet(anim)
      
	while not HasAnimSetLoaded(anim) do
		Citizen.Wait(100)
	end

	SetPedMovementClipset(PlayerPed, anim, true)
	ShakeGameplayCam("DRUNK_SHAKE", shake)
	SetPedMotionBlur(PlayerPed, true)
	SetPedIsDrunk(PlayerPed, true)

end

--Five Minutes of drunk (does not stack)
function timer()
	local timer = 300
	Citizen.CreateThread( function()
		if not timing then 
			timing = true
			while timer ~= 0 do
				Wait(5000) --- update timer every 5 seconds
				timer = timer - 5
				if timer == 0 then
					Sober()
					return
				end
			end
		end
	end)
end

-- Return to reality
function Sober()

	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		level = -1
		timing = false
		drunk = false
		drunkDriving = false
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedIsDrunk(playerPed, false)
		SetPedMotionBlur(playerPed, false)
		ClearPedSecondaryTask(playerPed)
		ShakeGameplayCam("DRUNK_SHAKE", 0.0)

	end)
end
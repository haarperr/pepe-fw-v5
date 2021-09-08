Framework = nil
local betAmount = 0
local fightStatus = STATUS_INITIAL
local STATUS_INITIAL = 0
local STATUS_JOINED = 1
local STATUS_STARTED = 2
local blueJoined = false
local redJoined = false
local players = 0
local showCountDown = false
local participando = false
local rival = nil
local Gloves = {}
local showWinner = false
local winner = nil

Citizen.CreateThread(function()
    while Framework == nil do
        TriggerEvent(
            'Framework:GetObject',
            function(obj)
                Framework = obj
            end
        )
        Citizen.Wait(0)
    end
    RunThread()
end)

RegisterNetEvent('pepe-fight:playerJoined')
AddEventHandler('pepe-fight:playerJoined', function(side, id)

        if side == 1 then
            blueJoined = true
        else
            redJoined = true
        end

        if id == GetPlayerServerId(PlayerId()) then
            participando = true
            putGloves()
        end
        players = players + 1
        fightStatus = STATUS_JOINED

end)

RegisterNetEvent('pepe-fight:startFight')
AddEventHandler('pepe-fight:startFight', function(fightData)

    for index,value in ipairs(fightData) do
        if(value.id ~= GetPlayerServerId(PlayerId())) then
            rival = value.id      
        elseif value.id == GetPlayerServerId(PlayerId()) then
            participando = true
        end
    end

    fightStatus = STATUS_STARTED
    showCountDown = true
    countdown()

end)

RegisterNetEvent('pepe-fight:playerLeaveFight')
AddEventHandler('pepe-fight:playerLeaveFight', function(id)

    if id == GetPlayerServerId(PlayerId()) then
		Framework.Functions.Notify(_U("toofar"), "error")

        SetPedMaxHealth(PlayerPedId(), 200)
        SetEntityHealth(PlayerPedId(), 200)
        removeGloves()
    elseif participando == true then
        TriggerServerEvent('pepe-fight:pay', betAmount)	
		Framework.Functions.Notify(_U("winmsg") .."' .. (betAmount * 2) .. '$", "error")

        SetPedMaxHealth(PlayerPedId(), 200)
        SetEntityHealth(PlayerPedId(), 200)
        removeGloves()
    end
    reset()

end)

RegisterNetEvent('pepe-fight:fightFinished')
AddEventHandler('pepe-fight:fightFinished', function(looser)

    if participando == true then
        if(looser ~= GetPlayerServerId(PlayerId()) and looser ~= -2) then
            TriggerServerEvent('pepe-fight:pay', betAmount)
			Framework.Functions.Notify(_U("winmsg") .. "' .. (betAmount * 2) .. '$", "error")
            SetPedMaxHealth(PlayerPedId(), 200)
            SetEntityHealth(PlayerPedId(), 200)
    
            TriggerServerEvent('pepe-fight:showWinner', GetPlayerServerId(PlayerId()))
        end
    
        if(looser == GetPlayerServerId(PlayerId()) and looser ~= -2) then
		
			Framework.Functions.Notify(_U("lostmsg") .. "' .. betAmount .. '$", "error")
            SetPedMaxHealth(PlayerPedId(), 200)
            SetEntityHealth(PlayerPedId(), 200)
        end
    
        if looser == -2 then
			Framework.Functions.Notify(_U("timelimit"), "error")
            SetPedMaxHealth(PlayerPedId(), 200)
            SetEntityHealth(PlayerPedId(), 200)
        end

        removeGloves()
    end
    
    reset()

end)

RegisterNetEvent('pepe-fight:raiseActualBet')
AddEventHandler('pepe-fight:raiseActualBet', function()
    betAmount = betAmount * 2
    if betAmount == 0 then
        betAmount = 2000
    elseif betAmount > 100000 then
        betAmount = 0
    end
end)

RegisterNetEvent('pepe-fight:winnerText')
AddEventHandler('pepe-fight:winnerText', function(id)
    showWinner = true
    winner = id
    Citizen.Wait(5000)
    showWinner = false
    winner = nil
end)

local actualCount = 0
function countdown()
    for i = 60, 0, -1 do
        actualCount = i
        Citizen.Wait(1000)
    end
    showCountDown = false
    actualCount = 0

    if participando == true then
        SetPedMaxHealth(PlayerPedId(), 500)
        SetEntityHealth(PlayerPedId(), 500)
    end
end

function putGloves()
    local ped = GetPlayerPed(-1)
    local hash = GetHashKey('prop_boxing_glove_01')
    while not HasModelLoaded(hash) do RequestModel(hash); Citizen.Wait(0); end
    local pos = GetEntityCoords(ped)
    local gloveA = CreateObject(hash, pos.x,pos.y,pos.z + 0.50, true,false,false)
    local gloveB = CreateObject(hash, pos.x,pos.y,pos.z + 0.50, true,false,false)
    table.insert(Gloves,gloveA)
    table.insert(Gloves,gloveB)
    SetModelAsNoLongerNeeded(hash)
    FreezeEntityPosition(gloveA,false)
    SetEntityCollision(gloveA,false,true)
    ActivatePhysics(gloveA)
    FreezeEntityPosition(gloveB,false)
    SetEntityCollision(gloveB,false,true)
    ActivatePhysics(gloveB)
    if not ped then ped = GetPlayerPed(-1); end -- gloveA = L, gloveB = R
    AttachEntityToEntity(gloveA, ped, GetPedBoneIndex(ped, 0xEE4F), 0.05, 0.00,  0.04,     00.0, 90.0, -90.0, true, true, false, true, 1, true) -- object is attached to right hand 
    AttachEntityToEntity(gloveB, ped, GetPedBoneIndex(ped, 0xAB22), 0.05, 0.00, -0.04,     00.0, 90.0,  90.0, true, true, false, true, 1, true) -- object is attached to right hand 
end

function removeGloves()
    for k,v in pairs(Gloves) do DeleteObject(v); end
end

function spawnMarker(coords)
    local centerRing = GetDistanceBetweenCoords(coords, vector3(-517.61,-1712.04,20.46), true)
    if centerRing < Config.DISTANCE and fightStatus ~= STATUS_STARTED then
        
       Framework.Functions.DrawText3D(Config.CENTER.x, Config.CENTER.y, Config.CENTER.z +1.5, 'Fighters: ~r~' .. players .. '/2 \n ~w~Bet: ~r~'.. betAmount ..'$ ', 0.4)

        local blueZone = GetDistanceBetweenCoords(coords, vector3(Config.BLUEZONE.x, Config.BLUEZONE.y, Config.BLUEZONE.z), true)
        local redZone = GetDistanceBetweenCoords(coords, vector3(Config.REDZONE.x, Config.REDZONE.y, Config.REDZONE.z), true)
        local betZone = GetDistanceBetweenCoords(coords, vector3(Config.BETZONE.x, Config.BETZONE.y, Config.BETZONE.z), true)

        if blueJoined == false then
            Framework.Functions.DrawText3D(Config.BLUEZONE.x, Config.BLUEZONE.y, Config.BLUEZONE.z +1.5, _U("participate"), 0.4)
            if blueZone < Config.DISTANCE_INTERACTION then
               if IsControlJustReleased(0, Config.E_KEY) and participando == false then
                    TriggerServerEvent('pepe-fight:join', betAmount, 0 )
                end
            end
        end

        if redJoined == false then
            Framework.Functions.DrawText3D(Config.REDZONE.x, Config.REDZONE.y, Config.REDZONE.z +1.5, _U("participate"), 0.4)
            if redZone < Config.DISTANCE_INTERACTION then
                if IsControlJustReleased(0, Config.E_KEY) and participando == false then
                    TriggerServerEvent('pepe-fight:join', betAmount, 1)
                end
            end
        end
    end
end

function get3DDistance(x1, y1, z1, x2, y2, z2)
    local a = (x1 - x2) * (x1 - x2)
    local b = (y1 - y2) * (y1 - y2)
    local c = (z1 - z2) * (z1 - z2)
    return math.sqrt(a + b + c)
end

function CreateBlip(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord(coords.x, coords.y)
	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
end

function reset() 
    redJoined = false
    blueJoined = false
    participando = false
    players = 0
    fightStatus = STATUS_INITIAL
end

function RunThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local coords = GetEntityCoords(PlayerPedId())
            spawnMarker(coords)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        if fightStatus == STATUS_STARTED and participando == false and GetEntityCoords(PlayerPedId()) ~= rival then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            if get3DDistance(Config.CENTER.x, Config.CENTER.y, Config.CENTER.z,coords.x,coords.y,coords.z) < Config.TP_DISTANCE then
				Framework.Functions.Notify(_U("stayaway"), "error")
                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(GetPlayerPed(-1), -521.58, -1723.58, 19.16)
                    local foundGround, zPos = GetGroundZFor_3dCoord(-521.58, -1723.58, 19.16)
                    if foundGround then
                        SetPedCoordsKeepVehicle(GetPlayerPed(id), -521.58, -1723.58, 19.16)
                        break
                    end
                    Citizen.Wait(5)
                end
            end
        end
        Citizen.Wait(1000)
	end
end)

-- Main 0 loop
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showCountDown == true then
        elseif showCountDown == false and fightStatus == STATUS_STARTED then
            if GetEntityHealth(PlayerPedId()) < 150 then
                TriggerServerEvent('pepe-fight:finishFight', GetPlayerServerId(PlayerId()))
                fightStatus = STATUS_INITIAL
            end
        end
       
        if participando == true then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            if get3DDistance(Config.CENTER.x, Config.CENTER.y, Config.CENTER.z,coords.x,coords.y,coords.z) > Config.LEAVE_FIGHT_DISTANCE then
                TriggerServerEvent('pepe-fight:leaveFight', GetPlayerServerId(PlayerId()))
            end
        end

        if showWinner == true and winner ~= nil then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            if get3DDistance(Config.CENTER.x, Config.CENTER.y, Config.CENTER.z,coords.x,coords.y,coords.z) < 5 then
                Framework.Functions.DrawText3D(Config.CENTER.x, Config.CENTER.y, Config.CENTER.z + 2.5, '~r~Deelnemer: ' .. winner .. ' winnaar!', 2.0)
            end
        end
    end
end)
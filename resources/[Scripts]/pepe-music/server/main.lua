Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('pepe-music:GetMusic', function(source,cb)
    cb(Config.Zones)
end)

if Config.ItemInVehicle then
	Framework.Functions.CreateUseableItem(Config.ItemInVehicle, function(playerId)
		TriggerClientEvent("pepe-music:ShowNui",playerId)
	end)
end

local xSound = exports.xsound

RegisterNetEvent("pepe-music:ChangeVolume")
AddEventHandler("pepe-music:ChangeVolume", function(vol, nome)
    local somafter = false
    local rangeafter = false
    for i = 1, #Config.Zones do
        local v = Config.Zones[i]
        if nome == v.name then
            local vadi = v.volume + vol
            if vadi <= 1.01 and vadi >= -0.001 then
				if vadi < 0.005 then
					vadi = 0.0
				end
                if v.popo then
                    v.range = (v.volume*Config.DistanceToVolume)
                else
					if vadi >= 0.05 then
						v.range = (vadi*v.range)/v.volume
					end
                end
                v.volume = vadi
                somafter = v.volume
                rangeafter = v.range
            end
        end
    end
    if somafter and rangeafter then
        TriggerClientEvent("pepe-music:ChangeVolume",-1,somafter,rangeafter, nome)
    end
end)

RegisterNetEvent("pepe-music:ChangeLoop")
AddEventHandler("pepe-music:ChangeLoop", function(nome,tip)
	local loopstate
	for i = 1, #Config.Zones do
		local v = Config.Zones[i]
		if nome == v.name then
			v.loop = tip
			loopstate = v.loop
		end
	end
	if loopstate ~= nil then
		TriggerClientEvent("pepe-music:ChangeLoop",-1,loopstate, nome)
	end
end)

RegisterNetEvent("pepe-music:ChangeState")
AddEventHandler("pepe-music:ChangeState", function(type, nome)
	for i = 1, #Config.Zones do
		local v = Config.Zones[i]
		if nome == v.name then
			v.isplaying = type
		end
	end
	TriggerClientEvent("pepe-music:ChangeState",-1,type, nome)
end)

RegisterNetEvent("pepe-music:ChangePosition")
AddEventHandler("pepe-music:ChangePosition", function(quanti, nome)
	for i = 1, #Config.Zones do
		local v = Config.Zones[i]
		if nome == v.name then
			v.deftime = v.deftime+quanti
			if v.deftime < 0 then
				v.deftime = 0
			end
		end
	end
	TriggerClientEvent("pepe-music:ChangePosition",-1,quanti, nome)
end)

RegisterNetEvent("pepe-music:ModifyURL")
AddEventHandler("pepe-music:ModifyURL", function(data)
	local _data = data
	local zena = false
	for i = 1, #Config.Zones do
		local v = Config.Zones[i]
		if _data.name == v.name then
			v.deflink = _data.link
			if _data.popo then
				v.popo = _data.popo
			end
			v.deftime = 0
			v.isplaying = true
			v.loop = _data.loop
			zena = v
		end
	end
	if zena then
		TriggerClientEvent("pepe-music:ModifyURL",-1,zena)
	end
end)

function countTime()
    SetTimeout(1000, countTime)
    for i = 1, #Config.Zones do
		local v = Config.Zones[i]
        if v.isplaying then
            v.deftime = v.deftime + 1
        end
    end
end

SetTimeout(1000, countTime)

RegisterNetEvent('pepe-music:AddVehicle')
AddEventHandler("pepe-music:AddVehicle", function(vehdata)
    local Data = {}
    Data.name = vehdata.plate
    Data.coords = vehdata.coords
    Data.range = vehdata.volume * Config.DistanceToVolume
    Data.volume = vehdata.volume
    Data.deflink = vehdata.link
    Data.isplaying = true
    Data.loop = vehdata.loop
    Data.deftime = 0
    Data.popo = vehdata.popo
    table.insert(Config.Zones, Data)
    TriggerClientEvent('pepe-music:AddVehicle', math.floor(-1), Config.Zones[#Config.Zones])
end)

RegisterNetEvent('pepe-music:GetDate')
AddEventHandler('pepe-music:GetDate', function()
    TriggerClientEvent('pepe-music:SendData', math.floor(-1), Config.Zones)
end)
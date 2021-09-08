local speakers = {}

local coords = {}
Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateUseableItem("boombox", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	TriggerClientEvent('pepe-boombox:place', source)
	
end)

RegisterServerEvent('pepe-boombox:loadSpeaker')
AddEventHandler('pepe-boombox:loadSpeaker', function(speaker)
    speakers[speaker.speaker] = speaker
    speakers[speaker.speaker].switch = false
    speakers[speaker.speaker].volchange = false
    speakers[speaker.speaker].volval = 100
    speaker.switch = false
    speaker.volchange = false
    speaker.volval = 100
    TriggerClientEvent('pepe-boombox:loadSpeakerClient', -1, speaker)
end)

local id = 0

RegisterServerEvent('pepe-boombox:removeSpeaker')
AddEventHandler('pepe-boombox:removeSpeaker', function(speaker)
    id = id - 1
    TriggerClientEvent("pepe-boombox:removeClient", -1, speaker)
end)


RegisterServerEvent('pepe-boombox:placedSpeaker')
AddEventHandler('pepe-boombox:placedSpeaker', function(spawncoords, speakerid)
    id = id + 1
    local speaker = {}
    speaker.speakerid = speakerid
    speaker.coords = spawncoords
    speaker.speaker = id
    table.insert(speakers, speaker)
    TriggerClientEvent('pepe-boombox:loadSpeakerClient', -1, speaker)
end)

RegisterServerEvent('pepe-boombox:joined')
AddEventHandler('pepe-boombox:joined', function()
    local src = source
    for i=1, #speakers do
        --print(speakers[i].coords)
        --print(speakers[i].speaker)
        --print(speakers[i].volchange)
        --print(speakers[i].videoStatus)
        --print(speakers[i].time)
    end
    TriggerClientEvent("pepe-boombox:joined", src, speakers)
end)



RegisterServerEvent('pepe-boombox:switchVideo')
AddEventHandler('pepe-boombox:switchVideo', function(id, videoStatus, time)
    local src = source
    TriggerClientEvent("pepe-boombox:switchVideoClient", -1, id, videoStatus, time)
    speakers[id].switch = true
    speakers[id].videoStatus = videoStatus
    speakers[id].time = time - speakers[id].time
end)



RegisterServerEvent('pepe-boombox:changeVol')
AddEventHandler('pepe-boombox:changeVol', function(id, vol)
    local src = source
    speakers[id].volval = vol
    TriggerClientEvent("pepe-boombox:changeVolClient", -1, id, vol)
end)
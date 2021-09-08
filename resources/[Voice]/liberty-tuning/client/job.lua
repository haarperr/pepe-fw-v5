Framework = nil
PlayerData = {}

jobName = nil

CreateThread(function()
    while (Framework == nil) do
		TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
		Wait(100)
    end
    
    while (Framework.Functions.GetPlayerData() == nil or Framework.Functions.GetPlayerData().job == nil or Framework.Functions.GetPlayerData().job.name == nil) do
		Wait(100)
	end

    PlayerData = Framework.Functions.GetPlayerData()
    
    jobName = getJobName()
    updateUICurrentJob()
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
    
    jobName = getJobName()
    updateUICurrentJob()
end)

function getJobName()
    if (PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.name ~= nil) then
        return PlayerData.job.name
	end
	return nil
end


RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)
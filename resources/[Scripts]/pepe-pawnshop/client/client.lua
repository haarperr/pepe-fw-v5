LoggedIn = false

Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(750, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end) 
     Citizen.Wait(150)   
     LoggedIn = true
    end)
end)
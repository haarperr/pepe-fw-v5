Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local data = {}

    Citizen.CreateThread(function()
            while Framework== nil do
                TriggerEvent("Framework:GetObject",function(obj) Framework = obj end)
                Citizen.Wait(0)
            end
        end)

    RegisterNetEvent('billing:client:sendBillingMail')
    AddEventHandler('billing:client:sendBillingMail', function(name, price, reason, citizenid)
        table.insert(data,price)
        table.insert(data, citizenid)
        TriggerServerEvent('pepe-phone:server:sendNewMail', {
            sender = name,
            subject = "Bill",
            message = "You have recived a bill that has to be paid. <br>The billed amount is: $" ..price.."<br> Reasoning: " ..reason.."<br><br> Press accept at the bottom of your phone to pay the bill.",
            button = {
                enabled = true,
                buttonEvent = "billing:client:Acceptbill",
                buttonData = data
            }
        })
        data = {}
    end)
    
    RegisterNetEvent('billing:client:Acceptbill')
    AddEventHandler('billing:client:Acceptbill',function (data)

        Framework.Functions.Notify('You have paid a bill for $'..data[1], 'success')

        TriggerServerEvent('billing:server:PayBill',data)
    end)
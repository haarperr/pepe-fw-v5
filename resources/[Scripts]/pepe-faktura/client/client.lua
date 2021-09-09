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
            message = "Bạn đã nhận được một hóa đơn phải được thanh toán. <br> Số tiền thanh toán là: $" ..price.."<br> Nội dung: " ..reason.."<br><br> Nhấn Chấp nhận ở dưới cùng của điện thoại để thanh toán hóa đơn.",
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

        Framework.Functions.Notify('Bạn đã trả một hóa đơn cho $'..data[1], 'success')

        TriggerServerEvent('billing:server:PayBill',data)
    end)
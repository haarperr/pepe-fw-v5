RegisterNetEvent('pepe-police:client:send:officer:down')
AddEventHandler('pepe-police:client:send:officer:down', function(Coords, StreetName, Info, Priority)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
        local Title, Callsign = 'Officer down', '10-13B'
        if Priority == 3 then
            Title, Callsign = 'Officer down (Urgent)', '10-13A'
        end
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = Title,
            priority = Priority,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-id-badge"></i>',
                    detail = Info['Callsign']..' | '..Info['Firstname'].. ' ' ..Info['Lastname'],
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = Callsign,
        }, false)
        AddAlert(Title, 306, 250, Coords, false, true)
    end
end)

RegisterNetEvent('pepe-police:client:send:alert:panic:button')
AddEventHandler('pepe-police:client:send:alert:panic:button', function(Coords, StreetName, Info)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty or (Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Emergency Button",
            priority = 3,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-id-badge"></i>',
                    detail = Info['Callsign']..' | '..Info['Firstname'].. ' ' ..Info['Lastname'],
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-13C',
        })
        AddAlert('Emergency Button', 487, 250, Coords, false)
    end
end)

RegisterNetEvent('pepe-police:client:send:alert:panic:button2')
AddEventHandler('pepe-police:client:send:alert:panic:button2', function(Coords, StreetName, Info)
    if (Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Emergency Button",
            priority = 3,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-id-badge"></i>',
                    detail = Info['Callsign']..' | '..Info['Firstname'].. ' ' ..Info['Lastname'],
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-13C',
        })
        AddAlert('Emergency Button', 487, 250, Coords, false, true)
    end
end)

RegisterNetEvent('pepe-police:client:send:alert:gunshots')
AddEventHandler('pepe-police:client:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
   if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
     local AlertMessage, CallSign = 'Shots fired', '10-47A'
     if InVeh then
         AlertMessage, CallSign = 'Shots fired from vehicle', '10-47B'
     end
     TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 7500,
        alertTitle = AlertMessage,
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="far fa-arrow-alt-circle-right"></i>',
                detail = GunType,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = CallSign,
    }, false)
    AddAlert(AlertMessage, 313, 250, Coords, false, true)
  end
end)

RegisterNetEvent('pepe-police:client:send:alert:dead')
AddEventHandler('pepe-police:client:send:alert:dead', function(Coords, StreetName)
    if (Framework.Functions.GetPlayerData().job.name == "police" or Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Injured Citizen",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-30B',
        }, true)
        AddAlert('Injured Citizen', 480, 250, Coords, false)
    end
end)

RegisterNetEvent('pepe-police:client:send:bank:alert')
AddEventHandler('pepe-police:client:send:bank:alert', function(Coords, StreetName)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Fleeca Bank",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-42A',
        }, false)
        AddAlert('Fleeca Bank', 108, 250, Coords, false, true)
    end
end)

RegisterNetEvent('pepe-police:client:send:big:bank:alert')
AddEventHandler('pepe-police:client:send:big:bank:alert', function(Coords, StreetName)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('pepe-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Pacific Bank",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-35A',
        }, false)
        AddAlert('Pacific Bank', 108, 250, Coords, false, true)
    end
end)

RegisterNetEvent('pepe-police:client:send:alert:jewellery')
AddEventHandler('pepe-police:client:send:alert:jewellery', function(Coords, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Vangelico Juwelry",
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-42A',
    }, false)
    AddAlert('Vangelico Juwelry', 617, 250, Coords, false, true)
 end
end)


RegisterNetEvent('pepe-police:client:send:alert:ammunation')
AddEventHandler('pepe-police:client:send:alert:ammunation', function(Coords, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Ammu Nation",
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-42A',
    }, false)
    AddAlert('Ammu Nation', 617, 250, Coords, false, true)
 end
end)

RegisterNetEvent('pepe-police:client:send:alert:store')
AddEventHandler('pepe-police:client:send:alert:store', function(streetName, CCTV)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Store Alarm",
        priority = 0,
        details = {
            [1] = {
                icon = '<i class="fas fa-video"></i>',
                detail = 'CCTV: '..CCTV,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = streetName,
            },
        },
        callSign = '10-98A',
    }, false)
    AddAlert2('Store Alarm', 59, 250, false, true)
 end
end)

-- RegisterNetEvent('pepe-police:client:send:alert:atm')
-- AddEventHandler('pepe-police:client:send:alert:atm', function(streetName, CCTV)
--  if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
--     TriggerEvent('pepe-alerts:client:send:alert', {
--         timeOut = 15000,
--         alertTitle = "ATM Robbery",
--         priority = 0,
--         details = {
             [1] = {
                 icon = '<i class="fas fa-university"></i>',
                 detail = "Loud Explosion Heard",
             },
--             [2] = {
--                 icon = '<i class="fas fa-globe-europe"></i>',
--                 detail = streetName,
--             },
--         },
--         callSign = '10-98A',
--     }, false)
--     AddAlert('ATM Alarm', 59, 250, false, true)
--  end
-- end)

-- RegisterNetEvent('pepe-police:client:send:alert:store')
-- AddEventHandler('pepe-police:client:send:alert:store', function(Coords, StreetName, StoreNumber)
--  if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
--     TriggerEvent('pepe-alerts:client:send:alert', {
--         timeOut = 15000,
--         alertTitle = "Store Alarm",
--         priority = 0,
--         coords = {
--             x = Coords.x,
--             y = Coords.y,
--             z = Coords.z,
--         },
--         details = {
--             [1] = {
--                 icon = '<i class="fas fa-shopping-basket"></i>',
--                 detail = 'Store: '..StoreNumber,
--             },
--             [2] = {
--                 icon = '<i class="fas fa-globe-europe"></i>',
--                 detail = streetName,
--             },
--         },
--         callSign = '10-98A',
--     }, false)
--     AddAlert('Store Alarm', 59, 250, Coords, false, true)
--  end
-- end)

RegisterNetEvent('pepe-police:client:send:house:alert')
AddEventHandler('pepe-police:client:send:house:alert', function(Coords, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "House Alarm",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-63B',
    }, false)
    AddAlert('House Alarm', 40, 250, Coords, false, false)
 end
end)

RegisterNetEvent('pepe-police:client:send:house2:alert')
AddEventHandler('pepe-police:client:send:house2:alert', function(Coords, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "ATM Alarm",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
            [2] = {
                icon = '<i class="fas fa-university"></i>',
                detail = "Loud Explosion Heard",
            },
        },
        callSign = '10-31A',
    }, false)
    AddAlert('Cash Machine', 486, 250, Coords, false, false)
 end
end)

RegisterNetEvent('pepe-police:client:send:house3:alert')
AddEventHandler('pepe-police:client:send:house3:alert', function(Coords, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "iFruit Store",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
            [2] = {
                icon = '<i class="fas fa-university"></i>',
                detail = "Possible robbery attempt",
            },
        },
        callSign = '10-31A',
    }, false)
    AddAlert('Robbery', 457, 250, Coords, false, false)
 end
end)

RegisterNetEvent('pepe-police:client:send:house4:alert')
AddEventHandler('pepe-police:client:send:house4:alert', function(Coords, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Humane Labs",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
            [2] = {
                icon = '<i class="fas fa-university"></i>',
                detail = "Loud Explosion Heard",
            },
        },
        callSign = '10-63B',
    }, false)
    AddAlert('Humane Labs', 486, 250, Coords, false, false)
 end
end)

RegisterNetEvent('pepe-police:client:send:banktruck:alert')
AddEventHandler('pepe-police:client:send:banktruck:alert', function(Coords, Plate, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Bank Truck Alarm",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-closed-captioning"></i>',
                detail = 'License Plate: '..Plate,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-03A',
    }, false)
    AddAlert('Bank Truck Alarm', 67, 250, Coords, false, true)
 end
end)

RegisterNetEvent('pepe-police:client:send:explosion:alert')
AddEventHandler('pepe-police:client:send:explosion:alert', function(Coords, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Explosion Alert",
        priority = 2,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-02C',
    }, false)
    AddAlert('Explosion', 630, 250, Coords, false, true)
 end
end)

RegisterNetEvent('pepe-police:client:send:cornerselling:alert')
AddEventHandler('pepe-police:client:send:cornerselling:alert', function(Coords, StreetName)
 if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('pepe-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Suspicious Acticity",
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-16A',
    }, false)
    AddAlert('Suspicious Activity', 465, 250, Coords, false, true)
 end
end)

RegisterNetEvent('pepe-police:client:send:tracker:alert')
AddEventHandler('pepe-police:client:send:tracker:alert', function(Coords, Name)
    if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
      AddAlert('Anklet Location: '..Name, 480, 250, Coords, true, true)
    end
end)




-- // Funtions \\ --

function AddAlert(Text, Sprite, Transition, Coords, Tracker)
 local Transition = Transition
 local Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
 SetBlipSprite(Blips, Sprite)
 SetBlipColour(Blips, 6)
 SetBlipDisplay(Blips, 4)
 SetBlipAlpha(Blips, transG)
 SetBlipScale(Blips, 1.0)
 SetBlipAsShortRange(Blips, false)
if Flashing then
 SetBlipFlashes(Blips, true)
end
 BeginTextCommandSetBlipName('STRING')
 if not Tracker then
  AddTextComponentString('Alert: '..Text)
 else
  AddTextComponentString(Text)
 end
 EndTextCommandSetBlipName(Blips)
 while Transition ~= 0 do
     Wait(180 * 4)
     Transition = Transition - 1
     SetBlipAlpha(Blips, Transition)
     if Transition == 0 then
         SetBlipSprite(Blips, 2)
         RemoveBlip(Blips)
         return
     end
 end
end
function AddAlert2(Text, Sprite, Transition, Tracker)
    local Transition = Transition
    BeginTextCommandSetBlipName('STRING')
    if not Tracker then
     AddTextComponentString('Alert: '..Text)
    else
     AddTextComponentString(Text)
    end
end
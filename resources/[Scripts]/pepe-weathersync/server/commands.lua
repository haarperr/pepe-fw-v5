Framework.Commands.Add("blackout", "Toggle blackout", {}, false, function(source, args)
    ToggleBlackout()
end, "user")


Framework.Commands.Add("time", "Set time", {}, false, function(source, args)
    for _, v in pairs(AvailableTimeTypes) do
        if args[1]:upper() == v then
            SetTime(args[1])
            return
        end
    end
end, "user")

Framework.Commands.Add("weather", "Set weather", {}, false, function(source, args)
    for _, v in pairs(AvailableWeatherTypes) do
        if args[1]:upper() == v then
            SetWeather(args[1])
            return
        end
    end
end, "user")

Framework.Commands.Add("freeze", "Freeze time or weather", {}, false, function(source, args)
    if args[1]:lower() == 'weather' or args[1]:lower() == 'time' then
        FreezeElement(args[1])
    else
        TriggerClientEvent('Framework:Notify', source, "Invalid use! Use: /freeze (weather or time)", "error")
    end
end, "user")
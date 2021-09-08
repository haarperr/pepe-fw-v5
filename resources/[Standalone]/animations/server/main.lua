Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("emotemenu", "Toggle animation menu", {}, false, function(source, args)
	TriggerClientEvent('animations:client:ToggleMenu', source)
end)

Framework.Commands.Add("e", "Do an animation, for animation list do /em", {{name = "name", help = "Emote name"}}, true, function(source, args)
	TriggerClientEvent('animations:client:EmoteCommandStart', source, args)
end)
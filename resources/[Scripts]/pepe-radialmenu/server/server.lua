Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('pepe-radialmenu:server:HasItem', function(source, cb, itemName)
    local Player = Framework.Functions.GetPlayer(source)
    if Player ~= nil then
      local Item = Player.Functions.GetItemByName(itemName)
        if Item ~= nil then
			cb(true)
        else
			cb(false)
        end
	end
end)
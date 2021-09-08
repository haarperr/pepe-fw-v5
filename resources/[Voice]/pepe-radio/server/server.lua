Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateUseableItem("radio", function(source, item)
  local Player = Framework.Functions.GetPlayer(source)
  TriggerClientEvent('pepe-radio:use', source)
end)

Framework.Functions.CreateCallback('pepe-radio:server:GetItem', function(source, cb, item)
  local src = source
  local Player = Framework.Functions.GetPlayer(src)
  if Player ~= nil then 
    local RadioItem = Player.Functions.GetItemByName(item)
    if RadioItem ~= nil then
      cb(true)
    else
      cb(false)
    end
  else
    cb(false)
  end
end)
local CurrentProp = nil
local HasProp = false

function AddProp(Name)
    if Config.PropList[Name] ~= nil then
      if CurrentProp == nil then
        RequestModelHash(Config.PropList[Name]['prop'])
        CurrentProp = CreateObject(Config.PropList[Name]['hash'], 0, 0, 0, true, true, true)
        AttachEntityToEntity(CurrentProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), Config.PropList[Name]['bone-index']['bone']), Config.PropList[Name]['bone-index']['X'], Config.PropList[Name]['bone-index']['Y'], Config.PropList[Name]['bone-index']['Z'], Config.PropList[Name]['bone-index']['XR'], Config.PropList[Name]['bone-index']['YR'], Config.PropList[Name]['bone-index']['ZR'], true, true, false, true, 1, true)
        HasProp = true
      end
    end 
end

function AddPropWithAnim(Name, AnimDict, Anim, AnimTime)
  if Config.PropList[Name] ~= nil then
    if CurrentProp == nil then
      RequestModel(Config.PropList[Name]['prop'])
      while not HasModelLoaded(Config.PropList[Name]['prop']) do
          Wait(10)
      end
      exports['pepe-assets']:RequestAnimationDict(AnimDict)
      CurrentProp = CreateObject(Config.PropList[Name]['hash'], 0, 0, 0, true, true, true)
      AttachEntityToEntity(CurrentProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), Config.PropList[Name]['bone-index']['bone']), Config.PropList[Name]['bone-index']['X'], Config.PropList[Name]['bone-index']['Y'], Config.PropList[Name]['bone-index']['Z'], Config.PropList[Name]['bone-index']['XR'], Config.PropList[Name]['bone-index']['YR'], Config.PropList[Name]['bone-index']['ZR'], true, true, false, true, 1, true)
      TaskPlayAnim(PlayerPedId(), AnimDict, Anim, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
      HasProp = true
      Citizen.Wait(AnimTime)
      RemoveProp()
      HasProp = false
      StopAnimTask(PlayerPedId(), AnimDict, Anim, 1.0)
    end
  end 
end

function RemoveProp()
  if CurrentProp ~= nil then
    if HasProp ~= nil then
     DetachEntity(CurrentProp, true, false)
     DeleteEntity(CurrentProp)
     DeleteObject(CurrentProp)
     HasProp = false
     CurrentProp = nil
    end
  end
end

function GetPropStatus()
  return HasProp
end

function RequestModelHash(Model)
  RequestModel(Model)
	while not HasModelLoaded(Model) do
	    Wait(1)
    end
end

RegisterNetEvent('pepe-assets:addprop:with:anim')
AddEventHandler('pepe-assets:addprop:with:anim', function(ItemName, AnimDict, AnimName, Time)
  AddPropWithAnim(ItemName, AnimDict, AnimName, Time)
end)


AddEventHandler('onResourceStop', function(resource)
	RemoveProp()
end)

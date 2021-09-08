local Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)


-- Code

function GetLevel(type)

    Level = Framework.Functions.GetPlayerData().metadata[type]

    if Level ~= nil then

        if Level > 0 and Level < 1001 then

            return string.format("%.0f", (Level / 100))

        elseif Level > 1000 then

            return 10

        else 

            return 0

        end

    else
        
        return 0

    end
    
end


function GiveLevelExperience(type, amount)

	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    Player.Functions.SetMetaData(type, Framework.Functions.GetPlayerData().levels[type]+amount)

end

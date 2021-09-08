Onyx Memory Minigame

Use:
exports['orp-memoryminigame']:StartMinigame({
    success = 'success:event:example',
    fail = 'fail:event:example'
})

RegisterNetEvent('success:event:example')
AddEventHandler('success:event:example', function()
    -- What to do if player was successful
end)

RegisterNetEvent('fail:event:example')
AddEventHandler('fail:event:example', function()
    -- What to do if player failed minigame
end)

Configuration
-Change the maximum amount of active squares in `main.js` line 1
MAX_SQUARES = 7;

Any issues feel free to contact Howdy#1337 on discord.
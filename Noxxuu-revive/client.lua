
local reviveTimer = 1
local reviveColor = "~y~"
local chatColor = "~b~" 

timerCount1 = reviveTimer
isDead = false



AddEventHandler('onClientMapStart', function()
	exports.spawnmanager:spawnPlayer()
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
end)


function revivePed(ped)
	isDead = false
	timerCount1 = reviveTimer
	local playerPos = GetEntityCoords(ped, true)
	NetworkResurrectLocalPlayer(playerPos, true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
end

function ShowInfoRevive(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(true, true)
end

Citizen.CreateThread(function()
    while true do
    	Citizen.Wait(0)
		ped = GetPlayerPed(-1)
        if IsEntityDead(ped) then
			isDead = true
            SetPlayerInvincible(ped, true)
            SetEntityHealth(ped, 1)
			ShowInfoRevive(chatColor .. 'Jestes ranny/nieprzytomny. kliknij ' .. reviveColor .. 'E ' .. chatColor ..'zeby wstac.')
            if IsControlJustReleased(0, 38) and GetLastInputMethod(0) then
                if timerCount1 == 0 or cHavePerms then
                    revivePed(ped)
				else
					TriggerEvent('chat:addMessage', {args = {'^1^*' .. timerCount1 .. ' | zrevuj sie'}})
                end	
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isDead then
			if timerCount1 ~= 0 then
				timerCount1 = timerCount1 - 1
			end
        end
        Citizen.Wait(1000)          
    end
end)

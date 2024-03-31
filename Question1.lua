-- Incorrect code 
--[[local function releaseStorage(player)
    player:setStorageValue(1000, -1)
end

function onLogout(player)
    if player:getStorageValue(1000) == 1 then
        addEvent(releaseStorage, 1000, player)
    end
    return true
end--]] 

--The function releaseStorage is supposed to define the key 1000 to value -1 of certain player
local function releaseStorage(player)
    player:setStorageValue(1000, -1)
end

--The function onLogout is supposed to notifys when a certain player logout
function onLogout(player)
    --In the incorrect code compares the key with 1 instead -1, so, the condition never will be trigged and the
    -- releaseStorage function would never be called
    if player:getStorageValue(1000) == -1 then
        addEvent(releaseStorage, 1000, player)
    end
    return true
end


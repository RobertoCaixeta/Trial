--Incorrect code
--[[function do_sth_with_PlayerParty(playerId, membername)
    player = Player(playerId)
    local party = player:getParty()

    for k, v in pairs(party:getMembers()) do
        if v == Player(membername) then
            party:removeMember(Player(membername))
        end
    end
end--]]

--Correct code

function excludePartyMember(playerId, membername)
    --To avoid problems, is better declare player as a local variable
    local player = Player(playerId)
    local party = player:getParty() 
    
    for k, v in pairs(party:getMembers()) do
        if v == Player(membername) then
            party:removeMember(Player(membername))
            -- To improve the code, a break have to be include, to prevent the loop check another players after the desired
            break
        end
    end
end

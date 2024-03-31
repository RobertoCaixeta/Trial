-- Incorrect code
--[[function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
    local guildName = result.getString("name")
    print(guildName)
end--]] 

-- The code doens't handle multiples results for the query and the variable result is never declareted

function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < ?;"
    local resultId = db.storeQuery(selectGuildQuery, memberCount)
    -- Handle none or multiples results 
    if resultId:size() == 0 then
        print("No guild has less than " .. memberCount .. " members.")
    else
        for i = 1, resultId:size() - 1 do
            local guildName = resultId[i]:getString("name")
            print(guildName)
        end
    end
end


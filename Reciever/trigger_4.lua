function(event)
    if event == "PLAYER_ENTERING_WORLD" and IsInGuild() then
        ChatThrottleLib:SendAddonMessage("BULK", "RWVER", aura_env.version, "GUILD")
        aura_env.logged = false
    end
    
    if event == "GROUP_ROSTER_UPDATE" then
        if IsInRaid() then
            ChatThrottleLib:SendAddonMessage("BULK", "RWVER", aura_env.version, "RAID")
        else
            ChatThrottleLib:SendAddonMessage("BULK", "RWVER", aura_env.version, "PARTY")
        end
    end
end

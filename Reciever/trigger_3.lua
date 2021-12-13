function(event, prefix, version, channel, sender)
    if prefix == "RWVER" and not aura_env.logged then
        if tonumber(version) - 4 > tonumber(aura_env.version) then
            aura_env.logged = true
            print("|cFFF14602Raid warning receiver: your version ("..aura_env.version..") is more than 4 versions below of actual. Consider updating!|r")
        end
    end
    
    if prefix == "REQUESTRWVER" then
        ChatThrottleLib:SendAddonMessage("BULK", "MYRWVER", aura_env.version, "WHISPER", sender)
    end
end

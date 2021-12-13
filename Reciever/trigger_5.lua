function(event, text, ...)
    if text and text:find("item:171280") then
        if aura_env.last then
            ChatThrottleLib:SendAddonMessage("ALERT", "2FLASKS", WeakAuras.me.." "..(aura_env.alchemy and "true" or "false"), "RAID")
        else
            aura_env.last = true
            C_Timer.After(10, function() WeakAuras.ScanEvents("RESET_FLASK_COUNTER") end)
        end
    end
end

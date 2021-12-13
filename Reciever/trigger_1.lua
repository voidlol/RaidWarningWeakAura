function(allstates, event, ...)
    local prefix, message, _, sender = ...
    sender = sender and strsplit("-", sender) or ""
    if prefix == "TWETW" and (UnitIsGroupAssistant(sender) or UnitIsGroupLeader(sender) or sender == UnitName('player')) then
        local e = aura_env
        local name, msg = e.getName(message)
        if name == strlower(UnitName("Player")) or name == "all" then
            local pos = msg:find("<t")
            local time, spellIcon, sound = nil
            if pos then
                time = msg:match("%d[%d.,]*", pos + 1)
                msg = msg:gsub("<t%d[%d.,]*>", "")       
            end
            local posSound = msg:find("<s")
            if posSound then
                sound = msg:match("[%a.,]*", posSound + 2)
                msg = msg:gsub("<s[%a.,]*>", "")
            end
            
            if tonumber(msg) ~= nil and IsPlayerSpell(tonumber(msg)) then
                msg, _, spellIcon = GetSpellInfo(msg)
                spellIcon = "|T"..spellIcon..":"..e.config["iconSize"].."|t"
            end
            local string = e.config[strlower(msg)] and e.config[strlower(msg)] or msg
            if (msg == "personal" or msg == "personals") and (UnitGroupRolesAssigned("player") == "TANK") then
                string = ""
                msg = ""
                return false
            end                      
            allstates[GetTime()..msg] = {
                show = true,
                changed = true,
                progressType = "timed",                
                duration = time and tonumber(time) or e.config["duration"],
                expirationTime = GetTime() + (time and time or e.config["duration"]),
                autoHide = true,
                icon =  e.config["icon"] and (e.buffIcons[strlower(msg)] or spellIcon) or "",
                warning = e.config["color"] and WrapTextInColorCode(string, e.color) or string,
                showTime = time and true or false
            }
            if posSound and e.config["enableWarning"] then
                PlaySoundFile(e.receiveSoundPath..sound, "Master")    
            end
            if e.debug then                
                print("|CFFFFFF00RWR Debug: MESSAGE RECIEVED: "..message.." -> "..string)
            end
        end
        return true
    end    
end

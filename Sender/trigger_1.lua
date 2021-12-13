function(event, ...)
    if (aura_env.start) then
        local e = aura_env
        if event == "COMBAT_LOG_EVENT_UNFILTERED" and e.startSpells then
            local timeStamp, subevent, _, _, _, _, _, _, _, _, _, spellId = ...
            subevent = (subevent == "SPELL_CAST_SUCCESS" and select(4, GetSpellInfo(spellId)) == 0) and "SPELL_CAST_START" or subevent
            local spells = e.encounters[e.encounterId]["SPELLS"]
            if spells ~= nil and spells[spellId] ~= nil and spells[spellId][subevent] ~= nil then
                if (subevent == "SPELL_AURA_APPLIED" and (not e.debuff[spellId] or e.debuff[spellId] < timeStamp - e.throttle[spellId])) 
                or subevent == "SPELL_CAST_START" then
                    e.debuff[spellId] = timeStamp
                    e.count[spellId] = e.count[spellId] or 0
                    e.count[spellId] = e.count[spellId] + 1
                    if spells[spellId][subevent][e.count[spellId]] ~= nil then
                        e.sendMsg(spells[spellId][subevent][e.count[spellId]], spellId)
                    end
                    if spells[spellId][subevent]["ALL"] ~= nil then
                        e.sendMsg(spells[spellId][subevent]["ALL"], spellId)
                    end
                end
            end
        end
        
        
        if (event == "BigWigs_StartBar" or event == "DBM_TimerStart") and e.startBW then
            local name = ...
            local bar = event == "BigWigs_StartBar" and WeakAuras.GetBigWigsTimerById(name) or WeakAuras.GetDBMTimerById(name)
            local text = e.searchBW(e.encounterId, bar)
            if bar and e.searchBW(e.encounterId, bar) then
                e.bwcounts[text] = e.bwcounts[text] or 0
                e.bwcounts[text] = e.bwcounts[text] + 1
                local counts = e.encounters[e.encounterId]["BW"][text]
                local currentCount = (not counts["GLOBAL"] and tonumber(bar.count) > 0) and tonumber(bar.count) or e.bwcounts[text]
                if counts[currentCount] ~= nil then
                    e.sendBWMsg(counts[currentCount], bar, currentCount)
                end
                if counts["ALL"] then
                    e.sendBWMsg(counts["ALL"], bar, currentCount)
                end
            end
        end
        
        
        if (event == "BigWigs_StopBar" or event == "DBM_TimerStop") and e.startBW then
            local name = ...
            if name and e.bw[name] and not e.BWdelayed[name] then
                e.bw[name]:Cancel()
                e.bw[name] = nil
            end
        end
    end
    
    if event == "ENCOUNTER_START" then
        local e = aura_env
        e.bw = {}
        e.bwcounts = {}
        e.debuff = {}
        e.encounterId = ...
        local _, _, difficulty = ...
        difficulty = difficulty - 13
        e.timeTable = {}
        e.count = {}
        e.BWdelayed = {}
        if e.encounters[e.encounterId] ~= nil and e.encounters[e.encounterId].difficulty[difficulty] then
            e.buildHealersAndDamagers()
            if (e.debug) then
                e.msgCounter = 0
                print(string.format("|cFFFFFF00RWS Debug: Encounter %u captured!", e.encounterId))
            end
            e.start = true
            e.startSpells = e.encounters[e.encounterId]["SPELLS"] and true or false
            e.startBW = e.encounters[e.encounterId]["BW"] and true or false
            if e.encounters[e.encounterId]["TIMES"] ~= nil then
                for time, saves in pairs(e.encounters[e.encounterId]["TIMES"]) do
                    local timer = C_Timer.NewTimer(time, function()
                            for _, announce in ipairs(saves) do
                                announce.save = announce.customDur and (announce.save.."<t"..announce.duration..">") or announce.save
                                announce.save = announce.soundEnable and (announce.save.."<s"..e.soundTable[announce.sound]..".ogg>") or announce.save
                                local names = e.buildNames(announce.name)
                                for _, name in ipairs(names) do
                                    ChatThrottleLib:SendAddonMessage("ALERT", "TWETW", name.." "..announce.save, "RAID")
                                    if (e.debug) then 
                                        print(string.format("|cFFFFFF00RWS Debug: Message (%s %s) sent.", name, announce.save))
                                    end
                                end
                            end
                        end
                    )
                    tinsert(e.timeTable, timer)
                end
            end 
        end
    end
end

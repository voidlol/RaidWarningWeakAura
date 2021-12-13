function(event, ...)
    if event == "ENCOUNTER_END" then
        local e = aura_env
        e.start = false
        e.startSpells = false
        e.startBW = false
        if e.timeTable then
            for _, timer in pairs(e.timeTable) do
                timer:Cancel()       
            end
        end
        if e.bw then
            for _, timer in pairs(e.bw) do
                timer:Cancel()
            end
        end
        e.bw = nil
        e.bwcounts = nil
        e.debuff = nil
        e.encounterId = nil
        e.timeTable = nil
        e.count = nil
        e.BWdelayed = nil  
        return true
    end
end

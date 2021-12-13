--[[
###MADE BY VOIDLOL###
BattleTag: voidlol#2667
Discord: voidlol#8805
In-game: Воидлол @ Свежеватель Душ
         Сапрессор @ Свежеватель Душ
]]

--[[MAKING LOCAL COPY OF GLOBAL VARS]]--
local e = aura_env
local tinsert = table.insert
local tconcat = table.concat
local UnitInRaid = UnitInRaid
local GetRaidRosterInfo = GetRaidRosterInfo
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
e.soundTable = {
    [1] = "Adds",
    [2] = "AirHorn",
    [3] = "Applause",
    [4] = "BananaPeelSlip",
    [5] = "BatmanPunch",
    [6] = "BikeHorn",
    [7] = "Blast",
    [8] = "Bleat",
    [9] = "Boss",
    [10] = "BoxingArenaSound",
    [11] = "CartoonVoiceBaritone",
    [12] = "CartoonWalking",
    [13] = "CatMeow2",
    [14] = "Circle",
    [15] = "CowMooing",
    [16] = "Cross",
    [17] = "Diamond",
    [18] = "DontRelease",
    [19] = "Empowered",
    [20] = "Focus",
    [21] = "Idiot",
    [22] = "KittenMeow",
    [23] = "Left",
    [24] = "Moon",
    [25] = "Next",
    [26] = "Portal",
    [27] = "Protected",
    [28] = "Release",
    [29] = "Right",
    [30] = "RingingPhone",
    [31] = "RoaringLion",
    [32] = "RobotBlip",
    [33] = "RunAway",
    [34] = "SharpPunch",
    [35] = "Shotgun",
    [36] = "Skull",
    [37] = "Spread",
    [38] = "Square",
    [39] = "SquishFart",
    [40] = "Stack",
    [41] = "Star",
    [42] = "Switch",
    [43] = "Taunt",
    [44] = "TempleBellHuge",
    [45] = "Torch",
    [46] = "Triangle",
    [47] = "WarningSiren",
    [48] = "WaterDrop",
}

e.virag = LoadAddOn("ViragDevTool") --This helps debugging
e.debug = e.config["debug"] --Easy access to debug option
e.healers = nil --Healer's names
e.mdd = nil --Melee DD's names
e.rdd = nil --Ranged DD's names

--[[FUNCTION TO DETERMINE IS UNIT MELEE OR NOT]]--
e.isMelee = function(unit) --All credits to Reloe for this function.
    local c = select(3, UnitClass(unit))
    if c == 1 or c == 6 or c == 2 or c == 10 or c == 4 or c == 12 then -- Melee Only Classes
        return true
    elseif c == 8 or c == 5 or c == 9 then -- Ranged Only Classes
        return false
    elseif c == 3 then -- Hunter
        if UnitPowerMax(unit) == 100 and UnitExists(unit.."pet") then 
            return true
        else
            return false
        end
        
    elseif c == 11 then -- Druid
        if (UnitGroupRolesAssigned(unit) == "DAMAGER" and UnitPowerType(unit) ~= 8 and UnitPower(unit, 8) ~= 0) or UnitGroupRolesAssigned(unit) == "TANK" then 
            return true
        else
            return false
        end
        
    elseif c == 7 and UnitPowerType(unit) == 11 then -- Shaman
        return true
    else
        return false
    end
    
end

--[[FUNCTION TO BUILD HEALER'S, MELEE DD'S AND RANGED DD'S NAMES]]--
e.buildHealersAndDamagers = function()
    local healers = {}
    local mdd = {}
    local rdd = {}
    local hfound, mfound, rfound = false
    
    for unit in WA_IterateGroupMembers() do
        local role = UnitGroupRolesAssigned(unit)
        local name = UnitName(unit)
        if role == "HEALER" then
            hfound = true
            tinsert(healers, name)
        elseif role == "DAMAGER" then
            if e.isMelee(unit) then
                mfound = true
                tinsert(mdd, name)
            else
                rfound = true
                tinsert(rdd, name)
            end
        end
    end
    e.healers = hfound and tconcat(healers, " ") or nil
    e.mdd = mfound and tconcat(mdd, " ") or nil
    e.rdd = rfound and tconcat(rdd, " ") or nil
end

--[[BUILDS NAMES FOR ANNOUNCE]]--
e.buildNames = function(namestring)
    local names = {}
    for name in namestring:gmatch("[^, ]+") do 
        if strlower(name):match("group%d") and UnitInRaid("player") then
            local group = tonumber(name:match("%d"))
            local counter = 0
            for unit in WA_IterateGroupMembers() do
                local raidIndex = UnitInRaid(unit)
                local unitName, _, sub = GetRaidRosterInfo(raidIndex)
                if sub == group then
                    counter = counter + 1
                    tinsert(names, unitName)
                end
                if counter == 5 then
                    break
                end
            end
        elseif (strlower(name) == "healer" or strlower(name) == "healers") and e.healers then
            for hname in e.healers:gmatch("[^, ]+") do tinsert(names, hname) end
        elseif strlower(name) == "mdd" and e.mdd then
            for mname in e.mdd:gmatch("[^, ]+") do tinsert(names, mname) end
        elseif strlower(name) == "rdd" and e.rdd then
            for rname in e.rdd:gmatch("[^, ]+") do tinsert(names, rname) end
        else
            tinsert(names, name)
        end
    end
    return names
end

--[[BUILDS MAIN ENCOUNTER TABLE]]--
e.buildEncounters = function()
    e.throttle = {}
    e.encounters = {}
    for _, encounters in pairs(e.config.encounters) do
        if encounters.encID and encounters.isEncEnabled then
            e.encounters[encounters.encID] = e.encounters[encounters.encID] or {}
            e.encounters[encounters.encID].difficulty = encounters.difficulty
            for _, spells in pairs(encounters.spells) do
                if spells.spellID and spells.isSpellEnabled then
                    e.encounters[encounters.encID]["SPELLS"] = e.encounters[encounters.encID]["SPELLS"] or {}
                    e.encounters[encounters.encID]["SPELLS"][spells.spellID] = e.encounters[encounters.encID]["SPELLS"][spells.spellID] or {}
                    local event = spells.event == 1 and "SPELL_CAST_START" or "SPELL_AURA_APPLIED"
                    e.encounters[encounters.encID]["SPELLS"][spells.spellID][event] = e.encounters[encounters.encID]["SPELLS"][spells.spellID][event] or {}
                    if event == "SPELL_AURA_APPLIED" then
                        e.throttle[spells.spellID] = spells.throttle or 30
                    end
                    for _, casts in pairs(spells.casts) do
                        if casts.count and casts.isCountEnabled then
                            if casts.count == "ALL" or casts.count == "All" or casts.count == "all"then
                                e.encounters[encounters.encID]["SPELLS"][spells.spellID][event]["ALL"] = e.encounters[encounters.encID]["SPELLS"][spells.spellID][event]["ALL"] or {}
                                for _, saves in pairs(casts.saves) do
                                    if saves.save and saves.isMsgEnabled then
                                        tinsert(e.encounters[encounters.encID]["SPELLS"][spells.spellID][event]["ALL"], saves)
                                    end
                                end
                            else
                                local castNumbers = {}
                                for castCount in casts.count:gmatch("[^, ]+") do tinsert(castNumbers, castCount) end
                                for _, count in ipairs(castNumbers) do
                                    if tonumber(count) == nil then
                                        print("|cFFFF0000Raid Warning Sender ERROR|r: count field can contains ONLY digits and spaces!")
                                        break
                                    else
                                        count = tonumber(count)
                                        e.encounters[encounters.encID]["SPELLS"][spells.spellID][event][count] = e.encounters[encounters.encID]["SPELLS"][spells.spellID][event][count] or {}
                                        for _, saves in pairs(casts.saves) do
                                            if saves.save and saves.isMsgEnabled then
                                                tinsert(e.encounters[encounters.encID]["SPELLS"][spells.spellID][event][count], saves)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            for _, time in pairs(encounters.times) do
                if (time.minutes or time.seconds) and time.isTimeEnabled then
                    e.encounters[encounters.encID]["TIMES"] = e.encounters[encounters.encID]["TIMES"] or {}
                    local timestamp = (time.minutes * 60) + time.seconds
                    e.encounters[encounters.encID]["TIMES"][timestamp] = e.encounters[encounters.encID]["TIMES"][timestamp] or {}
                    for _, saves in pairs(time.saves) do
                        if saves.save and saves.isMsgEnabled then
                            tinsert(e.encounters[encounters.encID]["TIMES"][timestamp], saves)
                        end                     
                    end
                end
            end
            
            for _, bigwigs in pairs(encounters.bigwigs) do
                if bigwigs.name and bigwigs.name:len() > 0 and bigwigs.isBWEnabled then
                    e.encounters[encounters.encID]["BW"] = e.encounters[encounters.encID]["BW"] or {}
                    e.encounters[encounters.encID]["BW"][bigwigs.name] = e.encounters[encounters.encID]["BW"][bigwigs.name] or {}
                    e.encounters[encounters.encID]["BW"][bigwigs.name]["GLOBAL"] = bigwigs.global
                    if bigwigs.spellID > 0 then
                        e.encounters[encounters.encID]["BW"][bigwigs.name]["SPELLID"] = bigwigs.spellID
                    end
                    for _, counts in ipairs(bigwigs.counter) do
                        if counts.count and counts.isCountEnabled then
                            if counts.count == "ALL" or counts.count == "All" or counts.count == "all" then
                                e.encounters[encounters.encID]["BW"][bigwigs.name]["ALL"] = e.encounters[encounters.encID]["BW"][bigwigs.name]["ALL"] or {}                         
                                e.encounters[encounters.encID]["BW"][bigwigs.name]["ALL"][counts.expiration] = e.encounters[encounters.encID]["BW"][bigwigs.name]["ALL"][counts.expiration] or {}
                                for _, saves in pairs(counts.saves) do
                                    if saves.save and saves.isMsgEnabled then
                                        tinsert(e.encounters[encounters.encID]["BW"][bigwigs.name]["ALL"][counts.expiration], saves)
                                    end
                                end
                            else
                                local barNumbers = {}
                                for barCount in counts.count:gmatch("[^, ]+") do tinsert(barNumbers, barCount) end
                                for _, count in ipairs(barNumbers) do
                                    if tonumber(count) == nil then
                                        print("|cFFFF0000Raid Warning Sender ERROR|r: count field can contains ONLY digits, spaces and \"ALL\" keyword!")
                                        break
                                    else
                                        count = tonumber(count)
                                        e.encounters[encounters.encID]["BW"][bigwigs.name][count] = e.encounters[encounters.encID]["BW"][bigwigs.name][count] or {}
                                        e.encounters[encounters.encID]["BW"][bigwigs.name][count][counts.expiration] = e.encounters[encounters.encID]["BW"][bigwigs.name][count][counts.expiration] or {}
                                        for _, saves in pairs(counts.saves) do
                                            if saves.save and saves.isMsgEnabled then
                                                tinsert(e.encounters[encounters.encID]["BW"][bigwigs.name][count][counts.expiration], saves)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

--[[SEARCH MAIN ENCOUNTER TABLE FOR THAT BOSSMOD BAR]]--
e.searchBW = function(encID, bar)
    local text = bar.text and strlower(bar.text) or strlower(bar.message)
    for bwname, value in pairs(e.encounters[encID]["BW"]) do
        if value["SPELLID"] then
            if strfind(text, strlower(bwname)) and value["SPELLID"] == tonumber(bar.spellId) then
                return bwname
            end
        else
            if strfind(text, strlower(bwname)) then
                return bwname
            end
        end
    end
    return nil
end

--[[SENDS SPELL ANNOUNCE]]--
e.sendMsg = function(tbl, spellId)
    for _, announce in ipairs(tbl) do
        local names = e.buildNames(announce.name)
        local save = announce.customDur and (announce.save.."<t"..announce.duration..">") or announce.save
        save = announce.soundEnable and (save.."<s"..e.soundTable[announce.sound]..".ogg>") or save
        if announce.delay then
            local timer = C_Timer.NewTimer(announce.dtime, function()
                    for _, name in ipairs(names) do
                        ChatThrottleLib:SendAddonMessage("ALERT", "TWETW", name.." "..save, "RAID")
                        if (e.debug) then
                            print(string.format("|cFFFFFF00RWS Debug: Message (%s %s) sent after %u seconds delay. Spell = %u. Count = %u.", name, save, announce.dtime, spellId, e.count[spellId]))
                        end
                    end
                end
            )
            tinsert(e.timeTable, timer)
        else
            for _, name in ipairs(names) do
                ChatThrottleLib:SendAddonMessage("ALERT", "TWETW", name.." "..save, "RAID")
                if (e.debug) then
                    print(string.format("|cFFFFFF00RWS Debug: Message (%s %s) sent. Spell = %u. Count = %u.", name, save, spellId, e.count[spellId]))
                end
            end
        end
    end
end

--[[SENDS BW ANNOUNCE]]--
e.sendBWMsg = function(tbl, bar, currentCount)
    local bartext = bar.text and bar.text or bar.message
    for exp, announces in pairs(tbl) do
        if exp < 0 then
            e.BWdelayed[bartext] = true
        end
        local when = bar.duration - exp
        if (when > 0) then
            for _, announce in ipairs(announces) do
                local names = e.buildNames(announce.name)
                local save = announce.customDur and (announce.save.."<t"..announce.duration..">") or announce.save
                save = announce.soundEnable and (save.."<s"..e.soundTable[announce.sound]..".ogg>") or save
                local timer = C_Timer.NewTimer(when, function()
                        for _, name in ipairs(names) do
                            ChatThrottleLib:SendAddonMessage("ALERT", "TWETW", name.." "..save, "RAID")
                            if (e.debug) then
                                print(string.format("|cFFFFFF00RWS Debug: Message (%s %s) sent. Bar = %s. Count = %u. Remaing time = %u.", name, save, bartext, currentCount, exp))
                            end
                        end
                    end
                )
                e.bw[bartext] = timer
            end
        else
            print(string.format("|cFFFF0000RWS ERROR|r|cFFFFFF00: BigWigs bar's (%s) duration is less or equal than requested remaining time (%u <= %u)", bartext, bar.duration, exp))
            for _, announce in ipairs(announces) do
                local names = e.buildNames(announce.name)
                local save = announce.customDur and (announce.save.."<t"..announce.duration..">") or announce.save
                save = announce.soundEnable and (save.."<s"..e.soundTable[announce.sound]..".ogg>") or save
                for _, name in ipairs(names) do
                    ChatThrottleLib:SendAddonMessage("ALERT", "TWETW", name.." "..save, "RAID")
                    if (e.debug) then
                        print(string.format("|cFFFFFF00RWS Debug: Message (%s %s) sent. Bar = %s. Count = %u.", name, save, bartext, currentCount))
                    end
                end
            end
        end
    end
end

--[[BUILD ENCOUNTERS AND DEBUG INFO]]--
e.buildEncounters()
if (e.debug) then
    if e.virag then
        ViragDevTool_AddData(e.encounters, "Encounters table")
        ViragDevTool_AddData(e.throttle, "throttle")
    end
end



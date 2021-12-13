--[[
###MADE BY VOIDLOL###
BattleTag: voidlol#2667
Discord: voidlol#8805
In-game: Воидлол @ Свежеватель Душ
         Сапрессор @ Свежеватель Душ
]]

local tankIcon = "Interface\\LFGFrame\\UI-LFG-ICON-ROLES:0:0:0:0:256:256:0:67:67:134"
local e = aura_env
local soundPath = e.config["enableSound"] and (LoadAddOn("BigWigs") and "Interface\\AddOns\\BigWigs\\Media\\Sounds\\Amy" or "Interface\\AddOns\\DBM-Core\\sounds\\Corsica") or "123"
e.sounds = {
    [1] = soundPath.."\\1.ogg",
    [2] = soundPath.."\\2.ogg",
    [3] = soundPath.."\\3.ogg",
    [4] = soundPath.."\\4.ogg",
    [5] = soundPath.."\\5.ogg",    
}
e.receiveSoundPath = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\"
e.logged = false
e.version = "301023"
WeakAurasSaved["displays"]["Announce"]["RWVER"] = e.version
e.virag = LoadAddOn("ViragDevTool")
e.personals = {
    --WARRIOR +
    [71] = { 118038, "none", { [0] = 0, [1] = 307865, [2] = 317349, [3] = 325886, [4] = 324143} }, -- Arms
    [72] = { 184364, "none", { [0] = 0, [1] = 307865, [2] = 317349, [3] = 325886, [4] = 324143} }, -- Fury
    [73] = { tankIcon, "none", { [0] = 0, [1] = 307865, [2] = 317349, [3] = 325886, [4] = 324143} }, -- Protection (TANK)
    --PALADIN +
    [65] = { 498, 642, { [0] = 0, [1] = 304971, [2] = 316958, [3] = 328620, [4] = 328204} }, -- Holy
    [66] = { tankIcon, 642, { [0] = 0, [1] = 304971, [2] = 316958, [3] = 328620, [4] = 328204} }, -- Protection (TANK)
    [70] = { 184662, 642, { [0] = 0, [1] = 304971, [2] = 316958, [3] = 328620, [4] = 328204} }, --  Retribution
    --HUNTER +
    [253] = { 109304, 186265, { [0] = 0, [1] = 308491, [2] = 324149, [3] = 328231, [4] = 325028} }, -- Beast Mastery
    [254] = { 109304, 186265, { [0] = 0, [1] = 308491, [2] = 324149, [3] = 328231, [4] = 325028} }, -- Marksmanship
    [255] = { 109304, 186265, { [0] = 0, [1] = 308491, [2] = 324149, [3] = 328231, [4] = 325028} }, -- Survival
    --ROGUE +
    [259] = { 1966, 31224, { [0] = 0, [1] = 323547, [2] = 323654, [3] = 328305, [4] = 328547} }, -- Assassination
    [260] = { 1966, 31224, { [0] = 0, [1] = 323547, [2] = 323654, [3] = 328305, [4] = 328547} }, -- Outlaw
    [261] = { 1966, 31224, { [0] = 0, [1] = 323547, [2] = 323654, [3] = 328305, [4] = 328547} }, -- Subtlety
    --PRIEST +
    [256] = { 19236, "none", { [0] = 0, [1] = 325013, [2] = 323673, [3] = 327661, [4] = 324724} }, -- Discipline
    [257] = { 19236, "none", { [0] = 0, [1] = 325013, [2] = 323673, [3] = 327661, [4] = 324724} }, -- Holy
    [258] = { 19236, 47585, { [0] = 0, [1] = 325013, [2] = 323673, [3] = 327661, [4] = 324724} }, -- Shadow
    --DEATHKIGHT +
    [250] = { tankIcon, 48707, { [0] = 0, [1] = 312202, [2] = 311648, [3] = 324128, [4] = 315443} }, -- Blood (TANK)
    [251] = { 48792, 48707, { [0] = 0, [1] = 312202, [2] = 311648, [3] = 324128, [4] = 315443} }, -- Frost
    [252] = { 48792, 48707, { [0] = 0, [1] = 312202, [2] = 311648, [3] = 324128, [4] = 315443} }, -- Unholy
    --SHAMAN +
    [262] = { 108271, "none", { [0] = 0, [1] = 324386, [2] = 320674, [3] = 328923, [4] = 326059} }, -- Elemental
    [263] = { 108271, "none", { [0] = 0, [1] = 324386, [2] = 320674, [3] = 328923, [4] = 326059} }, -- Enhancement
    [264] = { 108271, "none", { [0] = 0, [1] = 324386, [2] = 320674, [3] = 328923, [4] = 326059} },-- Restoration
    --MAGE +
    [62] = { 235450, 45438, { [0] = 0, [1] = 307443, [2] = 314793, [3] = 314791, [4] = 324220} }, -- Arcane
    [63] = { 235313, 45438, { [0] = 0, [1] = 307443, [2] = 314793, [3] = 314791, [4] = 324220} }, -- Fire
    [64] = { 11426, 45438, { [0] = 0, [1] = 307443, [2] = 314793, [3] = 314791, [4] = 324220} }, -- Frost
    --WARLOCK +
    [265] = { 104773, "none", { [0] = 0, [1] = 312321, [2] = 321792, [3] = 325640, [4] = 325289} }, -- Affliction
    [266] = { 104773, "none", { [0] = 0, [1] = 312321, [2] = 321792, [3] = 325640, [4] = 325289} }, -- Demonology
    [267] = { 104773, "none", { [0] = 0, [1] = 312321, [2] = 321792, [3] = 325640, [4] = 325289} }, -- Destuction
    --MONK +
    [268] = { tankIcon, "none", { [0] = 0, [1] = 310454, [2] = 326860, [3] = 327104, [4] = 325216} }, -- Brewmaster (TANK)
    [269] = { 122278, "none", { [0] = 0, [1] = 310454, [2] = 326860, [3] = 327104, [4] = 325216} }, -- Windwalker
    [270] = { 122278, "none", { [0] = 0, [1] = 310454, [2] = 326860, [3] = 327104, [4] = 325216} }, -- Mistweaver
    --DRUID +
    [102] = { 22812, "none", { [0] = 0, [1] = 326434, [2] = 323546, [3] = 323764, [4] = 325727} }, -- Boomkin
    [103] = { 61336, "none", { [0] = 0, [1] = 326434, [2] = 323546, [3] = 323764, [4] = 325727} }, -- Feral
    [104] = { tankIcon, "none", { [0] = 0, [1] = 326434, [2] = 323546, [3] = 323764, [4] = 325727} }, -- Guardian (TANK)
    [105] = { 22812, "none", { [0] = 0, [1] = 326434, [2] = 323546, [3] = 323764, [4] = 325727} },-- Restoration
    --DEMONHUNTER +
    [577] = { 198589, 196555, { [0] = 0, [1] = 306830, [2] = 317009, [3] = 323639, [4] = 329554} },-- Havoc 1305150
    [581] = { tankIcon, "none", { [0] = 0, [1] = 306830, [2] = 317009, [3] = 323639, [4] = 329554} } -- Vengeance (TANK)
}

e.buffIcons = {
    ["id10"] = "|T136107:"..e.config["iconSize"].."|t", --Tranquility Druid
    ["id11"] = "|T464343:"..e.config["iconSize"].."|t", --Roar Druid
    ["id20"] = "|T538569:"..e.config["iconSize"].."|t", --HTT Shaman
    ["id21"] = "|T237586:"..e.config["iconSize"].."|t", --SLT Shaman
    ["id22"] = "|T136009:"..e.config["iconSize"].."|t", --APT Shaman
    ["id23"] = "|T135861:"..e.config["iconSize"].."|t", --MTT Shaman
    ["id24"] = "|T538576:"..e.config["iconSize"].."|t", --Windrush Shaman
    ["id30"] = "|T237540:"..e.config["iconSize"].."|t", --Hymn Priest
    ["id31"] = "|T458225:"..e.config["iconSize"].."|t", --Salvation Priest
    ["id40"] = "|T253400:"..e.config["iconSize"].."|t", --Barrier Priest
    ["id41"] = "|T538565:"..e.config["iconSize"].."|t", --Ramp Priest
    ["id50"] = "|T1020466:"..e.config["iconSize"].."|t", --Revival Monk
    ["id60"] = "|T135872:"..e.config["iconSize"].."|t", --Aura Mastery Paladin
    ["id61"] = "|T135875:"..e.config["iconSize"].."|t", --Avenging Crusader Paladin
    ["id70"] = "|T132351:"..e.config["iconSize"].."|t", --Rallying Cry Warrior
    ["id80"] = "|T1305154:"..e.config["iconSize"].."|t", --Darkness Demon Hunter
    ["id90"] = "|T237510:"..e.config["iconSize"].."|t", --AMZ Death Knight
    ["id100"] = "|T136230:"..e.config["iconSize"].."|t", --Vampiric Embrace Shadow Priest
    ["hs"] = "|T538745:"..e.config["iconSize"].."|t".."|T3566860:"..e.config["iconSize"].."|t",
}


e.getPersonalAndImmunity = function()
    e.spec = GetSpecializationInfo(GetSpecialization())
    local covenant = C_Covenants.GetActiveCovenantID()
    if covenant > 0 then
        local covenantAbility, _, covenantIcon = GetSpellInfo(e.personals[e.spec][3][covenant])
        e.buffIcons["covenant"] = "|T"..covenantIcon..":"..e.config["iconSize"].."|t"
        e.config["covenant"] = covenantAbility
    end
    local personalId = e.personals[e.spec][1]
    local immunityId = (e.personals[e.spec][2] ~= "none" and IsPlayerSpell(e.personals[e.spec][2])) and e.personals[e.spec][2] or "none"
    local pname, picon, iname, iicon, _ = nil
    if personalId == tankIcon then
        picon = personalId
        if immunityId ~= "none" then
            immunityId = (e.config["myIdImmunity"] and IsPlayerSpell(e.config["spellidi"])) and e.config["spellidi"] or immunityId
            iname, _, iicon = GetSpellInfo(immunityId)
            iname = (e.config["myNameImmunity"] and e.config["immunityName"]) and e.config["immunityName"] or iname
            if e.config["myIdImmunity"] and not IsPlayerSpell(e.config["spellidi"]) then
                print("|CFFFF0000RWR ERROR|r|CFFFFFF00: Spell with Spell ID "..e.config["spellidi"].." is not found in your spellbook. Using default: |T"..iicon..":0|t "..iname..".")
            end
        end
    else
        personalId = (e.config["myIdPersonal"] and IsPlayerSpell(e.config["spellid"])) and e.config["spellid"] or personalId
        pname, _, picon = GetSpellInfo(personalId)
        pname = (e.config["myNamePersonal"] and e.config["personalName"]) and e.config["personalName"] or pname
        if e.config["myIdPersonal"] and not IsPlayerSpell(e.config["spellid"]) then
            print("|CFFFF0000RWR ERROR|r|CFFFFFF00: Spell with Spell ID "..e.config["spellid"].." is not found in your spellbook. Using default: |T"..picon..":0|t "..pname..".")
        end
        if immunityId ~= "none" then
            immunityId = (e.config["myIdImmunity"] and IsPlayerSpell(e.config["spellidi"])) and e.config["spellidi"] or immunityId
            iname, _, iicon = GetSpellInfo(immunityId)
            iname = (e.config["myNameImmunity"] and e.config["immunityName"]) and e.config["immunityName"] or iname
            if e.config["myIdImmunity"] and not IsPlayerSpell(e.config["spellidi"]) then
                print("|CFFFF0000RWR ERROR|r|CFFFFFF00: Spell with Spell ID "..e.config["spellidi"].." is not found in your spellbook. Using default: |T"..iicon..":0|t "..iname..".")
            end
        end
    end
    
    e.buffIcons["personal"] = "|T"..picon..":"..e.config["iconSize"].."|t"    
    e.config["personal"] = pname
    e.buffIcons["immunity"] = iicon and "|T"..iicon..":"..e.config["iconSize"].."|t" or nil
    e.config["immunity"] = iname
    e.buffIcons["personals"] = e.buffIcons["personal"]
    e.config["personals"] = e.config["personal"]
end

e.alchemy = false
e.last = false

for _, index in pairs({ GetProfessions() }) do
    local id = select(7, GetProfessionInfo(index))
    if id == 171 then
        e.alchemy = true
        break
    end
end

e.update = function()
    e.getPersonalAndImmunity()
    e.config["hs"] = "Healing Potions!"
end

e.debug = e.config["debug"]
C_ChatInfo.RegisterAddonMessagePrefix("TWETW")
C_ChatInfo.RegisterAddonMessagePrefix("RWVER")
C_ChatInfo.RegisterAddonMessagePrefix("REQUESTRWVER")

e.color = select(4, GetClassColor(select(2, UnitClass("Player"))))

function e.getName(msg)
    local i = string.find(msg, " ")
    return strlower(strsub(msg, 0, i-1)), strsub(msg, i+1)
end

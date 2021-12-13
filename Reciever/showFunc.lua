function(_,_, progress)
    if WeakAuras.IsOptionsOpen() then
        local icon = aura_env.config["icon"] and "{rt8}" or ""
        local text = aura_env.config["color"] and WrapTextInColorCode("TEST WARNING", aura_env.color) or "TEST WARNING"
        return icon..text
    end
    
    return aura_env.state.showTime and " - |cFFFF0000"..progress or ""
end

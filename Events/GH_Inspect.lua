local isFunctionHook = false

function GHEvents:INSPECT_READY(unit)
    if (not isFunctionHook) and (InspectPaperDollItemsFrame) then
        GearHelper:HookInspectFrame()
        isFunctionHook = true
    end
end

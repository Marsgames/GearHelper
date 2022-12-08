function GearHelperEvents:LfgUpdate()
    GearHelper:UpdateGHLfrButton()
end

function GearHelperEvents:ReadyCheck()
    if lfrCheckIsChecked then
        ConfirmReadyCheck(1)
        ReadyCheckFrame:Hide()
        print("Ready check accepted") -- TODO: Add localization
        UIErrorsFrame:AddMessage("Ready check accepted", 0.0, 1.0, 0.0)
    end
end
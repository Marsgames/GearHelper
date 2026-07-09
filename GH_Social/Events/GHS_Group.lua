local lfrCheckIsChecked = false

function GHSocialEvents:LFG_UPDATE()
    GH_Social:UpdateGHLfrButton()
end

function GHSocialEvents:READY_CHECK()
    if lfrCheckIsChecked then
        ConfirmReadyCheck(1)
        ReadyCheckFrame:Hide()
        -- TODO: Add localization
        print("Ready check accepted")
        UIErrorsFrame:AddMessage("Ready check accepted", 0.0, 1.0, 0.0)
    end
end

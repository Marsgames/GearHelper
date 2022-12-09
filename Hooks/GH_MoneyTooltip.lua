function GearHelper:HookMoneyTooltip()
    TooltipDataProcessor.AddTooltipPostCall(
        Enum.TooltipDataType.Money,
        function(self, amount)
            local _, itemLink = self:GetItem()
            if GearHelper.db.global.SellPrices[itemLink] and not GearHelper.db.global.SellPrices[itemLink].sellPrice then
                GearHelper.db.global.SellPrices[itemLink].sellPrice = amount
            end
        end
    )
end

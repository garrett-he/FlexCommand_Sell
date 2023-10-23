FC_RegisterCommand("sell", {
    help = "sell items to merchant by filter",
    fn = function(args)
        if not MerchantFrame:IsShown() then
            FC_PrintWarning("No merchant is visiting.")
            return
        end

        if not args['filter'] then
            FC_PrintWarning("No filter specified for selling items.")
            return
        end

        local chunk = loadstring("local result, container, name, link, quality, itemLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = ...; result.value = (" .. args["filter"] .. ")")

        if not chunk then
            FC_PrintError("Invalid item filter expression '%s'.", args["filter"])
        end

        local result = { value = false }

        local total = 0

        for container = 0, 4 do
            local slotNum = GetContainerNumSlots(container)

            for slot = 1, slotNum do
                local link = GetContainerItemLink(container, slot)
                if link then
                    chunk(result, container, GetItemInfo(link))

                    local price = select(11, GetItemInfo(link)) * select(2, GetContainerItemInfo(container, slot))
                    if result.value and price > 0 then
                        UseContainerItem(container, slot)

                        total = total + price
                        FC_PrintInfo("Sold %s for %.1fg", link, price * 0.0001)
                    end
                end
            end
        end

        if total > 0 then
            FC_PrintInfo("Total %.1fg", total * 0.0001)
        end
    end
})

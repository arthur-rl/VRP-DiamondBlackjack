local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vRP_blackjack")

RegisterServerEvent("buychips:GetAmountofchips")
AddEventHandler(
    "buychips:GetAmountofchips",
    function()
        local player = source
        local user_id = vRP.getUserId({player})
        local amt = vRP.getInventoryItemAmount({user_id, "casino_token"})
        TriggerClientEvent("buychips:GotAmountOfChips", player, amt)
    end
)
RegisterServerEvent("buychips:TryChipPayment")
AddEventHandler(
    "buychips:TryChipPayment",
    function(amount)
        local player = source
        local user_id = vRP.getUserId({player})
        if vRP.tryPayment({user_id, tonumber(amount)}) then
            vRP.giveInventoryItem({user_id, "casino_token", tonumber(amount), false})
            vRPclient.notify(player, {"~g~Bought " .. amount .. " chips"})
            TriggerClientEvent("buychips:updatehud+", player, amount)
        else
            vRPclient.notify(player, {"~r~Not enough cash"})
        end
    end
)
RegisterServerEvent("buychips:PerformTradeIn")
AddEventHandler(
    "buychips:PerformTradeIn",
    function(amount)
        print("hello")
        local player = source
        local user_id = vRP.getUserId({player})
        if vRP.tryGetInventoryItem({user_id, "casino_token", tonumber(amount), false}) then
            vRPclient.notify(player, {"Given " .. amount .. " chips"})
            vRP.giveMoney({user_id, tonumber(amount)})
            TriggerClientEvent("buychips:updatehud-", player, tonumber(amount))
        else
            vRPclient.notify(player, {"~r~Not enough chips"})
        end
    end
)

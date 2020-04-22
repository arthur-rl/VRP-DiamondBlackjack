local casinoBuyChipsVector = vector3(1115.3167724609,219.67372131348,-49.435119628906)
-- 1117.8504638672,219.92866516113,-49.435161590576
RMenu.Add('casino_buychips', 'casino', RageUI.CreateMenu("", "CASHIER SERVICES",0,100,"shopui_title_casino", "shopui_title_casino"))
index = {
    chips = 1,
    tradeinchips = 1
}
playerAmountOfChips = 0
chipSizes = { 
    "1000",
    "2000",
    "3000",
    "4000",
    "5000",
    "10000",
    "20000",
    "25000"

}

areYouSureText = nil
areYouSureTextTradeIn = nil
isInCasino = false
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('casino_buychips', 'casino')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = true }, function()   
            RageUI.List("Acquire Chips", chipSizes, index.chips, "Press Enter to buy the selected amount", {}, true, function(Hovered, Active, Selected, Index)
                if (Active) then 
                    index.chips = Index;
                end
                if (Selected) then 
                    TriggerServerEvent('buychips:TryChipPayment', chipSizes[Index])
                end
                
            end)        
            RageUI.List("Trade In Chips", chipSizes, index.tradeinchips, "Press Enter to trade in selected amount", {}, true, function(Hovered, Active, Selected, Index)
                if (Active) then 
                    index.tradeinchips = Index;
                end
                if (Selected) then 
                    TriggerServerEvent('buychips:PerformTradeIn', chipSizes[Index])
                end
                
            end)        

        end, function()

        end)
    end
end)

Citizen.CreateThread(function()
    while true do 
        if Vdist2(GetEntityCoords(PlayerPedId(-1)), casinoBuyChipsVector.x, casinoBuyChipsVector.y, casinoBuyChipsVector.z) <= 1.4 then
            RageUI.Visible(RMenu:Get('casino_buychips', 'casino'), true)
        elseif Vdist2(GetEntityCoords(PlayerPedId(-1)), casinoBuyChipsVector.x, casinoBuyChipsVector.y, casinoBuyChipsVector.z) <= 2.5 then
            RageUI.Visible(RMenu:Get('casino_buychips', 'casino'), false)
        end
        DrawMarker(27, casinoBuyChipsVector.x, casinoBuyChipsVector.y, casinoBuyChipsVector.z-1.0, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255,255,255, 200, 0, 0, 0, 0)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('buychips:isInCasino')
AddEventHandler('buychips:isInCasino', function(bool) 
    TriggerServerEvent('buychips:GetAmountofchips')
    isInCasino = bool
end)
RegisterNetEvent('buychips:GotAmountOfChips')
AddEventHandler('buychips:GotAmountOfChips', function(amount) 
    playerAmountOfChips = amount
end)
RegisterNetEvent('buychips:updatehud+')
AddEventHandler('buychips:updatehud+', function(amount) 
    local newAmount = playerAmountOfChips + amount
    playerAmountOfChips = newAmount
end)
RegisterNetEvent('buychips:updatehud-')
AddEventHandler('buychips:updatehud-', function(amount) 
    if amount <= playerAmountOfChips then 
        local newAmount = playerAmountOfChips - amount
        playerAmountOfChips = newAmount
    end

end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(5)
        if isInCasino then 
            drawTxt("Your Chips: "..tostring(math.round(playerAmountOfChips)) , 255,255,255,255, 0.01,0.7599, 0.5,0.5, 7)
        end
    end
end)
--[[Random Functions]]
function drawTxt(txt,r,g,b,a,x,y,s1,s2,f) 
    SetTextFont(f) -- 0-4
    SetTextScale(s1, s2) -- Size of text
    SetTextColour(r, g, b, a) -- RGBA
    SetTextEntry("STRING")
    AddTextComponentString(txt) -- Main Text string
    DrawText( x,y) -- x,y of the screen
end


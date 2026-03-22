-- Fake Nick ТОЛЬКО для Tohan76 (реал-тайм ввод в табличке) — Adopt Me 2026
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local TARGET_NICK = "Tohan76"                -- ←←← ник, которого подменяем (реальный)
local currentFakeNick = "Fake"               -- начальное значение (будет меняться при вводе)

-- Создаём GUI
local sg = Instance.new("ScreenGui")
sg.Name = "FakeNickForTohan"
sg.ResetOnSpawn = false
sg.Parent = CoreGui

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.12, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
title.Text = "Fake для Tohan76 (пиши сюда)"
title.TextColor3 = Color3.fromRGB(180, 210, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.92, 0, 0, 40)
input.Position = UDim2.new(0.04, 0, 0.25, 0)
input.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
input.TextColor3 = Color3.new(1,1,1)
input.PlaceholderText = "Введи новый ник..."
input.Text = currentFakeNick
input.TextSize = 17
input.ClearTextOnFocus = false

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.92, 0, 0, 40)
status.Position = UDim2.new(0.04, 0, 0.58, 0)
status.BackgroundTransparency = 1
status.Text = "Ожидание трейда с Tohan76... Текущий фейк: " .. currentFakeNick
status.TextColor3 = Color3.fromRGB(160, 160, 190)
status.TextSize = 14
status.TextWrapped = true

-- Реал-тайм обновление при вводе текста
input:GetPropertyChangedSignal("Text"):Connect(function()
    currentFakeNick = input.Text:match("^%s*(.-)%s*$") or "NoName"  -- убираем пробелы по краям
    if currentFakeNick == "" then currentFakeNick = "NoName" end
    status.Text = "Фейк: " .. currentFakeNick .. " | Ждём Tohan76 в трейде"
end)

-- Функция поиска и подмены (только если партнёр — Tohan76)
local function tryReplaceNick()
    pcall(function()
        -- Ищем контейнер трейда (вариации названий на 2025–2026)
        local robloxGui = CoreGui:FindFirstChild("RobloxGui")
        if not robloxGui then return end
        
        local tradeUI = robloxGui:FindFirstChild("TradeApp", true) 
                     or robloxGui:FindFirstChild("TradeFrame", true)
                     or robloxGui:FindFirstChild("TradeOverlay", true)
                     or robloxGui:FindFirstChildWhichIsA("Frame", true)  -- на крайний случай
        
        if not tradeUI or not tradeUI.Visible then return end
        
        local yourName = player.Name:lower()
        local foundTarget = false
        local partnerName = nil
        
        -- Сначала ищем реальное имя партнёра
        for _, obj in pairs(tradeUI:GetDescendants()) do
            if obj:IsA("TextLabel") then
                local txt = obj.Text:lower()
                if txt:find("trading with") or txt:find("with") or txt:find("partner") then
                    partnerName = obj.Text:gsub("Trading with%s*", ""):gsub("with%s*", ""):gsub("%s*$", "")
                    if partnerName:lower() == TARGET_NICK:lower() then
                        foundTarget = true
                    end
                    break
                elseif #txt > 3 and #txt < 20 and txt ~= yourName and not txt:find("you") and not txt:find("your") then
                    -- запасной вариант: просто текст, похожий на ник
                    partnerName = txt
                    if partnerName:lower() == TARGET_NICK:lower() then
                        foundTarget = true
                    end
                end
            end
        end
        
        if not foundTarget then return end
        
        -- Если нашли — меняем все подходящие TextLabel'ы
        local changed = false
        for _, v in pairs(tradeUI:GetDescendants()) do
            if v:IsA("TextLabel") and v.Text ~= "" then
                local t = v.Text:lower()
                if t:find(TARGET_NICK:lower()) or (partnerName and t == partnerName:lower()) 
                    or t:find("trading with") or t:find("partner") or (#t > 3 and #t < 20 and not t:find(yourName)) then
                    
                    if v.Text ~= currentFakeNick then
                        v.Text = currentFakeNick
                        changed = true
                        
                        -- Убираем stroke/обводку, если мешает
                        local stroke = v:FindFirstChildWhichIsA("UIStroke") or v:FindFirstChildWhichIsA("UITextStroke")
                        if stroke then stroke.Enabled = false end
                    end
                end
            end
        end
        
        if changed then
            status.Text = "Подмена для Tohan76 → " .. currentFakeNick .. " (работает!)"
        end
    end)
end

-- Цикл проверки каждые 0.25 сек
spawn(function()
    while true do
        tryReplaceNick()
        task.wait(0.25)
    end
end)

print("Скрипт запущен: подмена ника ТОЛЬКО для Tohan76 на то, что введёшь в окошко")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fake Nick для Tohan76",
    Text = "Окошко появилось. Пиши ник — если Tohan76 в трейде, его ник заменится",
    Duration = 10
})

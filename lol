-- Fake Nick ТОЛЬКО для tohan76 (lowercase версия) — Adopt Me 2026
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local TARGET_LOWER = "tohan76"               -- ←←← lowercase версия ника
local currentFakeNick = "Fake"               -- начальное

-- GUI
local sg = Instance.new("ScreenGui")
sg.Name = "FakeForTohanLower"
sg.ResetOnSpawn = false
sg.Parent = CoreGui

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 320, 0, 160)
frame.Position = UDim2.new(0.5, -160, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
title.Text = "Fake ник для tohan76 (вводи сюда)"
title.TextColor3 = Color3.fromRGB(200, 220, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.92, 0, 0, 45)
input.Position = UDim2.new(0.04, 0, 0.28, 0)
input.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
input.TextColor3 = Color3.new(1,1,1)
input.PlaceholderText = "Новый ник..."
input.Text = currentFakeNick
input.TextSize = 18
input.ClearTextOnFocus = false

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.92, 0, 0, 40)
status.Position = UDim2.new(0.04, 0, 0.6, 0)
status.BackgroundTransparency = 1
status.Text = "Ждём трейд с tohan76... Фейк: " .. currentFakeNick
status.TextColor3 = Color3.fromRGB(150, 150, 190)
status.TextSize = 15
status.TextWrapped = true

-- Обновление при вводе
input:GetPropertyChangedSignal("Text"):Connect(function()
    currentFakeNick = input.Text:match("^%s*(.-)%s*$") or "NoName"
    if currentFakeNick == "" then currentFakeNick = "NoName" end
    status.Text = "Фейк обновлён: " .. currentFakeNick .. " (для tohan76)"
end)

-- Функция подмены
local function tryFake()
    pcall(function()
        local robloxGui = CoreGui:FindFirstChild("RobloxGui")
        if not robloxGui then return end
        
        -- Пробуем разные возможные контейнеры трейда (2026 вариации)
        local tradeContainers = {
            robloxGui:FindFirstChild("TradeApp", true),
            robloxGui:FindFirstChild("TradeFrame", true),
            robloxGui:FindFirstChild("TradeOverlay", true),
            robloxGui:FindFirstChild("TradeUI", true),
            robloxGui:FindFirstChildWhichIsA("ScreenGui", true)  -- запасной
        }
        
        local tradeUI = nil
        for _, cont in ipairs(tradeContainers) do
            if cont and cont.Visible and cont:IsDescendantOf(robloxGui) then
                tradeUI = cont
                break
            end
        end
        
        if not tradeUI then return end
        
        local yourLower = player.Name:lower()
        local found = false
        
        -- Поиск ника партнёра
        for _, v in pairs(tradeUI:GetDescendants()) do
            if v:IsA("TextLabel") and v.Text ~= "" then
                local txtLower = v.Text:lower():gsub("%s+", "")  -- убираем пробелы для сравнения
                
                if txtLower == TARGET_LOWER or txtLower:find(TARGET_LOWER) then
                    found = true
                    -- Меняем этот лейбл и похожие
                    if v.Text ~= currentFakeNick then
                        v.Text = currentFakeNick
                        status.Text = "Подмена! → " .. currentFakeNick
                        
                        -- Отключаем stroke если есть
                        for _, child in pairs(v:GetChildren()) do
                            if child:IsA("UIStroke") or child:IsA("UITextStroke") then
                                child.Enabled = false
                            end
                        end
                    end
                end
            end
        end
        
        if not found then
            status.Text = "tohan76 не найден в этом трейде (или UI изменился)"
        end
    end)
end

spawn(function()
    while true do
        tryFake()
        task.wait(0.3)
    end
end)

print("Запущен fake для lowercase 'tohan76' → вводи в окошко")

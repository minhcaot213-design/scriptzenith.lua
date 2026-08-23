-- [[ ZENITH HUB - V61 PERFECT FLIGHT & NO-RESET CORE ]] --
-- Khắc phục 100% lỗi tele qua tele lại, không bị reset nhân vật.
-- Giữ nguyên UI Lột Xác, Song ngữ VN/EN, Chống cháy sáng và Universal Fast Attack.

task.wait(0.5)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

-- Chống AFK Kick
pcall(function() for _, v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end end)
LocalPlayer.Idled:Connect(function() pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end)

-- Biến toàn cục hệ thống
_G.AutoFarm = false
_G.AutoQuest = true
_G.BringMonster = true
_G.FastAttack = true
_G.SelectWeapon = "Melee"
_G.GlobalFarmActive = false 

_G.AutoStats = false
_G.StatsAmount = 1
_G.StatsMelee = false
_G.StatsDefense = false
_G.StatsSword = false
_G.StatsFruit = false

_G.ESPPlayer = false
_G.ESPChest = false
_G.Language = "VN"

local StartBring = false
local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

local Loc = {
    VN = {
        Title = "ZENITH HUB <font color='#00d2ff'>• V61 ULTIMATE</font>",
        Farm = "Cày Cấp", Stats = "Nâng Điểm", Fruit = "Trái Ác Quỷ", ESP = "Nhìn Xuyên", Teleport = "Dịch Chuyển", Shop = "Cửa Hàng", Misc = "Cài Đặt",
        StatusReady = "Trạng thái: Sẵn sàng bay lượn tàn sát!",
        ToggleFarm = "⚡ Auto Farm Level",
        ToggleQuest = "📜 Tự Nhận Nhiệm Vụ",
        ToggleBring = "🧲 Kéo Quái (Bring Mob)",
        ToggleFast = "⚔️ Fast Attack (Chống Lag Cháy Sáng)",
        ToggleStats = "📈 Auto Nâng Điểm",
        BtnGacha = "🎲 Random Fruit (Gacha)",
        BtnStore = "📦 Cất Tất Cả Trái Vào Rương",
        ToggleESPPlr = "👁️ ESP Người Chơi",
        ToggleESPChest = "📦 ESP Rương Kho Báu",
        BtnSea1 = "🏝️ Dịch Chuyển Sea 1",
        BtnSea2 = "🏝️ Dịch Chuyển Sea 2",
        BtnSea3 = "🏝️ Dịch Chuyển Sea 3",
        BtnGeppo = "🦵 Mua Geppo (10k)",
        BtnBuso = "🛡️ Mua Buso Haki (25k)",
        BtnSoru = "🏃 Mua Soru (100k)",
        BtnKen = "👁️ Mua Ken Haki (750k)",
        BtnCode = "🎁 Nhập Tất Cả Giftcode",
        ToggleLag = "🚀 Giảm Lag / Tắt Hiệu Ứng Lóa",
        BtnRejoin = "🔄 Vào Lại Server (Rejoin)"
    },
    EN = {
        Title = "ZENITH HUB <font color='#00d2ff'>• V61 ULTIMATE</font>",
        Farm = "Auto Farm", Stats = "Stats", Fruit = "Blox Fruit", ESP = "Visuals", Teleport = "Teleport", Shop = "Shop", Misc = "Settings",
        StatusReady = "Status: Ready for smooth flying!",
        ToggleFarm = "⚡ Auto Farm Level",
        ToggleQuest = "📜 Auto Quest",
        ToggleBring = "🧲 Bring Mob (Ground Magnet)",
        ToggleFast = "⚔️ Fast Attack (Anti-Flash Optimization)",
        ToggleStats = "📈 Auto Upgrade Stats",
        BtnGacha = "🎲 Random Fruit (Gacha)",
        BtnStore = "📦 Store All Fruits",
        ToggleESPPlr = "👁️ ESP Players",
        ToggleESPChest = "📦 ESP Chests",
        BtnSea1 = "🏝️ Teleport Sea 1",
        BtnSea2 = "🏝️ Teleport Sea 2",
        BtnSea3 = "🏝️ Teleport Sea 3",
        BtnGeppo = "🦵 Buy Geppo (10k)",
        BtnBuso = "🛡️ Buy Buso Haki (25k)",
        BtnSoru = "🏃 Buy Soru (100k)",
        BtnKen = "👁️ Buy Ken Haki (750k)",
        BtnCode = "🎁 Redeem All Codes",
        ToggleLag = "🚀 Low Graphics / Reduce Flash",
        BtnRejoin = "🔄 Rejoin Server"
    }
}

local function L(key)
    local lang = _G.Language or "VN"
    return Loc[lang][key] or Loc["VN"][key] or key
end

-- =========================================================
-- KHỞI TẠO GIAO DIỆN ZENITH V61
-- =========================================================
local UI_NAME = "ZenithHub_V61_Ultimate"
pcall(function() if game:GetService("CoreGui"):FindFirstChild(UI_NAME) then game:GetService("CoreGui")[UI_NAME]:Destroy() end end)
pcall(function() if LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then LocalPlayer.PlayerGui[UI_NAME]:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME; ScreenGui.ResetOnSpawn = false
local s, p = pcall(function() return gethui() end)
if s and p then ScreenGui.Parent = p else ScreenGui.Parent = game:GetService("CoreGui") end

local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 50, 0, 50); FloatingButton.Position = UDim2.new(0.05, 0, 0.4, 0); FloatingButton.BackgroundColor3 = Color3.fromRGB(18, 22, 33); FloatingButton.Visible = false; FloatingButton.Text = "Z"; FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255); FloatingButton.Font = Enum.Font.GothamBlack; FloatingButton.TextSize = 22; FloatingButton.ZIndex = 999
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 14)
local fStroke = Instance.new("UIStroke", FloatingButton); fStroke.Color = Color3.fromRGB(0, 210, 255); fStroke.Thickness = 2

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 580, 0, 370); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(13, 17, 26); MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", MainFrame); mStroke.Color = Color3.fromRGB(0, 190, 255); mStroke.Thickness = 1.5

local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end end)
FloatingButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = FloatingButton.Position end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if MainFrame.Visible then MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        else FloatingButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end
    end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 42); TopBar.BackgroundColor3 = Color3.fromRGB(18, 23, 35); TopBar.BorderSizePixel = 0
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 350, 1, 0); Title.Position = UDim2.new(0, 16, 0, 0); Title.BackgroundTransparency = 1; Title.RichText = true; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = L("Title")

local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 26, 0, 26); CloseBtn.Position = UDim2.new(1, -32, 0.5, -13); CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 59, 90); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 11; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
local MinBtn = Instance.new("TextButton", TopBar); MinBtn.Size = UDim2.new(0, 26, 0, 26); MinBtn.Position = UDim2.new(1, -66, 0.5, -13); MinBtn.BackgroundColor3 = Color3.fromRGB(30, 38, 54); MinBtn.Text = "−"; MinBtn.TextColor3 = Color3.fromRGB(200, 210, 230); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 14; Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)
FloatingButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; FloatingButton.Visible = false end)
local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    MainFrame:TweenSize(isMin and UDim2.new(0, 580, 0, 42) or UDim2.new(0, 580, 0, 370), "Out", "Quart", 0.25, true)
end)

local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Name = "Sidebar"; Sidebar.Size = UDim2.new(0, 165, 1, -42); Sidebar.Position = UDim2.new(0, 0, 0, 42); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 20, 30); Sidebar.BorderSizePixel = 0
local TabScroller = Instance.new("ScrollingFrame", Sidebar); TabScroller.Size = UDim2.new(1, -10, 1, -12); TabScroller.Position = UDim2.new(0, 5, 0, 6); TabScroller.BackgroundTransparency = 1; TabScroller.BorderSizePixel = 0; TabScroller.ScrollBarThickness = 3; TabScroller.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIPadding", TabScroller).PaddingTop = UDim.new(0, 4)
local TabListLayout = Instance.new("UIListLayout", TabScroller); TabListLayout.Padding = UDim.new(0, 5); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContentContainer = Instance.new("Frame", MainFrame); ContentContainer.Size = UDim2.new(1, -165, 1, -42); ContentContainer.Position = UDim2.new(0, 165, 0, 42); ContentContainer.BackgroundTransparency = 1

local tabButtons, tabPages = {}, {}
local function createTab(nameKey, icon, labelKey)
    local btn = Instance.new("TextButton", TabScroller); btn.Size = UDim2.new(1, -4, 0, 34); btn.BackgroundColor3 = Color3.fromRGB(22, 28, 41); btn.TextColor3 = Color3.fromRGB(165, 175, 195); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Text = "  " .. icon .. "   " .. L(labelKey)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local Pill = Instance.new("Frame", btn); Pill.Size = UDim2.new(0, 3, 0, 20); Pill.Position = UDim2.new(0, 0, 0.5, -10); Pill.BackgroundColor3 = Color3.fromRGB(0, 210, 255); Pill.Visible = false; Instance.new("UICorner", Pill).CornerRadius = UDim.new(0, 2)
    
    local page = Instance.new("ScrollingFrame", ContentContainer); page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0; page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.Visible = false
    local pl = Instance.new("UIListLayout", page); pl.Padding = UDim.new(0, 7); pl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 12); Instance.new("UIPadding", page).PaddingBottom = UDim.new(0, 12)

    tabButtons[nameKey] = {Button = btn, Pill = Pill, Key = labelKey}; tabPages[nameKey] = page
    btn.MouseButton1Click:Connect(function()
        for tName, item in pairs(tabButtons) do
            local act = (tName == nameKey)
            item.Button.BackgroundColor3 = act and Color3.fromRGB(0, 140, 230) or Color3.fromRGB(22, 28, 41)
            item.Button.TextColor3 = act and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(165, 175, 195)
            item.Pill.Visible = act
        end
        for pName, p in pairs(tabPages) do p.Visible = (pName == nameKey) end
    end)
    return page
end

local function createToggle(page, labelKey, defaultState, callback)
    local state = defaultState
    local frame = Instance.new("Frame", page); frame.Size = UDim2.new(0.95, 0, 0, 36); frame.BackgroundColor3 = Color3.fromRGB(19, 25, 36); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", frame); stroke.Color = Color3.fromRGB(35, 45, 65); stroke.Thickness = 1
    
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, -55, 1, 0); label.Position = UDim2.new(0, 12, 0, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(230, 235, 245); label.Font = Enum.Font.GothamMedium; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = L(labelKey)
    local switch = Instance.new("TextButton", frame); switch.Size = UDim2.new(0, 36, 0, 18); switch.Position = UDim2.new(1, -45, 0.5, -9); switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(40, 48, 65); switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch); circle.Size = UDim2.new(0, 14, 0, 14); circle.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    switch.MouseButton1Click:Connect(function()
        state = not state; switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(40, 48, 65)
        circle:TweenPosition(state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.15, true)
        if callback then callback(state) end
    end)
end

local function createButton(page, labelKey, callback)
    local btn = Instance.new("TextButton", page); btn.Size = UDim2.new(0.95, 0, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(22, 30, 45); Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = Color3.fromRGB(0, 170, 230); stroke.Thickness = 1; stroke.Transparency = 0.3
    btn.TextColor3 = Color3.fromRGB(0, 210, 255); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 12; btn.Text = L(labelKey)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- TẠO CÁC TAB CHUẨN
local pFarm = createTab("Farm", "🌾", "Farm")
local pStats = createTab("Stats", "📈", "Stats")
local pFruit = createTab("Fruit", "🍎", "Fruit")
local pESP = createTab("ESP", "👁️", "ESP")
local pTele = createTab("Teleport", "🚀", "Teleport")
local pShop = createTab("Shop", "🛒", "Shop")
local pMisc = createTab("Misc", "⚙️", "Misc")

tabButtons["Farm"].Button.BackgroundColor3 = Color3.fromRGB(0, 140, 230); tabButtons["Farm"].Button.TextColor3 = Color3.fromRGB(255, 255, 255); tabButtons["Farm"].Pill.Visible = true; tabPages["Farm"].Visible = true

-- [ TAB FARM ]
local infoLabel = Instance.new("TextLabel", pFarm); infoLabel.Size = UDim2.new(0.95, 0, 0, 25); infoLabel.BackgroundTransparency = 1; infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150); infoLabel.Font = Enum.Font.GothamBold; infoLabel.TextSize = 12; infoLabel.Text = L("StatusReady")
local weaponSegment = Instance.new("Frame", pFarm); weaponSegment.Size = UDim2.new(0.95, 0, 0, 30); weaponSegment.BackgroundColor3 = Color3.fromRGB(16, 21, 31); Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", weaponSegment); wsLayout.FillDirection = Enum.FillDirection.Horizontal; wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; wsLayout.Padding = UDim.new(0, 4)

for _, wName in ipairs({"Melee", "Sword", "Blox Fruit"}) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size = UDim2.new(0.3, 0, 0.8, 0); b.BackgroundColor3 = _G.SelectWeapon == wName and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48); b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.GothamMedium; b.TextSize = 11; b.Text = wName; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function() _G.SelectWeapon = wName; for _, btn in pairs(weaponSegment:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = btn.Text == wName and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48) end end end)
end

createToggle(pFarm, "ToggleFarm", false, function(v) _G.AutoFarm = v end)
createToggle(pFarm, "ToggleQuest", true, function(v) _G.AutoQuest = v end)
createToggle(pFarm, "ToggleBring", true, function(v) _G.BringMonster = v end)
createToggle(pFarm, "ToggleFast", true, function(v) _G.FastAttack = v end)

-- [ TAB STATS ]
createToggle(pStats, "ToggleStats", false, function(v) _G.AutoStats = v end)
local statsAmtSeg = Instance.new("Frame", pStats); statsAmtSeg.Size = UDim2.new(0.95, 0, 0, 32); statsAmtSeg.BackgroundColor3 = Color3.fromRGB(16, 21, 31); Instance.new("UICorner", statsAmtSeg).CornerRadius = UDim.new(0, 6)
local saLayout = Instance.new("UIListLayout", statsAmtSeg); saLayout.FillDirection = Enum.FillDirection.Horizontal; saLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; saLayout.VerticalAlignment = Enum.VerticalAlignment.Center; saLayout.Padding = UDim.new(0, 3)

for _, amt in ipairs({1, 3, 10, 25, 50, 100}) do
    local ab = Instance.new("TextButton", statsAmtSeg)
    ab.Size = UDim2.new(0.15, 0, 0.8, 0); ab.BackgroundColor3 = _G.StatsAmount == amt and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48); ab.TextColor3 = Color3.fromRGB(255, 255, 255); ab.Font = Enum.Font.GothamBold; ab.TextSize = 11; ab.Text = tostring(amt); Instance.new("UICorner", ab).CornerRadius = UDim.new(0, 4)
    ab.MouseButton1Click:Connect(function()
        _G.StatsAmount = amt
        for _, btn in pairs(statsAmtSeg:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = (btn.Text == tostring(amt)) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48) end end
    end)
end

createToggle(pStats, "🥊 Melee", false, function(v) _G.StatsMelee = v end)
createToggle(pStats, "🛡️ Defense", false, function(v) _G.StatsDefense = v end)
createToggle(pStats, "⚔️ Sword", false, function(v) _G.StatsSword = v end)
createToggle(pStats, "🍎 Blox Fruit", false, function(v) _G.StatsFruit = v end)

-- [ TAB FRUITS ]
createButton(pFruit, "BtnGacha", function() if CommF then CommF:InvokeServer("Cousin", "Buy") end end)
createButton(pFruit, "BtnStore", function() for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") then CommF:InvokeServer("StoreFruit", string.split(v.Name, "-")[1], v) end end end)

-- [ TAB ESP ]
createToggle(pESP, "ToggleESPPlr", false, function(v) _G.ESPPlayer = v end)
createToggle(pESP, "ToggleESPChest", false, function(v) _G.ESPChest = v end)

-- [ TAB TELEPORT ]
createButton(pTele, "BtnSea1", function() if CommF then CommF:InvokeServer("TravelMain") end end)
createButton(pTele, "BtnSea2", function() if CommF then CommF:InvokeServer("TravelDressrosa") end end)
createButton(pTele, "BtnSea3", function() if CommF then CommF:InvokeServer("TravelZou") end end)

-- [ TAB SHOP ]
createButton(pShop, "BtnGeppo", function() if CommF then CommF:InvokeServer("BuyHaki", "Geppo") end end)
createButton(pShop, "BtnBuso", function() if CommF then CommF:InvokeServer("BuyHaki", "Buso") end end)
createButton(pShop, "BtnSoru", function() if CommF then CommF:InvokeServer("BuyHaki", "Soru") end end)
createButton(pShop, "BtnKen", function() if CommF then CommF:InvokeServer("KenTalk", "Buy") end end)

-- [ TAB MISC - CÀI ĐẶT NGÔN NGỮ ]
local langSeg = Instance.new("Frame", pMisc); langSeg.Size = UDim2.new(0.95, 0, 0, 35); langSeg.BackgroundColor3 = Color3.fromRGB(16, 21, 31); Instance.new("UICorner", langSeg).CornerRadius = UDim.new(0, 6)
local lgLayout = Instance.new("UIListLayout", langSeg); lgLayout.FillDirection = Enum.FillDirection.Horizontal; lgLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; lgLayout.VerticalAlignment = Enum.VerticalAlignment.Center; lgLayout.Padding = UDim.new(0, 6)

local langLabel = Instance.new("TextLabel", langSeg); langLabel.Size = UDim2.new(0.55, 0, 1, 0); langLabel.BackgroundTransparency = 1; langLabel.TextColor3 = Color3.fromRGB(220, 225, 235); langLabel.Font = Enum.Font.GothamMedium; langLabel.TextSize = 11; langLabel.Text = "🌐 Ngôn ngữ / Language:"
for _, lg in ipairs({"VN", "EN"}) do
    local lb = Instance.new("TextButton", langSeg)
    lb.Size = UDim2.new(0.18, 0, 0.75, 0); lb.BackgroundColor3 = _G.Language == lg and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48); lb.TextColor3 = Color3.fromRGB(255, 255, 255); lb.Font = Enum.Font.GothamBold; lb.TextSize = 11; lb.Text = lg; Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 4)
    lb.MouseButton1Click:Connect(function()
        _G.Language = lg
        Title.Text = L("Title")
        for _, tabKey in pairs({"Farm", "Stats", "Fruit", "ESP", "Teleport", "Shop", "Misc"}) do
            if tabButtons[tabKey] then
                local icon = (tabKey == "Farm" and "🌾" or tabKey == "Stats" and "📈" or tabKey == "Fruit" and "🍎" or tabKey == "ESP" and "👁️" or tabKey == "Teleport" and "🚀" or tabKey == "Shop" and "🛒" or "⚙️")
                tabButtons[tabKey].Button.Text = "  " .. icon .. "   " .. L(tabButtons[tabKey].Key)
            end
        end
        for _, btn in pairs(langSeg:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = (btn.Text == lg) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48) end end
    end)
end

createButton(pMisc, "BtnCode", function() local codes = {"ADMINHACKED", "ADMINDARES", "SECRET_ADMIN", "NOOB2PRO"}; task.spawn(function() for _, c in ipairs(codes) do pcall(function() CommF:InvokeServer("RedeemCustomCode", c) end); task.wait(0.2) end end) end)
createToggle(pMisc, "ToggleLag", false, function(v) Lighting.GlobalShadows = not v; if v then for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.SmoothPlastic end end end end)
createButton(pMisc, "BtnRejoin", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)

-- =========================================================
-- LOGIC DI CHUYỂN MƯỢT MÀ KHÔNG BAO GIỜ RESET NHÂN VẬT
-- =========================================================
local currentTween = nil

function topos(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart

    if not hrp:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity"); bv.Name = "BodyClip"; bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Velocity = Vector3.zero; bv.Parent = hrp
    end
    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end

    local dist = (targetCFrame.Position - hrp.Position).Magnitude
    if dist > 1500 then
        -- Dịch chuyển trực tiếp an toàn tuyệt đối không bao giờ xóa đầu hay reset
        hrp.CFrame = targetCFrame
        task.wait(0.1)
        hrp.CFrame = targetCFrame
    else
        if currentTween then currentTween:Cancel() end
        local tweenInfo = TweenInfo.new(dist / 300, Enum.EasingStyle.Linear)
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        currentTween:Play()
    end
end

function EquipWeapon(weaponType)
    pcall(function()
        if not LocalPlayer.Character:FindFirstChild("HasBuso") then CommF:InvokeServer("Buso") end
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:WaitForChild("Backpack")
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool then
            if weaponType == "Melee" and (currentTool.ToolTip == "Melee" or currentTool.Name == "Combat" or currentTool.Name == "Võ Tân Binh") then return end
            if weaponType == "Sword" and currentTool.ToolTip == "Sword" then return end
            if weaponType == "Blox Fruit" and currentTool.ToolTip == "Blox Fruit" then return end
        end
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if weaponType == "Melee" and (tool.ToolTip == "Melee" or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then char.Humanoid:EquipTool(tool); break
                elseif weaponType == "Sword" and tool.ToolTip == "Sword" then char.Humanoid:EquipTool(tool); break
                elseif weaponType == "Blox Fruit" and tool.ToolTip == "Blox Fruit" then char.Humanoid:EquipTool(tool); break end
            end
        end
    end)
end

local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon
function CheckQuest()
    local MyLevel = LocalPlayer.Data.Level.Value
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"; CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42); CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
        elseif MyLevel >= 10 and MyLevel <= 14 then Mon = "Monkey"; LevelQuest = 1; NameQuest = "JungleQuest"; NameMon = "Monkey"; CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37); CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)
        elseif MyLevel >= 15 and MyLevel <= 29 then Mon = "Gorilla"; LevelQuest = 2; NameQuest = "JungleQuest"; NameMon = "Gorilla"; CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37); CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)
        elseif MyLevel >= 30 and MyLevel <= 39 then Mon = "Pirate"; LevelQuest = 1; NameQuest = "BuggyQuest1"; NameMon = "Pirate"; CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54); CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)
        elseif MyLevel >= 40 and MyLevel <= 59 then Mon = "Brute"; LevelQuest = 2; NameQuest = "BuggyQuest1"; NameMon = "Brute"; CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54); CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)
        else Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"; CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42); CFrameMon = CFrame.new(1045.96, 27.00, 1560.82) end
    else Mon = "Raider"; LevelQuest = 1; NameQuest = "Area1Quest"; NameMon = "Raider"; CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18); CFrameMon = CFrame.new(-728.32, 52.77, 2345.77) end
end

spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                local questGui = LocalPlayer.PlayerGui.Main.Quest
                local questText = questGui.Container.QuestTitle.Title.Text
                if not questGui.Visible then
                    StartBring = false; _G.GlobalFarmActive = false
                    if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 20 then topos(CFrameQuest)
                    else if _G.AutoQuest and CommF then CommF:InvokeServer("StartQuest", NameQuest, LevelQuest) end end
                elseif not string.find(questText, NameMon) then
                    StartBring = false; _G.GlobalFarmActive = false; if CommF then CommF:InvokeServer("AbandonQuest") end
                else
                    local foundMob = false
                    for _, v512 in pairs(Workspace.Enemies:GetChildren()) do
                        if v512:FindFirstChild("HumanoidRootPart") and v512:FindFirstChild("Humanoid") and v512.Humanoid.Health > 0 and v512.Name == Mon then
                            foundMob = true
                            repeat
                                task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                local hrp = LocalPlayer.Character.HumanoidRootPart
                                topos(CFrameMon * CFrame.new(0, 15, 0))
                                hrp.CFrame = CFrame.lookAt(hrp.Position, v512.HumanoidRootPart.Position)
                                v512.HumanoidRootPart.CanCollide = false; v512.Humanoid.WalkSpeed = 0; v512.Head.CanCollide = false; v512.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                StartBring = true; _G.GlobalFarmActive = true
                                VirtualUser:CaptureController(); VirtualUser:Button1Down(Vector2.new(1280, 672))
                            until not _G.AutoFarm or v512.Humanoid.Health <= 0 or not v512.Parent or questGui.Visible == false
                        end
                    end
                    if not foundMob then StartBring = false; _G.GlobalFarmActive = false; topos(CFrameMon) end
                end
            end)
        else _G.GlobalFarmActive = false end
    end
end)

spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarm and _G.BringMonster and StartBring then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                for _, v1167 in pairs(Workspace.Enemies:GetChildren()) do
                    if v1167.Name == Mon and v1167:FindFirstChild("Humanoid") and v1167:FindFirstChild("HumanoidRootPart") and v1167.Humanoid.Health > 0 then
                        if (v1167.HumanoidRootPart.Position - hrp.Position).Magnitude <= 320 then
                            v1167.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v1167.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, -15, 0)
                            v1167.HumanoidRootPart.CanCollide = false; v1167.Head.CanCollide = false
                            if v1167.Humanoid:FindFirstChild("Animator") then v1167.Humanoid.Animator:Destroy() end
                            v1167.Humanoid:ChangeState(11)
                            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                end
            end
        end)
    end
end)

-- Lõi Fast Attack tối ưu hóa mượt mà chống giật lag
local v1 = next; local v2 = {ReplicatedStorage.Util, ReplicatedStorage.Common, ReplicatedStorage.Remotes, ReplicatedStorage.Assets, ReplicatedStorage.FX}; local v3, u4, u5 = nil, nil, nil
task.spawn(function()
    while true do
        local v6; v3, v6 = v1(v2, v3)
        if v3 == nil then break end
        local v7 = next; local v8, v9 = v6:GetChildren()
        while true do
            local v10; v9, v10 = v7(v8, v9)
            if v9 == nil then break end
            if v10:IsA('RemoteEvent') and v10:GetAttribute('Id') then u5 = v10:GetAttribute('Id'); u4 = v10 end
        end
        v6.ChildAdded:Connect(function(p11) if p11:IsA('RemoteEvent') and p11:GetAttribute('Id') then u5 = p11:GetAttribute('Id'); u4 = p11 end end)
    end
end)

task.spawn(function()
    while task.wait(0.00001) do
        if (_G.AutoFarm or _G.GlobalFarmActive) and _G.FastAttack then
            pcall(function()
                local _Character = LocalPlayer.Character; local v13 = _Character and _Character:FindFirstChild('HumanoidRootPart'); if not v13 then return end
                local v14, v15, v16 = ipairs({Workspace.Enemies, Workspace.Characters}); local u17 = {}
                while true do
                    local v18; v16, v18 = v14(v15, v16); if v16 == nil then break end
                    local v19, v20, v21 = ipairs(v18 and v18:GetChildren() or {})
                    while true do
                        local v22; v21, v22 = v19(v20, v21); if v21 == nil then break end
                        local _HumanoidRootPart = v22:FindFirstChild('HumanoidRootPart'); local _Humanoid = v22:FindFirstChild('Humanoid')
                        if v22 ~= _Character and (_HumanoidRootPart and (_Humanoid and (_Humanoid.Health > 0 and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 80))) then
                            local v25, v26, v27 = ipairs(v22:GetChildren())
                            while true do
                                local v28; v27, v28 = v25(v26, v27); if v27 == nil then break end
                                if v28:IsA('BasePart') and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 80 then u17[#u17 + 1] = {v22, v28} end
                            end
                        end
                    end
                end
                local _Tool = _Character:FindFirstChildOfClass('Tool')
                if #u17 > 0 and _Tool then
                    pcall(function()
                        require(ReplicatedStorage.Modules.Net):RemoteEvent('RegisterHit', true)
                        ReplicatedStorage.Modules.Net['RE/RegisterAttack']:FireServer()
                        local _Head = u17[1][1]:FindFirstChild('Head')
                        if _Head then
                            ReplicatedStorage.Modules.Net['RE/RegisterHit']:FireServer(_Head, u17, {}, tostring(LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                            local r_u4 = (typeof(cloneref) == "function" and cloneref(u4)) or u4
                            if r_u4 then r_u4:FireServer(string.gsub('RE/RegisterHit', '.', function(p31) return string.char(bit32.bxor(string.byte(p31), math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1)) end), bit32.bxor(u5 + 909090, ReplicatedStorage.Modules.Net.seed:InvokeServer() * 2), _Head, u17) end
                        end
                    end)
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoStats and CommF then
            pcall(function()
                if LocalPlayer.Data.Points.Value > 0 then
                    local amt = _G.StatsAmount or 1
                    if _G.StatsMelee then CommF:InvokeServer("AddPoint", "Melee", amt) end
                    if _G.StatsDefense then CommF:InvokeServer("AddPoint", "Defense", amt) end
                    if _G.StatsSword then CommF:InvokeServer("AddPoint", "Sword", amt) end
                    if _G.StatsFruit then CommF:InvokeServer("AddPoint", "BloxFruit", amt) end
                end
            end)
        end
    end
end)

-- [[ ZENITH BLOX FRUIT - V18.0 (PERFECT LDPLAYER FIX)
--    CHỐNG GIẬT 100% + NHẬN NHIỆM VỤ CHUẨN + TWEEN BAY MƯỢT
-- ]] --

task.wait(0.5)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- =========================================================
-- SERVICES
-- =========================================================
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local CommF
pcall(function()
    CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
end)

-- =========================================================
-- CHỐNG VĂNG GAME AFK
-- =========================================================
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- =========================================================
-- BIẾN HỆ THỐNG
-- =========================================================
local selectedWeaponType = "Melee"
local AutoFarmLevel = false
local AutoQuest = true
local BringMob = true

local espPlayerEnabled = false
local espFruitEnabled = false
local espChest1Enabled = false
local espChest2Enabled = false
local espChest3Enabled = false

local speedValue = 16
local speedEnabled = false
local jumpValue = 50
local jumpEnabled = false

local AutoRandomFruit = false
local AutoCollectFruit = false
local AutoStoreFruit = false

local currentTween = nil
local isAttackingTarget = false
local lockedFarmPosition = nil
local currentTargetName = ""

-- =========================================================
-- DỌN DẸP GIAO DIỆN CŨ
-- =========================================================
local UI_NAME = "ZenithBloxFruit_Zyrox_V18"
local function GetSafeUIFolder()
    local folder
    pcall(function() if gethui then folder = gethui() end end)
    if not folder then pcall(function() folder = game:GetService("CoreGui") end) end
    if not folder then folder = LocalPlayer:WaitForChild("PlayerGui") end
    return folder
end

local targetUIFolder = GetSafeUIFolder()
pcall(function() for _, gui in ipairs(targetUIFolder:GetChildren()) do if gui.Name == UI_NAME then gui:Destroy() end end end)
pcall(function() for _, gui in ipairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do if gui.Name == UI_NAME then gui:Destroy() end end end)

-- =========================================================
-- NGÔN NGỮ
-- =========================================================
local currentLang = "VI"
local translatableElements = {}
local LangDict = {
    VI = {
        title = "ZYROX VN <font color='#00d2ff'>• V18.0 (HOÀN HẢO)</font>",
        tab_farm = "Farm Level", tab_fruit = "Trái Ác Quỷ", tab_pvp = "PVP & ESP",
        tab_server = "Máy Chủ", tab_raid = "Đi Raid", tab_item = "Farm Item", tab_setting = "Cài Đặt",
        auto_farm_level = "⚡ Tự Động Farm (Mượt Không Giật)", auto_quest = "📜 Tự Nhận Nhiệm Vụ", bring_mob = "🧲 Gom Quái Xuống Đất",
        fruit_buy = "🎲 Mua Ngẫu Nhiên Trái", fruit_collect = "🧲 Nhặt Trái Rơi", fruit_store = "📦 Cất Trái Vào Rương",
        speed_toggle = "Bật Chạy Nhanh", speed_slider = "Tốc Độ", jump_toggle = "Bật Nhảy Cao", jump_slider = "Lực Nhảy",
        player_esp = "ESP Người Chơi", fruit_esp = "ESP Trái Ác Quỷ", chest_wood = "ESP Rương Gỗ", chest_gold = "ESP Rương Vàng", chest_diamond = "ESP Rương Kim Cương",
        redeem_codes = "🎁 Nhập Code Game", rejoin_btn = "Vào Lại Server", serverhop_btn = "Chuyển Server",
        auto_raid_start = "Tự Động Mua Vé & Bắt Đầu Raid", auto_bones = "Tự Farm Xương (Bones)",
        lang_title = "Ngôn Ngữ / Language", ui_scale = "Thu Phóng UI (%)", ui_transparency = "Trong Suốt UI (%)", fix_lag = "Tối Ưu Đồ Họa (Tăng FPS)", close_hub = "Đóng Cửa Sổ"
    }
}

local function registerText(label, key, isRich)
    table.insert(translatableElements, {Label = label, Key = key, Rich = isRich})
    if LangDict[currentLang] and LangDict[currentLang][key] then label.Text = LangDict[currentLang][key] end
end

-- =========================================================
-- KHỞI TẠO GIAO DIỆN (GIỮ NGUYÊN KIẾN TRÚC MƯỢT CỦA BẠN)
-- =========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME; ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = targetUIFolder end)

local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 48, 0, 48); FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5); FloatingButton.Position = UDim2.new(0.1, 0, 0.5, 0); FloatingButton.BackgroundColor3 = Color3.fromRGB(13, 16, 22); FloatingButton.Visible = false; FloatingButton.Text = "Z"; FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255); FloatingButton.Font = Enum.Font.GothamBlack; FloatingButton.TextSize = 24; FloatingButton.ZIndex = 999
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
local floatingStroke = Instance.new("UIStroke", FloatingButton); floatingStroke.Color = Color3.fromRGB(0, 210, 255); floatingStroke.Thickness = 1.5

local FULL_HEIGHT = 350; local MIN_HEIGHT = 38
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, FULL_HEIGHT); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19); MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true
local UIScale = Instance.new("UIScale", MainFrame)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 5)
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = Color3.fromRGB(32, 40, 55); MainStroke.Thickness = 1

local isDraggingWindow, isDraggingFloating = false, false
local dragStartPos, frameStartPos

MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingWindow = true; dragStartPos = input.Position; frameStartPos = MainFrame.Position end end)
FloatingButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingFloating = true; dragStartPos = input.Position; frameStartPos = FloatingButton.Position end end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if isDraggingFloating then isDraggingFloating = false; if dragStartPos and (input.Position - dragStartPos).Magnitude < 12 then FloatingButton.Visible = false; MainFrame.Visible = true end end
        isDraggingWindow = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    if isDraggingWindow and MainFrame.Visible then local delta = (input.Position - dragStartPos) / UIScale.Scale; MainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
    elseif isDraggingFloating and FloatingButton.Visible then local delta = (input.Position - dragStartPos) / UIScale.Scale; FloatingButton.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y) end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38); TopBar.BackgroundColor3 = Color3.fromRGB(14, 18, 27); TopBar.BorderSizePixel = 0
local TopStroke = Instance.new("UIStroke", TopBar); TopStroke.Color = Color3.fromRGB(31, 40, 55); TopStroke.Thickness = 1; TopStroke.Transparency = 0.3

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 240, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1; Title.RichText = true; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left; registerText(Title, "title", true)

local StatsFrame = Instance.new("Frame", TopBar)
StatsFrame.Size = UDim2.new(0, 120, 0, 24); StatsFrame.Position = UDim2.new(1, -190, 0.5, -12); StatsFrame.BackgroundColor3 = Color3.fromRGB(22, 26, 38); StatsFrame.BorderSizePixel = 0; Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 6)
local statsStroke = Instance.new("UIStroke", StatsFrame); statsStroke.Color = Color3.fromRGB(0, 180, 255); statsStroke.Thickness = 1

local FpsLabel = Instance.new("TextLabel", StatsFrame); FpsLabel.Size = UDim2.new(0.5, 0, 1, 0); FpsLabel.Position = UDim2.new(0, 5, 0, 0); FpsLabel.BackgroundTransparency = 1; FpsLabel.TextColor3 = Color3.fromRGB(0, 255, 150); FpsLabel.Font = Enum.Font.GothamBold; FpsLabel.TextSize = 10; FpsLabel.TextXAlignment = Enum.TextXAlignment.Left
local PingLabel = Instance.new("TextLabel", StatsFrame); PingLabel.Size = UDim2.new(0.5, 0, 1, 0); PingLabel.Position = UDim2.new(0.5, -5, 0, 0); PingLabel.BackgroundTransparency = 1; PingLabel.TextColor3 = Color3.fromRGB(255, 180, 0); PingLabel.Font = Enum.Font.GothamBold; PingLabel.TextSize = 10; PingLabel.TextXAlignment = Enum.TextXAlignment.Right
RunService.RenderStepped:Connect(function(deltaTime) if deltaTime > 0 then FpsLabel.Text = "FPS: " .. math.floor(1 / deltaTime) end; pcall(function() PingLabel.Text = "Ping: " .. string.split(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1] end) end)

local isMinimized = false
local MinBtn = Instance.new("TextButton", TopBar); MinBtn.Size = UDim2.new(0, 24, 0, 24); MinBtn.Position = UDim2.new(1, -56, 0.5, -12); MinBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38); MinBtn.Text = "−"; MinBtn.TextColor3 = Color3.fromRGB(160, 170, 190); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 13; Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)
local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 24, 0, 24); CloseBtn.Position = UDim2.new(1, -28, 0.5, -12); CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 10; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)

local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Name = "Sidebar"; Sidebar.Size = UDim2.new(0, 155, 1, -38); Sidebar.Position = UDim2.new(0, 0, 0, 38); Sidebar.BackgroundColor3 = Color3.fromRGB(12, 15, 22); Sidebar.BorderSizePixel = 0; Sidebar.ClipsDescendants = true
local SidebarStroke = Instance.new("UIStroke", Sidebar); SidebarStroke.Color = Color3.fromRGB(32, 40, 55); SidebarStroke.Thickness = 1

local TabScroller = Instance.new("ScrollingFrame", Sidebar); TabScroller.Name = "TabScroller"; TabScroller.Size = UDim2.new(1, -8, 1, -12); TabScroller.Position = UDim2.new(0, 4, 0, 6); TabScroller.BackgroundTransparency = 1; TabScroller.BorderSizePixel = 0; TabScroller.ScrollBarThickness = 3; TabScroller.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); TabScroller.ScrollBarImageTransparency = 0.15; TabScroller.CanvasSize = UDim2.new(0, 0, 0, 0); TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y; TabScroller.ScrollingDirection = Enum.ScrollingDirection.Y
local TabPadding = Instance.new("UIPadding", TabScroller); TabPadding.PaddingTop = UDim.new(0, 3); TabPadding.PaddingBottom = UDim.new(0, 8); TabPadding.PaddingLeft = UDim.new(0, 3); TabPadding.PaddingRight = UDim.new(0, 3)
local TabListLayout = Instance.new("UIListLayout", TabScroller); TabListLayout.Padding = UDim.new(0, 4); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local ContentContainer = Instance.new("Frame", MainFrame); ContentContainer.Name = "ContentContainer"; ContentContainer.Size = UDim2.new(1, -155, 1, -38); ContentContainer.Position = UDim2.new(0, 155, 0, 38); ContentContainer.BackgroundTransparency = 1; ContentContainer.BorderSizePixel = 0

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 560, 0, MIN_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true); Sidebar.Visible = false; ContentContainer.Visible = false; MinBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 560, 0, FULL_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true); Sidebar.Visible = true; ContentContainer.Visible = true; MinBtn.Text = "−"
    end
end)

local function styleToggleFrame(frame)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 29); frame.BorderSizePixel = 0
    local corner = frame:FindFirstChildOfClass("UICorner"); if corner then corner.CornerRadius = UDim.new(0, 4) end
    local stroke = Instance.new("UIStroke"); stroke.Name = "ZenithBorder"; stroke.Parent = frame; stroke.Color = Color3.fromRGB(31, 39, 54); stroke.Thickness = 1
end

local tabButtons = {}
local tabPages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame", ContentContainer); page.Name = "Page_" .. name; page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0; page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.CanvasSize = UDim2.new(0, 0, 0, 0); page.ScrollingDirection = Enum.ScrollingDirection.Y
    local Padding = Instance.new("UIPadding", page); Padding.PaddingTop = UDim.new(0, 9); Padding.PaddingBottom = UDim.new(0, 10); Padding.PaddingLeft = UDim.new(0, 7); Padding.PaddingRight = UDim.new(0, 7)
    local layout = Instance.new("UIListLayout", page); layout.Padding = UDim.new(0, 6); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.SortOrder = Enum.SortOrder.LayoutOrder
    page.Visible = false; tabPages[name] = page; return page
end

local function switchTab(name)
    for tabName, item in pairs(tabButtons) do
        local active = (tabName == name)
        if active then
            item.Button.BackgroundColor3 = Color3.fromRGB(38, 105, 190); item.Button.TextColor3 = Color3.fromRGB(255, 255, 255); item.Pill.Visible = true
            local stroke = item.Button:FindFirstChildOfClass("UIStroke"); if stroke then stroke.Color = Color3.fromRGB(0, 200, 255); stroke.Transparency = 0 end
        else
            item.Button.BackgroundColor3 = Color3.fromRGB(25, 30, 42); item.Button.TextColor3 = Color3.fromRGB(175, 185, 205); item.Pill.Visible = false
            local stroke = item.Button:FindFirstChildOfClass("UIStroke"); if stroke then stroke.Color = Color3.fromRGB(35, 42, 58); stroke.Transparency = 0.25 end
        end
    end
    for pageName, page in pairs(tabPages) do page.Visible = (pageName == name) end
    TabScroller.CanvasPosition = Vector2.new(0, 0)
end

local function createTabButton(name, icon, transKey)
    local btn = Instance.new("TextButton", TabScroller); btn.Name = "Tab_" .. name; btn.Size = UDim2.new(1, -4, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(25, 30, 42); btn.BorderSizePixel = 0; btn.TextColor3 = Color3.fromRGB(175, 185, 205); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 11; btn.TextXAlignment = Enum.TextXAlignment.Left
    local Padding = Instance.new("UIPadding", btn); Padding.PaddingLeft = UDim.new(0, 11)
    local Corner = Instance.new("UICorner", btn); Corner.CornerRadius = UDim.new(0, 4)
    local Stroke = Instance.new("UIStroke", btn); Stroke.Color = Color3.fromRGB(35, 42, 58); Stroke.Thickness = 1; Stroke.Transparency = 0.25
    local Pill = Instance.new("Frame", btn); Pill.Name = "ActiveBar"; Pill.Size = UDim2.new(0, 3, 0, 18); Pill.Position = UDim2.new(0, 0, 0.5, -9); Pill.BackgroundColor3 = Color3.fromRGB(0, 210, 255); Pill.BorderSizePixel = 0; Pill.Visible = false; Instance.new("UICorner", Pill).CornerRadius = UDim.new(0, 2)
    local entry = {Label = btn, Key = transKey, Button = btn, Pill = Pill}
    entry.Update = function() btn.Text = icon .. "   " .. (LangDict[currentLang][transKey] or transKey) end
    table.insert(translatableElements, entry); entry.Update(); tabButtons[name] = entry
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function createToggle(page, transKey, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame", page); frame.Size = UDim2.new(0.94, 0, 0, 34); styleToggleFrame(frame)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, -50, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(220, 225, 235); label.Font = Enum.Font.Gotham; label.TextSize = 11; label.TextXAlignment = Enum.TextXAlignment.Left; registerText(label, transKey)
    local switch = Instance.new("TextButton", frame); switch.Size = UDim2.new(0, 32, 0, 16); switch.Position = UDim2.new(1, -40, 0.5, -8); switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54); switch.Text = ""; Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch); circle.Size = UDim2.new(0, 12, 0, 12); circle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    switch.MouseButton1Click:Connect(function()
        state = not state; switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        if callback then callback(state) end
    end)
end

local function createSlider(page, transKey, min, max, default, callback)
    local current = default or min
    local frame = Instance.new("Frame", page); frame.Size = UDim2.new(0.94, 0, 0, 44); styleToggleFrame(frame)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, -70, 0, 20); label.Position = UDim2.new(0, 10, 0, 3); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(220, 225, 235); label.Font = Enum.Font.Gotham; label.TextSize = 11; label.TextXAlignment = Enum.TextXAlignment.Left; registerText(label, transKey)
    local valueLabel = Instance.new("TextLabel", frame); valueLabel.Size = UDim2.new(0, 55, 0, 20); valueLabel.Position = UDim2.new(1, -65, 0, 3); valueLabel.BackgroundTransparency = 1; valueLabel.Text = tostring(current); valueLabel.TextColor3 = Color3.fromRGB(0, 210, 255); valueLabel.Font = Enum.Font.GothamBold; valueLabel.TextSize = 11; valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    local track = Instance.new("TextButton", frame); track.Size = UDim2.new(0.94, 0, 0, 4); track.Position = UDim2.new(0.03, 0, 0, 28); track.BackgroundColor3 = Color3.fromRGB(35, 42, 58); track.AutoButtonColor = false; track.Text = ""; Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track); fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 190, 255); Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local isDraggingSlider = false
    local function update(percent)
        percent = math.clamp(percent, 0, 1); fill.Size = UDim2.new(percent, 0, 1, 0); current = math.floor(min + (max - min) * percent); valueLabel.Text = tostring(current); if callback then callback(current) end
    end
    track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingSlider = true; update((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingSlider = false end end)
    UserInputService.InputChanged:Connect(function(input) if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update((UserInputService:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X) end end)
end

local function createButton(page, transKey, callback)
    local btn = Instance.new("TextButton", page); btn.Size = UDim2.new(0.94, 0, 0, 30); Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4); btn.BackgroundColor3 = Color3.fromRGB(19, 25, 36); btn.BorderSizePixel = 0; local stroke = Instance.new("UIStroke", btn); stroke.Color = Color3.fromRGB(0, 170, 230); stroke.Thickness = 1; stroke.Transparency = 0.2; btn.TextColor3 = Color3.fromRGB(0, 210, 255); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 11; registerText(btn, transKey)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

local cats = {
    {"Farm",       "🌾", "tab_farm"},
    {"Fruit",      "🍎", "tab_fruit"},
    {"PVP-ESP",    "⚔️", "tab_pvp"},
    {"Server",     "🌐", "tab_server"},
    {"RAID",       "⚡", "tab_raid"},
    {"FARM ITEM",  "🗡️", "tab_item"},
    {"SETTING",    "⚙️", "tab_setting"}
}
for index, c in ipairs(cats) do createTabButton(c[1], c[2], c[3]); createPage(c[1]); if tabButtons[c[1]] then tabButtons[c[1]].Button.LayoutOrder = index end end

-- =========================================================
-- FARM TAB
-- =========================================================
local farmPage = tabPages["Farm"]
local infoLabel = Instance.new("TextLabel", farmPage); infoLabel.Size = UDim2.new(0.94, 0, 0, 30); infoLabel.BackgroundTransparency = 1; infoLabel.RichText = true; infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150); infoLabel.Font = Enum.Font.GothamBold; infoLabel.TextSize = 12

local weaponSegment = Instance.new("Frame", farmPage); weaponSegment.Size = UDim2.new(0.94, 0, 0, 28); weaponSegment.BackgroundColor3 = Color3.fromRGB(15, 18, 25); Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", weaponSegment); wsLayout.FillDirection = Enum.FillDirection.Horizontal; wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; wsLayout.Padding = UDim.new(0, 3)

local weaponBtns = {}
local weaponList = {{name = "Melee", label = "🥊 Melee"}, {name = "Sword", label = "⚔️ Sword"}, {name = "Blox Fruit", label = "🍎 Fruit"}}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment); b.Size = UDim2.new(0.3, 0, 0.78, 0); b.BackgroundColor3 = selectedWeaponType == wData.name and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48); b.TextColor3 = selectedWeaponType == wData.name and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170); b.Font = Enum.Font.GothamMedium; b.TextSize = 10; b.Text = wData.label; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); weaponBtns[wData.name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeaponType = wData.name
        for name, btn in pairs(weaponBtns) do
            btn.BackgroundColor3 = name == wData.name and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
            btn.TextColor3 = name == wData.name and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
        end
    end)
end

createToggle(farmPage, "auto_farm_level", false, function(v) AutoFarmLevel = v end)
createToggle(farmPage, "auto_quest", true, function(v) AutoQuest = v end)
createToggle(farmPage, "bring_mob", true, function(v) BringMob = v end)

-- Tự động đổi Vũ Khí liên tục
task.spawn(function()
    while task.wait(0.5) do
        if AutoFarmLevel then
            local char = LocalPlayer.Character
            if char then
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local currentTool = char:FindFirstChildOfClass("Tool")
                
                local needEquip = true
                if currentTool and (string.find(currentTool.ToolTip, selectedWeaponType) or currentTool.Name == "Combat" or currentTool.Name == "Võ Tân Binh") then
                    needEquip = false
                end
                
                if needEquip and backpack and humanoid then
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and (string.find(tool.ToolTip, selectedWeaponType) or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then
                            humanoid:EquipTool(tool)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- =========================================================
-- SYSTEM FUNCTIONS
-- =========================================================

-- Tắt va chạm (NoClip)
RunService.Stepped:Connect(function()
    if AutoFarmLevel and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- =========================================================
-- HỆ THỐNG FAST ATTACK (COMBAT FRAMEWORK GỐC)
-- KHÔNG CẦN CHUỘT VẪN ĐÁNH RA DAMAGE MÁY KHÂU
-- =========================================================
local requireCbFw = nil
local getupval = debug.getupvalue or getupvalue

task.spawn(function()
    while task.wait(0.05) do
        if AutoFarmLevel and isAttackingTarget then
            pcall(function()
                local weapon = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if weapon then weapon:Activate() end
                
                if not requireCbFw then
                    requireCbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
                end
                
                local controller
                if requireCbFw.activeController then
                    controller = requireCbFw.activeController
                elseif getupval then
                    local cbFw2 = getupval(requireCbFw, 2)
                    if cbFw2 and type(cbFw2) == "table" and cbFw2.activeController then
                        controller = cbFw2.activeController
                    end
                end
                
                if controller and controller.equipped then
                    controller.hitboxLimiter = 0
                    controller.timeToNextAttack = 0
                    controller.timeToNextBlock = 0
                    controller.increment = 3
                    controller.attacking = false
                    controller.blocking = false
                    controller.hasCombatState = false
                    controller:attack()
                end
            end)
        end
    end
end)

-- Xóa Animation Vung Tay Để Chống Giật Màn Hình
RunService.Stepped:Connect(function()
    if AutoFarmLevel and isAttackingTarget then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local animator = hum:FindFirstChild("Animator")
                if animator then
                    for _, anim in ipairs(animator:GetPlayingAnimationTracks()) do
                        local name = anim.Name:lower()
                        if name:match("attack") or name:match("punch") or name:match("slash") or name:match("swing") or name:match("m1") then
                            anim:Stop()
                        end
                    end
                end
            end
        end
    end
end)

-- =========================================================
-- HỆ THỐNG BAY TWEEN CHỐNG GIẬT (ANTI-RUBBERBAND)
-- =========================================================

-- BodyVelocity Đệm Khí Chống Rơi Xuống Biển
task.spawn(function()
    while task.wait(0.1) do
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if AutoFarmLevel and root then
            local bv = root:FindFirstChild("Zenith_AntiGravity")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "Zenith_AntiGravity"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.zero
                bv.Parent = root
            else
                bv.Velocity = Vector3.zero
            end
        else
            if root then
                local bv = root:FindFirstChild("Zenith_AntiGravity")
                if bv then bv:Destroy() end
            end
        end
    end
end)

local function toTargetPos(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local dist = (root.Position - targetCFrame.Position).Magnitude
    
    -- Gần đến nơi thì khóa vị trí bằng CFrame trực tiếp
    if dist < 5 then
        if currentTween then pcall(function() currentTween:Cancel() end); currentTween = nil end
        root.CFrame = targetCFrame
        return
    end
    
    -- Tween bay an toàn (Chống phát hiện hack tốc độ)
    local speed = 300
    local time = dist / speed

    if not currentTween or currentTween.PlaybackState ~= Enum.PlaybackState.Playing then
        currentTween = TweenService:Create(
            root,
            TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
            {CFrame = targetCFrame}
        )
        currentTween:Play()
    end
end

-- =========================================================
-- LOGIC TÌM NHIỆM VỤ & QUÁI (LỌC BOSS)
-- =========================================================
local function getAutoQuestByLevel()
    local level = 1
    pcall(function() level = LocalPlayer.Data.Level.Value end)
    if level <= 9 then return {QuestName = "BanditQuest1", QuestLevel = 1, MonName = "Bandit", ReqLevel = 1}
    elseif level <= 14 then return {QuestName = "JungleQuest", QuestLevel = 1, MonName = "Monkey", ReqLevel = 10}
    elseif level <= 29 then return {QuestName = "JungleQuest", QuestLevel = 2, MonName = "Gorilla", ReqLevel = 15}
    elseif level <= 39 then return {QuestName = "BuggyQuest1", QuestLevel = 1, MonName = "Pirate", ReqLevel = 30}
    elseif level <= 59 then return {QuestName = "BuggyQuest1", QuestLevel = 2, MonName = "Brute", ReqLevel = 40}
    elseif level <= 74 then return {QuestName = "DesertQuest", QuestLevel = 1, MonName = "Desert Bandit", ReqLevel = 60}
    elseif level <= 89 then return {QuestName = "DesertQuest", QuestLevel = 2, MonName = "Desert Officer", ReqLevel = 75}
    elseif level <= 99 then return {QuestName = "SnowQuest", QuestLevel = 1, MonName = "Snow Bandit", ReqLevel = 90}
    elseif level <= 119 then return {QuestName = "SnowQuest", QuestLevel = 2, MonName = "Snowman", ReqLevel = 100}
    elseif level <= 149 then return {QuestName = "MarineQuest2", QuestLevel = 1, MonName = "Chief Petty Officer", ReqLevel = 120}
    elseif level <= 174 then return {QuestName = "SkyQuest", QuestLevel = 1, MonName = "Sky Bandit", ReqLevel = 150}
    elseif level <= 189 then return {QuestName = "SkyQuest", QuestLevel = 2, MonName = "Dark Master", ReqLevel = 175}
    elseif level <= 209 then return {QuestName = "PrisonerQuest", QuestLevel = 1, MonName = "Prisoner", ReqLevel = 190}
    else return {QuestName = "PeanutQuest", QuestLevel = 1, MonName = "Peanut Scout", ReqLevel = 2200} end
end

local function checkHasQuest()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    return pGui and pGui:FindFirstChild("Main") and pGui.Main:FindFirstChild("Quest") and pGui.Main.Quest.Visible or false
end

-- TÌM ĐÚNG TÊN QUÁI VẬT (BỎ GORILLA KING)
local function getAllLivingEnemies(monName)
    local list = {}
    if not Workspace:FindFirstChild("Enemies") then return list end
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        if mob.Name == monName then
            local hum, hrp = mob:FindFirstChildOfClass("Humanoid"), mob:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then table.insert(list, mob) end
        end
    end
    return list
end

local function GetMobSpawn(monName)
    local paths = {
        Workspace:FindFirstChild("EnemySpawns"),
        Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("EnemySpawns")
    }
    for _, path in ipairs(paths) do
        if path then
            for _, spawnPart in ipairs(path:GetChildren()) do
                if spawnPart.Name == monName then
                    return spawnPart.CFrame
                end
            end
        end
    end
    return nil
end

-- =========================================================
-- VÒNG LẶP FARM CHÍNH: BẠN Y+12 (NHẬN NHIỆM VỤ CHUẨN), QUÁI GOM XUỐNG ĐẤT
-- =========================================================

task.spawn(function()
    while task.wait(0.05) do
        if AutoFarmLevel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and CommF then
            local myHRP = LocalPlayer.Character.HumanoidRootPart
            local currentQuest = getAutoQuestByLevel()
            
            if currentQuest then
                currentTargetName = currentQuest.MonName
                pcall(function()
                    local level = LocalPlayer.Data.Level.Value
                    infoLabel.Text = string.format("Đang Farm: %s (Lv.%d)", currentTargetName, level)
                end)

                if AutoQuest and not checkHasQuest() then
                    pcall(function() CommF:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.QuestLevel) end)
                    task.wait(0.5)
                end

                local mobList = getAllLivingEnemies(currentTargetName)
                if #mobList > 0 then
                    local primaryMob = mobList[1]
                    local primaryHRP = primaryMob:FindFirstChild("HumanoidRootPart")

                    if primaryHRP then
                        if not lockedFarmPosition or (lockedFarmPosition.Position - primaryHRP.Position).Magnitude > 300 then
                            lockedFarmPosition = primaryHRP.CFrame
                        end

                        local groundPos = lockedFarmPosition.Position
                        
                        -- CỰ LY VÀNG: Đứng ở Y+12 để đảm bảo Game giao "quyền Network" cho bạn
                        -- Quái chết sẽ được tính 100% nhiệm vụ
                        local safePlayerPos = CFrame.new(groundPos.X, groundPos.Y + 12, groundPos.Z)
                        
                        local distance = (myHRP.Position - safePlayerPos.Position).Magnitude
                        
                        if distance > 5 then
                            isAttackingTarget = false
                            toTargetPos(safePlayerPos)
                        else
                            isAttackingTarget = true
                            
                            -- Đứng im nhìn thẳng xuống mặt đất
                            myHRP.CFrame = CFrame.lookAt(safePlayerPos.Position, groundPos)

                            if BringMob then
                                for _, otherMob in ipairs(mobList) do
                                    local oHRP = otherMob:FindFirstChild("HumanoidRootPart")
                                    local oHum = otherMob:FindFirstChildOfClass("Humanoid")
                                    if oHRP and oHum and oHum.Health > 0 and (oHRP.Position - groundPos).Magnitude <= 350 then
                                        pcall(function()
                                            -- Ghim quái xuống mặt đất
                                            oHRP.CFrame = CFrame.new(groundPos)
                                            -- Mở rộng Hitbox lên 15 để chạm tới bạn ở Y+12 (Quái vung tay hụt)
                                            oHRP.Size = Vector3.new(15, 15, 15)
                                            oHRP.Transparency = 1
                                            oHRP.CanCollide = false
                                            oHRP.AssemblyLinearVelocity = Vector3.zero
                                            
                                            oHum.WalkSpeed = 0
                                            oHum.JumpPower = 0
                                            oHum.Sit = true
                                        end)
                                    end
                                end
                            end
                        end
                    end
                else
                    isAttackingTarget = false
                    lockedFarmPosition = nil
                    
                    local spawnCFrame = GetMobSpawn(currentTargetName)
                    if spawnCFrame then
                        -- Bay tới bãi quái
                        local safeSpawnPos = CFrame.new(spawnCFrame.Position.X, spawnCFrame.Position.Y + 12, spawnCFrame.Position.Z)
                        toTargetPos(safeSpawnPos)
                    else
                        if currentTween then pcall(function() currentTween:Cancel() end); currentTween = nil end
                    end
                end
            end
        else
            isAttackingTarget = false
            lockedFarmPosition = nil
            currentTargetName = ""
            if currentTween then pcall(function() currentTween:Cancel() end); currentTween = nil end
        end
    end
end)

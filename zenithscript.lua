-- [[ ZENITH BLOX FRUIT - V12.19 (STATUE MODE: ĐỨNG IM GÂY SÁT THƯƠNG + 100% ẨN CHUỘT) ]] --

task.wait(0.5)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local Camera = Workspace.CurrentCamera

-- Chống AFK (Tránh văng game khi treo)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Biến Global
local selectedWeaponType = "Melee"
local AutoFarmLevel, AutoQuest, BringMob = false, true, true
local speedValue, speedEnabled = 16, false
local jumpValue, jumpEnabled = 50, false
local AutoRandomFruit, AutoCollectFruit, AutoStoreFruit = false, false, false

-- ===================================================
-- 1. ÉP HIỂN THỊ GIAO DIỆN & DỌN DẸP
-- ===================================================
local UI_NAME = "ZenithBloxFruit_Zyrox_V12"

local function GetSafeUIFolder()
    local folder
    pcall(function() if gethui then folder = gethui() end end)
    if not folder then pcall(function() folder = game:GetService("CoreGui") end) end
    if not folder then folder = LocalPlayer:WaitForChild("PlayerGui") end
    return folder
end

local targetUIFolder = GetSafeUIFolder()
for _, gui in ipairs(targetUIFolder:GetChildren()) do if gui.Name == UI_NAME then gui:Destroy() end end
for _, gui in ipairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do if gui.Name == UI_NAME then gui:Destroy() end end

-- ===================================================
-- 2. HỆ THỐNG NGÔN NGỮ
-- ===================================================
local currentLang = "VI"
local translatableElements = {}
local LangDict = {
    VI = {
        title = "ZYROX VN <font color='#00d2ff'>• V12.19 (STATUE MODE)</font>",
        tab_farm = "Farm Level", tab_fruit = "Trái Ác Quỷ", tab_pvp = "PVP & ESP", tab_setting = "Cài Đặt",
        auto_farm_level = "⚡ Tự Động Farm (Đứng Im Gây Dame)", auto_quest = "📜 Tự Nhận Nhiệm Vụ", bring_mob = "🧲 Quái Bất Động (Tàng Hình)",
        fruit_buy = "🎲 Mua Ngẫu Nhiên Trái", fruit_collect = "🧲 Nhặt Trái Rơi", fruit_store = "📦 Cất Trái Vào Rương",
        speed_toggle = "Bật Chạy Nhanh", speed_slider = "Tốc Độ", jump_toggle = "Bật Nhảy Cao", jump_slider = "Lực Nhảy",
        lang_title = "Ngôn Ngữ / Language", ui_scale = "Thu Phóng UI (%)", fix_lag = "Tối Ưu Đồ Họa (Tăng FPS)", close_hub = "Đóng Cửa Sổ"
    },
    EN = {
        title = "ZYROX VN <font color='#00d2ff'>• V12.19 (STATUE MODE)</font>",
        tab_farm = "Farm Level", tab_fruit = "Devil Fruit", tab_pvp = "PVP & ESP", tab_setting = "Settings",
        auto_farm_level = "⚡ Auto Farm (Aura Attack)", auto_quest = "📜 Auto Quest", bring_mob = "🧲 Freeze Mobs (Invisible)",
        fruit_buy = "🎲 Random Fruit", fruit_collect = "🧲 Collect Fruits", fruit_store = "📦 Store Into Inventory",
        speed_toggle = "Enable WalkSpeed", speed_slider = "Speed", jump_toggle = "Enable High Jump", jump_slider = "Jump Height",
        lang_title = "Language", ui_scale = "UI Scale (%)", fix_lag = "Boost FPS", close_hub = "Close Window"
    }
}
local function registerText(label, key, isRich)
    table.insert(translatableElements, {Label = label, Key = key, Rich = isRich})
    label.Text = LangDict[currentLang][key]
end
local function setLanguage(lang)
    currentLang = lang
    for _, item in ipairs(translatableElements) do
        if item.Label and item.Label.Parent then
            if item.Update then item.Update() else item.Label.Text = LangDict[currentLang][item.Key] end
        end
    end
end

-- ===================================================
-- 3. XÂY DỰNG GIAO DIỆN (UI)
-- ===================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name, ScreenGui.ResetOnSpawn = UI_NAME, false
pcall(function() ScreenGui.Parent = targetUIFolder end)

-- NÚT THU NHỎ "Z"
local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size, FloatingButton.AnchorPoint, FloatingButton.Position = UDim2.new(0, 48, 0, 48), Vector2.new(0.5, 0.5), UDim2.new(0.1, 0, 0.5, 0)
FloatingButton.BackgroundColor3, FloatingButton.Visible = Color3.fromRGB(13, 16, 22), false
FloatingButton.Text, FloatingButton.TextColor3, FloatingButton.Font, FloatingButton.TextSize = "Z", Color3.fromRGB(0, 210, 255), Enum.Font.GothamBlack, 24
FloatingButton.ZIndex = 999 
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
local FloatStroke = Instance.new("UIStroke", FloatingButton)
FloatStroke.Color, FloatStroke.Thickness = Color3.fromRGB(0, 210, 255), 1.5

local FULL_HEIGHT, MIN_HEIGHT = 330, 38
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size, MainFrame.AnchorPoint, MainFrame.Position = UDim2.new(0, 540, 0, FULL_HEIGHT), Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3, MainFrame.BorderSizePixel, MainFrame.ClipsDescendants = Color3.fromRGB(11, 13, 19), 0, true
local UIScale = Instance.new("UIScale", MainFrame)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color, MainStroke.Thickness = Color3.fromRGB(30, 36, 50), 1.2

-- Logic Kéo thả
local isDraggingWindow, isDraggingFloating = false, false
local dragStartPos, frameStartPos = nil, nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        isDraggingWindow, dragStartPos, frameStartPos = true, input.Position, MainFrame.Position 
    end
end)

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        isDraggingFloating, dragStartPos, frameStartPos = true, input.Position, FloatingButton.Position 
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        if isDraggingFloating then
            isDraggingFloating = false
            if dragStartPos and (input.Position - dragStartPos).Magnitude < 10 then FloatingButton.Visible = false; MainFrame.Visible = true end
        end
        isDraggingWindow = false 
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if isDraggingWindow and MainFrame.Visible then
            local delta = (input.Position - dragStartPos) / UIScale.Scale
            MainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
        elseif isDraggingFloating and FloatingButton.Visible then
            local delta = (input.Position - dragStartPos) / UIScale.Scale
            FloatingButton.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
        end
    end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size, TopBar.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(15, 18, 26)
local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position, Title.BackgroundTransparency, Title.RichText, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = UDim2.new(0, 300, 1, 0), UDim2.new(0, 15, 0, 0), 1, true, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, Enum.TextXAlignment.Left
registerText(Title, "title", true)

-- BỘ ĐẾM FPS VÀ PING
local StatsFrame = Instance.new("Frame", TopBar)
StatsFrame.Size, StatsFrame.Position, StatsFrame.BackgroundColor3, StatsFrame.BorderSizePixel = UDim2.new(0, 120, 0, 24), UDim2.new(1, -190, 0.5, -12), Color3.fromRGB(22, 26, 38), 0
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 6)
local StatsStroke = Instance.new("UIStroke", StatsFrame)
StatsStroke.Color, StatsStroke.Thickness = Color3.fromRGB(0, 180, 255), 1 
local FpsLabel = Instance.new("TextLabel", StatsFrame)
FpsLabel.Size, FpsLabel.Position, FpsLabel.BackgroundTransparency, FpsLabel.TextColor3, FpsLabel.Font, FpsLabel.TextSize, FpsLabel.TextXAlignment = UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 5, 0, 0), 1, Color3.fromRGB(0, 255, 150), Enum.Font.GothamBold, 10, Enum.TextXAlignment.Left
local PingLabel = Instance.new("TextLabel", StatsFrame)
PingLabel.Size, PingLabel.Position, PingLabel.BackgroundTransparency, PingLabel.TextColor3, PingLabel.Font, PingLabel.TextSize, PingLabel.TextXAlignment = UDim2.new(0.5, 0, 1, 0), UDim2.new(0.5, -5, 0, 0), 1, Color3.fromRGB(255, 180, 0), Enum.Font.GothamBold, 10, Enum.TextXAlignment.Right
RunService.RenderStepped:Connect(function(deltaTime)
    FpsLabel.Text = "FPS: " .. math.floor(1 / deltaTime)
    pcall(function() PingLabel.Text = "Ping: " .. string.split(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1] end)
end)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size, MinBtn.Position, MinBtn.BackgroundColor3, MinBtn.Text, MinBtn.TextColor3, MinBtn.Font, MinBtn.TextSize = UDim2.new(0, 24, 0, 24), UDim2.new(1, -56, 0.5, -12), Color3.fromRGB(22, 26, 38), "−", Color3.fromRGB(160, 170, 190), Enum.Font.GothamBold, 13
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size, CloseBtn.Position, CloseBtn.BackgroundColor3, CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.Font, CloseBtn.TextSize = UDim2.new(0, 24, 0, 24), UDim2.new(1, -28, 0.5, -12), Color3.fromRGB(255, 60, 90), "✕", Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size, Sidebar.Position, Sidebar.BackgroundColor3 = UDim2.new(0, 140, 1, -38), UDim2.new(0, 0, 0, 38), Color3.fromRGB(13, 15, 22)
local TabListLayout = Instance.new("UIListLayout", Sidebar)
TabListLayout.Padding, TabListLayout.HorizontalAlignment = UDim.new(0, 3), Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 6)
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size, ContentContainer.Position, ContentContainer.BackgroundTransparency = UDim2.new(1, -140, 1, -38), UDim2.new(0, 140, 0, 38), 1

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 540, 0, MIN_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible, ContentContainer.Visible, MinBtn.Text = false, false, "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 540, 0, FULL_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible, ContentContainer.Visible, MinBtn.Text = true, true, "−"
    end
end)

local tabButtons, tabPages = {}, {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Size, page.BackgroundTransparency, page.ScrollBarThickness, page.ScrollBarImageColor3, page.BorderSizePixel, page.Visible = UDim2.new(1, 0, 1, 0), 1, 2, Color3.fromRGB(0, 180, 255), 0, false
    local layout = Instance.new("UIListLayout", page)
    layout.Padding, layout.HorizontalAlignment = UDim.new(0, 6), Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 8)
    tabPages[name] = page return page
end

local function switchTab(name)
    for tName, item in pairs(tabButtons) do
        if tName == name then
            item.Button.BackgroundColor3, item.Button.TextColor3, item.Pill.Visible = Color3.fromRGB(45, 120, 255), Color3.fromRGB(255, 255, 255), true
        else
            item.Button.BackgroundColor3, item.Button.TextColor3, item.Pill.Visible = Color3.fromRGB(28, 35, 48), Color3.fromRGB(180, 190, 210), false
        end
    end
    for pName, page in pairs(tabPages) do page.Visible = (pName == name) end
end

local function createTabButton(name, icon, labelText)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size, btn.BackgroundColor3, btn.TextColor3, btn.Font, btn.TextSize, btn.TextXAlignment = UDim2.new(0.92, 0, 0, 28), Color3.fromRGB(28, 35, 48), Color3.fromRGB(180, 190, 210), Enum.Font.GothamMedium, 11, Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 10)
    local pill = Instance.new("Frame", btn)
    pill.Size, pill.Position, pill.BackgroundColor3, pill.Visible = UDim2.new(0, 3, 0, 14), UDim2.new(0, -7, 0.5, -7), Color3.fromRGB(255, 255, 255), false
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local entry = {Label = btn, Key = labelText, Button = btn, Pill = pill, Update = function() btn.Text = icon .. "  " .. LangDict[currentLang][labelText] end}
    table.insert(translatableElements, entry); btn.Text = icon .. "  " .. LangDict[currentLang][labelText]
    tabButtons[name] = entry; btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function createToggle(page, transKey, defaultState, callback)
    local state = defaultState or false
    local frame = Instance.new("Frame", page)
    frame.Size, frame.BackgroundColor3 = UDim2.new(0.94, 0, 0, 34), Color3.fromRGB(16, 20, 28)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel", frame)
    label.Size, label.Position, label.BackgroundTransparency, label.TextColor3, label.Font, label.TextSize, label.TextXAlignment = UDim2.new(1, -50, 1, 0), UDim2.new(0, 10, 0, 0), 1, Color3.fromRGB(220, 225, 235), Enum.Font.Gotham, 11, Enum.TextXAlignment.Left
    registerText(label, transKey)
    local switch = Instance.new("TextButton", frame)
    switch.Size, switch.Position, switch.BackgroundColor3, switch.Text = UDim2.new(0, 32, 0, 16), UDim2.new(1, -40, 0.5, -8), state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54), ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch)
    circle.Size, circle.Position, circle.BackgroundColor3 = UDim2.new(0, 12, 0, 12), state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    switch.MouseButton1Click:Connect(function()
        state = not state switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        if callback then callback(state) end
    end)
end

local cats = {{"Farm", "🌾", "tab_farm"}, {"Fruit", "🍎", "tab_fruit"}, {"SETTING", "⚙️", "tab_setting"}}
for _, c in ipairs(cats) do createTabButton(c[1], c[2], c[3]) createPage(c[1]) end

local farmPage = tabPages["Farm"]
local infoLabel = Instance.new("TextLabel", farmPage)
infoLabel.Size, infoLabel.BackgroundTransparency, infoLabel.RichText, infoLabel.TextColor3, infoLabel.Font, infoLabel.TextSize = UDim2.new(0.94, 0, 0, 30), 1, true, Color3.fromRGB(0, 255, 150), Enum.Font.GothamBold, 12

local weaponSegment = Instance.new("Frame", farmPage)
weaponSegment.Size, weaponSegment.BackgroundColor3 = UDim2.new(0.94, 0, 0, 28), Color3.fromRGB(15, 18, 25)
Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", weaponSegment)
wsLayout.FillDirection, wsLayout.HorizontalAlignment, wsLayout.VerticalAlignment, wsLayout.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0, 3)
local weaponBtns, weaponList = {}, {{name = "Melee", label = "🥊 Melee"}, {name = "Sword", label = "⚔️ Sword"}, {name = "Blox Fruit", label = "🍎 Fruit"}}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size, b.BackgroundColor3, b.TextColor3, b.Font, b.TextSize = UDim2.new(0.3, 0, 0.78, 0), (selectedWeaponType == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48), (selectedWeaponType == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170), Enum.Font.GothamMedium, 10
    b.Text = wData.label; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); weaponBtns[wData.name] = b
    b.MouseButton1Click:Connect(function()
        selectedWeaponType = wData.name
        for name, btn in pairs(weaponBtns) do
            btn.BackgroundColor3, btn.TextColor3 = (name == wData.name) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48), (name == wData.name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
        end
    end)
end
createToggle(farmPage, "auto_farm_level", false, function(v) AutoFarmLevel = v end)
createToggle(farmPage, "auto_quest", true, function(v) AutoQuest = v end)
createToggle(farmPage, "bring_mob", true, function(v) BringMob = v end)

local settingPage = tabPages["SETTING"]
createToggle(settingPage, "fix_lag", false, function(v)
    Lighting.GlobalShadows = not v
    for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("BasePart") and v then obj.Material = Enum.Material.SmoothPlastic end end
end)
switchTab("Farm")


-- ===================================================
-- 4. HỆ THỐNG STATUE MODE (ĐỨNG IM ĐÁNH NGẦM 100%)
-- Tuyệt đối không dùng click chuột (VirtualUser/VIM)
-- ===================================================
local isAttackingTarget = false

-- Đóng băng Hoạt ảnh (Statue Mode)
RunService.RenderStepped:Connect(function()
    if AutoFarmLevel and isAttackingTarget then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                -- Ép nhân vật đứng im như tượng đá
                for _, anim in ipairs(hum:GetPlayingAnimationTracks()) do
                    local name = anim.Name:lower()
                    if name:match("attack") or name:match("slash") or name:match("punch") or name:match("combat") or name:match("m1") or name:match("swing") then
                        anim:Stop()
                    end
                end
            end
        end
    end
end)

-- Gửi sát thương siêu nhanh qua CombatFramework
task.spawn(function()
    local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
    while true do
        if AutoFarmLevel and isAttackingTarget then
            pcall(function()
                local controller = CbFw.activeController
                if controller and controller.equipped then
                    controller.hitboxLimiter = 0
                    controller.timeToNextAttack = 0
                    controller.timeToNextBlock = 0
                    controller.increment = 3
                    controller.attacking = false
                    controller.blocking = false
                    controller.hasCombatState = false
                    controller:attack() -- Xả sát thương ngầm 100%
                end
            end)
            task.wait(0.05) -- Tốc độ bàn thờ
        else
            task.wait(0.1)
        end
    end
end)


-- ===================================================
-- 5. LOGIC DI CHUYỂN, GOM QUÁI (TRỊ DỨT ĐIỂM LDPLAYER)
-- ===================================================
local currentTween = nil
local function toTargetPos(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    if currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing then return end
    
    local speed = 350 
    local time = (root.Position - targetCFrame.Position).Magnitude / speed
    currentTween = TweenService:Create(root, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    currentTween:Play()
end

RunService.Stepped:Connect(function()
    if AutoFarmLevel and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

local function equipChosenWeapon()
    local char = LocalPlayer.Character
    if not char then return end
    local backpack, humanoid = LocalPlayer:FindFirstChild("Backpack"), char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool and (currentTool.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (currentTool.ToolTip == "Melee" or currentTool.ToolTip == "Combat" or currentTool.Name == "Combat" or currentTool.Name == "Võ Tân Binh"))) then 
        return -- Vũ khí đã được cầm, không gọi Activate
    end
    
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (tool.ToolTip == "Melee" or tool.ToolTip == "Combat" or tool.Name == "Combat" or tool.Name == "Võ Tân Binh"))) then
                humanoid:EquipTool(tool) 
                return
            end
        end
    end
end

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

local function getAllLivingEnemies(monName)
    local list = {}
    if not Workspace:FindFirstChild("Enemies") then return list end
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        if string.find(mob.Name, monName) then
            local hum, hrp = mob:FindFirstChildOfClass("Humanoid"), mob:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then table.insert(list, mob) end
        end
    end
    return list
end

-- ===================================================
-- VÒNG LẶP FARM CHÍNH: KHÓA CHẶT QUÁI
-- ===================================================
local lockedFarmPosition = nil

task.spawn(function()
    while true do
        task.wait(0.05)
        if AutoFarmLevel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and CommF then
            local currentQuest = getAutoQuestByLevel()
            if currentQuest then
                pcall(function() infoLabel.Text = string.format("Đang Farm: %s (Lv.%d)", currentQuest.MonName, LocalPlayer.Data.Level.Value) end)
                
                if AutoQuest and not checkHasQuest() then 
                    CommF:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.QuestLevel) 
                    task.wait(0.5) 
                end
                
                local mobList = getAllLivingEnemies(currentQuest.MonName)
                if #mobList > 0 then
                    equipChosenWeapon()
                    local primaryMob = mobList[1]
                    local primaryHRP = primaryMob:FindFirstChild("HumanoidRootPart")
                    local myHRP = LocalPlayer.Character.HumanoidRootPart
                    
                    if primaryHRP then
                        if not lockedFarmPosition or (lockedFarmPosition.Position - primaryHRP.Position).Magnitude > 300 then
                            lockedFarmPosition = primaryHRP.CFrame
                        end
                        
                        -- Nhân vật lơ lửng trên trời (35 studs)
                        local attackPos = CFrame.new(lockedFarmPosition.Position.X, lockedFarmPosition.Position.Y + 35, lockedFarmPosition.Position.Z)
                        
                        if (myHRP.Position - attackPos.Position).Magnitude > 5 then
                            isAttackingTarget = false 
                            toTargetPos(attackPos)
                        else
                            if currentTween then currentTween:Cancel(); currentTween = nil end
                            
                            myHRP.CFrame = attackPos
                            myHRP.AssemblyLinearVelocity = Vector3.zero
                            isAttackingTarget = true
                            
                            if BringMob then
                                for _, otherMob in ipairs(mobList) do
                                    local oHRP, oHum = otherMob:FindFirstChild("HumanoidRootPart"), otherMob:FindFirstChildOfClass("Humanoid")
                                    if oHRP and oHum and oHum.Health > 0 and (oHRP.Position - lockedFarmPosition.Position).Magnitude <= 350 then
                                        
                                        -- CỐ ĐỊNH QUÁI HOÀN TOÀN: Bất động, không rớt, không đánh lại
                                        oHRP.Anchored = true
                                        oHRP.Size = Vector3.new(20, 20, 20) -- Vừa đủ to để bạn chém
                                        oHRP.Transparency = 1 -- Tàng hình 100%
                                        oHRP.CanCollide = false
                                        
                                        -- Đưa quái lên ngay trước mặt bạn 2 studs
                                        oHRP.CFrame = attackPos * CFrame.new(0, 0, -2)
                                        oHum.Sit = true
                                        oHum.PlatformStand = true
                                    end
                                end
                            end
                        end
                    end
                else 
                    isAttackingTarget = false
                    lockedFarmPosition = nil
                end
            end
        else 
            isAttackingTarget = false 
            lockedFarmPosition = nil
            if currentTween then currentTween:Cancel(); currentTween = nil end 
        end
    end
end)

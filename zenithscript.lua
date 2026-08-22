-- [[ ZENITH BLOX FRUIT - V12.24
--     LDPLAYER MASTER FIX
--     SKY FARM + AURA AFK + FAST ATTACK + FULL UI
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
    CommF = ReplicatedStorage
        :WaitForChild("Remotes")
        :WaitForChild("CommF_")
end)

-- =========================================================
-- ANTI AFK
-- =========================================================

LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- =========================================================
-- GLOBAL SETTINGS
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

-- =========================================================
-- UI CLEANUP
-- =========================================================

local UI_NAME = "ZenithBloxFruit_Zyrox_V12"

local function GetSafeUIFolder()

    local folder

    pcall(function()
        if gethui then
            folder = gethui()
        end
    end)

    if not folder then
        pcall(function()
            folder = game:GetService("CoreGui")
        end)
    end

    if not folder then
        folder = LocalPlayer:WaitForChild("PlayerGui")
    end

    return folder
end

local targetUIFolder = GetSafeUIFolder()

pcall(function()
    for _, gui in ipairs(targetUIFolder:GetChildren()) do
        if gui.Name == UI_NAME then
            gui:Destroy()
        end
    end
end)

pcall(function()
    for _, gui in ipairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
        if gui.Name == UI_NAME then
            gui:Destroy()
        end
    end
end)

-- =========================================================
-- LANGUAGE
-- =========================================================

local currentLang = "VI"
local translatableElements = {}

local LangDict = {

    VI = {

        title = "ZYROX VN <font color='#00d2ff'>• V12.24</font>",
        badge = "PRO",

        tab_farm = "Farm Level",
        tab_fruit = "Trái Ác Quỷ",
        tab_pvp = "PVP & ESP",
        tab_server = "Máy Chủ",
        tab_raid = "Đi Raid",
        tab_item = "Farm Item",
        tab_setting = "Cài Đặt",

        auto_farm_level = "⚡ Tự Động Farm (Aura AFK)",
        auto_quest = "📜 Tự Nhận Nhiệm Vụ",
        bring_mob = "🧲 Gom Quái An Toàn",

        fruit_buy = "🎲 Mua Ngẫu Nhiên Trái",
        fruit_collect = "🧲 Nhặt Trái Rơi",
        fruit_store = "📦 Cất Trái Vào Rương",

        speed_toggle = "Bật Chạy Nhanh",
        speed_slider = "Tốc Độ",
        jump_toggle = "Bật Nhảy Cao",
        jump_slider = "Lực Nhảy",

        player_esp = "ESP Người Chơi",
        fruit_esp = "ESP Trái Ác Quỷ",

        chest_wood = "ESP Rương Gỗ",
        chest_gold = "ESP Rương Vàng",
        chest_diamond = "ESP Rương Kim Cương",

        redeem_codes = "🎁 Nhập Code Game",
        rejoin_btn = "Vào Lại Server",
        serverhop_btn = "Chuyển Server",

        auto_raid_start = "Tự Động Mua Vé & Bắt Đầu Raid",
        auto_bones = "Tự Farm Xương (Bones)",

        lang_title = "Ngôn Ngữ / Language",
        ui_scale = "Thu Phóng UI (%)",
        ui_transparency = "Trong Suốt UI (%)",
        fix_lag = "Tối Ưu Đồ Họa (Tăng FPS)",
        close_hub = "Đóng Cửa Sổ"
    },

    EN = {

        title = "ZYROX VN <font color='#00d2ff'>• V12.24</font>",
        badge = "PRO",

        tab_farm = "Farm Level",
        tab_fruit = "Devil Fruit",
        tab_pvp = "PVP & ESP",
        tab_server = "Server",
        tab_raid = "Raid Hub",
        tab_item = "Item Farm",
        tab_setting = "Settings",

        auto_farm_level = "⚡ Auto Farm (Aura AFK)",
        auto_quest = "📜 Auto Quest",
        bring_mob = "🧲 Safe Bring Mobs",

        fruit_buy = "🎲 Random Fruit",
        fruit_collect = "🧲 Collect Fruits",
        fruit_store = "📦 Store Into Inventory",

        speed_toggle = "Enable WalkSpeed",
        speed_slider = "Speed",
        jump_toggle = "Enable High Jump",
        jump_slider = "Jump Height",

        player_esp = "Player ESP",
        fruit_esp = "Fruit ESP",

        chest_wood = "Wood Chest",
        chest_gold = "Gold Chest",
        chest_diamond = "Diamond Chest",

        redeem_codes = "🎁 Redeem Codes",
        rejoin_btn = "Rejoin Server",
        serverhop_btn = "Server Hop",

        auto_raid_start = "Auto Start Raid",
        auto_bones = "Auto Farm Bones",

        lang_title = "Language",
        ui_scale = "UI Scale (%)",
        ui_transparency = "Transparency (%)",
        fix_lag = "Boost FPS",
        close_hub = "Close Window"
    }
}

local function registerText(label, key, isRich)

    table.insert(translatableElements, {
        Label = label,
        Key = key,
        Rich = isRich
    })

    if LangDict[currentLang][key] then
        label.Text = LangDict[currentLang][key]
    end
end

local function setLanguage(lang)

    currentLang = lang

    for _, item in ipairs(translatableElements) do

        if item.Label and item.Label.Parent then

            if item.Update then
                item.Update()
            elseif LangDict[currentLang][item.Key] then
                item.Label.Text = LangDict[currentLang][item.Key]
            end

        end

    end
end

-- =========================================================
-- MAIN GUI
-- =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false

pcall(function()
    ScreenGui.Parent = targetUIFolder
end)

-- =========================================================
-- FLOATING BUTTON
-- =========================================================

local FloatingButton = Instance.new("TextButton", ScreenGui)

FloatingButton.Size = UDim2.new(0, 48, 0, 48)
FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingButton.Position = UDim2.new(0.1, 0, 0.5, 0)

FloatingButton.BackgroundColor3 = Color3.fromRGB(13, 16, 22)
FloatingButton.Visible = false

FloatingButton.Text = "Z"
FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255)
FloatingButton.Font = Enum.Font.GothamBlack
FloatingButton.TextSize = 24

FloatingButton.ZIndex = 999

Instance.new("UICorner", FloatingButton).CornerRadius =
    UDim.new(0, 12)

local floatingStroke =
    Instance.new("UIStroke", FloatingButton)

floatingStroke.Color =
    Color3.fromRGB(0, 210, 255)

floatingStroke.Thickness = 1.5

-- =========================================================
-- MAIN FRAME
-- =========================================================

local FULL_HEIGHT = 330
local MIN_HEIGHT = 38

local MainFrame = Instance.new("Frame", ScreenGui)

MainFrame.Size =
    UDim2.new(0, 540, 0, FULL_HEIGHT)

MainFrame.AnchorPoint =
    Vector2.new(0.5, 0.5)

MainFrame.Position =
    UDim2.new(0.5, 0, 0.5, 0)

MainFrame.BackgroundColor3 =
    Color3.fromRGB(11, 13, 19)

MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local UIScale = Instance.new("UIScale", MainFrame)

Instance.new("UICorner", MainFrame).CornerRadius =
    UDim.new(0, 10)

local mainStroke =
    Instance.new("UIStroke", MainFrame)

mainStroke.Color =
    Color3.fromRGB(30, 36, 50)

mainStroke.Thickness = 1.2

-- =========================================================
-- WINDOW DRAG
-- =========================================================

local isDraggingWindow = false
local isDraggingFloating = false

local dragStartPos
local frameStartPos

MainFrame.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        isDraggingWindow = true
        dragStartPos = input.Position
        frameStartPos = MainFrame.Position

    end

end)

FloatingButton.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        isDraggingFloating = true
        dragStartPos = input.Position
        frameStartPos = FloatingButton.Position

    end

end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        if isDraggingFloating then

            isDraggingFloating = false

            if dragStartPos
                and (input.Position - dragStartPos).Magnitude < 12 then

                FloatingButton.Visible = false
                MainFrame.Visible = true

            end

        end

        isDraggingWindow = false

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    if isDraggingWindow and MainFrame.Visible then

        local delta =
            (input.Position - dragStartPos) / UIScale.Scale

        MainFrame.Position = UDim2.new(
            frameStartPos.X.Scale,
            frameStartPos.X.Offset + delta.X,

            frameStartPos.Y.Scale,
            frameStartPos.Y.Offset + delta.Y
        )

    elseif isDraggingFloating and FloatingButton.Visible then

        local delta =
            (input.Position - dragStartPos) / UIScale.Scale

        FloatingButton.Position = UDim2.new(
            frameStartPos.X.Scale,
            frameStartPos.X.Offset + delta.X,

            frameStartPos.Y.Scale,
            frameStartPos.Y.Offset + delta.Y
        )

    end

end)

-- =========================================================
-- TOP BAR
-- =========================================================

local TopBar = Instance.new("Frame", MainFrame)

TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 =
    Color3.fromRGB(15, 18, 26)

local Title = Instance.new("TextLabel", TopBar)

Title.Size =
    UDim2.new(0, 240, 1, 0)

Title.Position =
    UDim2.new(0, 15, 0, 0)

Title.BackgroundTransparency = 1
Title.RichText = true

Title.TextColor3 =
    Color3.fromRGB(255, 255, 255)

Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment =
    Enum.TextXAlignment.Left

registerText(Title, "title", true)

-- =========================================================
-- FPS / PING
-- =========================================================

local StatsFrame = Instance.new("Frame", TopBar)

StatsFrame.Size =
    UDim2.new(0, 120, 0, 24)

StatsFrame.Position =
    UDim2.new(1, -190, 0.5, -12)

StatsFrame.BackgroundColor3 =
    Color3.fromRGB(22, 26, 38)

StatsFrame.BorderSizePixel = 0

Instance.new("UICorner", StatsFrame).CornerRadius =
    UDim.new(0, 6)

local statsStroke =
    Instance.new("UIStroke", StatsFrame)

statsStroke.Color =
    Color3.fromRGB(0, 180, 255)

statsStroke.Thickness = 1

local FpsLabel = Instance.new("TextLabel", StatsFrame)

FpsLabel.Size =
    UDim2.new(0.5, 0, 1, 0)

FpsLabel.Position =
    UDim2.new(0, 5, 0, 0)

FpsLabel.BackgroundTransparency = 1
FpsLabel.TextColor3 =
    Color3.fromRGB(0, 255, 150)

FpsLabel.Font = Enum.Font.GothamBold
FpsLabel.TextSize = 10
FpsLabel.TextXAlignment =
    Enum.TextXAlignment.Left

local PingLabel = Instance.new("TextLabel", StatsFrame)

PingLabel.Size =
    UDim2.new(0.5, 0, 1, 0)

PingLabel.Position =
    UDim2.new(0.5, -5, 0, 0)

PingLabel.BackgroundTransparency = 1
PingLabel.TextColor3 =
    Color3.fromRGB(255, 180, 0)

PingLabel.Font = Enum.Font.GothamBold
PingLabel.TextSize = 10
PingLabel.TextXAlignment =
    Enum.TextXAlignment.Right

RunService.RenderStepped:Connect(function(deltaTime)

    if deltaTime > 0 then
        FpsLabel.Text =
            "FPS: " .. math.floor(1 / deltaTime)
    end

    pcall(function()

        local ping =
            Stats.Network.ServerStatsItem["Data Ping"]
                :GetValueString()

        PingLabel.Text =
            "Ping: " .. string.split(ping, " ")[1]

    end)

end)

-- =========================================================
-- MIN / CLOSE
-- =========================================================

local isMinimized = false

local MinBtn = Instance.new("TextButton", TopBar)

MinBtn.Size =
    UDim2.new(0, 24, 0, 24)

MinBtn.Position =
    UDim2.new(1, -56, 0.5, -12)

MinBtn.BackgroundColor3 =
    Color3.fromRGB(22, 26, 38)

MinBtn.Text = "−"
MinBtn.TextColor3 =
    Color3.fromRGB(160, 170, 190)

MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 13

Instance.new("UICorner", MinBtn).CornerRadius =
    UDim.new(0, 5)

local CloseBtn = Instance.new("TextButton", TopBar)

CloseBtn.Size =
    UDim2.new(0, 24, 0, 24)

CloseBtn.Position =
    UDim2.new(1, -28, 0.5, -12)

CloseBtn.BackgroundColor3 =
    Color3.fromRGB(255, 60, 90)

CloseBtn.Text = "✕"

CloseBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 10

Instance.new("UICorner", CloseBtn).CornerRadius =
    UDim.new(0, 5)

CloseBtn.MouseButton1Click:Connect(function()

    MainFrame.Visible = false
    FloatingButton.Visible = true

end)

-- =========================================================
-- SIDEBAR
-- =========================================================

local Sidebar = Instance.new("Frame", MainFrame)

Sidebar.Size =
    UDim2.new(0, 140, 1, -38)

Sidebar.Position =
    UDim2.new(0, 0, 0, 38)

Sidebar.BackgroundColor3 =
    Color3.fromRGB(13, 15, 22)

local TabListLayout =
    Instance.new("UIListLayout", Sidebar)

TabListLayout.Padding =
    UDim.new(0, 3)

TabListLayout.HorizontalAlignment =
    Enum.HorizontalAlignment.Center

Instance.new("UIPadding", Sidebar).PaddingTop =
    UDim.new(0, 6)

local ContentContainer =
    Instance.new("Frame", MainFrame)

ContentContainer.Size =
    UDim2.new(1, -140, 1, -38)

ContentContainer.Position =
    UDim2.new(0, 140, 0, 38)

ContentContainer.BackgroundTransparency = 1

MinBtn.MouseButton1Click:Connect(function()

    isMinimized = not isMinimized

    if isMinimized then

        MainFrame:TweenSize(
            UDim2.new(0, 540, 0, MIN_HEIGHT),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quart,
            0.25,
            true
        )

        Sidebar.Visible = false
        ContentContainer.Visible = false
        MinBtn.Text = "+"

    else

        MainFrame:TweenSize(
            UDim2.new(0, 540, 0, FULL_HEIGHT),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quart,
            0.25,
            true
        )

        Sidebar.Visible = true
        ContentContainer.Visible = true
        MinBtn.Text = "−"

    end

end)

-- =========================================================
-- TABS
-- =========================================================

local tabButtons = {}
local tabPages = {}

local function createPage(name)

    local page =
        Instance.new("ScrollingFrame", ContentContainer)

    page.Size =
        UDim2.new(1, 0, 1, 0)

    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2

    page.ScrollBarImageColor3 =
        Color3.fromRGB(0, 180, 255)

    page.BorderSizePixel = 0
    page.Visible = false

    local layout =
        Instance.new("UIListLayout", page)

    layout.Padding =
        UDim.new(0, 6)

    layout.HorizontalAlignment =
        Enum.HorizontalAlignment.Center

    Instance.new("UIPadding", page).PaddingTop =
        UDim.new(0, 8)

    tabPages[name] = page

    return page
end

local function switchTab(name)

    for tName, item in pairs(tabButtons) do

        if tName == name then

            item.Button.BackgroundColor3 =
                Color3.fromRGB(45, 120, 255)

            item.Button.TextColor3 =
                Color3.fromRGB(255, 255, 255)

            item.Pill.Visible = true

        else

            item.Button.BackgroundColor3 =
                Color3.fromRGB(28, 35, 48)

            item.Button.TextColor3 =
                Color3.fromRGB(180, 190, 210)

            item.Pill.Visible = false

        end

    end

    for pName, page in pairs(tabPages) do
        page.Visible = (pName == name)
    end

end

local function createTabButton(name, icon, transKey)

    local btn =
        Instance.new("TextButton", Sidebar)

    btn.Size =
        UDim2.new(0.92, 0, 0, 28)

    btn.BackgroundColor3 =
        Color3.fromRGB(28, 35, 48)

    btn.BorderSizePixel = 0

    btn.TextColor3 =
        Color3.fromRGB(180, 190, 210)

    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextXAlignment =
        Enum.TextXAlignment.Left

    Instance.new("UICorner", btn).CornerRadius =
        UDim.new(0, 5)

    Instance.new("UIPadding", btn).PaddingLeft =
        UDim.new(0, 10)

    local pill =
        Instance.new("Frame", btn)

    pill.Size =
        UDim2.new(0, 3, 0, 14)

    pill.Position =
        UDim2.new(0, -7, 0.5, -7)

    pill.BackgroundColor3 =
        Color3.fromRGB(255, 255, 255)

    pill.Visible = false

    Instance.new("UICorner", pill).CornerRadius =
        UDim.new(1, 0)

    local entry = {
        Label = btn,
        Key = transKey,
        Button = btn,
        Pill = pill
    }

    entry.Update = function()
        btn.Text =
            icon .. "  " .. LangDict[currentLang][transKey]
    end

    table.insert(translatableElements, entry)

    entry.Update()

    tabButtons[name] = entry

    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)

end

-- =========================================================
-- UI COMPONENTS
-- =========================================================

local function createToggle(page, transKey, defaultState, callback)

    local state = defaultState or false

    local frame =
        Instance.new("Frame", page)

    frame.Size =
        UDim2.new(0.94, 0, 0, 34)

    frame.BackgroundColor3 =
        Color3.fromRGB(16, 20, 28)

    Instance.new("UICorner", frame).CornerRadius =
        UDim.new(0, 6)

    local label =
        Instance.new("TextLabel", frame)

    label.Size =
        UDim2.new(1, -50, 1, 0)

    label.Position =
        UDim2.new(0, 10, 0, 0)

    label.BackgroundTransparency = 1

    label.TextColor3 =
        Color3.fromRGB(220, 225, 235)

    label.Font = Enum.Font.Gotham
    label.TextSize = 11

    label.TextXAlignment =
        Enum.TextXAlignment.Left

    registerText(label, transKey)

    local switch =
        Instance.new("TextButton", frame)

    switch.Size =
        UDim2.new(0, 32, 0, 16)

    switch.Position =
        UDim2.new(1, -40, 0.5, -8)

    switch.BackgroundColor3 =
        state
        and Color3.fromRGB(0, 190, 255)
        or Color3.fromRGB(35, 40, 54)

    switch.Text = ""

    Instance.new("UICorner", switch).CornerRadius =
        UDim.new(1, 0)

    local circle =
        Instance.new("Frame", switch)

    circle.Size =
        UDim2.new(0, 12, 0, 12)

    circle.Position =
        state
        and UDim2.new(1, -14, 0.5, -6)
        or UDim2.new(0, 2, 0.5, -6)

    circle.BackgroundColor3 =
        Color3.fromRGB(255, 255, 255)

    Instance.new("UICorner", circle).CornerRadius =
        UDim.new(1, 0)

    switch.MouseButton1Click:Connect(function()

        state = not state

        switch.BackgroundColor3 =
            state
            and Color3.fromRGB(0, 190, 255)
            or Color3.fromRGB(35, 40, 54)

        circle:TweenPosition(
            state
            and UDim2.new(1, -14, 0.5, -6)
            or UDim2.new(0, 2, 0.5, -6),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.15,
            true
        )

        if callback then
            callback(state)
        end

    end)

end

local function createSlider(page, transKey, min, max, default, callback)

    local current = default or min

    local frame =
        Instance.new("Frame", page)

    frame.Size =
        UDim2.new(0.94, 0, 0, 44)

    frame.BackgroundColor3 =
        Color3.fromRGB(16, 20, 28)

    Instance.new("UICorner", frame).CornerRadius =
        UDim.new(0, 6)

    local label =
        Instance.new("TextLabel", frame)

    label.Size =
        UDim2.new(1, -70, 0, 20)

    label.Position =
        UDim2.new(0, 10, 0, 3)

    label.BackgroundTransparency = 1

    label.TextColor3 =
        Color3.fromRGB(220, 225, 235)

    label.Font = Enum.Font.Gotham
    label.TextSize = 11

    label.TextXAlignment =
        Enum.TextXAlignment.Left

    registerText(label, transKey)

    local valueLabel =
        Instance.new("TextLabel", frame)

    valueLabel.Size =
        UDim2.new(0, 55, 0, 20)

    valueLabel.Position =
        UDim2.new(1, -65, 0, 3)

    valueLabel.BackgroundTransparency = 1

    valueLabel.Text =
        tostring(current)

    valueLabel.TextColor3 =
        Color3.fromRGB(0, 210, 255)

    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11

    valueLabel.TextXAlignment =
        Enum.TextXAlignment.Right

    local track =
        Instance.new("TextButton", frame)

    track.Size =
        UDim2.new(0.94, 0, 0, 4)

    track.Position =
        UDim2.new(0.03, 0, 0, 28)

    track.BackgroundColor3 =
        Color3.fromRGB(35, 42, 58)

    track.AutoButtonColor = false
    track.Text = ""

    Instance.new("UICorner", track).CornerRadius =
        UDim.new(1, 0)

    local fill =
        Instance.new("Frame", track)

    fill.Size =
        UDim2.new(
            (current - min) / (max - min),
            0,
            1,
            0
        )

    fill.BackgroundColor3 =
        Color3.fromRGB(0, 190, 255)

    Instance.new("UICorner", fill).CornerRadius =
        UDim.new(1, 0)

    local isDraggingSlider = false

    local function update(percent)

        percent =
            math.clamp(percent, 0, 1)

        fill.Size =
            UDim2.new(percent, 0, 1, 0)

        current =
            math.floor(
                min +
                (max - min) * percent
            )

        valueLabel.Text =
            tostring(current)

        if callback then
            callback(current)
        end

    end

    track.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            isDraggingSlider = true

            update(
                (input.Position.X -
                track.AbsolutePosition.X) /
                track.AbsoluteSize.X
            )

        end

    end)

    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            isDraggingSlider = false

        end

    end)

    UserInputService.InputChanged:Connect(function(input)

        if isDraggingSlider
            and (
                input.UserInputType ==
                Enum.UserInputType.MouseMovement
                or input.UserInputType ==
                Enum.UserInputType.Touch
            ) then

            update(
                (
                    UserInputService:GetMouseLocation().X -
                    track.AbsolutePosition.X
                ) /
                track.AbsoluteSize.X
            )

        end

    end)

end

local function createButton(page, transKey, callback)

    local btn =
        Instance.new("TextButton", page)

    btn.Size =
        UDim2.new(0.94, 0, 0, 30)

    btn.BackgroundColor3 =
        Color3.fromRGB(20, 26, 38)

    btn.TextColor3 =
        Color3.fromRGB(0, 210, 255)

    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11

    Instance.new("UICorner", btn).CornerRadius =
        UDim.new(0, 6)

    local stroke =
        Instance.new("UIStroke", btn)

    stroke.Color =
        Color3.fromRGB(0, 180, 255)

    registerText(btn, transKey)

    btn.MouseButton1Click:Connect(function()

        if callback then
            callback()
        end

    end)

end

-- =========================================================
-- CREATE CATEGORIES
-- =========================================================

local cats = {

    {"Farm", "🌾", "tab_farm"},
    {"Fruit", "🍎", "tab_fruit"},
    {"PVP-ESP", "⚔️", "tab_pvp"},
    {"Server", "🌐", "tab_server"},
    {"RAID", "⚡", "tab_raid"},
    {"FARM ITEM", "🗡️", "tab_item"},
    {"SETTING", "⚙️", "tab_setting"}

}

for _, c in ipairs(cats) do

    createTabButton(
        c[1],
        c[2],
        c[3]
    )

    createPage(c[1])

end

-- =========================================================
-- FARM TAB
-- =========================================================

local farmPage = tabPages["Farm"]

local infoLabel =
    Instance.new("TextLabel", farmPage)

infoLabel.Size =
    UDim2.new(0.94, 0, 0, 30)

infoLabel.BackgroundTransparency = 1
infoLabel.RichText = true

infoLabel.TextColor3 =
    Color3.fromRGB(0, 255, 150)

infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 12

-- =========================================================
-- WEAPON SELECTOR
-- =========================================================

local weaponSegment =
    Instance.new("Frame", farmPage)

weaponSegment.Size =
    UDim2.new(0.94, 0, 0, 28)

weaponSegment.BackgroundColor3 =
    Color3.fromRGB(15, 18, 25)

Instance.new("UICorner", weaponSegment).CornerRadius =
    UDim.new(0, 6)

local wsLayout =
    Instance.new("UIListLayout", weaponSegment)

wsLayout.FillDirection =
    Enum.FillDirection.Horizontal

wsLayout.HorizontalAlignment =
    Enum.HorizontalAlignment.Center

wsLayout.VerticalAlignment =
    Enum.VerticalAlignment.Center

wsLayout.Padding =
    UDim.new(0, 3)

local weaponBtns = {}

local weaponList = {

    {
        name = "Melee",
        label = "🥊 Melee"
    },

    {
        name = "Sword",
        label = "⚔️ Sword"
    },

    {
        name = "Blox Fruit",
        label = "🍎 Fruit"
    }

}

for _, wData in ipairs(weaponList) do

    local b =
        Instance.new("TextButton", weaponSegment)

    b.Size =
        UDim2.new(0.3, 0, 0.78, 0)

    b.BackgroundColor3 =
        selectedWeaponType == wData.name
        and Color3.fromRGB(0, 160, 240)
        or Color3.fromRGB(28, 35, 48)

    b.TextColor3 =
        selectedWeaponType == wData.name
        and Color3.fromRGB(255, 255, 255)
        or Color3.fromRGB(140, 150, 170)

    b.Font = Enum.Font.GothamMedium
    b.TextSize = 10
    b.Text = wData.label

    Instance.new("UICorner", b).CornerRadius =
        UDim.new(0, 4)

    weaponBtns[wData.name] = b

    b.MouseButton1Click:Connect(function()

        selectedWeaponType = wData.name

        for name, btn in pairs(weaponBtns) do

            btn.BackgroundColor3 =
                name == wData.name
                and Color3.fromRGB(0, 160, 240)
                or Color3.fromRGB(28, 35, 48)

            btn.TextColor3 =
                name == wData.name
                and Color3.fromRGB(255, 255, 255)
                or Color3.fromRGB(140, 150, 170)

        end

    end)

end

createToggle(
    farmPage,
    "auto_farm_level",
    false,
    function(v)
        AutoFarmLevel = v
    end
)

createToggle(
    farmPage,
    "auto_quest",
    true,
    function(v)
        AutoQuest = v
    end
)

createToggle(
    farmPage,
    "bring_mob",
    true,
    function(v)
        BringMob = v
    end
)

-- =========================================================
-- FRUIT TAB
-- =========================================================

local fruitPage = tabPages["Fruit"]

createToggle(
    fruitPage,
    "fruit_buy",
    false,
    function(v)
        AutoRandomFruit = v
    end
)

createToggle(
    fruitPage,
    "fruit_collect",
    false,
    function(v)
        AutoCollectFruit = v
    end
)

createToggle(
    fruitPage,
    "fruit_store",
    false,
    function(v)
        AutoStoreFruit = v
    end
)

-- =========================================================
-- PVP / ESP
-- =========================================================

local pvpPage = tabPages["PVP-ESP"]

createToggle(
    pvpPage,
    "speed_toggle",
    false,
    function(v)
        speedEnabled = v
    end
)

createSlider(
    pvpPage,
    "speed_slider",
    16,
    300,
    16,
    function(val)
        speedValue = val
    end
)

createToggle(
    pvpPage,
    "jump_toggle",
    false,
    function(v)
        jumpEnabled = v
    end
)

createSlider(
    pvpPage,
    "jump_slider",
    50,
    400,
    50,
    function(val)
        jumpValue = val
    end
)

createToggle(
    pvpPage,
    "player_esp",
    false,
    function(v)
        espPlayerEnabled = v
    end
)

createToggle(
    pvpPage,
    "fruit_esp",
    false,
    function(v)
        espFruitEnabled = v
    end
)

createToggle(
    pvpPage,
    "chest_wood",
    false,
    function(v)
        espChest1Enabled = v
    end
)

createToggle(
    pvpPage,
    "chest_gold",
    false,
    function(v)
        espChest2Enabled = v
    end
)

createToggle(
    pvpPage,
    "chest_diamond",
    false,
    function(v)
        espChest3Enabled = v
    end
)

-- =========================================================
-- SERVER
-- =========================================================

local serverPage = tabPages["Server"]

createButton(
    serverPage,
    "redeem_codes",
    function()

        local codes = {

            "ADMINHACKED",
            "ADMINDARES",
            "SECRET_ADMIN",
            "NOOB2PRO",
            "StrawHatMaine",
            "Sub2Fer999",
            "Enyu_is_Pro",
            "Magicbus",
            "JCWK",
            "Starcodeheo",
            "Bluxxy",
            "THEGREATACE",
            "SUB2GAMERROBOT_EXP1",
            "Sub2OfficialNoobie",
            "FUDD10",
            "BIGNEWS",
            "KITT_RESET",
            "SUB2NOOBMASTER123",
            "Sub2UncleKizaru",
            "Sub2Daigrock",
            "Axiore",
            "TantaiGaming",
            "FUDD10_V2",
            "CHANDLER",
            "GAMER_ROBOT_1M",
            "TY_FOR_WATCHING",
            "UPD16",
            "3BVISITS",
            "2BILLION"

        }

        task.spawn(function()

            for _, c in ipairs(codes) do

                pcall(function()

                    if CommF then
                        CommF:InvokeServer(
                            "RedeemCustomCode",
                            c
                        )
                    end

                end)

                task.wait(0.1)

            end

        end)

    end
)

createButton(
    serverPage,
    "rejoin_btn",
    function()

        pcall(function()

            TeleportService:Teleport(
                game.PlaceId,
                LocalPlayer
            )

        end)

    end
)

createButton(
    serverPage,
    "serverhop_btn",
    function()

        local success, response =
            pcall(function()

                return HttpService:JSONDecode(
                    game:HttpGet(
                        "https://games.roblox.com/v1/games/"
                        .. game.PlaceId
                        .. "/servers/Public?sortOrder=Asc&limit=100"
                    )
                )

            end)

        if success and response and response.data then

            for _, s in ipairs(response.data) do

                if s.playing < s.maxPlayers
                    and s.id ~= game.JobId then

                    pcall(function()

                        TeleportService:TeleportToPlaceInstance(
                            game.PlaceId,
                            s.id,
                            LocalPlayer
                        )

                    end)

                    break

                end

            end

        end

    end
)

-- =========================================================
-- RAID / ITEM
-- =========================================================

createToggle(
    tabPages["RAID"],
    "auto_raid_start",
    false,
    function(v)
    end
)

createToggle(
    tabPages["FARM ITEM"],
    "auto_bones",
    false,
    function(v)
    end
)

-- =========================================================
-- SETTINGS
-- =========================================================

local settingPage = tabPages["SETTING"]

createToggle(
    settingPage,
    "fix_lag",
    false,
    function(v)

        Lighting.GlobalShadows = not v

        if v then

            for _, obj in ipairs(
                Workspace:GetDescendants()
            ) do

                if obj:IsA("BasePart") then
                    obj.Material =
                        Enum.Material.SmoothPlastic
                end

            end

        end

    end
)

createSlider(
    settingPage,
    "ui_scale",
    60,
    140,
    100,
    function(val)
        UIScale.Scale = val / 100
    end
)

createSlider(
    settingPage,
    "ui_transparency",
    0,
    80,
    12,
    function(val)

        MainFrame.BackgroundTransparency =
            val / 100

        Sidebar.BackgroundTransparency =
            math.clamp(
                (val + 8) / 100,
                0,
                1
            )

    end
)

createButton(
    settingPage,
    "close_hub",
    function()
        ScreenGui:Destroy()
    end
)

switchTab("Farm")

-- =========================================================
-- MOVEMENT
-- =========================================================

RunService.Heartbeat:Connect(function()

    if speedEnabled
        and LocalPlayer.Character
        and LocalPlayer.Character:FindFirstChild(
            "HumanoidRootPart"
        ) then

        local humanoid =
            LocalPlayer.Character:FindFirstChildOfClass(
                "Humanoid"
            )

        local rootPart =
            LocalPlayer.Character.HumanoidRootPart

        if humanoid
            and rootPart
            and humanoid.MoveDirection.Magnitude > 0 then

            rootPart.AssemblyLinearVelocity =
                Vector3.new(
                    humanoid.MoveDirection.X * speedValue,
                    rootPart.AssemblyLinearVelocity.Y,
                    humanoid.MoveDirection.Z * speedValue
                )

        end

    end

end)

UserInputService.JumpRequest:Connect(function()

    if jumpEnabled
        and LocalPlayer.Character
        and LocalPlayer.Character:FindFirstChild(
            "HumanoidRootPart"
        ) then

        local root =
            LocalPlayer.Character.HumanoidRootPart

        root.AssemblyLinearVelocity =
            Vector3.new(
                root.AssemblyLinearVelocity.X,
                jumpValue,
                root.AssemblyLinearVelocity.Z
            )

    end

end)

-- =========================================================
-- PLAYER ESP
-- =========================================================

task.spawn(function()

    while task.wait(0.2) do

        for _, p in ipairs(Players:GetPlayers()) do

            if p ~= LocalPlayer and p.Character then

                local char = p.Character
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")

                local myHRP =
                    LocalPlayer.Character
                    and LocalPlayer.Character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if espPlayerEnabled
                    and head
                    and hum
                    and myHRP
                    and hum.Health > 0 then

                    local dist =
                        math.floor(
                            (
                                head.Position
                                - myHRP.Position
                            ).Magnitude
                        )

                    local bbGui =
                        head:FindFirstChild(
                            "Zenith_PlayerBillboard"
                        )

                    if not bbGui then

                        bbGui =
                            Instance.new(
                                "BillboardGui",
                                head
                            )

                        bbGui.Name =
                            "Zenith_PlayerBillboard"

                        bbGui.Size =
                            UDim2.new(0, 200, 0, 45)

                        bbGui.StudsOffset =
                            Vector3.new(0, 2.8, 0)

                        bbGui.AlwaysOnTop = true

                        local txt =
                            Instance.new(
                                "TextLabel",
                                bbGui
                            )

                        txt.Name = "Info"

                        txt.Size =
                            UDim2.new(1, 0, 1, 0)

                        txt.BackgroundTransparency = 1

                        txt.Font =
                            Enum.Font.GothamBold

                        txt.TextSize = 11

                        txt.TextColor3 =
                            Color3.fromRGB(
                                255,
                                60,
                                90
                            )

                    end

                    bbGui.Info.Text =
                        string.format(
                            "%s\n[%dm] • HP: %d/%d",
                            p.DisplayName,
                            dist,
                            math.floor(hum.Health),
                            math.floor(hum.MaxHealth)
                        )

                else

                    if head
                        and head:FindFirstChild(
                            "Zenith_PlayerBillboard"
                        ) then

                        head.Zenith_PlayerBillboard:Destroy()

                    end

                end

            end

        end

    end

end)

-- =========================================================
-- CHEST SCANNER
-- =========================================================

local detectedChests = {}

task.spawn(function()

    while task.wait(3) do

        detectedChests = {}

        for _, obj in ipairs(
            Workspace:GetDescendants()
        ) do

            if obj:IsA("BasePart") then

                local name =
                    string.lower(obj.Name)

                local pName =
                    obj.Parent
                    and string.lower(obj.Parent.Name)
                    or ""

                if string.find(name, "chest")
                    or string.find(pName, "chest") then

                    local tier = 1

                    if string.find(name, "3")
                        or string.find(pName, "3")
                        or string.find(name, "diamond") then

                        tier = 3

                    elseif string.find(name, "2")
                        or string.find(pName, "2")
                        or string.find(name, "gold")
                        or string.find(name, "silver") then

                        tier = 2

                    end

                    table.insert(
                        detectedChests,
                        {
                            Part = obj,
                            Tier = tier
                        }
                    )

                end

            end

        end

    end

end)

-- =========================================================
-- FRUIT / CHEST ESP
-- =========================================================

task.spawn(function()

    while task.wait(0.2) do

        local myHRP =
            LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild(
                "HumanoidRootPart"
            )

        if not myHRP then
            continue
        end

        -- =================================================
        -- FRUIT ESP
        -- =================================================

        for _, obj in ipairs(
            Workspace:GetChildren()
        ) do

            if (
                obj:IsA("Tool")
                and string.find(
                    string.lower(obj.Name),
                    "fruit"
                )
            )
            or obj:FindFirstChild("Fruit") then

                local handle =
                    obj:FindFirstChild("Handle")
                    or obj:FindFirstChildWhichIsA(
                        "BasePart"
                    )

                if handle then

                    if espFruitEnabled then

                        local b =
                            handle:FindFirstChild(
                                "Zenith_FruitESP"
                            )

                        if not b then

                            b =
                                Instance.new(
                                    "BillboardGui",
                                    handle
                                )

                            b.Name =
                                "Zenith_FruitESP"

                            b.Size =
                                UDim2.new(
                                    0,
                                    180,
                                    0,
                                    30
                                )

                            b.StudsOffset =
                                Vector3.new(0, 2, 0)

                            b.AlwaysOnTop = true

                            local t =
                                Instance.new(
                                    "TextLabel",
                                    b
                                )

                            t.Name = "Label"

                            t.Size =
                                UDim2.new(1, 0, 1, 0)

                            t.BackgroundTransparency = 1

                            t.Font =
                                Enum.Font.GothamBold

                            t.TextSize = 12

                            t.TextColor3 =
                                Color3.fromRGB(
                                    255,
                                    70,
                                    220
                                )

                        end

                        b.Label.Text =
                            string.format(
                                "🍎 %s\n[%dm]",
                                obj.Name,
                                math.floor(
                                    (
                                        handle.Position
                                        - myHRP.Position
                                    ).Magnitude
                                )
                            )

                    else

                        if handle:FindFirstChild(
                            "Zenith_FruitESP"
                        ) then

                            handle.Zenith_FruitESP:Destroy()

                        end

                    end

                end

            end

        end

        -- =================================================
        -- CHEST ESP
        -- =================================================

        for _, item in ipairs(detectedChests) do

            local rootPart = item.Part
            local tier = item.Tier

            if rootPart and rootPart.Parent then

                local shouldShow =
                    (
                        tier == 1
                        and espChest1Enabled
                    )
                    or (
                        tier == 2
                        and espChest2Enabled
                    )
                    or (
                        tier == 3
                        and espChest3Enabled
                    )

                if shouldShow then

                    local b =
                        rootPart:FindFirstChild(
                            "Zenith_ChestESP"
                        )

                    if not b then

                        b =
                            Instance.new(
                                "BillboardGui",
                                rootPart
                            )

                        b.Name =
                            "Zenith_ChestESP"

                        b.Size =
                            UDim2.new(
                                0,
                                160,
                                0,
                                25
                            )

                        b.StudsOffset =
                            Vector3.new(0, 2, 0)

                        b.AlwaysOnTop = true

                        local t =
                            Instance.new(
                                "TextLabel",
                                b
                            )

                        t.Name = "Label"

                        t.Size =
                            UDim2.new(1, 0, 1, 0)

                        t.BackgroundTransparency = 1

                        t.Font =
                            Enum.Font.GothamBold

                        t.TextSize = 11

                    end

                    b.Label.TextColor3 =
                        (
                            tier == 3
                            and Color3.fromRGB(
                                0,
                                240,
                                255
                            )
                        )
                        or (
                            tier == 2
                            and Color3.fromRGB(
                                255,
                                215,
                                0
                            )
                        )
                        or Color3.fromRGB(
                            205,
                            127,
                            50
                        )

                    b.Label.Text =
                        string.format(
                            "%s [%dm]",

                            (
                                tier == 3
                                and "💎 Diamond"
                            )
                            or (
                                tier == 2
                                and "🪙 Gold"
                            )
                            or "📦 Bronze",

                            math.floor(
                                (
                                    rootPart.Position
                                    - myHRP.Position
                                ).Magnitude
                            )
                        )

                else

                    if rootPart:FindFirstChild(
                        "Zenith_ChestESP"
                    ) then

                        rootPart.Zenith_ChestESP:Destroy()

                    end

                end

            end

        end

    end

end)

-- =========================================================
-- AUTO BUY FRUIT
-- =========================================================

task.spawn(function()

    while task.wait(5) do

        if AutoRandomFruit and CommF then

            pcall(function()

                CommF:InvokeServer(
                    "Cousin",
                    "Buy"
                )

            end)

        end

    end

end)

-- =========================================================
-- AUTO COLLECT FRUIT
-- =========================================================

task.spawn(function()

    while task.wait(1) do

        if AutoCollectFruit
            and not AutoFarmLevel
            and LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild(
                "HumanoidRootPart"
            ) then

            for _, obj in ipairs(
                Workspace:GetChildren()
            ) do

                if (
                    obj:IsA("Tool")
                    and string.find(
                        string.lower(obj.Name),
                        "fruit"
                    )
                )
                or obj:FindFirstChild("Fruit") then

                    local handle =
                        obj:FindFirstChild("Handle")
                        or obj:FindFirstChildWhichIsA(
                            "BasePart"
                        )

                    if handle then

                        LocalPlayer.Character
                            .HumanoidRootPart.CFrame =
                            handle.CFrame

                        task.wait(0.5)

                        if firetouchinterest then

                            pcall(function()

                                firetouchinterest(
                                    LocalPlayer.Character
                                        .HumanoidRootPart,
                                    handle,
                                    0
                                )

                                task.wait()

                                firetouchinterest(
                                    LocalPlayer.Character
                                        .HumanoidRootPart,
                                    handle,
                                    1
                                )

                            end)

                        end

                    end

                end

            end

        end

    end

end)

-- =========================================================
-- AUTO STORE FRUIT
-- =========================================================

task.spawn(function()

    while task.wait(2) do

        if AutoStoreFruit and CommF then

            pcall(function()

                local backpack =
                    LocalPlayer:FindFirstChild(
                        "Backpack"
                    )

                local char =
                    LocalPlayer.Character

                if backpack then

                    for _, item in ipairs(
                        backpack:GetChildren()
                    ) do

                        if string.find(
                            string.lower(item.Name),
                            "fruit"
                        )
                        or item:FindFirstChild(
                            "Fruit"
                        ) then

                            CommF:InvokeServer(
                                "StoreFruit",
                                item.Name,
                                item
                            )

                        end

                    end

                end

                if char then

                    for _, item in ipairs(
                        char:GetChildren()
                    ) do

                        if item:IsA("Tool")
                            and (
                                string.find(
                                    string.lower(
                                        item.Name
                                    ),
                                    "fruit"
                                )
                                or item:FindFirstChild(
                                    "Fruit"
                                )
                            ) then

                            CommF:InvokeServer(
                                "StoreFruit",
                                item.Name,
                                item
                            )

                        end

                    end

                end

            end)

        end

    end

end)

-- =========================================================
-- WATER PLATFORM
-- =========================================================

task.spawn(function()

    local waterPlatform =
        Instance.new("Part")

    waterPlatform.Name =
        "Zenith_WaterPlatform"

    waterPlatform.Size =
        Vector3.new(120, 1, 120)

    waterPlatform.Transparency = 1
    waterPlatform.Anchored = true
    waterPlatform.CanCollide = true

    waterPlatform.Parent = Workspace

    RunService.RenderStepped:Connect(function()

        local char = LocalPlayer.Character

        if char
            and char:FindFirstChild(
                "HumanoidRootPart"
            ) then

            local hrp =
                char.HumanoidRootPart

            local humanoid =
                char:FindFirstChildOfClass(
                    "Humanoid"
                )

            if humanoid
                and humanoid:GetState()
                    == Enum.HumanoidStateType.Swimming then

                pcall(function()

                    humanoid:SetStateEnabled(
                        Enum.HumanoidStateType.Swimming,
                        false
                    )

                    humanoid:ChangeState(
                        Enum.HumanoidStateType.Running
                    )

                end)

            end

            if hrp.Position.Y <= 15
                and hrp.Position.Y >= -60 then

                waterPlatform.CFrame =
                    CFrame.new(
                        hrp.Position.X,
                        0.5,
                        hrp.Position.Z
                    )

                waterPlatform.CanCollide = true

            else

                waterPlatform.CFrame =
                    CFrame.new(
                        hrp.Position.X,
                        -500,
                        hrp.Position.Z
                    )

                waterPlatform.CanCollide = false

            end

        end

    end)

end)

-- =========================================================
-- =========================================================
-- ZENITH FAST ATTACK ENGINE
-- =========================================================
-- =========================================================

local isAttackingTarget = false

local FastAttack = {

    Enabled = true,

    -- Attack interval.
    -- Giá trị thấp hơn = attack nhanh hơn.
    Interval = 0.085,

    LastAttack = 0,

    Controller = nil,
    CombatFramework = nil,

    LastCharacter = nil,
    LastWeapon = nil

}

-- =========================================================
-- GET EQUIPPED WEAPON
-- =========================================================

local function GetEquippedWeapon()

    local character =
        LocalPlayer.Character

    if not character then
        return nil
    end

    for _, object in ipairs(
        character:GetChildren()
    ) do

        if object:IsA("Tool") then
            return object
        end

    end

    return nil

end

-- =========================================================
-- LOAD COMBAT FRAMEWORK
-- =========================================================

local function LoadCombatFramework()

    local playerScripts =
        LocalPlayer:FindFirstChild(
            "PlayerScripts"
        )

    if not playerScripts then
        return nil
    end

    local combatModule =
        playerScripts:FindFirstChild(
            "CombatFramework"
        )

    if not combatModule then
        return nil
    end

    local success, framework =
        pcall(function()

            return require(combatModule)

        end)

    if not success or not framework then
        return nil
    end

    FastAttack.CombatFramework =
        framework

    return framework

end

-- =========================================================
-- GET ACTIVE CONTROLLER
-- =========================================================

local function GetCombatController()

    local framework =
        FastAttack.CombatFramework

    if not framework then

        framework =
            LoadCombatFramework()

    end

    if not framework then
        return nil
    end

    -- Primary controller.
    local controller =
        framework.activeController

    if controller then

        FastAttack.Controller =
            controller

        return controller

    end

    -- Fallback controller scan.
    if debug
        and debug.getupvalues then

        pcall(function()

            for _, value in pairs(
                debug.getupvalues(framework)
            ) do

                if type(value) == "table"
                    and value.activeController then

                    FastAttack.Controller =
                        value.activeController

                    return

                end

            end

        end)

    end

    return FastAttack.Controller

end

-- =========================================================
-- RESET FAST ATTACK
-- =========================================================

local function ResetFastAttack()

    FastAttack.Controller = nil
    FastAttack.CombatFramework = nil
    FastAttack.LastAttack = 0
    FastAttack.LastWeapon = nil

end

-- =========================================================
-- REFRESH CONTROLLER
-- =========================================================

local function RefreshCombatController()

    local character =
        LocalPlayer.Character

    if not character then

        ResetFastAttack()

        return nil

    end

    if FastAttack.LastCharacter
        ~= character then

        FastAttack.LastCharacter =
            character

        ResetFastAttack()

        task.wait(0.25)

    end

    local weapon =
        GetEquippedWeapon()

    if weapon ~= FastAttack.LastWeapon then

        FastAttack.LastWeapon =
            weapon

        FastAttack.Controller = nil

    end

    return GetCombatController()

end

-- =========================================================
-- EXECUTE FAST ATTACK
-- =========================================================

local function ExecuteFastAttack()

    if not FastAttack.Enabled then
        return
    end

    if not AutoFarmLevel then
        return
    end

    if not isAttackingTarget then
        return
    end

    local character =
        LocalPlayer.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass(
            "Humanoid"
        )

    local root =
        character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not humanoid
        or humanoid.Health <= 0
        or not root then

        return

    end

    local weapon =
        GetEquippedWeapon()

    if not weapon then
        return
    end

    local now = os.clock()

    if now - FastAttack.LastAttack
        < FastAttack.Interval then

        return

    end

    local controller =
        RefreshCombatController()

    if not controller then
        return
    end

    FastAttack.LastAttack =
        now

    pcall(function()

        -- Reset combat timers.
        controller.hitboxLimiter = 0
        controller.timeToNextAttack = 0
        controller.timeToNextBlock = 0
        controller.increment = 3

        controller.blocking = false

        -- Activate weapon.
        if weapon.Parent == character then
            weapon:Activate()
        end

        -- Trigger CombatFramework.
        if typeof(controller.attack)
            == "function" then

            controller:attack()

        end

    end)

end

-- =========================================================
-- FAST ATTACK LOOP
-- =========================================================

task.spawn(function()

    while task.wait(0.025) do

        if not AutoFarmLevel then

            FastAttack.LastAttack = 0

            continue

        end

        if not isAttackingTarget then

            FastAttack.LastAttack = 0

            continue

        end

        local character =
            LocalPlayer.Character

        if not character then

            ResetFastAttack()

            task.wait(0.15)

            continue

        end

        local humanoid =
            character:FindFirstChildOfClass(
                "Humanoid"
            )

        if not humanoid
            or humanoid.Health <= 0 then

            ResetFastAttack()

            task.wait(0.15)

            continue

        end

        local weapon =
            GetEquippedWeapon()

        if not weapon then

            FastAttack.LastAttack = 0

            task.wait(0.05)

            continue

        end

        local success =
            pcall(ExecuteFastAttack)

        if not success then

            ResetFastAttack()

            task.wait(0.1)

        end

    end

end)

-- =========================================================
-- COMBAT WATCHDOG
-- =========================================================

task.spawn(function()

    while task.wait(0.75) do

        if AutoFarmLevel
            and isAttackingTarget then

            local controller =
                GetCombatController()

            if controller then
                FastAttack.Controller =
                    controller
            end

        end

    end

end)

-- =========================================================
-- RESPAWN FIX
-- =========================================================

LocalPlayer.CharacterAdded:Connect(
    function(character)

        FastAttack.LastCharacter =
            character

        ResetFastAttack()

        isAttackingTarget = false

        task.wait(1)

        if AutoFarmLevel then

            pcall(function()
                LoadCombatFramework()
            end)

        end

    end
)

-- =========================================================
-- AUTO FARM MOVEMENT
-- =========================================================

local currentTween = nil

local function toTargetPos(targetCFrame)

    local char =
        LocalPlayer.Character

    if not char then
        return
    end

    local root =
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    if not root then
        return
    end

    if currentTween
        and currentTween.PlaybackState
            == Enum.PlaybackState.Playing then

        return

    end

    local distance =
        (
            root.Position
            - targetCFrame.Position
        ).Magnitude

    if distance < 3 then
        return
    end

    local speed = 350

    local time =
        distance / speed

    currentTween =
        TweenService:Create(
            root,

            TweenInfo.new(
                time,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            ),

            {
                CFrame = targetCFrame
            }
        )

    currentTween:Play()

end

-- =========================================================
-- NO COLLISION
-- =========================================================

RunService.Stepped:Connect(function()

    if AutoFarmLevel
        and LocalPlayer.Character then

        for _, part in ipairs(
            LocalPlayer.Character:GetDescendants()
        ) do

            if part:IsA("BasePart") then
                part.CanCollide = false
            end

        end

    end

end)

-- =========================================================
-- FARM POSITION
-- =========================================================

local lockedFarmPosition = nil

-- =========================================================
-- MAIN AUTO FARM
-- =========================================================

task.spawn(function()

    while task.wait(0.05) do

        if AutoFarmLevel
            and LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild(
                "HumanoidRootPart"
            )
            and CommF then

            local currentQuest =
                getAutoQuestByLevel()

            if currentQuest then

                pcall(function()

                    if infoLabel then

                        local level = 0

                        pcall(function()

                            level =
                                LocalPlayer.Data
                                    .Level.Value

                        end)

                        infoLabel.Text =
                            string.format(
                                "Đang Farm: %s (Lv.%d)",
                                currentQuest.MonName,
                                level
                            )

                    end

                end)

                -- =========================================
                -- AUTO QUEST
                -- =========================================

                if AutoQuest
                    and not checkHasQuest() then

                    pcall(function()

                        CommF:InvokeServer(
                            "StartQuest",
                            currentQuest.QuestName,
                            currentQuest.QuestLevel
                        )

                    end)

                    task.wait(0.5)

                end

                -- =========================================
                -- FIND MOBS
                -- =========================================

                local mobList =
                    getAllLivingEnemies(
                        currentQuest.MonName
                    )

                if #mobList > 0 then

                    pcall(function()
                        equipChosenWeapon()
                    end)

                    local primaryMob =
                        mobList[1]

                    local primaryHRP =
                        primaryMob:FindFirstChild(
                            "HumanoidRootPart"
                        )

                    local myHRP =
                        LocalPlayer.Character
                            :FindFirstChild(
                                "HumanoidRootPart"
                            )

                    if primaryHRP
                        and myHRP then

                        -- =================================
                        -- LOCK TARGET
                        -- =================================

                        if not lockedFarmPosition
                            or (
                                lockedFarmPosition.Position
                                - primaryHRP.Position
                            ).Magnitude > 300 then

                            lockedFarmPosition =
                                primaryHRP.CFrame

                        end

                        local groundPos =
                            lockedFarmPosition.Position

                        local attackPos =
                            CFrame.new(
                                groundPos.X,
                                groundPos.Y + 6,
                                groundPos.Z
                            )

                        local lookAtPos =
                            CFrame.lookAt(
                                attackPos.Position,
                                groundPos
                            )

                        local distance =
                            (
                                myHRP.Position
                                - attackPos.Position
                            ).Magnitude

                        -- =================================
                        -- MOVE TO TARGET
                        -- =================================

                        if distance > 3 then

                            -- Tắt attack khi đang di chuyển.
                            isAttackingTarget = false

                            toTargetPos(
                                lookAtPos
                            )

                        else

                            -- =================================
                            -- STOP MOVEMENT
                            -- =================================

                            if currentTween then

                                pcall(function()
                                    currentTween:Cancel()
                                end)

                                currentTween = nil

                            end

                            -- =================================
                            -- LOCK PLAYER
                            -- =================================

                            myHRP.CFrame =
                                lookAtPos

                            myHRP.AssemblyLinearVelocity =
                                Vector3.zero

                            -- =================================
                            -- ENABLE FAST ATTACK
                            -- =================================

                            isAttackingTarget = true

                            -- =================================
                            -- BRING MOBS
                            -- =================================

                            if BringMob then

                                for _, otherMob
                                    in ipairs(mobList) do

                                    local oHRP =
                                        otherMob:FindFirstChild(
                                            "HumanoidRootPart"
                                        )

                                    local oHum =
                                        otherMob:FindFirstChildOfClass(
                                            "Humanoid"
                                        )

                                    if oHRP
                                        and oHum
                                        and oHum.Health > 0
                                        and (
                                            oHRP.Position
                                            - groundPos
                                        ).Magnitude <= 350 then

                                        pcall(function()

                                            oHRP.CFrame =
                                                CFrame.new(
                                                    groundPos
                                                )

                                            oHRP.AssemblyLinearVelocity =
                                                Vector3.zero

                                            oHRP.CanCollide =
                                                false

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

                    -- =================================
                    -- NO TARGET
                    -- =================================

                    isAttackingTarget = false
                    lockedFarmPosition = nil

                    if currentTween then

                        pcall(function()
                            currentTween:Cancel()
                        end)

                        currentTween = nil

                    end

                end

            end

        else

            -- =============================================
            -- FARM OFF
            -- =============================================

            isAttackingTarget = false

            lockedFarmPosition = nil

            FastAttack.LastAttack = 0

            if currentTween then

                pcall(function()
                    currentTween:Cancel()
                end)

                currentTween = nil

            end

        end

    end

end)

-- =========================================================
-- INITIALIZE
-- =========================================================

task.spawn(function()

    task.wait(1)

    pcall(function()
        LoadCombatFramework()
    end)

end)

-- ===================================================
-- 1. ÉP HIỂN THỊ GIAO DIỆN (CỨNG - KHÔNG LỖI)
-- ===================================================
local UI_NAME = "ZenithBloxFruit_Zyrox_V12"

-- Tìm folder cha an toàn nhất
local function GetSafeUIFolder()
    -- Ưu tiên CoreGui (chạy được hầu hết executor)
    local coreGui = game:GetService("CoreGui")
    if coreGui then return coreGui end
    
    -- Nếu không, thử gethui (cũ)
    local success, result = pcall(function()
        if gethui then
            return gethui()
        end
    end)
    if success and result then
        return result
    end
    
    -- Cuối cùng là PlayerGui (luôn có)
    return LocalPlayer:WaitForChild("PlayerGui")
end

local targetUIFolder = GetSafeUIFolder()

-- Xoá GUI cũ nếu còn
for _, gui in ipairs(targetUIFolder:GetChildren()) do
    if gui.Name == UI_NAME then
        gui:Destroy()
    end
end

-- Tạo ScreenGui với các thiết lập cứng
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- THỬ gán parent, nếu lỗi thì báo và dừng
local success, err = pcall(function()
    ScreenGui.Parent = targetUIFolder
end)

if not success then
    warn("❌ Không thể tạo UI: " .. tostring(err))
    -- Thử fallback vào PlayerGui
    local fallback = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Parent = fallback
    warn("✅ Đã fallback sang PlayerGui")
end

-- Đảm bảo ScreenGui tồn tại trước khi tạo các thành phần con
if not ScreenGui.Parent then
    error("❌ Không thể gán ScreenGui vào bất kỳ folder nào! Dừng script UI.")
    return
end

print("✅ UI đã được khởi tạo tại: " .. tostring(ScreenGui.Parent.Name))

-- ===================================================
-- 2. CÁC THÀNH PHẦN UI (NHẸ, ÍT LỖI)
-- ===================================================

-- NÚT THU NHỎ (FLOATING BUTTON)
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
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
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FloatingButton).Color = Color3.fromRGB(0, 210, 255)
Instance.new("UIStroke", FloatingButton).Thickness = 1.5
FloatingButton.Parent = ScreenGui

-- MAIN FRAME
local FULL_HEIGHT, MIN_HEIGHT = 330, 38
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, FULL_HEIGHT)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(30, 36, 50)
Instance.new("UIStroke", MainFrame).Thickness = 1.2
MainFrame.Parent = ScreenGui

-- SCALE (để zoom UI)
local UIScale = Instance.new("UIScale")
UIScale.Parent = MainFrame
UIScale.Scale = 1

-- KÉO THẢ
local isDraggingWindow = false
local dragStart, frameStart = nil, nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingWindow = true
        dragStart = input.Position
        frameStart = MainFrame.Position
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingWindow = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDraggingWindow and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = (input.Position - dragStart) / UIScale.Scale
        MainFrame.Position = UDim2.new(
            frameStart.X.Scale,
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end
end)

-- TOPBAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 240, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.RichText = true
Title.Text = "ZYROX VN <font color='#00d2ff'>• V12.24</font>"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- FPS + PING
local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(0, 120, 0, 24)
StatsFrame.Position = UDim2.new(1, -190, 0.5, -12)
StatsFrame.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
StatsFrame.BorderSizePixel = 0
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", StatsFrame).Color = Color3.fromRGB(0, 180, 255)
Instance.new("UIStroke", StatsFrame).Thickness = 1
StatsFrame.Parent = TopBar

local FpsLabel = Instance.new("TextLabel")
FpsLabel.Size = UDim2.new(0.5, 0, 1, 0)
FpsLabel.Position = UDim2.new(0, 5, 0, 0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: 60"
FpsLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
FpsLabel.Font = Enum.Font.GothamBold
FpsLabel.TextSize = 10
FpsLabel.TextXAlignment = Enum.TextXAlignment.Left
FpsLabel.Parent = StatsFrame

local PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(0.5, 0, 1, 0)
PingLabel.Position = UDim2.new(0.5, -5, 0, 0)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "Ping: 0"
PingLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
PingLabel.Font = Enum.Font.GothamBold
PingLabel.TextSize = 10
PingLabel.TextXAlignment = Enum.TextXAlignment.Right
PingLabel.Parent = StatsFrame

-- NÚT THU NHỎ
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -56, 0.5, -12)
MinBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(160, 170, 190)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 13
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)
MinBtn.Parent = TopBar

-- NÚT ĐÓNG
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingButton.Visible = true
end)

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 15, 22)
Sidebar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 3)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.Parent = Sidebar

Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 6)

-- CONTENT CONTAINER
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -140, 1, -38)
ContentContainer.Position = UDim2.new(0, 140, 0, 38)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- THU NHỎ TOÀN BỘ
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 540, 0, MIN_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible = false
        ContentContainer.Visible = false
        MinBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 540, 0, FULL_HEIGHT), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
        Sidebar.Visible = true
        ContentContainer.Visible = true
        MinBtn.Text = "−"
    end
end)

-- TẠO TAB + PAGE (giữ nguyên từ code cũ nhưng gán parent chính xác)
local tabButtons = {}
local tabPages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.BorderSizePixel = 0
    page.Visible = false
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = page
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 8)
    page.Parent = ContentContainer
    tabPages[name] = page
    return page
end

local function createTabButton(name, icon, transKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(28, 35, 48)
    btn.BorderSizePixel = 0
    btn.Text = icon .. "  " .. transKey
    btn.TextColor3 = Color3.fromRGB(180, 190, 210)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 10)
    
    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 3, 0, 14)
    pill.Position = UDim2.new(0, -7, 0.5, -7)
    pill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pill.Visible = false
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    pill.Parent = btn
    
    btn.Parent = Sidebar
    
    tabButtons[name] = {
        Button = btn,
        Pill = pill
    }
    
    btn.MouseButton1Click:Connect(function()
        for tName, item in pairs(tabButtons) do
            if tName == name then
                item.Button.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
                item.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                item.Pill.Visible = true
            else
                item.Button.BackgroundColor3 = Color3.fromRGB(28, 35, 48)
                item.Button.TextColor3 = Color3.fromRGB(180, 190, 210)
                item.Pill.Visible = false
            end
        end
        for pName, page in pairs(tabPages) do
            page.Visible = (pName == name)
        end
    end)
end

-- TẠO CÁC TAB
local tabNames = {
    {key = "Farm", icon = "🌾", label = "Farm Level"},
    {key = "Fruit", icon = "🍎", label = "Trái Ác Quỷ"},
    {key = "PVP-ESP", icon = "⚔️", label = "PVP & ESP"},
    {key = "Server", icon = "🌐", label = "Máy Chủ"},
    {key = "RAID", icon = "⚡", label = "Đi Raid"},
    {key = "FARM ITEM", icon = "🗡️", label = "Farm Item"},
    {key = "SETTING", icon = "⚙️", label = "Cài Đặt"},
}

for _, t in ipairs(tabNames) do
    createTabButton(t.key, t.icon, t.label)
    createPage(t.key)
end

-- MẶC ĐỊNH MỞ TAB FARM
for tName, item in pairs(tabButtons) do
    if tName == "Farm" then
        item.Button.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
        item.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        item.Pill.Visible = true
    else
        item.Button.BackgroundColor3 = Color3.fromRGB(28, 35, 48)
        item.Button.TextColor3 = Color3.fromRGB(180, 190, 210)
        item.Pill.Visible = false
    end
end
for pName, page in pairs(tabPages) do
    page.Visible = (pName == "Farm")
end

print("✅ UI khởi tạo thành công! Panel sẽ hiện sau 0.5s.")

-- ĐẢM BẢO HIỂN THỊ
task.wait(0.5)
MainFrame.Visible = true
FloatingButton.Visible = false

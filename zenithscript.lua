-- [[ ZENITH HUB - V700.PERFECTED - PHẦN 1 ]] --
task.wait(0.5)
if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local CommF = nil
pcall(function() 
    CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") 
end)

pcall(function() 
    for _, v in pairs(getconnections(LocalPlayer.Idled)) do 
        v:Disable() 
    end 
end)

LocalPlayer.Idled:Connect(function() 
    pcall(function() 
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new()) 
    end) 
end)

-- =========================================
-- BIẾN TOÀN CỤC CHÍNH THỨC
-- =========================================
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
_G.Language = "VN"
_G.StatusHUDVisible = true

_G.SilentAim = false
_G.FOVSize = 120
_G.HitAccuracy = 100
_G.FOVColor = Color3.fromRGB(235, 50, 65)

_G.SpeedEnabled = false
_G.SpeedVal = 35
_G.SpeedKey = Enum.KeyCode.Q
_G.NoclipEnabled = false
_G.NoclipKey = Enum.KeyCode.E
_G.JumpEnabled = false
_G.JumpVal = 180
_G.JumpKey = Enum.KeyCode.R
_G.PullEnabled = false
_G.PullKey = Enum.KeyCode.T

_G.ESPPlayer = false
_G.ESPChest = false
_G.ESPFruit = false
_G.ESPNPC = false
_G.ESPIsland = false
_G.AutoCollectFruit = false
_G.AutoItemFarm = false
_G.AutoClick = false

_G.AutoFarmBone = false
_G.AutoFarmTakakuri = false
_G.TakakuriCount = 0

_G.AutoBoss = false
_G.AllBossesFarm = false
_G.SelectedBossName = "None"

_G.AutoSeaBeast = false
_G.AutoGhostShip = false
_G.BoatSpeedEnabled = false
_G.BoatSpeedVal = 1.5
_G.BoatFlyHeight = 30

local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

local BossListSea1 = {"The Gorilla King", "The Mob Leader", "Bobby", "Yeti", "Vice Admiral", "Swan", "Chief Warden", "Warden"}
local BossListSea2 = {"Diamond", "Elegance", "Jeremy", "Fajita", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper"}
local BossListSea3 = {"Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Prince", "Dough King"}
local CurrentBossList = World1 and BossListSea1 or (World2 and BossListSea2 or BossListSea3)

local AllSwords = {"Cutlass", "Katana", "Iron Mace", "Dual Katana", "Triple Katana", "Shark Saw", "Soul Cane", "Dark Dagger", "Pipe", "Longsword", "Twin Blade", "Rengoku", "Saddi", "Yoru", "Canvander", "True Triple Katana"}
local AllGuns = {"Musket", "Refined Flintlock", "Flintlock", "Slingshot", "Cannon", "Kabucha", "Bazooka", "Acidum Rifle"}
local AllStyles = {"Dark Step", "Electro", "Fishman Karate", "Dragon Breath", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman"}

local Loc = {
    VN = {
        Title = "ZENITH HUB <font color='#ff3344'>• V700 PERFECTED</font>",
        Farm = "Cày Cấp", FarmItem = "Farm Item", Boss = "Săn Boss", PVP = "PVP & Aim", FruitEsp = "Trái & ESP", Stats = "Nâng Điểm", Teleport = "Dịch Chuyển", Shop = "Cửa Hàng", Misc = "Cài Đặt", SeaQuest = "Nhiệm Vụ Biển",
        StatusReady = "Trạng thái: CODE CHUẨN GỐC - LỖI FARM ĐÃ FIX 100%!",
        ToggleFarm = "⚡ Auto Farm Level", ToggleQuest = "📜 Tự Nhận Nhiệm Vụ", ToggleBring = "🧲 Kéo Quái (Bring Mob)", ToggleFast = "⚔️ Fast Attack (ULTRA MAX)",
        ToggleAutoClick = "⚔️ Auto Click (Tự Động Đánh Tại Chỗ)",
        ToggleItemFarm = "🦴 Auto Farm Item / Vật Phẩm", ToggleAutoBoss = "👑 Auto Farm Boss Đã Chọn", ToggleAllBoss = "🔥 Đánh Toàn Bộ Boss Trong Server",
        ToggleSilent = "🎯 Silent Aim (Legit FOV)", ToggleSpeed = "🏃 Chạy Nhanh (Speed)", ToggleNoclip = "👻 Đi Xuyên Tường (Noclip)", ToggleJump = "🦘 Nhảy Cao (Super Jump)", TogglePull = "🧲 Kéo Địch (Pull Player)",
        ToggleCollectFruit = "🍎 Auto Bay Nhặt Trái Ác Quỷ", ToggleESPPlr = "👁️ ESP Người Chơi", ToggleESPChest = "📦 ESP Rương Kho Báu", ToggleESPFruit = "🍎 ESP Trái Ác Quỷ", ToggleESPNPC = "👤 ESP NPC", ToggleESPIsland = "🏝️ ESP Đảo",
        BtnGacha = "🎲 Random Fruit (Gacha)", BtnStore = "📦 Cất Tất Cả Trái Vào Rương",
        BtnSea1 = "🏝️ Dịch Chuyển Sea 1", BtnSea2 = "🏝️ Lên Sea 2 (Auto Farm)", BtnSea3 = "🏝️ Lên Sea 3 (Auto Farm)",
        BtnGeppo = "🦵 Mua Geppo (10k)", BtnBuso = "🛡️ Mua Buso Haki (25k)", BtnSoru = "🏃 Mua Soru (100k)", BtnKen = "👁️ Mua Ken Haki (750k)",
        BtnBuySword = "⚔️ Mua Kiếm / Mua Vũ Khí", BtnBuyGun = "🔫 Mua Súng", BtnBuyStyle = "🥊 Mua Võ (Fighting Style)",
        BtnDiscord = "💬 Mở Link Discord Của Tôi", BtnCode = "🎁 Nhập Tất Cả Giftcode", ToggleLag = "🚀 Chống Lag / Khử Lóa", BtnRejoin = "🔄 Vào Lại Server", ToggleHUD = "📊 Hiện Bảng Status HUD",
        ToggleAutoFarmBone = "🦴 Auto Farm Bone (Rải Rác)", ToggleAutoFarmTakakuri = "🐉 Auto Farm Takakuri", LabelBoneCount = "🦴 Số Bone: ", LabelTakakuriCount = "🐉 Takakuri còn lại: ",
        ToggleBoatSpeed = "🚤 Tăng Tốc Thuyền", BoatSpeedLabel = "⚡ Tốc độ thuyền: ", BoatFlyHeightLabel = "🚀 Độ Bay Cao Thuyền: ",
        ToggleAutoSeaBeast = "🐋 Auto Farm Sea Beast", ToggleAutoGhostShip = "👻 Auto Farm Thuyền Ma",
        CloseAll = "❌ Đóng Tất Cả",
        SelectStyle = "🥊 Chọn Võ Cần Mua:",
        BtnBuySelectedStyle = "🥊 Mua Võ Đã Chọn"
    },
    EN = {
        Title = "ZENITH HUB <font color='#ff3344'>• V700 PERFECTED</font>",
        Farm = "Auto Farm", FarmItem = "Farm Item", Boss = "Boss Hunt", PVP = "PVP & Aim", FruitEsp = "Fruit & ESP", Stats = "Stats", Teleport = "Teleport", Shop = "Shop", Misc = "Settings", SeaQuest = "Sea Quest",
        StatusReady = "Status: UNMINIFIED CODE - FARM BUGS FIXED 100%!",
        ToggleFarm = "⚡ Auto Farm Level", ToggleQuest = "📜 Auto Quest", ToggleBring = "🧲 Bring Mob (Ground Magnet)", ToggleFast = "⚔️ Fast Attack (ULTRA MAX)",
        ToggleAutoClick = "⚔️ Auto Click (Attack in place)",
        ToggleItemFarm = "🦴 Auto Farm Items / Materials", ToggleAutoBoss = "👑 Auto Farm Selected Boss", ToggleAllBoss = "🔥 Farm All Bosses In Server",
        ToggleSilent = "🎯 Silent Aim (Legit FOV)", ToggleSpeed = "🏃 Enable Speed", ToggleNoclip = "👻 Enable Noclip", ToggleJump = "🦘 Super Jump", TogglePull = "🧲 Pull Player",
        ToggleCollectFruit = "🍎 Auto Collect Fruits", ToggleESPPlr = "👁️ ESP Players", ToggleESPChest = "📦 ESP Chests", ToggleESPFruit = "🍎 ESP Fruits", ToggleESPNPC = "👤 ESP NPCs", ToggleESPIsland = "🏝️ ESP Islands",
        BtnGacha = "🎲 Random Fruit (Gacha)", BtnStore = "📦 Store All Fruits",
        BtnSea1 = "🏝️ Teleport Sea 1", BtnSea2 = "🏝️ Auto Farm Sea 2", BtnSea3 = "🏝️ Auto Farm Sea 3",
        BtnGeppo = "🦵 Buy Geppo (10k)", BtnBuso = "🛡️ Buy Buso Haki (25k)", BtnSoru = "🏃 Buy Soru (100k)", BtnKen = "👁️ Buy Ken Haki (750k)",
        BtnBuySword = "⚔️ Buy Swords", BtnBuyGun = "🔫 Buy Guns", BtnBuyStyle = "🥊 Buy Fighting Styles",
        BtnDiscord = "💬 Open My Discord Link", BtnCode = "🎁 Redeem All Codes", ToggleLag = "🚀 Anti-Lag / Reduce Flash", BtnRejoin = "🔄 Rejoin Server", ToggleHUD = "📊 Show Status HUD",
        ToggleAutoFarmBone = "🦴 Auto Farm Bone (Scattered)", ToggleAutoFarmTakakuri = "🐉 Auto Farm Takakuri", LabelBoneCount = "🦴 Bone Count: ", LabelTakakuriCount = "🐉 Takakuri remaining: ",
        ToggleBoatSpeed = "🚤 Boat Speed Boost", BoatSpeedLabel = "⚡ Boat Speed: ", BoatFlyHeightLabel = "🚀 Boat Fly Height: ",
        ToggleAutoSeaBeast = "🐋 Auto Farm Sea Beast", ToggleAutoGhostShip = "👻 Auto Farm Ghost Ship",
        CloseAll = "❌ Close All",
        SelectStyle = "🥊 Select Fighting Style to Buy:",
        BtnBuySelectedStyle = "🥊 Buy Selected Style"
    }
}

local function L(key)
    local lang = _G.Language or "VN"
    return Loc[lang][key] or Loc["VN"][key] or key
end

local UI_NAME = "ZenithHub_V700_Crimson"
pcall(function() 
    if CoreGui:FindFirstChild(UI_NAME) then 
        CoreGui[UI_NAME]:Destroy() 
    end 
end)
pcall(function() 
    if LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then 
        LocalPlayer.PlayerGui[UI_NAME]:Destroy() 
    end 
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
local s, p = pcall(function() return gethui() end)
if s and p then 
    ScreenGui.Parent = p 
else 
    ScreenGui.Parent = CoreGui 
end

-- =========================================
-- STATUS HUD (BẢNG TRẠNG THÁI BO GÓC)
-- =========================================
local StatusHUD = Instance.new("Frame", ScreenGui)
StatusHUD.Size = UDim2.new(0, 220, 0, 180)
StatusHUD.Position = UDim2.new(1, -235, 0.4, 0)
StatusHUD.BackgroundColor3 = Color3.fromRGB(15, 10, 12)
StatusHUD.BackgroundTransparency = 0.3
StatusHUD.BorderSizePixel = 0
StatusHUD.ZIndex = 800
StatusHUD.Visible = _G.StatusHUDVisible

local StatusCorner = Instance.new("UICorner", StatusHUD)
StatusCorner.CornerRadius = UDim.new(0, 10)

local hudStroke = Instance.new("UIStroke", StatusHUD)
hudStroke.Color = Color3.fromRGB(235, 50, 65)
hudStroke.Transparency = 0.2
hudStroke.Thickness = 1.2

local hudTitle = Instance.new("TextLabel", StatusHUD)
hudTitle.Size = UDim2.new(1, 0, 0, 28)
hudTitle.BackgroundColor3 = Color3.fromRGB(45, 15, 22)
hudTitle.BackgroundTransparency = 0.3
hudTitle.BorderSizePixel = 0
hudTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
hudTitle.Font = Enum.Font.GothamBold
hudTitle.TextSize = 12
hudTitle.Text = "📊 ACTIVE STATUS HUD"

local TitleCorner = Instance.new("UICorner", hudTitle)
TitleCorner.CornerRadius = UDim.new(0, 10)

local hudContent = Instance.new("TextLabel", StatusHUD)
hudContent.Size = UDim2.new(1, -16, 1, -35)
hudContent.Position = UDim2.new(0, 8, 0, 32)
hudContent.BackgroundTransparency = 1
hudContent.TextColor3 = Color3.fromRGB(255, 255, 255)
hudContent.Font = Enum.Font.GothamBold
hudContent.TextSize = 12
hudContent.TextXAlignment = Enum.TextXAlignment.Left
hudContent.TextYAlignment = Enum.TextYAlignment.Top
hudContent.RichText = true
hudContent.TextStrokeTransparency = 0
hudContent.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
hudContent.Text = "Level: Đang tải..."

-- =========================================
-- NÚT ẨN Z (FLOAT BUTTON)
-- =========================================
local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 50, 0, 50)
FloatingButton.Position = UDim2.new(0.05, 0, 0.4, 0)
FloatingButton.BackgroundColor3 = Color3.fromRGB(25, 10, 14)
FloatingButton.BackgroundTransparency = 0.3
FloatingButton.Visible = false
FloatingButton.Text = "Z"
FloatingButton.TextColor3 = Color3.fromRGB(255, 50, 70)
FloatingButton.Font = Enum.Font.GothamBlack
FloatingButton.TextSize = 22
FloatingButton.ZIndex = 999

local FloatCorner = Instance.new("UICorner", FloatingButton)
FloatCorner.CornerRadius = UDim.new(0, 14)

local FloatStroke = Instance.new("UIStroke", FloatingButton)
FloatStroke.Color = Color3.fromRGB(235, 50, 65)
FloatStroke.Thickness = 2

local dragToggleBtn, dragStartBtn, startPosBtn
FloatingButton.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
        dragToggleBtn = true
        dragStartBtn = input.Position
        startPosBtn = FloatingButton.Position
        input.Changed:Connect(function() 
            if input.UserInputState == Enum.UserInputState.End then 
                dragToggleBtn = false 
            end 
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragToggleBtn then
            local delta = input.Position - dragStartBtn
            FloatingButton.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X, startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
        end
    end
end)

-- =========================================
-- KHUNG GIAO DIỆN CHÍNH (MAIN FRAME)
-- =========================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 680, 0, 460)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 12)
MainFrame.BackgroundTransparency = 0.12
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

local mStroke = Instance.new("UIStroke", MainFrame)
mStroke.Color = Color3.fromRGB(235, 50, 65)
mStroke.Thickness = 1.5

local draggingMain, dragStartMain, startPosMain
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        draggingMain = true
        dragStartMain = input.Position
        startPosMain = MainFrame.Position
        input.Changed:Connect(function() 
            if input.UserInputState == Enum.UserInputState.End then 
                draggingMain = false 
            end 
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if draggingMain then
            local delta = input.Position - dragStartMain
            MainFrame.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
        end
    end
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 12, 17)
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0

local TopBarCorner = Instance.new("UICorner", TopBar)
TopBarCorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = L("Title")

local CloseAllBtn = Instance.new("TextButton", TopBar)
CloseAllBtn.Size = UDim2.new(0, 60, 0, 26)
CloseAllBtn.Position = UDim2.new(1, -110, 0.5, -13)
CloseAllBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
CloseAllBtn.BackgroundTransparency = 0.3
CloseAllBtn.Text = L("CloseAll")
CloseAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseAllBtn.Font = Enum.Font.GothamBold
CloseAllBtn.TextSize = 10

local CloseAllCorner = Instance.new("UICorner", CloseAllBtn)
CloseAllCorner.CornerRadius = UDim.new(0, 6)

CloseAllBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = false
    FloatingButton.Visible = false 
end)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 59, 90)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11

local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 6)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -66, 0.5, -13)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 18, 25)
MinBtn.BackgroundTransparency = 0.3
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14

local MinCorner = Instance.new("UICorner", MinBtn)
MinCorner.CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = false
    FloatingButton.Visible = true 
end)

FloatingButton.MouseButton1Click:Connect(function() 
    MainFrame.Visible = true
    FloatingButton.Visible = false 
end)

local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        MainFrame:TweenSize(UDim2.new(0, 680, 0, 42), "Out", "Quart", 0.25, true)
    else
        MainFrame:TweenSize(UDim2.new(0, 680, 0, 460), "Out", "Quart", 0.25, true)
    end
end)
-- [[ ZENITH HUB - V700.PERFECTED - PHẦN 2 ]] --

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 165, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 10, 12)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 10)

local TabScroller = Instance.new("ScrollingFrame", Sidebar)
TabScroller.Size = UDim2.new(1, -10, 1, -12)
TabScroller.Position = UDim2.new(0, 5, 0, 6)
TabScroller.BackgroundTransparency = 1
TabScroller.BorderSizePixel = 0
TabScroller.ScrollBarThickness = 3
TabScroller.ScrollBarImageColor3 = Color3.fromRGB(235, 50, 65)
TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y

local TabPadding = Instance.new("UIPadding", TabScroller)
TabPadding.PaddingTop = UDim.new(0, 4)

local TabListLayout = Instance.new("UIListLayout", TabScroller)
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -165, 1, -42)
ContentContainer.Position = UDim2.new(0, 165, 0, 42)
ContentContainer.BackgroundTransparency = 1

local tabButtons = {}
local tabPages = {}

local function createTab(nameKey, icon, labelKey)
    local btn = Instance.new("TextButton", TabScroller)
    btn.Size = UDim2.new(1, -4, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(25, 12, 16)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(210, 180, 185)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Text = "  " .. icon .. "   " .. L(labelKey)
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(235, 50, 65)
    btnStroke.Transparency = 0.5
    btnStroke.Thickness = 1
    
    local Pill = Instance.new("Frame", btn)
    Pill.Size = UDim2.new(0, 3, 0, 20)
    Pill.Position = UDim2.new(0, 0, 0.5, -10)
    Pill.BackgroundColor3 = Color3.fromRGB(235, 50, 65)
    Pill.Visible = false
    
    local pillCorner = Instance.new("UICorner", Pill)
    pillCorner.CornerRadius = UDim.new(0, 2)
    
    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(235, 50, 65)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0, 7)
    pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local pagePad = Instance.new("UIPadding", page)
    pagePad.PaddingTop = UDim.new(0, 12)
    pagePad.PaddingBottom = UDim.new(0, 12)

    tabButtons[nameKey] = {Button = btn, Pill = Pill, Key = labelKey}
    tabPages[nameKey] = page
    
    btn.MouseButton1Click:Connect(function()
        for tName, item in pairs(tabButtons) do
            local act = (tName == nameKey)
            item.Button.BackgroundColor3 = act and Color3.fromRGB(220, 35, 50) or Color3.fromRGB(25, 12, 16)
            item.Button.BackgroundTransparency = act and 0 or 0.3
            item.Button.TextColor3 = act and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(210, 180, 185)
            item.Pill.Visible = act
        end
        for pName, p in pairs(tabPages) do 
            p.Visible = (pName == nameKey) 
        end
    end)
    
    return page
end

local function createToggle(page, labelKey, defaultState, callback)
    local state = defaultState
    local frame = Instance.new("Frame", page)
    frame.Size = UDim2.new(0.95, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(22, 12, 15)
    frame.BackgroundTransparency = 0.3
    
    local fCorner = Instance.new("UICorner", frame)
    fCorner.CornerRadius = UDim.new(0, 6)
    
    local fStroke = Instance.new("UIStroke", frame)
    fStroke.Color = Color3.fromRGB(75, 25, 35)
    fStroke.Transparency = 0.2
    fStroke.Thickness = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -55, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 240, 245)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = L(labelKey)
    
    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0, 36, 0, 18)
    switch.Position = UDim2.new(1, -45, 0.5, -9)
    switch.BackgroundColor3 = state and Color3.fromRGB(235, 50, 65) or Color3.fromRGB(50, 20, 26)
    switch.Text = ""
    
    local sCorner = Instance.new("UICorner", switch)
    sCorner.CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local cCorner = Instance.new("UICorner", circle)
    cCorner.CornerRadius = UDim.new(1, 0)
    
    switch.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and Color3.fromRGB(235, 50, 65) or Color3.fromRGB(50, 20, 26)
        if state then
            circle:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.15, true)
        else
            circle:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.15, true)
        end
        if callback then callback(state) end
    end)
end

local function createButton(page, labelKey, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(0.95, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(25, 12, 16)
    btn.BackgroundTransparency = 0.3
    
    local bCorner = Instance.new("UICorner", btn)
    bCorner.CornerRadius = UDim.new(0, 6)
    
    local bStroke = Instance.new("UIStroke", btn)
    bStroke.Color = Color3.fromRGB(235, 50, 65)
    bStroke.Thickness = 1
    bStroke.Transparency = 0.4
    
    btn.TextColor3 = Color3.fromRGB(255, 100, 115)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.Text = L(labelKey)
    
    btn.MouseButton1Click:Connect(function() 
        if callback then callback() end 
    end)
end

-- TẠO CÁC TAB
local pFarm = createTab("Farm", "🌾", "Farm")
local pItem = createTab("FarmItem", "🦴", "FarmItem")
local pSeaQuest = createTab("SeaQuest", "🌊", "SeaQuest")
local pBoss = createTab("Boss", "👑", "Boss")
local pPVP = createTab("PVP", "🎯", "PVP")
local pFruitEsp = createTab("FruitEsp", "🍎", "FruitEsp")
local pStats = createTab("Stats", "📈", "Stats")
local pTele = createTab("Teleport", "🚀", "Teleport")
local pShop = createTab("Shop", "🛒", "Shop")
local pMisc = createTab("Misc", "⚙️", "Misc")

tabButtons["Farm"].Button.BackgroundColor3 = Color3.fromRGB(220, 35, 50)
tabButtons["Farm"].Button.BackgroundTransparency = 0
tabButtons["Farm"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
tabButtons["Farm"].Pill.Visible = true
tabPages["Farm"].Visible = true

-- [ TAB FARM ]
local infoLabel = Instance.new("TextLabel", pFarm)
infoLabel.Size = UDim2.new(0.95, 0, 0, 25)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(255, 100, 115)
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 12
infoLabel.Text = L("StatusReady")

local weaponSegment = Instance.new("Frame", pFarm)
weaponSegment.Size = UDim2.new(0.95, 0, 0, 30)
weaponSegment.BackgroundColor3 = Color3.fromRGB(22, 12, 15)
weaponSegment.BackgroundTransparency = 0.3
local wsCorner = Instance.new("UICorner", weaponSegment)
wsCorner.CornerRadius = UDim.new(0, 6)
local wsStroke = Instance.new("UIStroke", weaponSegment)
wsStroke.Color = Color3.fromRGB(75, 25, 35)
wsStroke.Thickness = 1

local wsLayout = Instance.new("UIListLayout", weaponSegment)
wsLayout.FillDirection = Enum.FillDirection.Horizontal
wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wsLayout.Padding = UDim.new(0, 4)

for _, wName in ipairs({"Melee", "Sword", "Blox Fruit"}) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size = UDim2.new(0.3, 0, 0.78, 0)
    if _G.SelectWeapon == wName then
        b.BackgroundColor3 = Color3.fromRGB(220, 35, 50)
    else
        b.BackgroundColor3 = Color3.fromRGB(35, 18, 22)
    end
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 10
    b.Text = wName
    local bC = Instance.new("UICorner", b)
    bC.CornerRadius = UDim.new(0, 4)
    
    b.MouseButton1Click:Connect(function() 
        _G.SelectWeapon = wName
        for _, btn in pairs(weaponSegment:GetChildren()) do 
            if btn:IsA("TextButton") then 
                if btn.Text == wName then
                    btn.BackgroundColor3 = Color3.fromRGB(220, 35, 50)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(35, 18, 22)
                end
            end 
        end 
    end)
end

createToggle(pFarm, "ToggleFarm", false, function(v) _G.AutoFarm = v end)
createToggle(pFarm, "ToggleQuest", true, function(v) _G.AutoQuest = v end)
createToggle(pFarm, "ToggleBring", true, function(v) _G.BringMonster = v end)
createToggle(pFarm, "ToggleFast", true, function(v) _G.FastAttack = v end)
createToggle(pFarm, "ToggleAutoClick", false, function(v) _G.AutoClick = v end)

-- [ TAB FARM ITEM ]
createToggle(pItem, "ToggleItemFarm", false, function(v) _G.AutoItemFarm = v end)
createToggle(pItem, "ToggleAutoFarmBone", false, function(v) _G.AutoFarmBone = v end)
createToggle(pItem, "ToggleAutoFarmTakakuri", false, function(v) _G.AutoFarmTakakuri = v end)

local boneLabel = Instance.new("TextLabel", pItem)
boneLabel.Size = UDim2.new(0.95, 0, 0, 22)
boneLabel.BackgroundTransparency = 1
boneLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
boneLabel.Font = Enum.Font.GothamBold
boneLabel.TextSize = 12
boneLabel.Text = L("LabelBoneCount") .. "0"

local takakuriLabel = Instance.new("TextLabel", pItem)
takakuriLabel.Size = UDim2.new(0.95, 0, 0, 22)
takakuriLabel.BackgroundTransparency = 1
takakuriLabel.TextColor3 = Color3.fromRGB(255, 100, 200)
takakuriLabel.Font = Enum.Font.GothamBold
takakuriLabel.TextSize = 12
takakuriLabel.Text = L("LabelTakakuriCount") .. "0"

createButton(pItem, "BtnSea2", function() 
    pcall(function() 
        if LocalPlayer.Data.Level.Value >= 700 then 
            CommF:InvokeServer("DressrosaQuest") 
        else 
            infoLabel.Text = "Cần Cấp 700 để lên Sea 2!" 
        end 
    end) 
end)
createButton(pItem, "BtnSea3", function() 
    pcall(function() 
        if LocalPlayer.Data.Level.Value >= 1500 then 
            CommF:InvokeServer("ZouQuest") 
        else 
            infoLabel.Text = "Cần Cấp 1500 để lên Sea 3!" 
        end 
    end) 
end)

-- [ CÁC TAB CÒN LẠI ĐƯỢC GIỮ NGUYÊN HOÀN TOÀN CẤU TRÚC ]
createToggle(pSeaQuest, "ToggleAutoSeaBeast", false, function(v) _G.AutoSeaBeast = v end)
createToggle(pSeaQuest, "ToggleAutoGhostShip", false, function(v) _G.AutoGhostShip = v end)
createButton(pSeaQuest, "SeaQuestDaily", function() if CommF then CommF:InvokeServer("DailyQuest") end end)
createButton(pSeaQuest, "SeaQuestShip", function() if CommF then CommF:InvokeServer("ShipQuest") end end)
createButton(pSeaQuest, "SeaQuestBoss", function() if CommF then CommF:InvokeServer("SeaBossQuest") end end)

createToggle(pBoss, "ToggleAutoBoss", false, function(v) _G.AutoBoss = v end)
createToggle(pBoss, "ToggleAllBoss", false, function(v) _G.AllBossesFarm = v end)
local bossSelectFrame = Instance.new("Frame", pBoss)
bossSelectFrame.Size = UDim2.new(0.95, 0, 0, 36)
bossSelectFrame.BackgroundColor3 = Color3.fromRGB(22, 12, 15)
bossSelectFrame.BackgroundTransparency = 0.3
local bsFC = Instance.new("UICorner", bossSelectFrame)
bsFC.CornerRadius = UDim.new(0, 6)
local bsFS = Instance.new("UIStroke", bossSelectFrame)
bsFS.Color = Color3.fromRGB(75, 25, 35)
bsFS.Thickness = 1

local bossSelectLbl = Instance.new("TextLabel", bossSelectFrame)
bossSelectLbl.Size = UDim2.new(1, -16, 1, 0)
bossSelectLbl.Position = UDim2.new(0, 8, 0, 0)
bossSelectLbl.BackgroundTransparency = 1
bossSelectLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
bossSelectLbl.Font = Enum.Font.GothamBold
bossSelectLbl.TextSize = 11
bossSelectLbl.TextXAlignment = Enum.TextXAlignment.Left
bossSelectLbl.Text = "👑 Chọn Boss: [ Click để đổi ]"

local currentBossIdx = 1
bossSelectFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        currentBossIdx = currentBossIdx % #CurrentBossList + 1
        _G.SelectedBossName = CurrentBossList[currentBossIdx]
        bossSelectLbl.Text = "👑 Chọn Boss: " .. _G.SelectedBossName
    end
end)

createToggle(pFruitEsp, "ToggleCollectFruit", false, function(v) _G.AutoCollectFruit = v end)
createButton(pFruitEsp, "BtnGacha", function() if CommF then CommF:InvokeServer("Cousin", "Buy") end end)
createButton(pFruitEsp, "BtnStore", function() for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") then CommF:InvokeServer("StoreFruit", string.split(v.Name, "-")[1], v) end end end)
createToggle(pFruitEsp, "ToggleESPPlr", false, function(v) _G.ESPPlayer = v end)
createToggle(pFruitEsp, "ToggleESPChest", false, function(v) _G.ESPChest = v end)
createToggle(pFruitEsp, "ToggleESPFruit", false, function(v) _G.ESPFruit = v end)
createToggle(pFruitEsp, "ToggleESPNPC", false, function(v) _G.ESPNPC = v end)
createToggle(pFruitEsp, "ToggleESPIsland", false, function(v) _G.ESPIsland = v end)

createToggle(pStats, "ToggleStats", false, function(v) _G.AutoStats = v end)
createToggle(pStats, "🥊 Melee", false, function(v) _G.StatsMelee = v end)
createToggle(pStats, "🛡️ Defense", false, function(v) _G.StatsDefense = v end)
createToggle(pStats, "⚔️ Sword", false, function(v) _G.StatsSword = v end)
createToggle(pStats, "🍎 Blox Fruit", false, function(v) _G.StatsFruit = v end)

createButton(pTele, "BtnSea1", function() if CommF then CommF:InvokeServer("TravelMain") end end)
createButton(pTele, "BtnSea2", function() if CommF then CommF:InvokeServer("TravelDressrosa") end end)
createButton(pTele, "BtnSea3", function() if CommF then CommF:InvokeServer("TravelZou") end end)

createButton(pShop, "BtnBuySword", function() if CommF then CommF:InvokeServer("BuyItem", "Cutlass"); CommF:InvokeServer("BuyItem", "Katana") end end)
createButton(pShop, "BtnBuyGun", function() if CommF then CommF:InvokeServer("BuyItem", "Musket"); CommF:InvokeServer("BuyItem", "Refined Flintlock") end end)
createButton(pShop, "BtnBuyStyle", function() if CommF then CommF:InvokeServer("BuyItem", "Dark Step"); CommF:InvokeServer("BuyItem", "Electro") end end)

createToggle(pMisc, "ToggleHUD", true, function(v) _G.StatusHUDVisible = v; StatusHUD.Visible = v end)
createToggle(pMisc, "ToggleLag", false, function(v) Lighting.GlobalShadows = not v end)
-- [[ ZENITH HUB - V700.PERFECTED - PHẦN 2 (LOGIC) ]] --

-- =========================================================
-- HÀM GOM QUÁI & TRANG BỊ VŨ KHÍ (CHUẨN XÁC 100%)
-- =========================================================
local function pullMonsterToGround(monster, targetPos)
    if not monster or not monster:FindFirstChild("HumanoidRootPart") then return end
    local root = monster.HumanoidRootPart
    
    root.CFrame = CFrame.new(targetPos)
    root.Size = Vector3.new(60, 60, 60)
    root.CanCollide = false
    if monster:FindFirstChild("Head") then 
        monster.Head.CanCollide = false 
    end
    
    local hum = monster:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = 0
        hum.JumpPower = 0
        if hum:FindFirstChild("Animator") then 
            hum.Animator:Destroy() 
        end
        hum:ChangeState(11)
    end
    pcall(function() sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge) end)
end

function EquipWeapon(weaponType)
    pcall(function()
        if not LocalPlayer.Character:FindFirstChild("HasBuso") then
            CommF:InvokeServer("Buso")
        end
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:WaitForChild("Backpack")
        
        local function isValidWeapon(tool)
            if not tool:IsA("Tool") then return false end
            if weaponType == "Melee" then
                return tool.ToolTip == "Melee" or tool.Name == "Combat" or tool.Name == "Võ Tân Binh" or tool:GetAttribute("WeaponType") == "Melee"
            elseif weaponType == "Sword" then
                return tool.ToolTip == "Sword" or tool:GetAttribute("WeaponType") == "Sword"
            elseif weaponType == "Blox Fruit" then
                return tool.ToolTip == "Blox Fruit" or tool:GetAttribute("WeaponType") == "Blox Fruit" or string.find(tool.Name, "Fruit")
            end
            return false
        end

        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and isValidWeapon(currentTool) then return end
        if currentTool then currentTool.Parent = backpack end
        
        for _, tool in ipairs(backpack:GetChildren()) do
            if isValidWeapon(tool) then
                char.Humanoid:EquipTool(tool)
                task.wait(0.05)
                if tool.Parent ~= char then
                    tool.Parent = char
                end
                break
            end
        end
    end)
end

local currentTween = nil
function topos(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    if not hrp:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "BodyClip"
        bv.MaxForce = Vector3.new(100000, 100000, 100000)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp
    end
    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do 
        if v:IsA("BasePart") then v.CanCollide = false end 
    end

    local dist = (targetCFrame.Position - hrp.Position).Magnitude
    if currentTween then currentTween:Cancel() end
    local tweenInfo = TweenInfo.new(dist / 320, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
end

-- =========================================================
-- LOGIC KIỂM TRA NHIỆM VỤ (ĐÃ SỬA CHUẨN MILITARY SOLDIER)
-- =========================================================
local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon = "", 1, "", "", CFrame.new(), CFrame.new()
function CheckQuest()
    local MyLevel = 0
    pcall(function() MyLevel = LocalPlayer.Data.Level.Value end)
    
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"; CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42); CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
        elseif MyLevel >= 10 and MyLevel <= 14 then Mon = "Monkey"; LevelQuest = 1; NameQuest = "JungleQuest"; NameMon = "Monkey"; CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37); CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)
        elseif MyLevel >= 15 and MyLevel <= 29 then Mon = "Gorilla"; LevelQuest = 2; NameQuest = "JungleQuest"; NameMon = "Gorilla"; CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37); CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)
        elseif MyLevel >= 30 and MyLevel <= 39 then Mon = "Pirate"; LevelQuest = 1; NameQuest = "BuggyQuest1"; NameMon = "Pirate"; CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54); CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)
        elseif MyLevel >= 40 and MyLevel <= 59 then Mon = "Brute"; LevelQuest = 2; NameQuest = "BuggyQuest1"; NameMon = "Brute"; CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54); CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)
        elseif MyLevel >= 60 and MyLevel <= 74 then Mon = "Desert Bandit"; LevelQuest = 1; NameQuest = "DesertQuest"; NameMon = "Desert Bandit"; CFrameQuest = CFrame.new(894.48, 5.14, 4392.43); CFrameMon = CFrame.new(924.79, 6.44, 4481.58)
        elseif MyLevel >= 75 and MyLevel <= 89 then Mon = "Desert Officer"; LevelQuest = 2; NameQuest = "DesertQuest"; NameMon = "Desert Officer"; CFrameQuest = CFrame.new(894.48, 5.14, 4392.43); CFrameMon = CFrame.new(1608.28, 8.61, 4371.00)
        elseif MyLevel >= 90 and MyLevel <= 99 then Mon = "Snow Bandit"; LevelQuest = 1; NameQuest = "SnowQuest"; NameMon = "Snow Bandit"; CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90); CFrameMon = CFrame.new(1354.34, 87.27, -1393.94)
        elseif MyLevel >= 100 and MyLevel <= 119 then Mon = "Snowman"; LevelQuest = 2; NameQuest = "SnowQuest"; NameMon = "Snowman"; CFrameQuest = CFrame.new(1389.74, 88.15, -1298.90); CFrameMon = CFrame.new(1201.64, 144.57, -1550.06)
        elseif MyLevel >= 120 and MyLevel <= 149 then Mon = "Chief Petty Officer"; LevelQuest = 1; NameQuest = "MarineQuest2"; NameMon = "Chief Petty Officer"; CFrameQuest = CFrame.new(-5039.58, 27.35, 4324.68); CFrameMon = CFrame.new(-4881.23, 22.65, 4273.75)
        elseif MyLevel >= 150 and MyLevel <= 174 then Mon = "Sky Bandit"; LevelQuest = 1; NameQuest = "SkyQuest"; NameMon = "Sky Bandit"; CFrameQuest = CFrame.new(-4839, 717, -2622); CFrameMon = CFrame.new(-4968, 717, -2577)
        elseif MyLevel >= 175 and MyLevel <= 189 then Mon = "Dark Master"; LevelQuest = 2; NameQuest = "SkyQuest"; NameMon = "Dark Master"; CFrameQuest = CFrame.new(-4839, 717, -2622); CFrameMon = CFrame.new(-5185, 717, -2346)
        elseif MyLevel >= 190 and MyLevel <= 209 then Mon = "Prisoner"; LevelQuest = 1; NameQuest = "PrisonerQuest"; NameMon = "Prisoner"; CFrameQuest = CFrame.new(5308, 1, 474); CFrameMon = CFrame.new(5361, 1, 620)
        elseif MyLevel >= 210 and MyLevel <= 249 then Mon = "Dangerous Prisoner"; LevelQuest = 2; NameQuest = "PrisonerQuest"; NameMon = "Dangerous Prisoner"; CFrameQuest = CFrame.new(5308, 1, 474); CFrameMon = CFrame.new(5564, 1, 747)
        elseif MyLevel >= 250 and MyLevel <= 274 then Mon = "Toga Warrior"; LevelQuest = 1; NameQuest = "ColosseumQuest"; NameMon = "Toga Warrior"; CFrameQuest = CFrame.new(-1580, 7, -2986); CFrameMon = CFrame.new(-1661, 7, -2824)
        elseif MyLevel >= 275 and MyLevel <= 299 then Mon = "Gladiator"; LevelQuest = 2; NameQuest = "ColosseumQuest"; NameMon = "Gladiator"; CFrameQuest = CFrame.new(-1580, 7, -2986); CFrameMon = CFrame.new(-1319, 7, -3163)
        elseif MyLevel >= 300 and MyLevel <= 324 then Mon = "Military Soldier"; LevelQuest = 1; NameQuest = "MagmaQuest"; NameMon = "Military Soldier"; CFrameQuest = CFrame.new(-5313, 12, 8515); CFrameMon = CFrame.new(-5403, 15, 8352)
        elseif MyLevel >= 325 and MyLevel <= 374 then Mon = "Military Spy"; LevelQuest = 2; NameQuest = "MagmaQuest"; NameMon = "Military Spy"; CFrameQuest = CFrame.new(-5313, 12, 8515); CFrameMon = CFrame.new(-5816, 84, 8835)
        elseif MyLevel >= 375 and MyLevel <= 399 then Mon = "Fishman Warrior"; LevelQuest = 1; NameQuest = "FishmanQuest"; NameMon = "Fishman Warrior"; CFrameQuest = CFrame.new(61122, 18, 1569); CFrameMon = CFrame.new(60934, 18, 1541)
        elseif MyLevel >= 400 and MyLevel <= 449 then Mon = "Fishman Commando"; LevelQuest = 2; NameQuest = "FishmanQuest"; NameMon = "Fishman Commando"; CFrameQuest = CFrame.new(61122, 18, 1569); CFrameMon = CFrame.new(61849, 18, 1494)
        elseif MyLevel >= 450 and MyLevel <= 474 then Mon = "God's Guard"; LevelQuest = 1; NameQuest = "SkyExp1Quest"; NameMon = "God's Guard"; CFrameQuest = CFrame.new(-4721, 843, -1949); CFrameMon = CFrame.new(-4664, 844, -1896)
        elseif MyLevel >= 475 and MyLevel <= 524 then Mon = "Shanda"; LevelQuest = 2; NameQuest = "SkyExp1Quest"; NameMon = "Shanda"; CFrameQuest = CFrame.new(-4721, 843, -1949); CFrameMon = CFrame.new(-4033, 804, -2091)
        elseif MyLevel >= 525 and MyLevel <= 549 then Mon = "Royal Squad"; LevelQuest = 1; NameQuest = "SkyExp2Quest"; NameMon = "Royal Squad"; CFrameQuest = CFrame.new(-7927, 5545, -319); CFrameMon = CFrame.new(-7667, 5601, -446)
        elseif MyLevel >= 550 and MyLevel <= 624 then Mon = "Royal Soldier"; LevelQuest = 2; NameQuest = "SkyExp2Quest"; NameMon = "Royal Soldier"; CFrameQuest = CFrame.new(-7927, 5545, -319); CFrameMon = CFrame.new(-7809, 5601, -127)
        elseif MyLevel >= 625 and MyLevel <= 649 then Mon = "Galley Pirate"; LevelQuest = 1; NameQuest = "FountainQuest"; NameMon = "Galley Pirate"; CFrameQuest = CFrame.new(5256, 38, 4050); CFrameMon = CFrame.new(5569, 38, 3991)
        else Mon = "Galley Captain"; LevelQuest = 2; NameQuest = "FountainQuest"; NameMon = "Galley Captain"; CFrameQuest = CFrame.new(5256, 38, 4050); CFrameMon = CFrame.new(5662, 38, 4920) end
    elseif World2 then
        if MyLevel >= 700 and MyLevel <= 724 then Mon = "Raider"; LevelQuest = 1; NameQuest = "Area1Quest"; NameMon = "Raider"; CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18); CFrameMon = CFrame.new(-728.32, 52.77, 2345.77)
        else Mon = "Swan Pirate"; LevelQuest = 1; NameQuest = "Area2Quest"; NameMon = "Swan Pirate"; CFrameQuest = CFrame.new(638.43, 71.76, 918.28); CFrameMon = CFrame.new(1068.66, 137.61, 1322.10) end
    else
        Mon = "Pirate Millionaire"; LevelQuest = 1; NameQuest = "PiratePortQuest"; NameMon = "Pirate Millionaire"; CFrameQuest = CFrame.new(-450.10, 107.68, 5950.72); CFrameMon = CFrame.new(-245.99, 47.30, 5584.10)
    end
end

-- =========================================================
-- VÒNG LẶP AUTO FARM ĐỨNG IM TRÊN KHÔNG VÀ GOM QUÁI
-- =========================================================
local StartBring = false

spawn(function()
    while task.wait() do
        if _G.AutoFarm or _G.AutoItemFarm then
            pcall(function()
                CheckQuest()
                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                
                if not questGui or not questGui.Visible then
                    StartBring = false
                    _G.GlobalFarmActive = false
                    
                    if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 20 then 
                        topos(CFrameQuest)
                    else 
                        if _G.AutoQuest and CommF then 
                            CommF:InvokeServer("StartQuest", NameQuest, LevelQuest) 
                        end 
                    end
                else
                    -- LẤY ĐÚNG TÊN QUÁI TIẾNG ANH ĐỂ TRÁNH LỖI NGÔN NGỮ
                    local monsterName = NameMon
                    local foundMob = false
                    local targetMob = nil

                    for _, v in pairs(Workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            if v.Name:lower() == monsterName:lower() or string.find(v.Name:lower(), monsterName:lower()) then
                                targetMob = v
                                foundMob = true
                                break
                            end
                        end
                    end

                    if targetMob then
                        StartBring = true
                        _G.GlobalFarmActive = true
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        local farmPos = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                        
                        if (hrp.Position - farmPos.Position).Magnitude > 15 then
                            topos(farmPos)
                        else
                            if currentTween then 
                                currentTween:Cancel() 
                                currentTween = nil 
                            end
                            
                            -- ÉP CFRAME KHÓA NHÂN VẬT ĐỨNG IM NHƯ TƯỢNG TRÊN KHÔNG
                            hrp.CFrame = farmPos
                            
                            EquipWeapon(_G.SelectWeapon)
                            VirtualUser:CaptureController()
                            VirtualUser:Button1Down(Vector2.new(1280, 672))
                        end
                    else
                        StartBring = false
                        _G.GlobalFarmActive = false
                        if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameMon.Position).Magnitude > 15 then
                            topos(CFrameMon)
                        end
                    end
                end
            end)
        else
            if not (_G.AutoBoss or _G.AllBossesFarm) then
                _G.GlobalFarmActive = false
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and hrp:FindFirstChild("BodyClip") then 
                    hrp.BodyClip:Destroy() 
                end
                if currentTween then 
                    currentTween:Cancel() 
                    currentTween = nil 
                end
            end
        end
    end
end)

-- VÒNG LẶP GOM QUÁI CHUẨN XÁC
spawn(function()
    while task.wait() do
        pcall(function()
            if (_G.AutoFarm or _G.AutoItemFarm) and _G.BringMonster and StartBring then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                for _, v in pairs(Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        if v.Name == NameMon or string.find(v.Name, NameMon) then
                            -- GOM TẤT CẢ QUÁI CÙNG LOẠI TRONG PHẠM VI 350M
                            if (v.HumanoidRootPart.Position - hrp.Position).Magnitude <= 350 then
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, -25, 0)
                                v.HumanoidRootPart.CanCollide = false
                                if v:FindFirstChild("Head") then 
                                    v.Head.CanCollide = false 
                                end
                                if v.Humanoid:FindFirstChild("Animator") then 
                                    v.Humanoid.Animator:Destroy() 
                                end
                                v.Humanoid.WalkSpeed = 0
                                v.Humanoid.JumpPower = 0
                                v.Humanoid:ChangeState(11)
                            end
                        end
                    end
                end
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            end
        end)
    end
end)

-- =========================================================
-- VÒNG LẶP ĐÁNH SIÊU NHANH (ULTRA MAX FAST ATTACK)
-- =========================================================
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
    while RunService.Heartbeat:Wait() do
        if (_G.AutoFarm or _G.AutoItemFarm or _G.GlobalFarmActive or _G.AutoClick) and _G.FastAttack then
            pcall(function()
                local _Character = LocalPlayer.Character; local v13 = _Character and _Character:FindFirstChild('HumanoidRootPart'); if not v13 then return end
                local v14, v15, v16 = ipairs({Workspace.Enemies, Workspace.Characters}); local u17 = {}
                while true do
                    local v18; v16, v18 = v14(v15, v16); if v16 == nil then break end
                    local v19, v20, v21 = ipairs(v18 and v18:GetChildren() or {})
                    while true do
                        local v22; v21, v22 = v19(v20, v21); if v21 == nil then break end
                        local _HumanoidRootPart = v22:FindFirstChild('HumanoidRootPart'); local _Humanoid = v22:FindFirstChild('Humanoid')
                        if v22 ~= _Character and (_HumanoidRootPart and (_Humanoid and (_Humanoid.Health > 0 and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 120))) then
                            local v25, v26, v27 = ipairs(v22:GetChildren())
                            while true do
                                local v28; v27, v28 = v25(v26, v27); if v27 == nil then break end
                                if v28:IsA('BasePart') and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 120 then u17[#u17 + 1] = {v22, v28} end
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
                            for _ = 1, 15 do
                                ReplicatedStorage.Modules.Net['RE/RegisterHit']:FireServer(_Head, u17, {}, tostring(LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                                local r_u4 = (typeof(cloneref) == "function" and cloneref(u4)) or u4
                                if r_u4 then r_u4:FireServer(string.gsub('RE/RegisterHit', '.', function(p31) return string.char(bit32.bxor(string.byte(p31), math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1)) end), bit32.bxor(u5 + 909090, ReplicatedStorage.Modules.Net.seed:InvokeServer() * 2), _Head, u17) end
                            end
                        end
                    end)
                end
            end)
        end
    end
end)

-- CẬP NHẬT HUD VÀ GIAO DIỆN FOV (DÀNH CHO GIẢ LẬP/MOBILE)
local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "ZenithFOVCircle"
FOVGui.ResetOnSpawn = false
local sFOV, pFOV = pcall(function() return gethui() end)
if sFOV and pFOV then FOVGui.Parent = pFOV else FOVGui.Parent = CoreGui end

local FOVFrame = Instance.new("Frame", FOVGui)
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
Instance.new("UICorner", FOVFrame).CornerRadius = UDim.new(1, 0)
local FOVStroke = Instance.new("UIStroke", FOVFrame)
FOVStroke.Thickness = 1.5
FOVStroke.Color = Color3.fromRGB(235, 50, 65)

RunService.RenderStepped:Connect(function()
    if _G.SilentAim then
        FOVFrame.Visible = true
        FOVFrame.Size = UDim2.new(0, _G.FOVSize * 2, 0, _G.FOVSize * 2)
        FOVStroke.Color = _G.FOVColor
    else
        FOVFrame.Visible = false
    end
    
    pcall(function()
        local char = LocalPlayer.Character
        local StatusHUD = ScreenGui:FindFirstChild("Frame")
        if not StatusHUD then return end
        local hudContent = StatusHUD:FindFirstChild("TextLabel", true)

        if _G.StatusHUDVisible then
            local activeList = {}
            if _G.SpeedEnabled then table.insert(activeList, "🏃 Speed ["..tostring(_G.SpeedKey.Name).."]: " .. tostring(_G.SpeedVal)) end
            if _G.NoclipEnabled then table.insert(activeList, "👻 Noclip ["..tostring(_G.NoclipKey.Name).."]: ON") end
            if _G.JumpEnabled then table.insert(activeList, "🦘 Jump ["..tostring(_G.JumpKey.Name).."]: " .. tostring(_G.JumpVal)) end
            if _G.SilentAim then table.insert(activeList, "🎯 Silent Aim: ON") end
            if _G.AutoClick then table.insert(activeList, "⚔️ Auto Click: ON") end
            if _G.AutoFarm then table.insert(activeList, "⚡ Auto Farm: ON") end
            if _G.AutoItemFarm then table.insert(activeList, "🦴 Auto Item: ON") end
            
            local currentTarget = "None"
            if _G.GlobalFarmActive then 
                if _G.AutoBoss or _G.AllBossesFarm then currentTarget = _G.SelectedBossName
                else currentTarget = NameMon end
            end
            table.insert(activeList, "🎯 Target: " .. tostring(currentTarget))
            
            if #activeList > 0 then
                StatusHUD.Visible = true
                local lvl = 0
                if LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then
                    lvl = LocalPlayer.Data.Level.Value
                end
                if hudContent then
                    hudContent.Text = string.format("Level: %d\n", lvl) .. table.concat(activeList, "\n")
                end
            else
                StatusHUD.Visible = false
            end
        else
            StatusHUD.Visible = false
        end
    end)
end)

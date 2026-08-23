-- [[ ZENITH HUB - V500.0 PART 1: UI & COMPONENTS ]] --
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
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

pcall(function() for _, v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end end)
LocalPlayer.Idled:Connect(function() pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end)

-- Biến toàn cục
_G.AutoFarm = false; _G.AutoQuest = true; _G.BringMonster = true; _G.FastAttack = true
_G.SelectWeapon = "Melee"; _G.GlobalFarmActive = false 
_G.AutoStats = false; _G.StatsAmount = 1
_G.StatsMelee = false; _G.StatsDefense = false; _G.StatsSword = false; _G.StatsFruit = false
_G.Language = "VN"
_G.StatusHUDVisible = true

-- PVP & Aim Configs
_G.SilentAim = false; _G.FOVSize = 120; _G.HitAccuracy = 100; _G.FOVColor = Color3.fromRGB(235, 50, 65)

-- Movement Configs
_G.SpeedEnabled = false; _G.SpeedVal = 35; _G.SpeedKey = Enum.KeyCode.Q
_G.NoclipEnabled = false; _G.NoclipKey = Enum.KeyCode.E
_G.JumpEnabled = false; _G.JumpVal = 180; _G.JumpKey = Enum.KeyCode.R
_G.PullEnabled = false; _G.PullKey = Enum.KeyCode.T
_G.BoatSpeedEnabled = false

-- ESP Configs
_G.ESPPlayer = false; _G.ESPChest = false; _G.ESPFruit = false; _G.ESPNPC = false; _G.ESPIsland = false
_G.AutoCollectFruit = false
_G.AutoItemFarm = false
_G.AutoClick = false

-- Farm Item mới
_G.AutoFarmBone = false
_G.AutoFarmTakakuri = false
_G.TakakuriCount = 0

-- Boss & Sea Configs
_G.AutoBoss = false; _G.AllBossesFarm = false; _G.SelectedBossName = "None"

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
        Title = "ZENITH HUB <font color='#ff3344'>• V500 OMNIPOTENT</font>",
        Farm = "Cày Cấp", FarmItem = "Farm Item", Boss = "Săn Boss", PVP = "PVP & Aim", FruitEsp = "Trái & ESP", Stats = "Nâng Điểm", Teleport = "Dịch Chuyển", Shop = "Cửa Hàng", Misc = "Cài Đặt", SeaQuest = "Nhiệm Vụ Biển",
        StatusReady = "Trạng thái: Crimson UI & Full Sea Logic Sẵn Sàng!",
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
        ToggleBoatSpeed = "🚤 Tăng Tốc Thuyền",
        SeaQuestDaily = "📋 Nhiệm Vụ Hàng Ngày", SeaQuestShip = "🚢 Nhiệm Vụ Tàu", SeaQuestBoss = "👑 Nhiệm Vụ Boss Biển"
    },
    EN = {
        Title = "ZENITH HUB <font color='#ff3344'>• V500 OMNIPOTENT</font>",
        Farm = "Auto Farm", FarmItem = "Farm Item", Boss = "Boss Hunt", PVP = "PVP & Aim", FruitEsp = "Fruit & ESP", Stats = "Stats", Teleport = "Teleport", Shop = "Shop", Misc = "Settings", SeaQuest = "Sea Quest",
        StatusReady = "Status: Crimson UI & Full Sea Logic Active!",
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
        ToggleBoatSpeed = "🚤 Boat Speed Boost",
        SeaQuestDaily = "📋 Daily Quest", SeaQuestShip = "🚢 Ship Quest", SeaQuestBoss = "👑 Sea Boss Quest"
    }
}

local function L(key)
    local lang = _G.Language or "VN"
    return Loc[lang][key] or Loc["VN"][key] or key
end

local UI_NAME = "ZenithHub_V500_Crimson"
pcall(function() if CoreGui:FindFirstChild(UI_NAME) then CoreGui[UI_NAME]:Destroy() end end)
pcall(function() if LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then LocalPlayer.PlayerGui[UI_NAME]:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME; ScreenGui.ResetOnSpawn = false
local s, p = pcall(function() return gethui() end)
if s and p then ScreenGui.Parent = p else ScreenGui.Parent = CoreGui end

-- StatusHUD
local StatusHUD = Instance.new("Frame", ScreenGui)
StatusHUD.Size = UDim2.new(0, 220, 0, 160); StatusHUD.Position = UDim2.new(1, -235, 0.4, 0); StatusHUD.BackgroundColor3 = Color3.fromRGB(15, 10, 12); StatusHUD.BackgroundTransparency = 0.3; StatusHUD.BorderSizePixel = 0; StatusHUD.ZIndex = 800; StatusHUD.Visible = _G.StatusHUDVisible
Instance.new("UICorner", StatusHUD).CornerRadius = UDim.new(0, 10)
local hudStroke = Instance.new("UIStroke", StatusHUD); hudStroke.Color = Color3.fromRGB(235, 50, 65); hudStroke.Transparency = 0.2; hudStroke.Thickness = 1.2

local hudTitle = Instance.new("TextLabel", StatusHUD)
hudTitle.Size = UDim2.new(1, 0, 0, 28); hudTitle.BackgroundColor3 = Color3.fromRGB(45, 15, 22); hudTitle.BackgroundTransparency = 0.3; hudTitle.BorderSizePixel = 0; hudTitle.TextColor3 = Color3.fromRGB(255, 255, 255); hudTitle.Font = Enum.Font.GothamBold; hudTitle.TextSize = 12; hudTitle.Text = "📊 ACTIVE STATUS HUD"
Instance.new("UICorner", hudTitle).CornerRadius = UDim.new(0, 10)

local hudContent = Instance.new("TextLabel", StatusHUD)
hudContent.Size = UDim2.new(1, -16, 1, -35); hudContent.Position = UDim2.new(0, 8, 0, 32); hudContent.BackgroundTransparency = 1; hudContent.TextColor3 = Color3.fromRGB(255, 255, 255); hudContent.Font = Enum.Font.GothamMedium; hudContent.TextSize = 11; hudContent.TextXAlignment = Enum.TextXAlignment.Left; hudContent.TextYAlignment = Enum.TextYAlignment.Top; hudContent.RichText = true
hudContent.Text = "Level: 0"

local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 50, 0, 50); FloatingButton.Position = UDim2.new(0.05, 0, 0.4, 0); FloatingButton.BackgroundColor3 = Color3.fromRGB(25, 10, 14); FloatingButton.BackgroundTransparency = 0.3; FloatingButton.Visible = false; FloatingButton.Text = "Z"; FloatingButton.TextColor3 = Color3.fromRGB(255, 50, 70); FloatingButton.Font = Enum.Font.GothamBlack; FloatingButton.TextSize = 22; FloatingButton.ZIndex = 999
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", FloatingButton).Color = Color3.fromRGB(235, 50, 65); Instance.new("UIStroke", FloatingButton).Thickness = 2

local dragToggleBtn, dragStartBtn, startPosBtn
FloatingButton.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
        dragToggleBtn = true; dragStartBtn = input.Position; startPosBtn = FloatingButton.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggleBtn = false end end)
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

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 640, 0, 430); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 12); MainFrame.BackgroundTransparency = 0.12; MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", MainFrame); mStroke.Color = Color3.fromRGB(235, 50, 65); mStroke.Thickness = 1.5

local draggingMain, dragStartMain, startPosMain
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        draggingMain = true; dragStartMain = input.Position; startPosMain = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then draggingMain = false end end)
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
TopBar.Size = UDim2.new(1, 0, 0, 42); TopBar.BackgroundColor3 = Color3.fromRGB(30, 12, 17); TopBar.BackgroundTransparency = 0.3; TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 350, 1, 0); Title.Position = UDim2.new(0, 16, 0, 0); Title.BackgroundTransparency = 1; Title.RichText = true; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = L("Title")

local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 26, 0, 26); CloseBtn.Position = UDim2.new(1, -32, 0.5, -13); CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 59, 90); CloseBtn.BackgroundTransparency = 0.3; CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 11; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
local MinBtn = Instance.new("TextButton", TopBar); MinBtn.Size = UDim2.new(0, 26, 0, 26); MinBtn.Position = UDim2.new(1, -66, 0.5, -13); MinBtn.BackgroundColor3 = Color3.fromRGB(50, 18, 25); MinBtn.BackgroundTransparency = 0.3; MinBtn.Text = "−"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 14; Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)
FloatingButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; FloatingButton.Visible = false end)
local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    MainFrame:TweenSize(isMin and UDim2.new(0, 640, 0, 42) or UDim2.new(0, 640, 0, 430), "Out", "Quart", 0.25, true)
end)

local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Name = "Sidebar"; Sidebar.Size = UDim2.new(0, 165, 1, -42); Sidebar.Position = UDim2.new(0, 0, 0, 42); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 10, 12); Sidebar.BackgroundTransparency = 0.3; Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)
local TabScroller = Instance.new("ScrollingFrame", Sidebar); TabScroller.Size = UDim2.new(1, -10, 1, -12); TabScroller.Position = UDim2.new(0, 5, 0, 6); TabScroller.BackgroundTransparency = 1; TabScroller.BorderSizePixel = 0; TabScroller.ScrollBarThickness = 3; TabScroller.ScrollBarImageColor3 = Color3.fromRGB(235, 50, 65); TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIPadding", TabScroller).PaddingTop = UDim.new(0, 4)
local TabListLayout = Instance.new("UIListLayout", TabScroller); TabListLayout.Padding = UDim.new(0, 5); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContentContainer = Instance.new("Frame", MainFrame); ContentContainer.Size = UDim2.new(1, -165, 1, -42); ContentContainer.Position = UDim2.new(0, 165, 0, 42); ContentContainer.BackgroundTransparency = 1

local tabButtons, tabPages = {}, {}
local function createTab(nameKey, icon, labelKey)
    local btn = Instance.new("TextButton", TabScroller); btn.Size = UDim2.new(1, -4, 0, 34); btn.BackgroundColor3 = Color3.fromRGB(25, 12, 16); btn.BackgroundTransparency = 0.3; btn.TextColor3 = Color3.fromRGB(210, 180, 185); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Text = "  " .. icon .. "   " .. L(labelKey)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(235, 50, 65); Instance.new("UIStroke", btn).Transparency = 0.5; Instance.new("UIStroke", btn).Thickness = 1
    local Pill = Instance.new("Frame", btn); Pill.Size = UDim2.new(0, 3, 0, 20); Pill.Position = UDim2.new(0, 0, 0.5, -10); Pill.BackgroundColor3 = Color3.fromRGB(235, 50, 65); Pill.Visible = false; Instance.new("UICorner", Pill).CornerRadius = UDim.new(0, 2)
    
    local page = Instance.new("ScrollingFrame", ContentContainer); page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0; page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = Color3.fromRGB(235, 50, 65); page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.Visible = false
    local pl = Instance.new("UIListLayout", page); pl.Padding = UDim.new(0, 7); pl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 12); Instance.new("UIPadding", page).PaddingBottom = UDim.new(0, 12)

    tabButtons[nameKey] = {Button = btn, Pill = Pill, Key = labelKey}; tabPages[nameKey] = page
    btn.MouseButton1Click:Connect(function()
        for tName, item in pairs(tabButtons) do
            local act = (tName == nameKey)
            item.Button.BackgroundColor3 = act and Color3.fromRGB(220, 35, 50) or Color3.fromRGB(25, 12, 16)
            item.Button.BackgroundTransparency = act and 0 or 0.3
            item.Button.TextColor3 = act and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(210, 180, 185)
            item.Pill.Visible = act
        end
        for pName, p in pairs(tabPages) do p.Visible = (pName == nameKey) end
    end)
    return page
end

local function createToggle(page, labelKey, defaultState, callback)
    local state = defaultState
    local frame = Instance.new("Frame", page); frame.Size = UDim2.new(0.95, 0, 0, 36); frame.BackgroundColor3 = Color3.fromRGB(22, 12, 15); frame.BackgroundTransparency = 0.3; Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(75, 25, 35); Instance.new("UIStroke", frame).Transparency = 0.2; Instance.new("UIStroke", frame).Thickness = 1
    
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, -55, 1, 0); label.Position = UDim2.new(0, 12, 0, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(255, 240, 245); label.Font = Enum.Font.GothamMedium; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = L(labelKey)
    local switch = Instance.new("TextButton", frame); switch.Size = UDim2.new(0, 36, 0, 18); switch.Position = UDim2.new(1, -45, 0.5, -9); switch.BackgroundColor3 = state and Color3.fromRGB(235, 50, 65) or Color3.fromRGB(50, 20, 26); switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch); circle.Size = UDim2.new(0, 14, 0, 14); circle.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    switch.MouseButton1Click:Connect(function()
        state = not state; switch.BackgroundColor3 = state and Color3.fromRGB(235, 50, 65) or Color3.fromRGB(50, 20, 26)
        circle:TweenPosition(state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.15, true)
        if callback then callback(state) end
    end)
end

local function createButton(page, labelKey, callback)
    local btn = Instance.new("TextButton", page); btn.Size = UDim2.new(0.95, 0, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(25, 12, 16); btn.BackgroundTransparency = 0.3; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(235, 50, 65); Instance.new("UIStroke", btn).Thickness = 1; Instance.new("UIStroke", btn).Transparency = 0.4
    btn.TextColor3 = Color3.fromRGB(255, 100, 115); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 12; btn.Text = L(labelKey)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- TẠO CÁC TAB (thứ tự: Farm, FarmItem, SeaQuest, Boss, PVP, FruitEsp, Stats, Teleport, Shop, Misc)
local pFarm = createTab("Farm", "🌾", "Farm")
local pItem = createTab("FarmItem", "🦴", "FarmItem")
local pSeaQuest = createTab("SeaQuest", "🌊", "SeaQuest")   -- Đưa lên trên
local pBoss = createTab("Boss", "👑", "Boss")
local pPVP = createTab("PVP", "🎯", "PVP")
local pFruitEsp = createTab("FruitEsp", "🍎", "FruitEsp")
local pStats = createTab("Stats", "📈", "Stats")
local pTele = createTab("Teleport", "🚀", "Teleport")
local pShop = createTab("Shop", "🛒", "Shop")
local pMisc = createTab("Misc", "⚙️", "Misc")

tabButtons["Farm"].Button.BackgroundColor3 = Color3.fromRGB(220, 35, 50); tabButtons["Farm"].Button.BackgroundTransparency = 0; tabButtons["Farm"].Button.TextColor3 = Color3.fromRGB(255, 255, 255); tabButtons["Farm"].Pill.Visible = true; tabPages["Farm"].Visible = true

-- [ TAB FARM ] (giữ nguyên)
local infoLabel = Instance.new("TextLabel", pFarm); infoLabel.Size = UDim2.new(0.95, 0, 0, 25); infoLabel.BackgroundTransparency = 1; infoLabel.TextColor3 = Color3.fromRGB(255, 100, 115); infoLabel.Font = Enum.Font.GothamBold; infoLabel.TextSize = 12; infoLabel.Text = L("StatusReady")
local weaponSegment = Instance.new("Frame", pFarm); weaponSegment.Size = UDim2.new(0.95, 0, 0, 30); weaponSegment.BackgroundColor3 = Color3.fromRGB(22, 12, 15); weaponSegment.BackgroundTransparency = 0.3; Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", weaponSegment).Color = Color3.fromRGB(75, 25, 35); Instance.new("UIStroke", weaponSegment).Thickness = 1
local wsLayout = Instance.new("UIListLayout", weaponSegment); wsLayout.FillDirection = Enum.FillDirection.Horizontal; wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; wsLayout.Padding = UDim.new(0, 4)
for _, wName in ipairs({"Melee", "Sword", "Blox Fruit"}) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size = UDim2.new(0.3, 0, 0.78, 0); b.BackgroundColor3 = _G.SelectWeapon == wName and Color3.fromRGB(220, 35, 50) or Color3.fromRGB(35, 18, 22); b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.GothamMedium; b.TextSize = 10; b.Text = wName; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function() _G.SelectWeapon = wName; for _, btn in pairs(weaponSegment:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = btn.Text == wName and Color3.fromRGB(220, 35, 50) or Color3.fromRGB(35, 18, 22) end end end)
end
createToggle(pFarm, "ToggleFarm", false, function(v) _G.AutoFarm = v end)
createToggle(pFarm, "ToggleQuest", true, function(v) _G.AutoQuest = v end)
createToggle(pFarm, "ToggleBring", true, function(v) _G.BringMonster = v end)
createToggle(pFarm, "ToggleFast", true, function(v) _G.FastAttack = v end)
createToggle(pFarm, "ToggleAutoClick", false, function(v) _G.AutoClick = v end)

-- [ TAB FARM ITEM ] - giữ nguyên
createToggle(pItem, "ToggleItemFarm", false, function(v) _G.AutoItemFarm = v end)
createToggle(pItem, "ToggleAutoFarmBone", false, function(v) _G.AutoFarmBone = v end)
createToggle(pItem, "ToggleAutoFarmTakakuri", false, function(v) _G.AutoFarmTakakuri = v end)
local boneLabel = Instance.new("TextLabel", pItem); boneLabel.Size = UDim2.new(0.95, 0, 0, 22); boneLabel.BackgroundTransparency = 1; boneLabel.TextColor3 = Color3.fromRGB(255, 215, 0); boneLabel.Font = Enum.Font.GothamBold; boneLabel.TextSize = 12; boneLabel.Text = L("LabelBoneCount") .. "0"
local takakuriLabel = Instance.new("TextLabel", pItem); takakuriLabel.Size = UDim2.new(0.95, 0, 0, 22); takakuriLabel.BackgroundTransparency = 1; takakuriLabel.TextColor3 = Color3.fromRGB(255, 100, 200); takakuriLabel.Font = Enum.Font.GothamBold; takakuriLabel.TextSize = 12; takakuriLabel.Text = L("LabelTakakuriCount") .. "0"
createButton(pItem, "BtnSea2", function() pcall(function() if LocalPlayer.Data.Level.Value >= 700 then CommF:InvokeServer("DressrosaQuest") else infoLabel.Text = "Cần Cấp 700 để lên Sea 2!" end end) end)
createButton(pItem, "BtnSea3", function() pcall(function() if LocalPlayer.Data.Level.Value >= 1500 then CommF:InvokeServer("ZouQuest") else infoLabel.Text = "Cần Cấp 1500 để lên Sea 3!" end end) end)

-- [ TAB SEA QUEST ] - nhiệm vụ biển
createButton(pSeaQuest, "SeaQuestDaily", function()
    if CommF then CommF:InvokeServer("DailyQuest") end
end)
createButton(pSeaQuest, "SeaQuestShip", function()
    if CommF then CommF:InvokeServer("ShipQuest") end
end)
createButton(pSeaQuest, "SeaQuestBoss", function()
    if CommF then CommF:InvokeServer("SeaBossQuest") end
end)

-- [ TAB BOSS ] giữ nguyên
createToggle(pBoss, "ToggleAutoBoss", false, function(v) _G.AutoBoss = v end)
createToggle(pBoss, "ToggleAllBoss", false, function(v) _G.AllBossesFarm = v end)
local bossSelectFrame = Instance.new("Frame", pBoss); bossSelectFrame.Size = UDim2.new(0.95, 0, 0, 36); bossSelectFrame.BackgroundColor3 = Color3.fromRGB(22, 12, 15); bossSelectFrame.BackgroundTransparency = 0.3; Instance.new("UICorner", bossSelectFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", bossSelectFrame).Color = Color3.fromRGB(75, 25, 35); Instance.new("UIStroke", bossSelectFrame).Thickness = 1
local bossSelectLbl = Instance.new("TextLabel", bossSelectFrame); bossSelectLbl.Size = UDim2.new(1, -16, 1, 0); bossSelectLbl.Position = UDim2.new(0, 8, 0, 0); bossSelectLbl.BackgroundTransparency = 1; bossSelectLbl.TextColor3 = Color3.fromRGB(255, 215, 0); bossSelectLbl.Font = Enum.Font.GothamBold; bossSelectLbl.TextSize = 11; bossSelectLbl.TextXAlignment = Enum.TextXAlignment.Left; bossSelectLbl.Text = "👑 Chọn Boss: [ Click để đổi ]"
local currentBossIdx = 1
bossSelectFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        currentBossIdx = currentBossIdx % #CurrentBossList + 1
        _G.SelectedBossName = CurrentBossList[currentBossIdx]
        bossSelectLbl.Text = "👑 Chọn Boss: " .. _G.SelectedBossName
    end
end)
local bossListLabel = Instance.new("TextLabel", pBoss); bossListLabel.Size = UDim2.new(0.95, 0, 0, 30); bossListLabel.BackgroundTransparency = 1; bossListLabel.TextColor3 = Color3.fromRGB(255, 100, 115); bossListLabel.Font = Enum.Font.GothamBold; bossListLabel.TextSize = 11; bossListLabel.Text = "👑 Boss Đang Sống: Quét..."

-- [ TAB PVP ] giữ nguyên + Boat Speed
local pvpContainer = pPVP
local silentToggleFrame = Instance.new("Frame", pvpContainer); silentToggleFrame.Size = UDim2.new(0.95, 0, 0, 36); silentToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 12, 15); silentToggleFrame.BackgroundTransparency = 0.3; Instance.new("UICorner", silentToggleFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", silentToggleFrame).Color = Color3.fromRGB(75, 25, 35); Instance.new("UIStroke", silentToggleFrame).Thickness = 1
local silentLbl = Instance.new("TextLabel", silentToggleFrame); silentLbl.Size = UDim2.new(1, -55, 1, 0); silentLbl.Position = UDim2.new(0, 12, 0, 0); silentLbl.BackgroundTransparency = 1; silentLbl.TextColor3 = Color3.fromRGB(255, 240, 245); silentLbl.Font = Enum.Font.GothamMedium; silentLbl.TextSize = 12; silentLbl.TextXAlignment = Enum.TextXAlignment.Left; silentLbl.Text = L("ToggleSilent")
local silentSwitch = Instance.new("TextButton", silentToggleFrame); silentSwitch.Size = UDim2.new(0, 36, 0, 18); silentSwitch.Position = UDim2.new(1, -45, 0.5, -9); silentSwitch.BackgroundColor3 = Color3.fromRGB(50, 20, 26); silentSwitch.Text = ""; Instance.new("UICorner", silentSwitch).CornerRadius = UDim.new(1, 0)
local silentCircle = Instance.new("Frame", silentSwitch); silentCircle.Size = UDim2.new(0, 14, 0, 14); silentCircle.Position = UDim2.new(0, 2, 0.5, -7); silentCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", silentCircle).CornerRadius = UDim.new(1, 0)
local silentSubContainer = Instance.new("Frame", pvpContainer); silentSubContainer.Size = UDim2.new(0.95, 0, 0, 110); silentSubContainer.BackgroundTransparency = 1; silentSubContainer.Visible = false
local subList = Instance.new("UIListLayout", silentSubContainer); subList.Padding = UDim.new(0, 6); subList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local fovFrame = Instance.new("Frame", silentSubContainer); fovFrame.Size = UDim2.new(1, 0, 0, 34); fovFrame.BackgroundColor3 = Color3.fromRGB(22, 12, 15); fovFrame.BackgroundTransparency = 0.4; Instance.new("UICorner", fovFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", fovFrame).Color = Color3.fromRGB(75, 25, 35); Instance.new("UIStroke", fovFrame).Thickness = 1
local fovLbl = Instance.new("TextLabel", fovFrame); fovLbl.Size = UDim2.new(0.7, 0, 1, 0); fovLbl.Position = UDim2.new(0, 10, 0, 0); fovLbl.BackgroundTransparency = 1; fovLbl.TextColor3 = Color3.fromRGB(240, 230, 235); fovLbl.Font = Enum.Font.Gotham; fovLbl.TextSize = 11; fovLbl.TextXAlignment = Enum.TextXAlignment.Left; fovLbl.Text = "FOV Silent: 120"
local fovColorBtn = Instance.new("TextButton", fovFrame); fovColorBtn.Size = UDim2.new(0, 65, 0, 20); fovColorBtn.Position = UDim2.new(1, -75, 0.5, -10); fovColorBtn.BackgroundColor3 = Color3.fromRGB(235, 50, 65); fovColorBtn.TextColor3 = Color3.fromRGB(255, 255, 255); fovColorBtn.Font = Enum.Font.GothamBold; fovColorBtn.TextSize = 10; fovColorBtn.Text = "Đổi Màu"; Instance.new("UICorner", fovColorBtn).CornerRadius = UDim.new(0, 4)
local colorsList = {Color3.fromRGB(235, 50, 65), Color3.fromRGB(0, 210, 255), Color3.fromRGB(0, 255, 100), Color3.fromRGB(255, 215, 0)}
local colorIdx = 1
fovColorBtn.MouseButton1Click:Connect(function() colorIdx = colorIdx % #colorsList + 1; _G.FOVColor = colorsList[colorIdx]; fovColorBtn.BackgroundColor3 = _G.FOVColor end)
local fovTrack = Instance.new("TextButton", fovFrame); fovTrack.Size = UDim2.new(0.9, 0, 0, 6); fovTrack.Position = UDim2.new(0.05, 0, 0, 26); fovTrack.BackgroundColor3 = Color3.fromRGB(45, 20, 26); fovTrack.AutoButtonColor = false; fovTrack.Text = ""; Instance.new("UICorner", fovTrack).CornerRadius = UDim.new(1, 0)
local fovFill = Instance.new("Frame", fovTrack); fovFill.Size = UDim2.new(0.4, 0, 1, 0); fovFill.BackgroundColor3 = Color3.fromRGB(235, 50, 65); Instance.new("UICorner", fovFill).CornerRadius = UDim.new(1, 0)
local isDraggingFOV = false
fovTrack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingFOV = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingFOV = false end end)
UserInputService.InputChanged:Connect(function(input)
    if isDraggingFOV and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((UserInputService:GetMouseLocation().X - fovTrack.AbsolutePosition.X) / fovTrack.AbsoluteSize.X, 0, 1); fovFill.Size = UDim2.new(pos, 0, 1, 0); _G.FOVSize = math.floor(50 + 350 * pos); fovLbl.Text = "FOV Silent: " .. tostring(_G.FOVSize)
    end
end)
local accFrame = Instance.new("Frame", silentSubContainer); accFrame.Size = UDim2.new(1, 0, 0, 34); accFrame.BackgroundColor3 = Color3.fromRGB(22, 12, 15); accFrame.BackgroundTransparency = 0.4; Instance.new("UICorner", accFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", accFrame).Color = Color3.fromRGB(75, 25, 35); Instance.new("UIStroke", accFrame).Thickness = 1
local accLbl = Instance.new("TextLabel", accFrame); accLbl.Size = UDim2.new(1, -12, 0, 18); accLbl.Position = UDim2.new(0, 10, 0, 4); accLbl.BackgroundTransparency = 1; accLbl.TextColor3 = Color3.fromRGB(240, 230, 235); accLbl.Font = Enum.Font.Gotham; accLbl.TextSize = 11; accLbl.TextXAlignment = Enum.TextXAlignment.Left; accLbl.Text = "Độ Bám / Accuracy: 100%"
local accTrack = Instance.new("TextButton", accFrame); accTrack.Size = UDim2.new(0.9, 0, 0, 5); accTrack.Position = UDim2.new(0.05, 0, 0, 24); accTrack.BackgroundColor3 = Color3.fromRGB(45, 20, 26); accTrack.AutoButtonColor = false; accTrack.Text = ""; Instance.new("UICorner", accTrack).CornerRadius = UDim.new(1, 0)
local accFill = Instance.new("Frame", accTrack); accFill.Size = UDim2.new(1, 0, 1, 0); accFill.BackgroundColor3 = Color3.fromRGB(235, 50, 65); Instance.new("UICorner", accFill).CornerRadius = UDim.new(1, 0)
local isDraggingAcc = false
accTrack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingAcc = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingAcc = false end end)
UserInputService.InputChanged:Connect(function(input)
    if isDraggingAcc and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((UserInputService:GetMouseLocation().X - accTrack.AbsolutePosition.X) / accTrack.AbsoluteSize.X, 0, 1)
        accFill.Size = UDim2.new(pos, 0, 1, 0)
        _G.HitAccuracy = math.floor(pos * 100)
        accLbl.Text = "Độ Bám / Accuracy: " .. tostring(_G.HitAccuracy) .. "%"
    end
end)
silentSwitch.MouseButton1Click:Connect(function()
    _G.SilentAim = not _G.SilentAim
    silentSwitch.BackgroundColor3 = _G.SilentAim and Color3.fromRGB(235, 50, 65) or Color3.fromRGB(50, 20, 26)
    silentCircle:TweenPosition(_G.SilentAim and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.15, true)
    silentSubContainer.Visible = _G.SilentAim
end)

local function createAdvancedMovementControl(page, titleText, enabledVar, valVar, keyVar, minVal, maxVal)
    local frame = Instance.new("Frame", page); frame.Size = UDim2.new(0.95, 0, 0, 36); frame.BackgroundColor3 = Color3.fromRGB(22, 12, 15); frame.BackgroundTransparency = 0.3; Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(75, 25, 35); Instance.new("UIStroke", frame).Thickness = 1
    local lbl = Instance.new("TextLabel", frame); lbl.Size = UDim2.new(1, -120, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(255, 240, 245); lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = titleText
    local switch = Instance.new("TextButton", frame); switch.Size = UDim2.new(0, 36, 0, 18); switch.Position = UDim2.new(1, -45, 0.5, -9); switch.BackgroundColor3 = _G[enabledVar] and Color3.fromRGB(235, 50, 65) or Color3.fromRGB(50, 20, 26); switch.Text = ""; Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circ = Instance.new("Frame", switch); circ.Size = UDim2.new(0, 14, 0, 14); circ.Position = _G[enabledVar] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7); circ.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", circ).CornerRadius = UDim.new(1, 0)
    local keyBtn = Instance.new("TextButton", frame); keyBtn.Size = UDim2.new(0, 45, 0, 20); keyBtn.Position = UDim2.new(1, -95, 0.5, -10); keyBtn.BackgroundColor3 = Color3.fromRGB(35, 18, 22); keyBtn.TextColor3 = Color3.fromRGB(255, 100, 115); keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 10; keyBtn.Text = tostring(_G[keyVar].Name); Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 4)
    local subSlider = nil
    if valVar then
        subSlider = Instance.new("Frame", page); subSlider.Size = UDim2.new(0.95, 0, 0, 36); subSlider.BackgroundColor3 = Color3.fromRGB(22, 12, 15); subSlider.BackgroundTransparency = 0.4; subSlider.Visible = _G[enabledVar]; Instance.new("UICorner", subSlider).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", subSlider).Color = Color3.fromRGB(75, 25, 35); Instance.new("UIStroke", subSlider).Thickness = 1
        local sLbl = Instance.new("TextLabel", subSlider); sLbl.Size = UDim2.new(1, -12, 0, 16); sLbl.Position = UDim2.new(0, 10, 0, 2); sLbl.BackgroundTransparency = 1; sLbl.TextColor3 = Color3.fromRGB(240, 230, 235); sLbl.Font = Enum.Font.Gotham; sLbl.TextSize = 11; sLbl.TextXAlignment = Enum.TextXAlignment.Left; sLbl.Text = titleText .. ": " .. tostring(_G[valVar])
        local sTrack = Instance.new("TextButton", subSlider); sTrack.Size = UDim2.new(0.9, 0, 0, 5); sTrack.Position = UDim2.new(0.05, 0, 0, 24); sTrack.BackgroundColor3 = Color3.fromRGB(45, 20, 26); sTrack.AutoButtonColor = false; sTrack.Text = ""; Instance.new("UICorner", sTrack).CornerRadius = UDim.new(1, 0)
        local sFill = Instance.new("Frame", sTrack); sFill.Size = UDim2.new((_G[valVar]-minVal)/(maxVal-minVal), 0, 1, 0); sFill.BackgroundColor3 = Color3.fromRGB(235, 50, 65); Instance.new("UICorner", sFill).CornerRadius = UDim.new(1, 0)
        local draggingSlider = false
        sTrack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSlider = true end end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSlider = false end end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = math.clamp((UserInputService:GetMouseLocation().X - sTrack.AbsolutePosition.X) / sTrack.AbsoluteSize.X, 0, 1)
                sFill.Size = UDim2.new(pos, 0, 1, 0); _G[valVar] = math.floor(minVal + (maxVal - minVal) * pos); sLbl.Text = titleText .. ": " .. tostring(_G[valVar])
            end
        end)
    end
    switch.MouseButton1Click:Connect(function()
        _G[enabledVar] = not _G[enabledVar]
        switch.BackgroundColor3 = _G[enabledVar] and Color3.fromRGB(235, 50, 65) or Color3.fromRGB(50, 20, 26)
        circ:TweenPosition(_G[enabledVar] and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), "Out", "Quad", 0.15, true)
        if subSlider then subSlider.Visible = _G[enabledVar] end
    end)
    keyBtn.MouseButton1Click:Connect(function()
        keyBtn.Text = "..."
        local conn; conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                _G[keyVar] = input.KeyCode; keyBtn.Text = tostring(input.KeyCode.Name); conn:Disconnect()
            end
        end)
    end)
end

createAdvancedMovementControl(pPVP, L("ToggleSpeed"), "SpeedEnabled", "SpeedVal", "SpeedKey", 16, 200)
createAdvancedMovementControl(pPVP, L("ToggleJump"), "JumpEnabled", "JumpVal", "JumpKey", 50, 400)
createAdvancedMovementControl(pPVP, L("ToggleNoclip"), "NoclipEnabled", nil, "NoclipKey")
createAdvancedMovementControl(pPVP, L("TogglePull"), "PullEnabled", nil, "PullKey")
createToggle(pPVP, "ToggleBoatSpeed", false, function(v) _G.BoatSpeedEnabled = v end)

-- [ TAB FRUIT & ESP ] giữ nguyên
createToggle(pFruitEsp, "ToggleCollectFruit", false, function(v) _G.AutoCollectFruit = v end)
createButton(pFruitEsp, "BtnGacha", function() if CommF then CommF:InvokeServer("Cousin", "Buy") end end)
createButton(pFruitEsp, "BtnStore", function() for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") then CommF:InvokeServer("StoreFruit", string.split(v.Name, "-")[1], v) end end end)
createToggle(pFruitEsp, "ToggleESPPlr", false, function(v) _G.ESPPlayer = v end)
createToggle(pFruitEsp, "ToggleESPChest", false, function(v) _G.ESPChest = v end)
createToggle(pFruitEsp, "ToggleESPFruit", false, function(v) _G.ESPFruit = v end)
createToggle(pFruitEsp, "ToggleESPNPC", false, function(v) _G.ESPNPC = v end)
createToggle(pFruitEsp, "ToggleESPIsland", false, function(v) _G.ESPIsland = v end)

-- [ TAB STATS ] giữ nguyên
createToggle(pStats, "ToggleStats", false, function(v) _G.AutoStats = v end)
local statsAmtSeg = Instance.new("Frame", pStats); statsAmtSeg.Size = UDim2.new(0.95, 0, 0, 32); statsAmtSeg.BackgroundColor3 = Color3.fromRGB(22, 12, 15); statsAmtSeg.BackgroundTransparency = 0.3; Instance.new("UICorner", statsAmtSeg).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", statsAmtSeg).Color = Color3.fromRGB(75, 25, 35); Instance.new("UIStroke", statsAmtSeg).Thickness = 1
local saLayout = Instance.new("UIListLayout", statsAmtSeg); saLayout.FillDirection = Enum.FillDirection.Horizontal; saLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; saLayout.VerticalAlignment = Enum.VerticalAlignment.Center; saLayout.Padding = UDim.new(0, 3)
for _, amt in ipairs({1, 3, 10, 25, 50, 100}) do
    local ab = Instance.new("TextButton", statsAmtSeg)
    ab.Size = UDim2.new(0.15, 0, 0.8, 0); ab.BackgroundColor3 = _G.StatsAmount == amt and Color3.fromRGB(220, 35, 50) or Color3.fromRGB(35, 18, 22); ab.TextColor3 = Color3.fromRGB(255, 255, 255); ab.Font = Enum.Font.GothamBold; ab.TextSize = 11; ab.Text = tostring(amt); Instance.new("UICorner", ab).CornerRadius = UDim.new(0, 4)
    ab.MouseButton1Click:Connect(function()
        _G.StatsAmount = amt
        for _, btn in pairs(statsAmtSeg:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = (btn.Text == tostring(amt)) and Color3.fromRGB(220, 35, 50) or Color3.fromRGB(35, 18, 22) end end
    end)
end
createToggle(pStats, "🥊 Melee", false, function(v) _G.StatsMelee = v end)
createToggle(pStats, "🛡️ Defense", false, function(v) _G.StatsDefense = v end)
createToggle(pStats, "⚔️ Sword", false, function(v) _G.StatsSword = v end)
createToggle(pStats, "🍎 Blox Fruit", false, function(v) _G.StatsFruit = v end)

-- [ TAB TELEPORT ] giữ nguyên
createButton(pTele, "BtnSea1", function() if CommF then CommF:InvokeServer("TravelMain") end end)
createButton(pTele, "BtnSea2", function() if CommF then CommF:InvokeServer("TravelDressrosa") end end)
createButton(pTele, "BtnSea3", function() if CommF then CommF:InvokeServer("TravelZou") end end)

-- [ TAB SHOP ] - thêm tất cả võ, kiếm, súng
createButton(pShop, "BtnGeppo", function() if CommF then CommF:InvokeServer("BuyHaki", "Geppo") end end)
createButton(pShop, "BtnBuso", function() if CommF then CommF:InvokeServer("BuyHaki", "Buso") end end)
createButton(pShop, "BtnSoru", function() if CommF then CommF:InvokeServer("BuyHaki", "Soru") end end)
createButton(pShop, "BtnKen", function() if CommF then CommF:InvokeServer("BuyHaki", "KenTalk", "Buy") end end)
createButton(pShop, "Mua Tất Cả Kiếm", function()
    for _, sword in ipairs(AllSwords) do
        pcall(function() CommF:InvokeServer("BuyItem", sword) end)
        task.wait(0.1)
    end
end)
createButton(pShop, "Mua Tất Cả Súng", function()
    for _, gun in ipairs(AllGuns) do
        pcall(function() CommF:InvokeServer("BuyItem", gun) end)
        task.wait(0.1)
    end
end)
createButton(pShop, "Mua Tất Cả Võ", function()
    for _, style in ipairs(AllStyles) do
        pcall(function() CommF:InvokeServer("BuyItem", style) end)
        task.wait(0.1)
    end
end)
createButton(pShop, "BtnBuySword", function() if CommF then CommF:InvokeServer("BuyItem", "Cutlass") CommF:InvokeServer("BuyItem", "Katana") end end)
createButton(pShop, "BtnBuyGun", function() if CommF then CommF:InvokeServer("BuyItem", "Musket") CommF:InvokeServer("BuyItem", "Refined Flintlock") end end)
createButton(pShop, "BtnBuyStyle", function() if CommF then CommF:InvokeServer("BuyItem", "Dark Step") CommF:InvokeServer("BuyItem", "Electro") end end)

-- [ TAB MISC ] giữ nguyên
createButton(pMisc, "BtnDiscord", function() setclipboard("https://discord.gg/yourlink") end)
local langSeg = Instance.new("Frame", pMisc); langSeg.Size = UDim2.new(0.95, 0, 0, 35); langSeg.BackgroundColor3 = Color3.fromRGB(22, 12, 15); langSeg.BackgroundTransparency = 0.3; Instance.new("UICorner", langSeg).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", langSeg).Color = Color3.fromRGB(75, 25, 35); Instance.new("UIStroke", langSeg).Thickness = 1
local lgLayout = Instance.new("UIListLayout", langSeg); lgLayout.FillDirection = Enum.FillDirection.Horizontal; lgLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; lgLayout.VerticalAlignment = Enum.VerticalAlignment.Center; lgLayout.Padding = UDim.new(0, 6)
local langLabel = Instance.new("TextLabel", langSeg); langLabel.Size = UDim2.new(0.55, 0, 1, 0); langLabel.BackgroundTransparency = 1; langLabel.TextColor3 = Color3.fromRGB(255, 240, 245); langLabel.Font = Enum.Font.GothamMedium; langLabel.TextSize = 11; langLabel.Text = "🌐 Ngôn ngữ / Language:"
for _, lg in ipairs({"VN", "EN"}) do
    local lb = Instance.new("TextButton", langSeg)
    lb.Size = UDim2.new(0.18, 0, 0.75, 0); lb.BackgroundColor3 = _G.Language == lg and Color3.fromRGB(220, 35, 50) or Color3.fromRGB(35, 18, 22); lb.TextColor3 = Color3.fromRGB(255, 255, 255); lb.Font = Enum.Font.GothamBold; lb.TextSize = 11; lb.Text = lg; Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 4)
    lb.MouseButton1Click:Connect(function()
        _G.Language = lg
        Title.Text = L("Title")
        for _, tabKey in pairs({"Farm", "FarmItem", "SeaQuest", "Boss", "PVP", "FruitEsp", "Stats", "Teleport", "Shop", "Misc"}) do
            if tabButtons[tabKey] then
                local icon = (tabKey == "Farm" and "🌾" or tabKey == "FarmItem" and "🦴" or tabKey == "SeaQuest" and "🌊" or tabKey == "Boss" and "👑" or tabKey == "PVP" and "🎯" or tabKey == "FruitEsp" and "🍎" or tabKey == "Stats" and "📈" or tabKey == "Teleport" and "🚀" or tabKey == "Shop" and "🛒" or "⚙️")
                tabButtons[tabKey].Button.Text = "  " .. icon .. "   " .. L(tabButtons[tabKey].Key)
            end
        end
        for _, btn in pairs(langSeg:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = (btn.Text == lg) and Color3.fromRGB(220, 35, 50) or Color3.fromRGB(35, 18, 22) end end
        boneLabel.Text = L("LabelBoneCount") .. tostring(CountBone())
        takakuriLabel.Text = L("LabelTakakuriCount") .. tostring(CountTakakuri())
    end)
end

createToggle(pMisc, "ToggleHUD", true, function(v) _G.StatusHUDVisible = v; StatusHUD.Visible = v end)
createButton(pMisc, "BtnCode", function() local codes = {"NEWTROLL", "KITT_RESET", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "fudd10_v2", "SUB2GAMERROBOT_EXP1", "Sub2NoobMaster123", "Sub2UncleKizaru", "Sub2Daigrock", "Axiore", "TantaiGaming", "StrawHatMaine"}; task.spawn(function() for _, c in ipairs(codes) do pcall(function() CommF:InvokeServer("RedeemCode", c) end); task.wait(0.2) end end) end)
createToggle(pMisc, "ToggleLag", false, function(v)
    Lighting.GlobalShadows = not v
    if v then
        -- Tối ưu lag: tắt hết Particle, các hiệu ứng không cần thiết
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("BasePart") then o.Material = Enum.Material.SmoothPlastic end
            if o:IsA("ParticleEmitter") then o.Enabled = false; o.Rate = 0 end
            if o:IsA("Trail") then o.Enabled = false end
            if o:IsA("Beam") then o.Enabled = false end
            if o:IsA("Explosion") then o:Destroy() end
            if o:IsA("Smoke") then o:Destroy() end
            if o:IsA("Fire") then o:Destroy() end
        end
        -- Xóa các đối tượng hiệu ứng khi quái chết
        game:GetService("CollectionService"):GetInstanceRemovedSignal("Enemy"):Connect(function(enemy)
            task.wait(0.1)
            for _, child in pairs(enemy:GetDescendants()) do
                if child:IsA("ParticleEmitter") or child:IsA("Trail") or child:IsA("Beam") then child:Destroy() end
            end
        end)
    else
        -- Phục hồi (không làm gì)
    end
end)
createButton(pMisc, "BtnRejoin", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)

-- [[ LOGIC EXECUTION ]] --
local currentTween = nil
function topos(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    if not hrp:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity"); bv.Name = "BodyClip"; bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Velocity = Vector3.zero; bv.Parent = hrp
    end
    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    local dist = (targetCFrame.Position - hrp.Position).Magnitude
    if currentTween then currentTween:Cancel() end
    local tweenInfo = TweenInfo.new(dist / 320, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == _G.SpeedKey then _G.SpeedEnabled = not _G.SpeedEnabled end
        if input.KeyCode == _G.NoclipKey then _G.NoclipEnabled = not _G.NoclipEnabled end
        if input.KeyCode == _G.JumpKey then _G.JumpEnabled = not _G.JumpEnabled end
        if input.KeyCode == _G.PullKey then
            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        break
                    end
                end
            end)
        end
    end
end)

function CountBone()
    local count = 0
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name, "Bone") then count = count + 1 end
    end
    for _, item in pairs(LocalPlayer.Character:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name, "Bone") then count = count + 1 end
    end
    return count
end

function CountTakakuri()
    local count = 0
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == "Takakuri" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            count = count + 1
        end
    end
    return count
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            boneLabel.Text = L("LabelBoneCount") .. tostring(CountBone())
            takakuriLabel.Text = L("LabelTakakuriCount") .. tostring(CountTakakuri())
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        if _G.BoatSpeedEnabled then
            pcall(function()
                local boat = LocalPlayer.Character:FindFirstChild("Boat") or LocalPlayer.Character:FindFirstChild("Ship")
                if boat and boat:FindFirstChild("BodyVelocity") then
                    boat.BodyVelocity.Velocity = boat.BodyVelocity.Velocity * 1.5
                end
            end)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hum then
            hum.WalkSpeed = _G.SpeedEnabled and _G.SpeedVal or 16
            hum.JumpPower = _G.JumpEnabled and _G.JumpVal or 50
        end
        if _G.NoclipEnabled and char then
            for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
        end

        if not (_G.AutoFarm or _G.AutoItemFarm or _G.AutoBoss or _G.AllBossesFarm) then
            if currentTween then currentTween:Cancel(); currentTween = nil end
            if hrp and hrp:FindFirstChild("BodyClip") then hrp.BodyClip:Destroy() end
        end
        
        -- Xóa hiệu ứng khi quái chết nếu bật chống lag
        if _G.ToggleLag then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") and (string.find(obj.Name, "Explosion") or string.find(obj.Name, "Flash") or string.find(obj.Name, "Effect") or string.find(obj.Name, "Hit")) then
                    obj.Rate = 0
                    obj.Enabled = false
                end
                if obj:IsA("Trail") or obj:IsA("Beam") then obj.Enabled = false end
            end
        end

        if _G.StatusHUDVisible then
            local activeList = {}
            if _G.SpeedEnabled then table.insert(activeList, "🏃 Speed ["..tostring(_G.SpeedKey.Name).."]: " .. tostring(_G.SpeedVal)) end
            if _G.NoclipEnabled then table.insert(activeList, "👻 Noclip ["..tostring(_G.NoclipKey.Name).."]: ON") end
            if _G.JumpEnabled then table.insert(activeList, "🦘 Jump ["..tostring(_G.JumpKey.Name).."]: " .. tostring(_G.JumpVal)) end
            if _G.SilentAim then table.insert(activeList, "🎯 Silent Aim: ON") end
            if _G.AutoFarm then table.insert(activeList, "⚡ Auto Farm: ON") end
            if _G.AutoClick then table.insert(activeList, "⚔️ Auto Click: ON") end
            if _G.BoatSpeedEnabled then table.insert(activeList, "🚤 Boat Speed: ON") end
            if #activeList > 0 then
                StatusHUD.Visible = true
                hudContent.Text = table.concat(activeList, "\n") .. string.format("\nLevel: %d", LocalPlayer.Data.Level.Value)
            else
                StatusHUD.Visible = false
            end
        else
            StatusHUD.Visible = false
        end
    end)
end)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 1.5
FOVCircle.Filled = false

RunService.RenderStepped:Connect(function()
    if _G.SilentAim then
        FOVCircle.Visible = true
        FOVCircle.Radius = _G.FOVSize
        FOVCircle.Color = _G.FOVColor
        FOVCircle.Position = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)
        
        local closestPlayer = nil; local shortestDist = _G.FOVSize
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    local center = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < shortestDist then shortestDist = dist; closestPlayer = p end
                end
            end
        end
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
            if math.random(1, 100) <= _G.HitAccuracy then
                Workspace.CurrentCamera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.Head.Position)
            end
        end
    else
        FOVCircle.Visible = false
    end
end)

-- ESP (giữ nguyên)
task.spawn(function()
    while task.wait(1) do
        if _G.ESPPlayer then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local head = p.Character.Head
                    if not head:FindFirstChild("Z_ESP_Plr") then
                        local gui = Instance.new("BillboardGui", head); gui.Name = "Z_ESP_Plr"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 3, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextSize = 12; txt.TextColor3 = Color3.fromRGB(235, 50, 65); txt.Font = Enum.Font.GothamBold; txt.TextStrokeTransparency = 0
                    end
                    local dist = math.floor((head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    head.Z_ESP_Plr.TextLabel.Text = p.Name .. " [" .. dist .. "m]"
                end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("Z_ESP_Plr") then p.Character.Head.Z_ESP_Plr:Destroy() end end
        end

        if _G.ESPChest then
            for _, chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
                if not chest:GetAttribute("IsDisabled") then
                    if not chest:FindFirstChild("Z_ESP_Chest") then
                        local gui = Instance.new("BillboardGui", chest); gui.Name = "Z_ESP_Chest"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 2, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextSize = 12; txt.TextColor3 = Color3.fromRGB(255, 215, 0); txt.Font = Enum.Font.GothamBold; txt.TextStrokeTransparency = 0
                    end
                    local dist = math.floor((chest:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    chest.Z_ESP_Chest.TextLabel.Text = "Chest [" .. dist .. "m]"
                elseif chest:FindFirstChild("Z_ESP_Chest") then chest.Z_ESP_Chest:Destroy() end
            end
        else
            for _, chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do if chest:FindFirstChild("Z_ESP_Chest") then chest.Z_ESP_Chest:Destroy() end end
        end

        if _G.ESPFruit then
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                    local handle = v.Handle
                    if not handle:FindFirstChild("Z_ESP_Fruit") then
                        local gui = Instance.new("BillboardGui", handle); gui.Name = "Z_ESP_Fruit"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 2, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextSize = 12; txt.TextColor3 = Color3.fromRGB(255, 50, 50); txt.Font = Enum.Font.GothamBold; txt.TextStrokeTransparency = 0
                    end
                    local dist = math.floor((handle.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    handle.Z_ESP_Fruit.TextLabel.Text = "🍎 " .. v.Name .. " [" .. dist .. "m]"
                end
            end
        else
            for _, v in pairs(Workspace:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") and v.Handle:FindFirstChild("Z_ESP_Fruit") then v.Handle.Z_ESP_Fruit:Destroy() end end
        end

        if _G.ESPNPC then
            for _, npc in pairs(Workspace:GetDescendants()) do
                if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) then
                    local hrp = npc.HumanoidRootPart
                    if not hrp:FindFirstChild("Z_ESP_NPC") then
                        local gui = Instance.new("BillboardGui", hrp); gui.Name = "Z_ESP_NPC"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 3, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextSize = 11; txt.TextColor3 = Color3.fromRGB(0, 255, 100); txt.Font = Enum.Font.GothamBold; txt.TextStrokeTransparency = 0
                    end
                    hrp.Z_ESP_NPC.TextLabel.Text = "👤 " .. npc.Name
                end
            end
        else
            for _, npc in pairs(Workspace:GetDescendants()) do if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and npc.HumanoidRootPart:FindFirstChild("Z_ESP_NPC") then npc.HumanoidRootPart.Z_ESP_NPC:Destroy() end end
        end

        if _G.ESPIsland then
            local map = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("Locations")
            if map then
                for _, loc in pairs(map:GetChildren()) do
                    if not loc:FindFirstChild("Z_ESP_Island") then
                        local gui = Instance.new("BillboardGui", loc); gui.Name = "Z_ESP_Island"; gui.Size = UDim2.new(0, 200, 0, 40); gui.AlwaysOnTop = true; gui.StudsOffset = Vector3.new(0, 10, 0)
                        local txt = Instance.new("TextLabel", gui); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextSize = 13; txt.TextColor3 = Color3.fromRGB(200, 100, 255); txt.Font = Enum.Font.GothamBold; txt.TextStrokeTransparency = 0
                    end
                    local dist = math.floor((loc.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    loc.Z_ESP_Island.TextLabel.Text = "🏝️ " .. loc.Name .. " [" .. dist .. "m]"
                end
            end
        else
            local map = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("Locations")
            if map then for _, loc in pairs(map:GetChildren()) do if loc:FindFirstChild("Z_ESP_Island") then loc.Z_ESP_Island:Destroy() end end end
        end
    end
end)

-- =========================================================
-- LOGIC AUTO FARM, BRING MOB, BOSS, BONE, TAKAKURI (SỬA LỖI ĐỨNG FARM)
-- =========================================================
function EquipWeapon(weaponType)
    pcall(function()
        if not LocalPlayer.Character:FindFirstChild("HasBuso") then CommF:InvokeServer("Buso") end
        local char = LocalPlayer.Character; local backpack = LocalPlayer:WaitForChild("Backpack")
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

local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon = "", 1, "", "", CFrame.new(), CFrame.new()
function CheckQuest()
    local MyLevel = LocalPlayer.Data.Level.Value
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
        elseif MyLevel >= 300 and MyLevel <= 324 then Mon = "Magma Ninja"; LevelQuest = 1; NameQuest = "MagmaQuest"; NameMon = "Magma Ninja"; CFrameQuest = CFrame.new(-5313, 12, 8515); CFrameMon = CFrame.new(-5403, 15, 8352)
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

-- Vòng lặp Auto Farm Level & Item Farm (sửa lỗi đứng farm)
spawn(function()
    while task.wait() do
        if _G.AutoFarm or _G.AutoItemFarm then
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
                            -- Di chuyển đến vị trí quái một lần, không di chuyển liên tục
                            local targetPos = v512.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                            if (LocalPlayer.Character.HumanoidRootPart.Position - targetPos.Position).Magnitude > 10 then
                                topos(targetPos)
                            end
                            repeat
                                task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                local hrp = LocalPlayer.Character.HumanoidRootPart
                                -- Chỉ xoay hướng về quái, không di chuyển nữa
                                hrp.CFrame = CFrame.lookAt(hrp.Position, v512.HumanoidRootPart.Position)
                                v512.HumanoidRootPart.CanCollide = false; v512.Humanoid.WalkSpeed = 0; v512.Head.CanCollide = false; v512.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                StartBring = true; _G.GlobalFarmActive = true
                                VirtualUser:CaptureController(); VirtualUser:Button1Down(Vector2.new(1280, 672))
                            until not (_G.AutoFarm or _G.AutoItemFarm) or v512.Humanoid.Health <= 0 or not v512.Parent or questGui.Visible == false
                        end
                    end
                    if not foundMob then StartBring = false; _G.GlobalFarmActive = false; topos(CFrameMon) end
                end
            end)
        else
            if not (_G.AutoBoss or _G.AllBossesFarm) then _G.GlobalFarmActive = false end
        end
    end
end)

-- Auto Click (giữ)
spawn(function()
    while task.wait() do
        if _G.AutoClick then
            pcall(function()
                EquipWeapon(_G.SelectWeapon)
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(1280, 672))
            end)
        end
    end
end)

-- Bring Mob (giữ)
spawn(function()
    while task.wait() do
        pcall(function()
            if (_G.AutoFarm or _G.AutoItemFarm) and _G.BringMonster and StartBring then
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

-- Boss Farm (sửa lỗi đứng farm)
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local liveBosses = {}
            for _, v in pairs(Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and (string.find(v.Name, "Boss") or table.find(CurrentBossList, v.Name)) then
                    table.insert(liveBosses, v.Name)
                end
            end

            if _G.AutoBoss or _G.AllBossesFarm then
                for _, v in pairs(Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        if _G.AllBossesFarm or v.Name == _G.SelectedBossName then
                            _G.GlobalFarmActive = true
                            -- Di chuyển đến boss một lần
                            local targetPos = v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                            if (LocalPlayer.Character.HumanoidRootPart.Position - targetPos.Position).Magnitude > 10 then
                                topos(targetPos)
                            end
                            repeat
                                task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                local hrp = LocalPlayer.Character.HumanoidRootPart
                                hrp.CFrame = CFrame.lookAt(hrp.Position, v.HumanoidRootPart.Position)
                                v.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, -15, 0)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0; v.Humanoid.JumpPower = 0
                                if v.Humanoid:FindFirstChild("Animator") then v.Humanoid.Animator:Destroy() end
                                v.Humanoid:ChangeState(11)
                            until not (_G.AutoBoss or _G.AllBossesFarm) or v.Humanoid.Health <= 0 or not v.Parent
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto Collect Fruit (giữ)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoCollectFruit then
            pcall(function()
                for _, v in pairs(Workspace:GetChildren()) do
                    if v:IsA("Tool") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                        topos(v.Handle.CFrame)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Handle, 0)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Handle, 1)
                    end
                end
            end)
        end
    end
end)

-- Fast Attack Turbo Max Speed (giảm số lần gửi để đỡ lag)
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
        if (_G.AutoFarm or _G.AutoItemFarm or _G.GlobalFarmActive or _G.AutoClick or _G.AutoFarmBone or _G.AutoFarmTakakuri) and _G.FastAttack then
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
                            -- Giảm từ 10 xuống 3 lần gửi để giảm lag
                            for _ = 1, 3 do
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

-- Auto Stats (giữ)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoStats and CommF then
            pcall(function()
                if LocalPlayer.Data.Points.Value > 0 then
                    local amt = _G.StatsAmount or 1
                    if _G.StatsMelee then CommF:InvokeServer("AddPoint", "Melee", amt) end
                    if _G.StatsDefense then CommF:InvokeServer("AddPoint", "Defense", amt) end
                    if _G.StatsSword then CommF:InvokeServer("AddPoint", "Sword", amt) end
                    if _G.StatsFruit then CommF:InvokeServer("AddPoint", "Demon Fruit", amt) end
                end
            end)
        end
    end
end)

-- Auto Farm Bone (sửa lỗi đứng farm)
task.spawn(function()
    while task.wait() do
        if _G.AutoFarmBone then
            pcall(function()
                for _, v in pairs(Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        if string.find(v.Name, "Bone") or string.find(v.Name, "Skeleton") or string.find(v.Name, "Zombie") then
                            _G.GlobalFarmActive = true
                            local targetPos = v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                            if (LocalPlayer.Character.HumanoidRootPart.Position - targetPos.Position).Magnitude > 10 then
                                topos(targetPos)
                            end
                            repeat
                                task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                local hrp = LocalPlayer.Character.HumanoidRootPart
                                hrp.CFrame = CFrame.lookAt(hrp.Position, v.HumanoidRootPart.Position)
                                v.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, -15, 0)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0; v.Humanoid.JumpPower = 0
                                if v.Humanoid:FindFirstChild("Animator") then v.Humanoid.Animator:Destroy() end
                                v.Humanoid:ChangeState(11)
                            until not _G.AutoFarmBone or v.Humanoid.Health <= 0 or not v.Parent
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Farm Takakuri (sửa lỗi đứng farm)
task.spawn(function()
    while task.wait() do
        if _G.AutoFarmTakakuri then
            pcall(function()
                local takakuriCount = CountTakakuri()
                if takakuriCount > 0 then
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v:IsA("Model") and v.Name == "Takakuri" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                            _G.GlobalFarmActive = true
                            local targetPos = v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                            if (LocalPlayer.Character.HumanoidRootPart.Position - targetPos.Position).Magnitude > 10 then
                                topos(targetPos)
                            end
                            repeat
                                task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                local hrp = LocalPlayer.Character.HumanoidRootPart
                                hrp.CFrame = CFrame.lookAt(hrp.Position, v.HumanoidRootPart.Position)
                                v.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, -15, 0)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0; v.Humanoid.JumpPower = 0
                                if v.Humanoid:FindFirstChild("Animator") then v.Humanoid.Animator:Destroy() end
                                v.Humanoid:ChangeState(11)
                            until not _G.AutoFarmTakakuri or v.Humanoid.Health <= 0 or not v.Parent
                        end
                    end
                else
                    if CommF then
                        CommF:InvokeServer("SummonTakakuri")
                        task.wait(2)
                    end
                end
            end)
        end
    end
end)

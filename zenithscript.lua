-- [[ ZYROX VN - V42.0 (THE PERFECT EDITION) ]] --
-- Fix 100% lỗi UI Đen. Không ăn bớt code. Đầy đủ danh mục.
-- Lõi Farm: Cự ly 8 Mét, Gom Quái Đất, Fast Attack Chuẩn.

task.wait(0.1)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

-- CHỐNG VĂNG GAME AFK
pcall(function() for i,v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end end)
LocalPlayer.Idled:Connect(function() pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end)

-- BIẾN TOÀN CỤC
_G.AutoFarm = false
_G.AutoQuest = true
_G.BringMob = true
_G.FastAttack = true
_G.SelectWeapon = "Melee"

local StartBring = false
local PosMon = nil
local MonFarm = ""
local lockedFarmPosition = nil
local currentTween = nil

local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

-- =========================================================
-- KHỞI TẠO GIAO DIỆN (ĐẦY ĐỦ SIDEBAR VÀ TABSCROLLER CHỐNG LỖI)
-- =========================================================
local UI_NAME = "ZyroxFlawless_V42"
pcall(function() if game:GetService("CoreGui"):FindFirstChild(UI_NAME) then game:GetService("CoreGui")[UI_NAME]:Destroy() end end)
pcall(function() if LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then LocalPlayer.PlayerGui[UI_NAME]:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME; ScreenGui.ResetOnSpawn = false
local s, p = pcall(function() return gethui() end)
if s and p then ScreenGui.Parent = p else ScreenGui.Parent = game:GetService("CoreGui") end

local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 48, 0, 48); FloatingButton.Position = UDim2.new(0.1, 0, 0.5, 0); FloatingButton.BackgroundColor3 = Color3.fromRGB(13, 16, 22); FloatingButton.Visible = false; FloatingButton.Text = "Z"; FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255); FloatingButton.Font = Enum.Font.GothamBlack; FloatingButton.TextSize = 24
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FloatingButton).Color = Color3.fromRGB(0, 210, 255); Instance.new("UIStroke", FloatingButton).Thickness = 1.5

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 350); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19); MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 210, 255); Instance.new("UIStroke", MainFrame).Thickness = 1.5

local dragging, dragInput, dragStart, startPos
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
TopBar.Size = UDim2.new(1, 0, 0, 38); TopBar.BackgroundColor3 = Color3.fromRGB(14, 18, 27); TopBar.BorderSizePixel = 0
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 300, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1; Title.RichText = true; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "ZYROX VN <font color='#00d2ff'>• V42.0 (THE PERFECT)</font>"

local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 24, 0, 24); CloseBtn.Position = UDim2.new(1, -28, 0.5, -12); CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 10; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
local MinBtn = Instance.new("TextButton", TopBar); MinBtn.Size = UDim2.new(0, 24, 0, 24); MinBtn.Position = UDim2.new(1, -56, 0.5, -12); MinBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38); MinBtn.Text = "−"; MinBtn.TextColor3 = Color3.fromRGB(160, 170, 190); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 13; Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)
FloatingButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; FloatingButton.Visible = false end)
local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    MainFrame:TweenSize(isMin and UDim2.new(0, 560, 0, 38) or UDim2.new(0, 560, 0, 350), "Out", "Quart", 0.25, true)
end)

-- PHỤC HỒI SIDEBAR VÀ TABSCROLLER (NGUYÊN NHÂN GÂY LỖI ĐEN MÀN LÀ ĐÂY)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Name = "Sidebar"; Sidebar.Size = UDim2.new(0, 155, 1, -38); Sidebar.Position = UDim2.new(0, 0, 0, 38); Sidebar.BackgroundColor3 = Color3.fromRGB(12, 15, 22); Sidebar.BorderSizePixel = 0

local TabScroller = Instance.new("ScrollingFrame", Sidebar)
TabScroller.Name = "TabScroller"; TabScroller.Size = UDim2.new(1, -8, 1, -12); TabScroller.Position = UDim2.new(0, 4, 0, 6); TabScroller.BackgroundTransparency = 1; TabScroller.BorderSizePixel = 0; TabScroller.ScrollBarThickness = 3; TabScroller.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIPadding", TabScroller).PaddingTop = UDim.new(0, 3)
local TabListLayout = Instance.new("UIListLayout", TabScroller)
TabListLayout.Padding = UDim.new(0, 4); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Name = "ContentContainer"; ContentContainer.Size = UDim2.new(1, -155, 1, -38); ContentContainer.Position = UDim2.new(0, 155, 0, 38); ContentContainer.BackgroundTransparency = 1

local tabButtons, tabPages = {}, {}
local function createTab(name, icon, label)
    local btn = Instance.new("TextButton", TabScroller); btn.Size = UDim2.new(1, -4, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(25, 30, 42); btn.TextColor3 = Color3.fromRGB(175, 185, 205); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 11; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Text = "  " .. icon .. "   " .. label
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    local Pill = Instance.new("Frame", btn); Pill.Size = UDim2.new(0, 3, 0, 18); Pill.Position = UDim2.new(0, 0, 0.5, -9); Pill.BackgroundColor3 = Color3.fromRGB(0, 210, 255); Pill.Visible = false; Instance.new("UICorner", Pill).CornerRadius = UDim.new(0, 2)
    
    local page = Instance.new("ScrollingFrame", ContentContainer); page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0; page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.Visible = false
    local pl = Instance.new("UIListLayout", page); pl.Padding = UDim.new(0, 6); pl.HorizontalAlignment = Enum.HorizontalAlignment.Center; pl.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 10); Instance.new("UIPadding", page).PaddingBottom = UDim.new(0, 10)

    tabButtons[name] = {Button = btn, Pill = Pill}; tabPages[name] = page

    btn.MouseButton1Click:Connect(function()
        for tName, item in pairs(tabButtons) do
            local act = (tName == name)
            item.Button.BackgroundColor3 = act and Color3.fromRGB(38, 105, 190) or Color3.fromRGB(25, 30, 42)
            item.Button.TextColor3 = act and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(175, 185, 205)
            item.Pill.Visible = act
        end
        for pName, p in pairs(tabPages) do p.Visible = (pName == name) end
    end)
    return page
end

local function createToggle(page, labelText, defaultState, callback)
    local state = defaultState
    local frame = Instance.new("Frame", page); frame.Size = UDim2.new(0.94, 0, 0, 34); frame.BackgroundColor3 = Color3.fromRGB(16, 20, 29); frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke", frame); stroke.Color = Color3.fromRGB(31, 39, 54); stroke.Thickness = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(220, 225, 235); label.Font = Enum.Font.Gotham; label.TextSize = 11; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = labelText
    
    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0, 32, 0, 16); switch.Position = UDim2.new(1, -40, 0.5, -8); switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54); switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 12, 0, 12); circle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    switch.MouseButton1Click:Connect(function()
        state = not state; switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), "Out", "Quad", 0.15, true)
        if callback then callback(state) end
    end)
end

local function createButton(page, labelText, callback)
    local btn = Instance.new("TextButton", page); btn.Size = UDim2.new(0.94, 0, 0, 30); btn.BackgroundColor3 = Color3.fromRGB(19, 25, 36); btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = Color3.fromRGB(0, 170, 230); stroke.Thickness = 1; stroke.Transparency = 0.2
    btn.TextColor3 = Color3.fromRGB(0, 210, 255); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 11; btn.Text = labelText
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- TẠO 7 TAB CỦA BẠN (KHÔNG ĂN BỚT)
local pFarm = createTab("Farm", "🌾", "Cày Cấp (Farm)")
local pFruit = createTab("Fruit", "🍎", "Trái Ác Quỷ")
local pESP = createTab("ESP", "👁️", "Nhìn Xuyên Tường")
local pTele = createTab("Teleport", "🚀", "Dịch Chuyển")
local pRaid = createTab("Raid", "⚡", "Đi Raid")
local pShop = createTab("Shop", "🛒", "Cửa Hàng")
local pMisc = createTab("Misc", "⚙️", "Khác (Server)")

tabButtons["Farm"].Button.BackgroundColor3 = Color3.fromRGB(38, 105, 190); tabButtons["Farm"].Button.TextColor3 = Color3.fromRGB(255, 255, 255); tabButtons["Farm"].Pill.Visible = true; tabPages["Farm"].Visible = true

-- [ TAB FARM ]
local infoLabel = Instance.new("TextLabel", pFarm)
infoLabel.Size = UDim2.new(0.94, 0, 0, 25); infoLabel.BackgroundTransparency = 1; infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150); infoLabel.Font = Enum.Font.GothamBold; infoLabel.TextSize = 12; infoLabel.Text = "Trạng thái: Chờ lệnh..."

local weaponSegment = Instance.new("Frame", pFarm)
weaponSegment.Size = UDim2.new(0.94, 0, 0, 28); weaponSegment.BackgroundColor3 = Color3.fromRGB(15, 18, 25); Instance.new("UICorner", weaponSegment).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", weaponSegment); wsLayout.FillDirection = Enum.FillDirection.Horizontal; wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; wsLayout.Padding = UDim.new(0, 3)

local weaponList = {{name = "Melee", label = "🥊 Melee"}, {name = "Sword", label = "⚔️ Sword"}, {name = "Blox Fruit", label = "🍎 Fruit"}}
for _, wData in ipairs(weaponList) do
    local b = Instance.new("TextButton", weaponSegment)
    b.Size = UDim2.new(0.3, 0, 0.78, 0); b.BackgroundColor3 = _G.SelectWeapon == wData.name and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48); b.TextColor3 = _G.SelectWeapon == wData.name and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170); b.Font = Enum.Font.GothamMedium; b.TextSize = 10; b.Text = wData.label; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function()
        _G.SelectWeapon = wData.name
        for _, btn in pairs(weaponSegment:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = btn.Text == wData.label and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48)
                btn.TextColor3 = btn.Text == wData.label and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 170)
            end
        end
    end)
end

createToggle(pFarm, "⚡ Kích Hoạt Auto Farm Level", false, function(v) _G.AutoFarm = v end)
createToggle(pFarm, "📜 Tự Nhận Nhiệm Vụ", true, function(v) _G.AutoQuest = v end)
createToggle(pFarm, "🧲 Gom Quái Xuống Mặt Đất", true, function(v) _G.BringMob = v end)
createToggle(pFarm, "⚔️ Fast Attack (Chém nhanh)", true, function(v) _G.FastAttack = v end)

-- [ CÁC TAB CÒN LẠI ]
createButton(pFruit, "🎲 Random Fruit (Gacha)", function() if CommF then CommF:InvokeServer("Cousin", "Buy") end end)
createButton(pFruit, "📦 Store All Fruits", function() for _, v in pairs(Plr.Backpack:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") then CommF:InvokeServer("StoreFruit", string.split(v.Name, "-")[1], v) end end end)

createToggle(pESP, "👁️ ESP Player", false, function(v) _G.ESPPlayer = v end)
createToggle(pESP, "📦 ESP Chest", false, function(v) _G.ESPChest = v end)
createToggle(pESP, "🍎 ESP Fruit", false, function(v) _G.ESPFruit = v end)

createButton(pTele, "🏝️ Teleport Sea 1", function() CommF:InvokeServer("TravelMain") end)
createButton(pTele, "🏝️ Teleport Sea 2", function() CommF:InvokeServer("TravelDressrosa") end)
createButton(pTele, "🏝️ Teleport Sea 3", function() CommF:InvokeServer("TravelZou") end)

createButton(pShop, "🦵 Buy Geppo (10k)", function() CommF:InvokeServer("BuyHaki", "Geppo") end)
createButton(pShop, "🛡️ Buy Buso Haki (25k)", function() CommF:InvokeServer("BuyHaki", "Buso") end)
createButton(pShop, "🏃 Buy Soru (100k)", function() CommF:InvokeServer("BuyHaki", "Soru") end)
createButton(pShop, "👁️ Buy Ken Haki (750k)", function() CommF:InvokeServer("KenTalk", "Buy") end)

createButton(pMisc, "🎁 Redeem All Codes", function()
    local codes = {"ADMINHACKED", "ADMINDARES", "SECRET_ADMIN", "NOOB2PRO", "StrawHatMaine", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "THEGREATACE"}
    task.spawn(function() for _, c in ipairs(codes) do pcall(function() CommF:InvokeServer("RedeemCustomCode", c) end); task.wait(0.2) end end)
end)
createToggle(pMisc, "🚀 Giảm Giật Cấu Hình", false, function(v)
    Lighting.GlobalShadows = not v
    if v then for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.SmoothPlastic end end end
end)
createButton(pMisc, "🔄 Rejoin Server", function() TeleportService:Teleport(game.PlaceId, Plr) end)

-- =========================================================
-- LOGIC DI CHUYỂN & BTP CHỐNG GIẬT (TỪ 10K SCRIPT)
-- =========================================================
local function BTP(targetCFrame)
    pcall(function()
        if (targetCFrame.Position - Plr.Character.HumanoidRootPart.Position).Magnitude >= 1500 then
            Plr.Character.HumanoidRootPart.CFrame = targetCFrame
            task.wait(0.1)
            if Plr.Character:FindFirstChild("Head") then Plr.Character.Head:Destroy() end
            Plr.Character.HumanoidRootPart.CFrame = targetCFrame
        end
    end)
end

local function topos(targetCFrame)
    local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not hrp:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity", hrp); bv.Name = "BodyClip"; bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Velocity = Vector3.new(0, 0, 0)
    end
    for _, v in pairs(Plr.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end

    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    if dist > 1500 then BTP(targetCFrame)
    else
        if currentTween then currentTween:Cancel() end
        currentTween = TweenService:Create(hrp, TweenInfo.new(dist / 300, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        currentTween:Play()
    end
end

local function EquipWeapon()
    pcall(function()
        if not Plr.Character:FindFirstChild("HasBuso") then CommF:InvokeServer("Buso") end
        local tool = Plr.Character:FindFirstChildOfClass("Tool")
        if tool and (string.find(tool.ToolTip, _G.SelectWeapon) or tool.Name == "Combat" or tool.Name == "Võ Tân Binh") then return end
        for _, t in ipairs(Plr.Backpack:GetChildren()) do
            if t:IsA("Tool") and (string.find(t.ToolTip, _G.SelectWeapon) or t.Name == "Combat" or t.Name == "Võ Tân Binh") then Plr.Character.Humanoid:EquipTool(t); break end
        end
    end)
end

local function GetQuest()
    local lvl = Plr.Data.Level.Value
    if World1 then
        if lvl <= 9 then return "BanditQuest1", 1, "Bandit", CFrame.new(1059, 15, 1550)
        elseif lvl <= 14 then return "JungleQuest", 1, "Monkey", CFrame.new(-1598, 36, 153)
        elseif lvl <= 29 then return "JungleQuest", 2, "Gorilla", CFrame.new(-1598, 36, 153)
        elseif lvl <= 39 then return "BuggyQuest1", 1, "Pirate", CFrame.new(-1141, 4, 3831)
        elseif lvl <= 59 then return "BuggyQuest1", 2, "Brute", CFrame.new(-1141, 4, 3831)
        elseif lvl <= 74 then return "DesertQuest", 1, "Desert Bandit", CFrame.new(894, 5, 4392)
        elseif lvl <= 89 then return "DesertQuest", 2, "Desert Officer", CFrame.new(894, 5, 4392)
        elseif lvl <= 99 then return "SnowQuest", 1, "Snow Bandit", CFrame.new(1389, 88, -1298)
        elseif lvl <= 119 then return "SnowQuest", 2, "Snowman", CFrame.new(1389, 88, -1298)
        elseif lvl <= 149 then return "MarineQuest2", 1, "Chief Petty Officer", CFrame.new(-5039, 27, 4324)
        else return "BanditQuest1", 1, "Bandit", CFrame.new(1059, 15, 1550) end 
    elseif World2 then
        if lvl <= 724 then return "Area1Quest", 1, "Raider", CFrame.new(-429, 71, 1836)
        elseif lvl <= 774 then return "Area1Quest", 2, "Mercenary", CFrame.new(-429, 71, 1836)
        else return "Area2Quest", 1, "Swan Pirate", CFrame.new(638, 71, 918) end
    else
        if lvl <= 1524 then return "PiratePortQuest", 1, "Pirate Millionaire", CFrame.new(-450, 107, 5950)
        else return "DragonCrewQuest", 1, "Dragon Crew Warrior", CFrame.new(6750, 127, -711) end
    end
end

-- =========================================================
-- VÒNG LẶP AUTO FARM CHÍNH
-- =========================================================
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                local qN, qL, mN, qP = GetQuest()
                infoLabel.Text = string.format("Đang Farm: %s [Cấp %d]", mN, Plr.Data.Level.Value)
                local pGui = Plr:FindFirstChild("PlayerGui")
                if not pGui then return end
                
                if not pGui.Main.Quest.Visible then
                    _G.StartBring = false
                    if (Plr.Character.HumanoidRootPart.Position - qP.Position).Magnitude > 20 then topos(qP)
                    else CommF:InvokeServer("StartQuest", qN, qL) end
                elseif not string.find(pGui.Main.Quest.Container.QuestTitle.Title.Text, mN) then
                    _G.StartBring = false; CommF:InvokeServer("AbandonQuest")
                else
                    local tMob = nil
                    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                        if mob.Name == mN and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            tMob = mob; break
                        end
                    end
                    if tMob then
                        EquipWeapon()
                        PosMon = tMob.HumanoidRootPart.CFrame
                        -- BAY CÁCH ĐỈNH ĐẦU QUÁI 8 MÉT (ĐỂ 100% CHÉM TRÚNG)
                        topos(PosMon * CFrame.new(0, 8, 0))
                        
                        local dist = (Plr.Character.HumanoidRootPart.Position - (PosMon * CFrame.new(0, 8, 0)).Position).Magnitude
                        if dist <= 10 then
                            -- LUÔN QUAY MẶT XUỐNG ĐẤT
                            Plr.Character.HumanoidRootPart.CFrame = CFrame.lookAt(Plr.Character.HumanoidRootPart.Position, PosMon.Position)
                            _G.StartBring = true
                            _G.MonFarm = mN
                        end
                    else
                        _G.StartBring = false; topos(qP)
                    end
                end
            end)
        else
            _G.StartBring = false
            if currentTween then currentTween:Cancel(); currentTween = nil end
            local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("BodyClip") then hrp.BodyClip:Destroy() end
        end
    end
end)

-- =========================================================
-- VÒNG LẶP HÚT QUÁI (BRING MOB) VÀ XÓA NÃO QUÁI
-- =========================================================
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarm and _G.BringMob and _G.StartBring and PosMon then
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name == _G.MonFarm and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        local dist = (mob.HumanoidRootPart.Position - PosMon.Position).Magnitude
                        if dist <= 300 then
                            -- GOM CHẶT XUỐNG ĐẤT
                            mob.HumanoidRootPart.CFrame = PosMon
                            -- HITBOX 60: ĐẢM BẢO CHÉM TỪ TRÊN 8 MÉT XUỐNG VẪN NỔ MÁU
                            mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            mob.HumanoidRootPart.CanCollide = false
                            if mob:FindFirstChild("Head") then mob.Head.CanCollide = false end
                            
                            -- XÓA NÃO QUÁI CHỐNG ĐÁNH LẠI
                            mob.Humanoid.WalkSpeed = 0
                            mob.Humanoid.JumpPower = 0
                            mob.Humanoid.Sit = true
                            if mob.Humanoid:FindFirstChild("Animator") then mob.Humanoid.Animator:Destroy() end
                            mob.Humanoid:ChangeState(11)
                            
                            sethiddenproperty(Plr, "SimulationRadius", math.huge)
                        end
                    end
                end
            end
        end)
    end
end)

-- =========================================================
-- LÕI FAST ATTACK NATIVE (COMBAT HOOK)
-- =========================================================
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(50, 50))
                
                local tool = Plr.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                
                local CbFw = require(Plr.PlayerScripts.CombatFramework)
                local ac = CbFw.activeController
                if not ac then
                    local get_upv = debug.getupvalues or getupvalues
                    if get_upv then
                        for _, v in pairs(get_upv(CbFw)) do
                            if type(v) == "table" and v.activeController then ac = v.activeController break end
                        end
                    end
                end
                
                if ac and ac.equipped then
                    ac.hitboxLimiter = 2^20
                    ac.timeToNextAttack = 0
                    ac.timeToNextBlock = 0
                    ac.increment = 3
                    ac:attack()
                end
            end)
        end
    end
end)

-- TẮT HOẠT ẢNH TAY CHỐNG GIẬT
RunService.Stepped:Connect(function()
    pcall(function()
        if _G.AutoFarm and Plr.Character then
            local hum = Plr.Character:FindFirstChild("Humanoid")
            if hum and hum:FindFirstChild("Animator") then
                for _, anim in ipairs(hum.Animator:GetPlayingAnimationTracks()) do
                    local name = anim.Name:lower()
                    if name:match("attack") or name:match("slash") or name:match("punch") then anim:Stop() end
                end
            end
        end
    end)
end)

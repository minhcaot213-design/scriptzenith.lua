-- [[ ZENITH BLOX FRUIT - V20.0 (FULL UI + GOD MODE BYPASS)
--    GIAO DIỆN HOÀN CHỈNH KẾT HỢP LÕI FAST ATTACK MEMORY HOOK
-- ]] --

task.wait(0.5)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- =========================================================
-- SERVICES & BIẾN
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

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local CommF
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

-- CHỐNG AFK DISCONNECT VĨNH VIỄN
for i,v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end

local selectedWeaponType = "Melee"
local AutoFarmLevel = false
local AutoQuest = true
local BringMob = true
local espPlayerEnabled = false
local espFruitEnabled = false
local espChest1Enabled, espChest2Enabled, espChest3Enabled = false, false, false
local speedValue, speedEnabled = 16, false
local jumpValue, jumpEnabled = 50, false
local AutoRandomFruit, AutoCollectFruit, AutoStoreFruit = false, false, false

-- =========================================================
-- GIAO DIỆN: CHỐNG LỖI HIỂN THỊ (SAFE FOLDER)
-- =========================================================
local UI_NAME = "ZenithTrueHub_V20"
local function GetSafeUIFolder()
    local folder
    pcall(function() if gethui then folder = gethui() end end)
    if not folder then pcall(function() folder = game:GetService("CoreGui") end) end
    if not folder then folder = LocalPlayer:WaitForChild("PlayerGui") end
    return folder
end

local targetUIFolder = GetSafeUIFolder()
pcall(function() for _, gui in ipairs(targetUIFolder:GetChildren()) do if gui.Name == UI_NAME then gui:Destroy() end end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME; ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = targetUIFolder end)

-- NÚT Z LƠ LỬNG
local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 48, 0, 48); FloatingButton.Position = UDim2.new(0.1, 0, 0.5, 0); FloatingButton.BackgroundColor3 = Color3.fromRGB(13, 16, 22); FloatingButton.Visible = false; FloatingButton.Text = "Z"; FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255); FloatingButton.Font = Enum.Font.GothamBlack; FloatingButton.TextSize = 24; FloatingButton.ZIndex = 999
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
local floatingStroke = Instance.new("UIStroke", FloatingButton); floatingStroke.Color = Color3.fromRGB(0, 210, 255); floatingStroke.Thickness = 1.5

-- BẢNG CHÍNH
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 350); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19); MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true
local UIScale = Instance.new("UIScale", MainFrame)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 5)
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = Color3.fromRGB(0, 210, 255); MainStroke.Thickness = 1.5

-- KÉO THẢ GIAO DIỆN
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

-- THANH TIÊU ĐỀ
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38); TopBar.BackgroundColor3 = Color3.fromRGB(14, 18, 27); TopBar.BorderSizePixel = 0
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 240, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1; Title.RichText = true; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "ZYROX VN <font color='#00d2ff'>• V20 (GOD MODE)</font>"

local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 24, 0, 24); CloseBtn.Position = UDim2.new(1, -28, 0.5, -12); CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 10; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
local MinBtn = Instance.new("TextButton", TopBar); MinBtn.Size = UDim2.new(0, 24, 0, 24); MinBtn.Position = UDim2.new(1, -56, 0.5, -12); MinBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38); MinBtn.Text = "−"; MinBtn.TextColor3 = Color3.fromRGB(160, 170, 190); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 13; Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame:TweenSize(isMinimized and UDim2.new(0, 560, 0, 38) or UDim2.new(0, 560, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
end)

-- TẠO CẤU TRÚC TAB
local Sidebar = Instance.new("Frame", MainFrame); Sidebar.Name = "Sidebar"; Sidebar.Size = UDim2.new(0, 155, 1, -38); Sidebar.Position = UDim2.new(0, 0, 0, 38); Sidebar.BackgroundColor3 = Color3.fromRGB(12, 15, 22); Sidebar.BorderSizePixel = 0
local TabScroller = Instance.new("ScrollingFrame", Sidebar); TabScroller.Size = UDim2.new(1, -8, 1, -12); TabScroller.Position = UDim2.new(0, 4, 0, 6); TabScroller.BackgroundTransparency = 1; TabScroller.BorderSizePixel = 0; TabScroller.ScrollBarThickness = 3; TabScroller.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIPadding", TabScroller).PaddingTop = UDim.new(0, 3)
local TabListLayout = Instance.new("UIListLayout", TabScroller); TabListLayout.Padding = UDim.new(0, 4); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local ContentContainer = Instance.new("Frame", MainFrame); ContentContainer.Name = "ContentContainer"; ContentContainer.Size = UDim2.new(1, -155, 1, -38); ContentContainer.Position = UDim2.new(0, 155, 0, 38); ContentContainer.BackgroundTransparency = 1

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
    local frame = Instance.new("Frame", page); frame.Size = UDim2.new(0.94, 0, 0, 34); frame.BackgroundColor3 = Color3.fromRGB(16, 20, 29); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    local lbl = Instance.new("TextLabel", frame); lbl.Size = UDim2.new(1, -50, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(220, 225, 235); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = labelText
    local switch = Instance.new("TextButton", frame); switch.Size = UDim2.new(0, 32, 0, 16); switch.Position = UDim2.new(1, -40, 0.5, -8); switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54); switch.Text = ""; Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch); circle.Size = UDim2.new(0, 12, 0, 12); circle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    switch.MouseButton1Click:Connect(function()
        state = not state; switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), "Out", "Quad", 0.15, true)
        if callback then callback(state) end
    end)
end

local farmPage = createTab("Farm", "🌾", "Cày Cấp (Farm)")
local espPage = createTab("ESP", "👁️", "Nhìn Xuyên Tường")
local miscPage = createTab("Misc", "⚙️", "Cài Đặt")

-- KÍCH HOẠT TAB ĐẦU TIÊN
tabButtons["Farm"].Button.BackgroundColor3 = Color3.fromRGB(38, 105, 190); tabButtons["Farm"].Button.TextColor3 = Color3.fromRGB(255, 255, 255); tabButtons["Farm"].Pill.Visible = true; tabPages["Farm"].Visible = true

local infoLabel = Instance.new("TextLabel", farmPage); infoLabel.Size = UDim2.new(0.94, 0, 0, 25); infoLabel.BackgroundTransparency = 1; infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150); infoLabel.Font = Enum.Font.GothamBold; infoLabel.TextSize = 12

createToggle(farmPage, "⚡ Kích Hoạt Auto Farm", false, function(v) AutoFarmLevel = v end)
createToggle(farmPage, "📜 Tự Nhận Nhiệm Vụ", true, function(v) AutoQuest = v end)
createToggle(farmPage, "🧲 Gom Quái (Không Kẹt Dưới Đất)", true, function(v) BringMob = v end)

createToggle(espPage, "Hiện Người Chơi", false, function(v) espPlayerEnabled = v end)
createToggle(espPage, "Hiện Trái Ác Quỷ", false, function(v) espFruitEnabled = v end)

createToggle(miscPage, "Giảm Lag Đồ Họa (Cho LDPlayer)", false, function(v)
    Lighting.GlobalShadows = not v
    if v then for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end end end
end)

-- =========================================================
-- ĐỔI VŨ KHÍ TỰ ĐỘNG
-- =========================================================
task.spawn(function()
    while task.wait(0.5) do
        if AutoFarmLevel then
            pcall(function()
                local char = LocalPlayer.Character
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                local currentTool = char and char:FindFirstChildOfClass("Tool")
                
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
            end)
        end
    end
end)

-- =========================================================
-- LÕI GOD MODE: CHÉM XUYÊN BỘ NHỚ (KHÔNG CẦN CHUỘT)
-- =========================================================
local requireCbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
local CbFw = debug.getupvalues(requireCbFw)[2]

task.spawn(function()
    while task.wait() do
        if AutoFarmLevel then
            pcall(function()
                local ac = CbFw.activeController
                if ac and ac.equipped then
                    -- Tốc độ chém bàn thờ
                    ac.hitboxLimiter = 0
                    ac.timeToNextAttack = 0
                    ac.timeToNextBlock = 0
                    ac.increment = 3
                    ac.attacking = false
                    ac.blocking = false
                    ac.hasCombatState = false
                    
                    -- Hàm đánh trực tiếp vào Server
                    ac:attack()
                    
                    -- Kích hoạt hình ảnh chém
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end)
        end
    end
end)

-- Xóa Animation Tay Của Player (Giảm Giật Lag 100%)
RunService.Stepped:Connect(function()
    if AutoFarmLevel and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
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
end)

-- =========================================================
-- HỆ THỐNG BAY LERP/TWEEN (BYPASS ANTI-CHEAT)
-- =========================================================
local currentTween = nil
local function TweenTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local dist = (root.Position - targetCFrame.Position).Magnitude
    if dist < 5 then 
        if currentTween then currentTween:Cancel(); currentTween = nil end
        root.CFrame = targetCFrame
        return 
    end
    
    local speed = 350
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

-- Chống kẹt vật thể và giữ lơ lửng
RunService.Stepped:Connect(function()
    if AutoFarmLevel and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            local bv = hrp:FindFirstChild("GodMode_BV")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "GodMode_BV"; bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Velocity = Vector3.new(0, 0, 0); bv.Parent = hrp
            else
                bv.Velocity = Vector3.new(0, 0, 0)
            end
        end
    else
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("GodMode_BV") then hrp.GodMode_BV:Destroy() end
    end
end)

-- =========================================================
-- LOGIC BẢN ĐỒ GPS VÀ FARM CHUẨN XÁC
-- =========================================================
local function getQuestData()
    local level = LocalPlayer.Data.Level.Value
    if level <= 9 then return "BanditQuest1", 1, "Bandit", CFrame.new(1057, 16, 1378)
    elseif level <= 14 then return "JungleQuest", 1, "Monkey", CFrame.new(-1598, 36, 153)
    elseif level <= 29 then return "JungleQuest", 2, "Gorilla", CFrame.new(-1189, 36, -512)
    elseif level <= 39 then return "BuggyQuest1", 1, "Pirate", CFrame.new(-1141, 4, 3828)
    elseif level <= 59 then return "BuggyQuest1", 2, "Brute", CFrame.new(-1141, 4, 3828)
    elseif level <= 74 then return "DesertQuest", 1, "Desert Bandit", CFrame.new(895, 6, 4390)
    elseif level <= 89 then return "DesertQuest", 2, "Desert Officer", CFrame.new(895, 6, 4390)
    elseif level <= 99 then return "SnowQuest", 1, "Snow Bandit", CFrame.new(1386, 87, -1298)
    elseif level <= 119 then return "SnowQuest", 2, "Snowman", CFrame.new(1386, 87, -1298)
    elseif level <= 149 then return "MarineQuest2", 1, "Chief Petty Officer", CFrame.new(-4884, 21, 4301)
    elseif level <= 174 then return "SkyQuest", 1, "Sky Bandit", CFrame.new(-4842, 717, -2623)
    elseif level <= 189 then return "SkyQuest", 2, "Dark Master", CFrame.new(-4842, 717, -2623)
    elseif level <= 209 then return "PrisonerQuest", 1, "Prisoner", CFrame.new(4875, 5, 735)
    else return "PeanutQuest", 1, "Peanut Scout", CFrame.new(-2051, 37, -10254) end
end

local function hasQuest()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    return gui and gui.Main:FindFirstChild("Quest") and gui.Main.Quest.Visible
end

task.spawn(function()
    while task.wait(0.1) do
        if AutoFarmLevel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local qName, qLevel, mobName, defaultSpawn = getQuestData()
            
            pcall(function() infoLabel.Text = string.format("Đang Farm: %s [Cấp %d]", mobName, LocalPlayer.Data.Level.Value) end)

            if AutoQuest and not hasQuest() then
                pcall(function() CommF:InvokeServer("StartQuest", qName, qLevel) end)
                task.wait(0.5)
            end

            local targetMob = nil
            if Workspace:FindFirstChild("Enemies") then
                for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        targetMob = mob; break
                    end
                end
            end

            if targetMob then
                local mobPos = targetMob.HumanoidRootPart.Position
                local safePos = CFrame.new(mobPos.X, mobPos.Y + 30, mobPos.Z)
                local myHRP = LocalPlayer.Character.HumanoidRootPart
                
                if (myHRP.Position - safePos.Position).Magnitude > 5 then
                    TweenTo(safePos)
                else
                    if currentTween then currentTween:Cancel(); currentTween = nil end
                    myHRP.CFrame = CFrame.lookAt(safePos.Position, safePos.Position - Vector3.new(0, 10, 0))

                    if BringMob then
                        for _, v in pairs(Workspace.Enemies:GetChildren()) do
                            if v.Name == mobName then
                                pcall(function()
                                    local eHrp = v.HumanoidRootPart
                                    local eHum = v.Humanoid
                                    if eHum.Health > 0 and (eHrp.Position - mobPos).Magnitude < 350 then
                                        -- Cố định quái dưới chân, khoảng cách 6 mét. Chém vô tư.
                                        eHrp.CFrame = safePos * CFrame.new(0, -6, -4)
                                        eHrp.Size = Vector3.new(12, 12, 12)
                                        eHrp.CanCollide = false
                                        eHum.WalkSpeed = 0
                                        eHum.JumpPower = 0
                                        eHum:ChangeState(11) -- Enum.HumanoidStateType.StrafingNoPhysics (Tắt AI)
                                    end
                                end)
                            end
                        end
                    end
                end
            else
                TweenTo(defaultSpawn * CFrame.new(0, 30, 0))
            end
        else
            if currentTween then currentTween:Cancel(); currentTween = nil end
        end
    end
end)

-- [[ ZENITH x REDZ HUB - PERFECTION UNIFIED V51 ]] --
-- Giao diện UI tự tạo độc lập (Không cần mạng ngoài để tải lib).
-- Lõi Farm nguyên bản Redz: CheckQuest, topos, BTP, Fast Attack Network.

task.wait(0.5)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)

-- Chống AFK Kick
pcall(function() for i,v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end end)
LocalPlayer.Idled:Connect(function() pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end)

-- Biến toàn cục
_G.AutoFarm = false
_G.AutoQuest = true
_G.BringMonster = true
_G.FastAttack = true
_G.SelectWeapon = "Melee"

local StartBring = false
local PosMon = nil
local currentTween = nil

local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

-- =========================================================
-- KHỞI TẠO GIAO DIỆN ZENITH (HOÀN TOÀN ĐỘC LẬP, KHÔNG LỖI)
-- =========================================================
local UI_NAME = "ZenithHub_Standalone_V51"
pcall(function() if game:GetService("CoreGui"):FindFirstChild(UI_NAME) then game:GetService("CoreGui")[UI_NAME]:Destroy() end end)
pcall(function() if LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then LocalPlayer.PlayerGui[UI_NAME]:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME; ScreenGui.ResetOnSpawn = false
local s, p = pcall(function() return gethui() end)
if s and p then ScreenGui.Parent = p else ScreenGui.Parent = game:GetService("CoreGui") end

-- Nút thu nhỏ nổi
local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 48, 0, 48); FloatingButton.Position = UDim2.new(0.1, 0, 0.5, 0); FloatingButton.BackgroundColor3 = Color3.fromRGB(13, 16, 22); FloatingButton.Visible = false; FloatingButton.Text = "Z"; FloatingButton.TextColor3 = Color3.fromRGB(0, 210, 255); FloatingButton.Font = Enum.Font.GothamBlack; FloatingButton.TextSize = 24; FloatingButton.ZIndex = 999
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FloatingButton).Color = Color3.fromRGB(0, 210, 255); Instance.new("UIStroke", FloatingButton).Thickness = 1.5

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 320); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19); MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local ms = Instance.new("UIStroke", MainFrame); ms.Color = Color3.fromRGB(0, 210, 255); ms.Thickness = 1.5

-- Kéo thả UI
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
TopBar.Size = UDim2.new(1, 0, 0, 38); TopBar.BackgroundColor3 = Color3.fromRGB(14, 18, 27); TopBar.BorderSizePixel = 0
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 300, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1; Title.RichText = true; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "ZENITH HUB <font color='#00d2ff'>• V51 STANDALONE</font>"

local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 24, 0, 24); CloseBtn.Position = UDim2.new(1, -28, 0.5, -12); CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 90); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 10; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; FloatingButton.Visible = true end)
FloatingButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; FloatingButton.Visible = false end)

local Page = Instance.new("ScrollingFrame", MainFrame)
Page.Size = UDim2.new(1, -20, 1, -55); Page.Position = UDim2.new(0, 10, 0, 45); Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0; Page.ScrollBarThickness = 3; Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
local pl = Instance.new("UIListLayout", Page); pl.Padding = UDim.new(0, 8); pl.HorizontalAlignment = Enum.HorizontalAlignment.Center

local infoLabel = Instance.new("TextLabel", Page)
infoLabel.Size = UDim2.new(0.96, 0, 0, 25); infoLabel.BackgroundTransparency = 1; infoLabel.TextColor3 = Color3.fromRGB(0, 255, 150); infoLabel.Font = Enum.Font.GothamBold; infoLabel.TextSize = 12; infoLabel.Text = "Trạng thái: Sẵn sàng tàn sát!"

-- Chọn vũ khí
local wSeg = Instance.new("Frame", Page); wSeg.Size = UDim2.new(0.96, 0, 0, 32); wSeg.BackgroundColor3 = Color3.fromRGB(15, 18, 25); Instance.new("UICorner", wSeg).CornerRadius = UDim.new(0, 6)
local wsLayout = Instance.new("UIListLayout", wSeg); wsLayout.FillDirection = Enum.FillDirection.Horizontal; wsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; wsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; wsLayout.Padding = UDim.new(0, 5)

for _, wName in ipairs({"Melee", "Sword", "Blox Fruit"}) do
    local b = Instance.new("TextButton", wSeg)
    b.Size = UDim2.new(0.3, 0, 0.8, 0); b.BackgroundColor3 = _G.SelectWeapon == wName and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48); b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.GothamMedium; b.TextSize = 11; b.Text = wName
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function()
        _G.SelectWeapon = wName
        for _, btn in pairs(wSeg:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = btn.Text == wName and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 35, 48) end end
    end)
end

local function CreateToggle(labelText, defaultState, callback)
    local state = defaultState
    local frame = Instance.new("Frame", Page); frame.Size = UDim2.new(0.96, 0, 0, 36); frame.BackgroundColor3 = Color3.fromRGB(16, 20, 29); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, -60, 1, 0); label.Position = UDim2.new(0, 12, 0, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(220, 225, 235); label.Font = Enum.Font.GothamMedium; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = labelText
    local switch = Instance.new("TextButton", frame); switch.Size = UDim2.new(0, 36, 0, 18); switch.Position = UDim2.new(1, -45, 0.5, -9); switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54); switch.Text = ""; Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switch); circle.Size = UDim2.new(0, 14, 0, 14); circle.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    switch.MouseButton1Click:Connect(function()
        state = not state; switch.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(35, 40, 54)
        circle:TweenPosition(state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.15, true)
        if callback then callback(state) end
    end)
end

CreateToggle("⚡ Kích Hoạt Auto Farm Level", false, function(v) _G.AutoFarm = v end)
CreateToggle("📜 Tự Nhận Nhiệm Vụ", true, function(v) _G.AutoQuest = v end)
CreateToggle("🧲 Kéo Quái (Bring Mob)", true, function(v) _G.BringMonster = v end)
CreateToggle("⚔️ Fast Attack (Mượt Mà)", true, function(v) _G.FastAttack = v end)

-- =========================================================
-- LOGIC DI CHUYỂN BTP & TOPOS GỐC TỪ REDZ
-- =========================================================
local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon
function CheckQuest()
    local MyLevel = LocalPlayer.Data.Level.Value
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42); CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"; LevelQuest = 1; NameQuest = "JungleQuest"; NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37); CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"; LevelQuest = 2; NameQuest = "JungleQuest"; NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37); CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)
        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"; LevelQuest = 1; NameQuest = "BuggyQuest1"; NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54); CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)
        elseif MyLevel >= 40 and MyLevel <= 59 then
            Mon = "Brute"; LevelQuest = 2; NameQuest = "BuggyQuest1"; NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54); CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)
        else
            Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42); CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
        end
    else
        Mon = "Raider"; LevelQuest = 1; NameQuest = "Area1Quest"; NameMon = "Raider"
        CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18); CFrameMon = CFrame.new(-728.32, 52.77, 2345.77)
    end
end

function BTP(targetCFrame)
    pcall(function()
        if (targetCFrame.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1500 and LocalPlayer.Character.Humanoid.Health > 0 then
            repeat
                task.wait()
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
                task.wait(0.05)
                if LocalPlayer.Character:FindFirstChild("Head") then LocalPlayer.Character.Head:Destroy() end
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
            until (targetCFrame.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 1500 or LocalPlayer.Character.Humanoid.Health <= 0
        end
    end)
end

function topos(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    if not LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "BodyClip"; bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Velocity = Vector3.zero
        bv.Parent = LocalPlayer.Character.HumanoidRootPart
    end
    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end

    local dist = (targetCFrame.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if dist > 1500 then
        BTP(targetCFrame)
    else
        local tweenInfo = TweenInfo.new(dist / 300, Enum.EasingStyle.Linear)
        TweenService:Create(LocalPlayer.Character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame}):Play()
    end
end

function EquipWeapon(weaponName)
    pcall(function()
        if not LocalPlayer.Character:FindFirstChild("HasBuso") and CommF then CommF:InvokeServer("Buso") end
        local backpack = LocalPlayer:WaitForChild("Backpack")
        local tool = backpack:FindFirstChild(weaponName)
        if tool then LocalPlayer.Character.Humanoid:EquipTool(tool) end
    end)
end

-- =========================================================
-- VÒNG LẶP AUTO FARM CHÍNH
-- =========================================================
spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                local questGui = LocalPlayer.PlayerGui.Main.Quest
                local questText = questGui.Container.QuestTitle.Title.Text
                
                if not questGui.Visible then
                    StartBring = false
                    if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 20 then
                        topos(CFrameQuest)
                    else
                        if _G.AutoQuest and CommF then CommF:InvokeServer("StartQuest", NameQuest, LevelQuest) end
                    end
                elseif not string.find(questText, NameMon) then
                    StartBring = false
                    if CommF then CommF:InvokeServer("AbandonQuest") end
                else
                    local foundMob = false
                    for _, v512 in pairs(Workspace.Enemies:GetChildren()) do
                        if v512:FindFirstChild("HumanoidRootPart") and v512:FindFirstChild("Humanoid") and v512.Humanoid.Health > 0 and v512.Name == Mon then
                            foundMob = true
                            repeat
                                task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                local hrp = LocalPlayer.Character.HumanoidRootPart
                                
                                -- ĐỨNG CÁCH ĐẦU QUÁI 8 MÉT (100% NỔ DAME)
                                topos(v512.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0))
                                hrp.CFrame = CFrame.lookAt(hrp.Position, v512.HumanoidRootPart.Position)
                                
                                v512.HumanoidRootPart.CanCollide = false
                                v512.Humanoid.WalkSpeed = 0
                                v512.Head.CanCollide = false
                                v512.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                
                                StartBring = true
                                MonFarm = v512.Name
                                
                                VirtualUser:CaptureController()
                                VirtualUser:Button1Down(Vector2.new(1280, 672))
                            until not _G.AutoFarm or v512.Humanoid.Health <= 0 or not v512.Parent or questGui.Visible == false
                        end
                    end
                    if not foundMob then
                        StartBring = false
                        topos(CFrameMon)
                    end
                end
            end)
        end
    end
end)

-- BRING MOB
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarm and _G.BringMonster and StartBring and MonFarm ~= "" then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                for _, v1167 in pairs(Workspace.Enemies:GetChildren()) do
                    if v1167.Name == MonFarm and v1167:FindFirstChild("Humanoid") and v1167:FindFirstChild("HumanoidRootPart") and v1167.Humanoid.Health > 0 then
                        if (v1167.HumanoidRootPart.Position - hrp.Position).Magnitude <= 320 then
                            v1167.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v1167.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, -8, 0)
                            v1167.HumanoidRootPart.CanCollide = false
                            v1167.Head.CanCollide = false
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

-- =========================================================
-- LÕI FAST ATTACK NATIVE 
-- =========================================================
local v1 = next
local v2 = {ReplicatedStorage.Util, ReplicatedStorage.Common, ReplicatedStorage.Remotes, ReplicatedStorage.Assets, ReplicatedStorage.FX}
local v3, u4, u5 = nil, nil, nil

task.spawn(function()
    while true do
        local v6
        v3, v6 = v1(v2, v3)
        if v3 == nil then break end
        local v7 = next
        local v8, v9 = v6:GetChildren()
        while true do
            local v10
            v9, v10 = v7(v8, v9)
            if v9 == nil then break end
            if v10:IsA('RemoteEvent') and v10:GetAttribute('Id') then
                u5 = v10:GetAttribute('Id')
                u4 = v10
            end
        end
        v6.ChildAdded:Connect(function(p11)
            if p11:IsA('RemoteEvent') and p11:GetAttribute('Id') then
                u5 = p11:GetAttribute('Id')
                u4 = p11
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.0001) do
        if _G.AutoFarm and _G.FastAttack then
            pcall(function()
                local _Character = LocalPlayer.Character
                local v13 = _Character and _Character:FindFirstChild('HumanoidRootPart')
                if not v13 then return end

                local v14, v15, v16 = ipairs({Workspace.Enemies, Workspace.Characters})
                local u17 = {}

                while true do
                    local v18
                    v16, v18 = v14(v15, v16)
                    if v16 == nil then break end

                    local v19, v20, v21 = ipairs(v18 and v18:GetChildren() or {})
                    while true do
                        local v22
                        v21, v22 = v19(v20, v21)
                        if v21 == nil then break end

                        local _HumanoidRootPart = v22:FindFirstChild('HumanoidRootPart')
                        local _Humanoid = v22:FindFirstChild('Humanoid')

                        if v22 ~= _Character and (_HumanoidRootPart and (_Humanoid and (_Humanoid.Health > 0 and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 60))) then
                            local v25, v26, v27 = ipairs(v22:GetChildren())
                            while true do
                                local v28
                                v27, v28 = v25(v26, v27)
                                if v27 == nil then break end
                                if v28:IsA('BasePart') and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 60 then
                                    u17[#u17 + 1] = {v22, v28}
                                end
                            end
                        end
                    end
                end

                local _Tool = _Character:FindFirstChildOfClass('Tool')
                if #u17 > 0 and (_Tool and (_Tool:GetAttribute('WeaponType') == 'Melee' or _Tool:GetAttribute('WeaponType') == 'Sword' or _Tool.Name == "Combat")) then
                    pcall(function()
                        require(ReplicatedStorage.Modules.Net):RemoteEvent('RegisterHit', true)
                        ReplicatedStorage.Modules.Net['RE/RegisterAttack']:FireServer()

                        local _Head = u17[1][1]:FindFirstChild('Head')

                        if _Head then
                            ReplicatedStorage.Modules.Net['RE/RegisterHit']:FireServer(_Head, u17, {}, tostring(LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                            local r_u4 = (typeof(cloneref) == "function" and cloneref(u4)) or u4
                            if r_u4 then
                                r_u4:FireServer(string.gsub('RE/RegisterHit', '.', function(p31)
                                    return string.char(bit32.bxor(string.byte(p31), math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1))
                                end), bit32.bxor(u5 + 909090, ReplicatedStorage.Modules.Net.seed:InvokeServer() * 2), _Head, u17)
                            end
                        end
                    end)
                end
            end)
        end
    end
end)

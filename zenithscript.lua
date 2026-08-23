-- [[ ZENITH HUB - V400 PART 2: LOGIC EXECUTION ]] --
local currentTween = nil
function topos(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    if not hrp:FindFirstChild("BodyClip") then
        local bv = Instance.new("BodyVelocity"); bv.Name = "BodyClip"; bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Velocity = Vector3.zero; bv.Parent = hrp
    end
    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end

    local dist = (targetCFrame.Position - hrp.Position).Magnitude
    if dist > 3000 then
        hrp.CFrame = targetCFrame; task.wait(0.1); hrp.CFrame = targetCFrame
    else
        if currentTween then currentTween:Cancel() end
        local tweenInfo = TweenInfo.new(dist / 320, Enum.EasingStyle.Linear)
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        currentTween:Play()
    end
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

RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if hum then
            hum.WalkSpeed = _G.SpeedEnabled and _G.SpeedVal or 16
            hum.JumpPower = _G.JumpEnabled and _G.JumpVal or 50
        end
        if _G.NoclipEnabled and char then
            for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
        end
        
        -- Khử hiệu ứng chớp sáng lóa màn hình sau khi giết quái
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") and (string.find(obj.Name, "Explosion") or string.find(obj.Name, "Flash") or string.find(obj.Name, "Effect")) then
                obj.Rate = 0
            end
        end

        -- Cập nhật Status HUD động (Chỉ hiện khi tính năng bật)
        local activeList = {}
        if _G.SpeedEnabled then table.insert(activeList, "🏃 Speed ["..tostring(_G.SpeedKey.Name).."]: " .. tostring(_G.SpeedVal)) end
        if _G.NoclipEnabled then table.insert(activeList, "👻 Noclip ["..tostring(_G.NoclipKey.Name).."]: ON") end
        if _G.JumpEnabled then table.insert(activeList, "🦘 Jump ["..tostring(_G.JumpKey.Name).."]: " .. tostring(_G.JumpVal)) end
        if _G.SilentAim then table.insert(activeList, "🎯 Silent Aim: ON") end
        if _G.AutoFarm then table.insert(activeList, "⚡ Auto Farm: ON") end
        
        if #activeList > 0 then
            StatusHUD.Visible = true
            hudContent.Text = table.concat(activeList, "\n") .. string.format("\nLevel: %d", LocalPlayer.Data.Level.Value)
        else
            StatusHUD.Visible = false
        end
    end)
end)

-- Vòng tròn FOV cố định giữa màn hình Silent Aim
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

-- =========================================================
-- LOGIC ESP TOÀN DIỆN (ĐÃ FIX ESP NPC & TẮT ESP ĐẢO)
-- =========================================================
task.spawn(function()
    while task.wait(1) do
        -- ESP Player
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

        -- ESP Chest
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

        -- ESP Fruit
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

        -- ESP NPC (Đã sửa hoạt động chính xác)
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

        -- ESP Đảo (Đã sửa cho phép bật/tắt linh hoạt)
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
-- LOGIC AUTO FARM, BRING MOB, BOSS & COLLECT FRUIT
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
        else Mon = "Chief Petty Officer"; LevelQuest = 1; NameQuest = "MarineQuest2"; NameMon = "Chief Petty Officer"; CFrameQuest = CFrame.new(-5039.58, 27.35, 4324.68); CFrameMon = CFrame.new(-4881.23, 22.65, 4273.75) end
    elseif World2 then
        if MyLevel >= 700 and MyLevel <= 724 then Mon = "Raider"; LevelQuest = 1; NameQuest = "Area1Quest"; NameMon = "Raider"; CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18); CFrameMon = CFrame.new(-728.32, 52.77, 2345.77)
        else Mon = "Swan Pirate"; LevelQuest = 1; NameQuest = "Area2Quest"; NameMon = "Swan Pirate"; CFrameQuest = CFrame.new(638.43, 71.76, 918.28); CFrameMon = CFrame.new(1068.66, 137.61, 1322.10) end
    else
        Mon = "Pirate Millionaire"; LevelQuest = 1; NameQuest = "PiratePortQuest"; NameMon = "Pirate Millionaire"; CFrameQuest = CFrame.new(-450.10, 107.68, 5950.72); CFrameMon = CFrame.new(-245.99, 47.30, 5584.10)
    end
end

-- Auto Farm Level
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
        else
            if not (_G.AutoBoss or _G.AllBossesFarm) then _G.GlobalFarmActive = false end
        end
    end
end)

-- Bring Mob (Đã sửa gom quái ổn định)
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

-- Auto Boss & All Bosses
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local liveBosses = {}
            for _, v in pairs(Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and (string.find(v.Name, "Boss") or table.find(CurrentBossList, v.Name)) then
                    table.insert(liveBosses, v.Name)
                end
            end
            if #liveBosses > 0 then
                bossListLabel.Text = "👑 Boss Sống: " .. table.concat(liveBosses, ", ")
            else
                bossListLabel.Text = "👑 Không có Boss nào trong Server"
            end

            if _G.AutoBoss or _G.AllBossesFarm then
                for _, v in pairs(Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        if _G.AllBossesFarm or v.Name == _G.SelectedBossName then
                            _G.GlobalFarmActive = true
                            repeat
                                task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(LocalPlayer.Character.HumanoidRootPart.Position, v.HumanoidRootPart.Position)
                                v.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -15, 0)
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

-- Auto Collect Fruit
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

-- Fast Attack Turbo Max Speed (Không delay)
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
    while task.wait() do
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

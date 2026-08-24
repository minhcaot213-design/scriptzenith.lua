-- ===== PHẦN 2: LOGIC (SỬA GOM QUÁI DƯỚI ĐẤT) =====
-- Sử dụng toàn bộ biến và UI đã tạo ở phần 1

-- Hàm gom quái (giữ độ cao Y của quái, chỉ kéo X và Z về người chơi)
local bodyPositions = {}
local function pullMonsterToGround(monster, targetPos)
    if not monster or not monster:FindFirstChild("HumanoidRootPart") then return end
    local root = monster.HumanoidRootPart
    local currentY = root.Position.Y
    local finalPos = Vector3.new(targetPos.X, currentY, targetPos.Z)
    local bp = root:FindFirstChild("BodyPosition")
    if not bp then
        bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bp.D = 2000
        bp.P = 20000
        bp.Parent = root
        table.insert(bodyPositions, bp)
    end
    bp.Position = finalPos
    root.CanCollide = false
    if monster:FindFirstChild("Head") then monster.Head.CanCollide = false end
    local hum = monster:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = 0
        hum.JumpPower = 0
        if hum:FindFirstChild("Animator") then hum.Animator:Destroy() end
        hum:ChangeState(11)
    end
    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
end

local function cleanupBodyPositions()
    for _, bp in ipairs(bodyPositions) do
        if bp and bp.Parent then bp:Destroy() end
    end
    bodyPositions = {}
end

-- Các hàm CheckQuest, getQuestMonsterName, isQuestCompleted, completeQuest giữ nguyên (không đổi)

-- Vòng lặp Auto Farm chính (đã sửa gom quái)
spawn(function()
    while task.wait() do
        if _G.AutoFarm or _G.AutoItemFarm then
            pcall(function()
                CheckQuest()
                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                if not questGui or not questGui.Visible then
                    StartBring = false
                    _G.GlobalFarmActive = false
                    cleanupBodyPositions()
                    if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 20 then topos(CFrameQuest)
                    else if _G.AutoQuest and CommF then CommF:InvokeServer("StartQuest", NameQuest, LevelQuest) end end
                else
                    local questCompleted = isQuestCompleted()
                    if questCompleted then
                        if CommF then completeQuest() end
                        task.wait(0.5)
                        if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 20 then topos(CFrameQuest)
                        else if _G.AutoQuest and CommF then CommF:InvokeServer("StartQuest", NameQuest, LevelQuest) end end
                        StartBring = false
                        _G.GlobalFarmActive = false
                        cleanupBodyPositions()
                    else
                        local questMonster = getQuestMonsterName()
                        local monsterName = questMonster or NameMon
                        local foundMob = false
                        local enemies = Workspace:FindFirstChild("Enemies") or Workspace
                        for _, v512 in pairs(enemies:GetChildren()) do
                            if v512:FindFirstChild("HumanoidRootPart") and v512:FindFirstChild("Humanoid") and v512.Humanoid.Health > 0 and v512.Name:lower() == monsterName:lower() then
                                foundMob = true
                                local targetPos = v512.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                                if (LocalPlayer.Character.HumanoidRootPart.Position - targetPos.Position).Magnitude > 10 then
                                    topos(targetPos)
                                end
                                StartBring = true
                                _G.GlobalFarmActive = true
                                repeat
                                    task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    local hrp = LocalPlayer.Character.HumanoidRootPart
                                    hrp.CFrame = CFrame.lookAt(hrp.Position, v512.HumanoidRootPart.Position)
                                    if _G.BringMonster then
                                        local pullPos = Vector3.new(hrp.Position.X, v512.HumanoidRootPart.Position.Y, hrp.Position.Z) + Vector3.new(0, 0, 5)
                                        pullMonsterToGround(v512, pullPos)
                                    end
                                    VirtualUser:CaptureController()
                                    VirtualUser:Button1Down(Vector2.new(1280, 672))
                                until not (_G.AutoFarm or _G.AutoItemFarm) or v512.Humanoid.Health <= 0 or not v512.Parent or not questGui.Visible
                                StartBring = false
                                cleanupBodyPositions()
                            end
                        end
                        if not foundMob then
                            StartBring = false
                            _G.GlobalFarmActive = false
                            cleanupBodyPositions()
                            if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameMon.Position).Magnitude > 15 then
                                topos(CFrameMon)
                            end
                        end
                    end
                end
            end)
        else
            if not (_G.AutoBoss or _G.AllBossesFarm) then
                _G.GlobalFarmActive = false
                cleanupBodyPositions()
            end
        end
    end
end)

-- Các vòng lặp khác (Auto Click, Boss, Bone, Takakuri, SeaBeast, GhostShip) đều được sửa tương tự: dùng pullMonsterToGround thay vì kéo lên trời.

-- VÍ DỤ CHO BOSS:
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local enemies = Workspace:FindFirstChild("Enemies") or Workspace
            if _G.AutoBoss or _G.AllBossesFarm then
                for _, v in pairs(enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        if _G.AllBossesFarm or v.Name == _G.SelectedBossName then
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
                                if _G.BringMonster then
                                    local pullPos = Vector3.new(hrp.Position.X, v.HumanoidRootPart.Position.Y, hrp.Position.Z) + Vector3.new(0, 0, 5)
                                    pullMonsterToGround(v, pullPos)
                                end
                                VirtualUser:CaptureController()
                                VirtualUser:Button1Down(Vector2.new(1280, 672))
                            until not (_G.AutoBoss or _G.AllBossesFarm) or v.Humanoid.Health <= 0 or not v.Parent
                            cleanupBodyPositions()
                        end
                    end
                end
            end
        end)
    end
end)

-- (Tương tự cho các vòng lặp khác, chỉ thay pullMonsterToGround)

-- Các phần còn lại (Fast Attack, Auto Stats, v.v.) giữ nguyên.

print("LOGIC ĐÃ SẴN SÀNG, GOM QUÁI DƯỚI ĐẤT!")

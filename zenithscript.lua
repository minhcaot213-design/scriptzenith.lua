-- ===================================================
-- 6. COMBAT ENGINE & FARM TWEEN (RE-ENGINEERED)
-- ===================================================
local currentTween = nil
local isAttackingTarget = false
local Camera = Workspace.CurrentCamera

local function executeDirectSlash()
    local char = LocalPlayer.Character
    if not char then return end

    -- 1. Kích hoạt trực tiếp Tool an toàn
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then 
        tool:Activate() 
    end

    -- 2. Hook Combat Controller
    pcall(function()
        local cf = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework", 1))
        if cf and cf.activeController then
            cf.activeController.hitboxLimiter = 0
            cf.activeController.timeToNextAttack = 0
            cf.activeController.attacking = false
            cf.activeController.increment = 3
            cf.activeController:attack()
        end
    end)

    -- 3. Click chuột vào trung tâm màn hình (Không dùng task.wait để tránh khựng loop)
    pcall(function()
        local midX, midY = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(midX, midY))
        
        VirtualInputManager:SendMouseButtonEvent(midX, midY, 0, true, game, 1)
        VirtualInputManager:SendMouseButtonEvent(midX, midY, 0, false, game, 1)
    end)
    
    -- Hỗ trợ thêm cho một số Executor có sẵn hàm click
    if mouse1click then pcall(mouse1click) end
end

-- Vòng lặp ra đòn (Tối ưu tốc độ để server nhận 100% damage)
task.spawn(function()
    while true do
        if AutoFarmLevel and isAttackingTarget then
            executeDirectSlash()
            task.wait(0.125) -- Khoảng delay lý tưởng (~8 hit/giây) tránh cơ chế anti-spam của Blox Fruits
        else
            task.wait(0.1)
        end
    end
end)

local function toTargetPos(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    local distance = (root.Position - targetCFrame.Position).Magnitude
    local speed = 260
    local time = distance / speed

    if currentTween then currentTween:Cancel() end
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
end

RunService.Stepped:Connect(function()
    if (AutoFarmLevel or AutoCollectFruit) and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

local function equipChosenWeapon()
    local char = LocalPlayer.Character
    if not char then return nil end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            if item.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (item.ToolTip == "Melee" or item.ToolTip == "Combat" or item.Name == "Combat" or item.Name == "Võ Tân Binh")) then
                return item
            end
        end
    end

    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if tool.ToolTip == selectedWeaponType or (selectedWeaponType == "Melee" and (tool.ToolTip == "Melee" or tool.ToolTip == "Combat" or tool.Name == "Combat" or tool.Name == "Võ Tân Binh")) then
                    humanoid:EquipTool(tool)
                    return tool
                end
            end
        end
    end
    return nil
end

local function checkHasQuest()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui and playerGui:FindFirstChild("Main") then
        local questFrame = playerGui.Main:FindFirstChild("Quest")
        if questFrame and questFrame.Visible then return true end
    end
    return false
end

local function getAllLivingEnemies(monName)
    local list = {}
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return list end

    for _, mob in ipairs(enemies:GetChildren()) do
        if string.find(mob.Name, monName) then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                table.insert(list, mob)
            end
        end
    end
    return list
end

-- VÒNG LẶP CHÍNH: KHÓA MỤC TIÊU VÀ TỰ ĐỘNG TẤN CÔNG
task.spawn(function()
    while true do
        task.wait(0.05)
        if AutoFarmLevel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local currentQuest = getAutoQuestByLevel()
            if currentQuest then
                if AutoQuest and not checkHasQuest() then
                    CommF:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.QuestLevel)
                    task.wait(0.3)
                end

                local mobList = getAllLivingEnemies(currentQuest.MonName)
                if #mobList > 0 then
                    equipChosenWeapon()
                    local primaryMob = mobList[1]
                    local primaryHRP = primaryMob:FindFirstChild("HumanoidRootPart")
                    local myHRP = LocalPlayer.Character.HumanoidRootPart

                    if primaryHRP then
                        local clusterPosition = primaryHRP.Position
                        local targetCFrame = CFrame.new(clusterPosition + Vector3.new(0, 1.5, 2.5), clusterPosition)
                        local dist = (myHRP.Position - clusterPosition).Magnitude

                        if dist > 12 then
                            isAttackingTarget = false
                            toTargetPos(targetCFrame)
                        else
                            if currentTween then currentTween:Cancel() end
                            
                            -- [ĐÃ FIX]: Tránh ghi đè CFrame liên tục khiến nhân vật bị khựng đòn đánh
                            if (myHRP.Position - targetCFrame.Position).Magnitude > 3.5 then
                                myHRP.CFrame = targetCFrame
                                myHRP.AssemblyLinearVelocity = Vector3.zero
                            end
                            
                            isAttackingTarget = true

                            if BringMob then
                                for _, otherMob in ipairs(mobList) do
                                    local oHRP = otherMob:FindFirstChild("HumanoidRootPart")
                                    local oHum = otherMob:FindFirstChildOfClass("Humanoid")
                                    if oHRP and oHum and oHum.Health > 0 then
                                        local d = (oHRP.Position - clusterPosition).Magnitude
                                        if d <= 320 then
                                            oHRP.CFrame = CFrame.new(clusterPosition)
                                            oHRP.AssemblyLinearVelocity = Vector3.zero
                                            oHRP.CanCollide = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    isAttackingTarget = false
                end
            end
        else
            isAttackingTarget = false
            if currentTween then currentTween:Cancel() end
        end
    end
end)

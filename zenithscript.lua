-- ===================================================
-- 8. AUTO FARM + FLY (FIX - ĐỨNG IM GÂY SÁT THƯƠNG + FLY CAO + SLIDER TỐC ĐỘ ĐÁNH)
-- ===================================================
local flightHeight = 35  -- Bay cao hơn, trên đầu quái
local attackRadius = 30
local attackCooldown = 0.05  -- Mặc định
local attackCount = 8  -- Số đòn mỗi chu kỳ

-- THANH KÉO TỐC ĐỘ ĐÁNH (đặt trong tab Farm)
local attackSpeedFrame = Instance.new("Frame", farmPage)
attackSpeedFrame.Size = UDim2.new(0.94, 0, 0, 44)
attackSpeedFrame.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
attackSpeedFrame.AutomaticSize = Enum.AutomaticSize.None
Instance.new("UICorner", attackSpeedFrame).CornerRadius = UDim.new(0, 6)

local attackSpeedLabel = Instance.new("TextLabel", attackSpeedFrame)
attackSpeedLabel.Size = UDim2.new(1, -70, 0, 20)
attackSpeedLabel.Position = UDim2.new(0, 10, 0, 3)
attackSpeedLabel.BackgroundTransparency = 1
attackSpeedLabel.Text = "⚡ Tốc Độ Đánh (0.01 - 0.2s)"
attackSpeedLabel.TextColor3 = Color3.fromRGB(220, 225, 235)
attackSpeedLabel.Font = Enum.Font.Gotham
attackSpeedLabel.TextSize = 11
attackSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local attackSpeedValue = Instance.new("TextLabel", attackSpeedFrame)
attackSpeedValue.Size = UDim2.new(0, 55, 0, 20)
attackSpeedValue.Position = UDim2.new(1, -65, 0, 3)
attackSpeedValue.BackgroundTransparency = 1
attackSpeedValue.Text = "0.05s"
attackSpeedValue.TextColor3 = Color3.fromRGB(0, 210, 255)
attackSpeedValue.Font = Enum.Font.GothamBold
attackSpeedValue.TextSize = 11
attackSpeedValue.TextXAlignment = Enum.TextXAlignment.Right

local attackSpeedTrack = Instance.new("TextButton", attackSpeedFrame)
attackSpeedTrack.Size = UDim2.new(0.94, 0, 0, 4)
attackSpeedTrack.Position = UDim2.new(0.03, 0, 0, 28)
attackSpeedTrack.BackgroundColor3 = Color3.fromRGB(35, 42, 58)
attackSpeedTrack.AutoButtonColor = false
attackSpeedTrack.Text = ""
Instance.new("UICorner", attackSpeedTrack).CornerRadius = UDim.new(1, 0)

local attackSpeedFill = Instance.new("Frame", attackSpeedTrack)
attackSpeedFill.Size = UDim2.new(0.25, 0, 1, 0)  -- Mặc định 0.05s
attackSpeedFill.BackgroundColor3 = Color3.fromRGB(0, 190, 255)
Instance.new("UICorner", attackSpeedFill).CornerRadius = UDim.new(1, 0)

local isDraggingSpeedSlider = false
local function updateAttackSpeed(percent)
    -- percent 0 -> 0.2s, percent 1 -> 0.01s
    local cooldown = 0.2 - (percent * 0.19)
    cooldown = math.max(0.01, math.min(0.2, cooldown))
    attackCooldown = cooldown
    attackSpeedFill.Size = UDim2.new(percent, 0, 1, 0)
    attackSpeedValue.Text = string.format("%.3fs", cooldown)
end

attackSpeedTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingSpeedSlider = true
        local percent = (input.Position.X - attackSpeedTrack.AbsolutePosition.X) / attackSpeedTrack.AbsoluteSize.X
        updateAttackSpeed(math.clamp(percent, 0, 1))
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingSpeedSlider = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDraggingSpeedSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = UserInputService:GetMouseLocation()
        local percent = (mousePos.X - attackSpeedTrack.AbsolutePosition.X) / attackSpeedTrack.AbsoluteSize.X
        updateAttackSpeed(math.clamp(percent, 0, 1))
    end
end)

-- EQUIP VŨ KHÍ
local function equipChosenWeapon()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        
        local function findWeapon(type)
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local list = {}
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then table.insert(list, tool) end
                end
            end
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then table.insert(list, tool) end
                end
            end
            for _, tool in ipairs(list) do
                local name = string.lower(tool.Name)
                if type == "Melee" and (string.find(name, "melee") or string.find(name, "fist") or string.find(name, "combat") or string.find(name, "fighting") or string.find(name, "superhuman")) then
                    return tool
                elseif type == "Sword" and (string.find(name, "sword") or string.find(name, "blade") or string.find(name, "katana") or string.find(name, "cutlass") or string.find(name, "saber") or string.find(name, "dark")) then
                    return tool
                elseif type == "Blox Fruit" and (string.find(name, "fruit") or string.find(name, "devil") or string.find(name, "paw") or string.find(name, "buddha") or string.find(name, "light") or string.find(name, "dough") or string.find(name, "flame") or string.find(name, "ice")) then
                    return tool
                end
            end
            return list[1]
        end
        
        local weapon = findWeapon(selectedWeaponType)
        if weapon and weapon.Parent == LocalPlayer:FindFirstChild("Backpack") then
            CommF:InvokeServer("EquipTool", weapon)
            task.wait(0.05)
        end
    end)
end

-- LẤY DANH SÁCH QUÁI SỐNG
local function getAllLivingEnemies(monName)
    local list = {}
    local monLower = string.lower(monName)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local objName = string.lower(obj.Name)
                if string.find(objName, monLower) or string.find(objName, string.gsub(monLower, " ", "")) then
                    table.insert(list, obj)
                end
            end
        end
    end
    return list
end

-- GOM QUÁI VÀO DƯỚI CHÂN
local function pullMobs(mobList, myPos)
    local pullRadius = 120
    for _, mob in ipairs(mobList) do
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local dist = (hrp.Position - myPos).Magnitude
            if dist > attackRadius and dist < pullRadius then
                -- Kéo quái vào ngay dưới chân player
                local offset = Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                hrp.CFrame = CFrame.new(myPos + offset)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                hrp.CanCollide = false
                hum.WalkSpeed = 0
                hum.JumpPower = 0
                hum.Sit = true
                hum.PlatformStand = true
                local animator = hum:FindFirstChild("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop()
                    end
                end
                for _, part in ipairs(mob:GetDescendants()) do
                    if part:IsA("BasePart") and part ~= hrp then
                        part.CFrame = CFrame.new(myPos + offset + Vector3.new(0, math.random(-2, 2), 0))
                        part.AssemblyLinearVelocity = Vector3.zero
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end

-- SPAM ĐÒN (ĐỨNG IM GÂY SÁT THƯƠNG)
local function fastAttack()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        
        -- Activate tool
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
            task.wait(0.01)
            tool:Activate()
        end
        
        -- CombatFramework hack
        local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
        local controller = CbFw.activeController
        if not controller then
            for _, v in pairs(debug.getupvalues(CbFw)) do
                if type(v) == "table" and v.activeController then
                    controller = v.activeController
                    break
                end
            end
        end
        if controller then
            controller.hitboxLimiter = 0
            controller.timeToNextAttack = 0
            controller.timeToNextBlock = 0
            controller.increment = 15
            controller.attacking = false
            controller.blocking = false
            
            -- Spam 8-10 đòn mỗi lần
            local count = 8 + math.random(0, 3)
            for i = 1, count do
                controller:attack()
                task.wait(0.008)
            end
        end
    end)
end

-- BAY ĐẾN VỊ TRÍ (FLY CAO)
local function flyToPosition(targetPos)
    local char = LocalPlayer.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local target = Vector3.new(targetPos.X, flightHeight, targetPos.Z)
    local current = root.Position
    local dist = (target - current).Magnitude
    
    if dist < 3 then
        root.AssemblyLinearVelocity = Vector3.zero
        return true
    end
    
    local dir = (target - current).Unit
    local speed = 150  -- Bay nhanh
    root.AssemblyLinearVelocity = dir * speed
    
    -- Giữ độ cao chặt
    local yDiff = flightHeight - current.Y
    if math.abs(yDiff) > 1 then
        root.AssemblyLinearVelocity = Vector3.new(
            root.AssemblyLinearVelocity.X,
            yDiff * 5,
            root.AssemblyLinearVelocity.Z
        )
    end
    
    return false
end

-- LẤY NHIỆM VỤ THEO LEVEL
local function getAutoQuestByLevel()
    local level = LocalPlayer.Data and LocalPlayer.Data.Level and LocalPlayer.Data.Level.Value or 1
    local quests = {
        {MonName = "Bandit", QuestName = "BanditQuest1", QuestLevel = 1},
        {MonName = "Gorilla", QuestName = "GorillaQuest1", QuestLevel = 50},
        {MonName = "Dragon", QuestName = "DragonQuest1", QuestLevel = 120},
        {MonName = "Ice", QuestName = "IceQuest1", QuestLevel = 200},
        {MonName = "Dark", QuestName = "DarkQuest1", QuestLevel = 300},
        {MonName = "Light", QuestName = "LightQuest1", QuestLevel = 400},
        {MonName = "Dough", QuestName = "DoughQuest1", QuestLevel = 500},
        {MonName = "Flame", QuestName = "FlameQuest1", QuestLevel = 650},
        {MonName = "Venom", QuestName = "VenomQuest1", QuestLevel = 800},
    }
    for _, q in ipairs(quests) do
        if level >= q.QuestLevel then return q end
    end
    return quests[#quests]
end

local function checkHasQuest()
    return true
end

local function stopTween()
    if currentTween then
        pcall(function() currentTween:Cancel() end)
        currentTween = nil
    end
end

-- MAIN FARM THREAD (ĐỨNG IM GÂY SÁT THƯƠNG)
task.spawn(function()
    while true do
        task.wait(0.05)
        
        if not AutoFarmLevel then
            stopTween()
            task.wait(0.5)
            continue
        end
        
        local char = LocalPlayer.Character
        if not char then task.wait(0.5) continue end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(0.5) continue end
        
        -- Duy trì độ cao
        root.AssemblyLinearVelocity = Vector3.new(
            root.AssemblyLinearVelocity.X,
            math.max(root.AssemblyLinearVelocity.Y, -1),
            root.AssemblyLinearVelocity.Z
        )
        
        -- Lấy quest
        local questData = getAutoQuestByLevel()
        if not questData then
            infoLabel.Text = "⚠️ Không có nhiệm vụ phù hợp"
            task.wait(1)
            continue
        end
        
        -- Tự nhận quest
        if AutoQuest and not checkHasQuest() then
            pcall(function()
                CommF:InvokeServer("StartQuest", questData.QuestName, questData.QuestLevel)
            end)
            task.wait(0.3)
        end
        
        -- Tìm quái
        local mobs = getAllLivingEnemies(questData.MonName)
        if #mobs == 0 then
            infoLabel.Text = string.format("🔍 Đang tìm %s...", questData.MonName)
            task.wait(0.3)
            continue
        end
        
        -- Sắp xếp theo khoảng cách
        table.sort(mobs, function(a, b)
            local aPos = a:FindFirstChild("HumanoidRootPart")
            local bPos = b:FindFirstChild("HumanoidRootPart")
            if not aPos or not bPos then return false end
            return (aPos.Position - root.Position).Magnitude < (bPos.Position - root.Position).Magnitude
        end)
        
        local target = mobs[1]
        local targetHRP = target:FindFirstChild("HumanoidRootPart")
        if not targetHRP then task.wait(0.1) continue end
        
        local level = LocalPlayer.Data.Level.Value
        infoLabel.Text = string.format(
            "⚔️ %s | Lv.%d | Quái: %d | Tốc độ: %.3fs",
            questData.MonName,
            level,
            #mobs,
            attackCooldown
        )
        
        -- Gom quái
        if BringMob then
            pullMobs(mobs, root.Position)
        end
        
        -- Equip vũ khí
        equipChosenWeapon()
        
        -- BAY ĐẾN QUÁI (FLY CAO)
        local dist = (targetHRP.Position - root.Position).Magnitude
        if dist > attackRadius then
            local reached = flyToPosition(targetHRP.Position)
            stopTween()
            if not reached then
                task.wait(0.05)
                continue
            end
        end
        
        -- KHI ĐÃ ĐẾN GẦN → ĐỨNG IM, CHỈ ĐÁNH
        if dist <= attackRadius + 15 then
            -- KHÔNG DI CHUYỂN, CHỈ GIỮ ĐỘ CAO
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            
            -- Quay mặt về phía quái
            local lookVec = (targetHRP.Position - root.Position).Unit
            if lookVec.Magnitude > 0 then
                root.CFrame = CFrame.lookAt(root.Position, root.Position + lookVec * 10)
            end
            
            -- Giữ độ cao cố định
            local yDiff = flightHeight - root.Position.Y
            if math.abs(yDiff) > 1.5 then
                root.AssemblyLinearVelocity = Vector3.new(0, yDiff * 4, 0)
            end
            
            -- SPAM ĐÁNH (ĐỨNG IM)
            local attackCycles = math.max(1, math.floor(0.5 / (attackCooldown * 0.08)))
            for i = 1, attackCycles do
                fastAttack()
                task.wait(attackCooldown)
            end
            
            -- Activate tool thêm lần nữa
            local weapon = char:FindFirstChildOfClass("Tool")
            if weapon then
                weapon:Activate()
                task.wait(0.02)
                weapon:Activate()
            end
        end
        
        -- Thoát hiểm máu thấp
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < hum.MaxHealth * 0.2 then
            root.AssemblyLinearVelocity = Vector3.new(0, 60, 0)
            task.wait(0.5)
        end
        
        task.wait(0.02)
    end
end)

-- DUY TRÌ ĐỘ CAO LIÊN TỤC
task.spawn(function()
    while true do
        task.wait(0.08)
        if not AutoFarmLevel then task.wait(0.5) continue end
        
        local char = LocalPlayer.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        
        local y = root.Position.Y
        if y < flightHeight - 1.5 then
            root.AssemblyLinearVelocity = Vector3.new(
                root.AssemblyLinearVelocity.X,
                40,
                root.AssemblyLinearVelocity.Z
            )
        elseif y > flightHeight + 3 then
            root.AssemblyLinearVelocity = Vector3.new(
                root.AssemblyLinearVelocity.X,
                -6,
                root.AssemblyLinearVelocity.Z
            )
        end
        
        -- Disable collision
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end
end)

print("✅ AUTO FARM V3 - ĐỨNG IM GÂY DAME + FLY CAO + SLIDER TỐC ĐỘ ĐÁNH")

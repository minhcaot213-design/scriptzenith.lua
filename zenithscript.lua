-- ===================================================
-- REPLACE SKY FARM + FLIGHT + COMBAT (FULL FIX)
-- ===================================================

local flightEnabled = true
local flightHeight = 25 -- Sky farm height
local attackRadius = 40 -- Keep mobs within this range
local attackCooldown = 0.08 -- Faster attack cycle

-- Kill any existing tweens
local function stopAllTweens()
    if currentTween then
        pcall(function() currentTween:Cancel() end)
        currentTween = nil
    end
end

-- Direct flight movement (no TweenService garbage)
local function flyTo(position)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local targetPos = Vector3.new(position.X, flightHeight, position.Z)
    local currentPos = root.Position
    local distance = (targetPos - currentPos).Magnitude
    
    if distance < 2 then
        root.AssemblyLinearVelocity = Vector3.zero
        return true -- Reached target
    end
    
    -- Direct velocity movement (bypasses physics lag)
    local direction = (targetPos - currentPos).Unit
    local speed = 120 -- Fast enough to stay ahead of mobs
    root.AssemblyLinearVelocity = direction * speed
    
    -- Maintain altitude
    if math.abs(root.Position.Y - flightHeight) > 1 then
        local yDiff = flightHeight - root.Position.Y
        root.AssemblyLinearVelocity = Vector3.new(
            root.AssemblyLinearVelocity.X,
            yDiff * 3, -- Aggressive Y correction
            root.AssemblyLinearVelocity.Z
        )
    end
    
    return false
end

-- Aggressive combat loop (independent from quest system)
local function fastAttack()
    pcall(function()
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
            tool:Activate() -- Double-tap to bypass cooldown
        end
        
        -- Direct CombatFramework abuse for zero-delay attacks
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
            controller.increment = 5
            controller.attacking = false
            controller.blocking = false
            
            -- Spam attack multiple times per cycle
            for i = 1, 3 do
                controller:attack()
                task.wait(0.02)
            end
        end
    end)
end

-- Smarter mob gathering (keeps them stacked on you)
local function pullMobsToMe(mobList)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local myPos = root.Position
    local pullRadius = 80 -- Aggressive gather range
    
    for _, mob in ipairs(mobList) do
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local dist = (hrp.Position - myPos).Magnitude
            if dist > attackRadius and dist < pullRadius then
                -- Pull mob directly to your position with offset
                local offset = Vector3.new(
                    math.random(-3, 3),
                    0,
                    math.random(-3, 3)
                )
                hrp.CFrame = CFrame.new(myPos + offset)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CanCollide = false
                
                -- Disable mob AI so they don't run away
                hum.WalkSpeed = 0
                hum.JumpPower = 0
                hum.Sit = true
                
                -- Also freeze any animation tracks
                local animator = hum:FindFirstChild("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop()
                    end
                end
            end
        end
    end
end

-- MAIN AUTO FARM THREAD (REPLACE THE OLD ONE)
task.spawn(function()
    while true do
        task.wait(0.05)
        
        if not AutoFarmLevel then
            stopAllTweens()
            task.wait(0.5)
            continue
        end
        
        local char = LocalPlayer.Character
        if not char then task.wait(0.5) continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(0.5) continue end
        
        -- Keep flight active at all times
        root.AssemblyLinearVelocity = Vector3.new(
            root.AssemblyLinearVelocity.X,
            math.max(root.AssemblyLinearVelocity.Y, -5), -- Prevent falling
            root.AssemblyLinearVelocity.Z
        )
        
        -- Get current quest target
        local questData = getAutoQuestByLevel()
        if not questData then
            infoLabel.Text = "⚠️ No quest available for your level"
            task.wait(1)
            continue
        end
        
        -- Auto-accept quest if enabled
        if AutoQuest and not checkHasQuest() then
            pcall(function()
                CommF:InvokeServer("StartQuest", questData.QuestName, questData.QuestLevel)
            end)
            task.wait(0.3)
        end
        
        -- Find mobs
        local mobs = getAllLivingEnemies(questData.MonName)
        if #mobs == 0 then
            infoLabel.Text = string.format("🔍 Searching for %s...", questData.MonName)
            task.wait(0.2)
            continue
        end
        
        -- Sort mobs by distance
        table.sort(mobs, function(a, b)
            local aPos = a:FindFirstChild("HumanoidRootPart")
            local bPos = b:FindFirstChild("HumanoidRootPart")
            if not aPos or not bPos then return false end
            return (aPos.Position - root.Position).Magnitude < (bPos.Position - root.Position).Magnitude
        end)
        
        local targetMob = mobs[1]
        local targetHRP = targetMob:FindFirstChild("HumanoidRootPart")
        if not targetHRP then task.wait(0.1) continue end
        
        -- Update UI
        infoLabel.Text = string.format(
            "⚔️ Farming: %s (Lv.%d) | Mobs: %d",
            questData.MonName,
            LocalPlayer.Data.Level.Value,
            #mobs
        )
        
        -- Pull mobs close
        if BringMob then
            pullMobsToMe(mobs)
        end
        
        -- FLY TO TARGET
        local targetPos = targetHRP.Position
        local distance = (targetPos - root.Position).Magnitude
        
        if distance > attackRadius then
            -- Fly toward mob
            local reached = flyTo(targetPos)
            stopAllTweens()
            
            if not reached then
                task.wait(0.05)
                continue -- Keep flying
            end
        end
        
        -- WE ARE IN RANGE → ATTACK FAST
        if distance <= attackRadius + 10 then
            -- Stop horizontal movement, maintain altitude
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            
            -- Face the target
            local lookVec = (targetPos - root.Position).Unit
            root.CFrame = CFrame.lookAt(root.Position, root.Position + lookVec * 10)
            
            -- SPAM ATTACKS (independent of any other system)
            for i = 1, 5 do
                fastAttack()
                task.wait(attackCooldown)
            end
            
            -- Additional weapon activation for melee
            local weapon = char:FindFirstChildOfClass("Tool")
            if weapon and weapon:IsA("Tool") then
                weapon:Activate()
                task.wait(0.05)
                weapon:Activate()
            end
        end
        
        -- Anti-stun: If health drops, force flight up
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < hum.MaxHealth * 0.3 then
            root.AssemblyLinearVelocity = Vector3.new(
                root.AssemblyLinearVelocity.X,
                50, -- Emergency boost up
                root.AssemblyLinearVelocity.Z
            )
            task.wait(0.3)
        end
        
        -- Small delay to prevent CPU overload
        task.wait(0.03)
    end
end)

-- FLIGHT OVERRIDE (keeps you airborne even when not farming)
task.spawn(function()
    while true do
        task.wait(0.1)
        if not AutoFarmLevel then task.wait(0.5) continue end
        
        local char = LocalPlayer.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        
        -- Force altitude maintenance
        local currentY = root.Position.Y
        if currentY < flightHeight - 2 then
            root.AssemblyLinearVelocity = Vector3.new(
                root.AssemblyLinearVelocity.X,
                30, -- Strong upward push
                root.AssemblyLinearVelocity.Z
            )
        elseif currentY > flightHeight + 5 then
            root.AssemblyLinearVelocity = Vector3.new(
                root.AssemblyLinearVelocity.X,
                -10,
                root.AssemblyLinearVelocity.Z
            )
        end
        
        -- Disable collision on all player parts to avoid getting stuck
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end
end)

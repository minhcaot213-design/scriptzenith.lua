-- ===================================================================
-- 1. LOAD UI 10.000 DÒNG TỪ GITHUB CỦA BẠN (Ép Bypass Cache tải bản mới nhất)
-- ===================================================================
loadstring(game:HttpGet("https://raw.githubusercontent.com/minhcaot213-design/scriptzenith.lua/refs/heads/main/zenithscript.lua?t=" .. tostring(tick())))()

-- ===================================================================
-- 2. LÕI HACK NGẦM: CHẠY SONG SONG ĐỂ BUFF SỨC MẠNH CHO UI CỦA BẠN
-- ===================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- A. LÕI FAST ATTACK (COMBAT FRAMEWORK HOOK)
task.spawn(function()
    while task.wait(0.01) do
        pcall(function()
            -- Bơm thêm Click chuột ảo để chống xịt
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):Button1Down(Vector2.new(50, 50))

            local CbFw = require(LocalPlayer.PlayerScripts.CombatFramework)
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
                ac.hitboxLimiter = 2^20 -- Phá giới hạn tầm đánh
                ac.timeToNextAttack = 0
                ac.timeToNextBlock = 0
                ac.increment = 3
                ac:attack()
            end
        end)
    end
end)

-- B. LÕI XÓA NÃO QUÁI VẬT (CHỐNG BỊ QUÁI ĐÁNH TRẢ)
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Quét tất cả quái xung quanh 50 mét
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                    local mobHum = mob:FindFirstChild("Humanoid")
                    if mobHRP and mobHum and mobHum.Health > 0 then
                        if (mobHRP.Position - hrp.Position).Magnitude <= 50 then
                            -- Ép Hitbox khổng lồ
                            mobHRP.Size = Vector3.new(60, 60, 60)
                            mobHRP.CanCollide = false
                            
                            -- Xóa sạch AI và hoạt ảnh của quái
                            mobHum.WalkSpeed = 0
                            mobHum.JumpPower = 0
                            mobHum.Sit = true
                            if mobHum:FindFirstChild("Animator") then
                                mobHum.Animator:Destroy()
                            end
                            mobHum:ChangeState(11) -- Ép tắt vật lý
                        end
                    end
                end
            end
        end)
    end
end)

-- C. LÕI XÓA HOẠT ẢNH TAY (CHỐNG GIẬT MÀN HÌNH)
RunService.Stepped:Connect(function()
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum and hum:FindFirstChild("Animator") then
            for _, anim in ipairs(hum.Animator:GetPlayingAnimationTracks()) do
                local name = anim.Name:lower()
                if name:match("attack") or name:match("punch") or name:match("slash") or name:match("swing") or name:match("m1") then 
                    anim:Stop() 
                end
            end
        end
    end)
end)

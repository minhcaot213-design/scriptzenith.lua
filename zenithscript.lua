-- [[ ROBLOX MULTI-TOOL: ESP + SPEED SLIDER + FIX LAG ]] --

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ===================================================
-- 0. DỌN DẸP INSTANCE CŨ TRƯỚC KHI CHẠY (CLEANUP)
-- ===================================================
local GUI_NAME = "Archivist_Utility_UI"

local function getSafeGuiParent()
    local success, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if success and coreGui then
        return coreGui
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local targetParent = getSafeGuiParent()
local existingUI = targetParent:FindFirstChild(GUI_NAME)
if existingUI then
    existingUI:Destroy()
end

-- ===================================================
-- 1. FIX LAG / TỐI ƯU HÓA ĐỒ HỌA
-- ===================================================
local function applyFixLag()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1

        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") then
                effect.Enabled = false
            end
        end

        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                obj.Enabled = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            end
        end

        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 0
        end
    end)
end

task.spawn(applyFixLag)

-- ===================================================
-- 2. ESP (HIGHLIGHT PLAYERS)
-- ===================================================
local function setupPlayerESP(player)
    if player == LocalPlayer then return end

    local function attachHighlight(character)
        if not character then return end
        if character:FindFirstChild("ESPHighlight") then return end

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.fromRGB(255, 45, 85)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Adornee = character
        highlight.Parent = character
    end

    if player.Character then
        attachHighlight(player.Character)
    end
    player.CharacterAdded:Connect(attachHighlight)
end

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayerESP(player)
end
Players.PlayerAdded:Connect(setupPlayerESP)

-- ===================================================
-- 3. SPEED CONTROLLER & GIAO DIỆN SLIDER
-- ===================================================
local minSpeed = 16
local maxSpeed = 250
local targetSpeed = 16

-- Vòng lặp duy trì tốc độ di chuyển
task.spawn(function()
    while true do
        task.wait(0.1)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.WalkSpeed ~= targetSpeed then
                humanoid.WalkSpeed = targetSpeed
            end
        end
    end
end)

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = targetParent

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 100)
MainFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "CONTROL PANEL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.Parent = MainFrame

local SpeedDisplay = Instance.new("TextLabel")
SpeedDisplay.Size = UDim2.new(1, 0, 0, 20)
SpeedDisplay.Position = UDim2.new(0, 0, 0, 28)
SpeedDisplay.BackgroundTransparency = 1
SpeedDisplay.Text = "WalkSpeed: " .. tostring(targetSpeed)
SpeedDisplay.TextColor3 = Color3.fromRGB(160, 160, 180)
SpeedDisplay.Font = Enum.Font.GothamMedium
SpeedDisplay.TextSize = 12
SpeedDisplay.Parent = MainFrame

local SliderTrack = Instance.new("TextButton")
SliderTrack.Name = "SliderTrack"
SliderTrack.Size = UDim2.new(0.85, 0, 0, 6)
SliderTrack.Position = UDim2.new(0.075, 0, 0, 64)
SliderTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SliderTrack.AutoButtonColor = false
SliderTrack.BorderSizePixel = 0
SliderTrack.Text = ""
SliderTrack.Parent = MainFrame

local TrackCorner = Instance.new("UICorner")
TrackCorner.CornerRadius = UDim.new(1, 0)
TrackCorner.Parent = SliderTrack

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local SliderThumb = Instance.new("Frame")
SliderThumb.Size = UDim2.new(0, 14, 0, 14)
SliderThumb.Position = UDim2.new(0, -7, 0.5, -7)
SliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderThumb.BorderSizePixel = 0
SliderThumb.Parent = SliderTrack

local ThumbCorner = Instance.new("UICorner")
ThumbCorner.CornerRadius = UDim.new(1, 0)
ThumbCorner.Parent = SliderThumb

-- Xử lý tương tác kéo thả Slider
local isDragging = false

local function updateSlider(percent)
    percent = math.clamp(percent, 0, 1)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderThumb.Position = UDim2.new(percent, -7, 0.5, -7)

    targetSpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * percent)
    SpeedDisplay.Text = "WalkSpeed: " .. tostring(targetSpeed)

    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = targetSpeed
        end
    end
end

SliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        local relativeX = input.Position.X - SliderTrack.AbsolutePosition.X
        updateSlider(relativeX / SliderTrack.AbsoluteSize.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = UserInputService:GetMouseLocation().X
        local relativeX = mousePos - SliderTrack.AbsolutePosition.X
        updateSlider(relativeX / SliderTrack.AbsoluteSize.X)
    end
end)

-- Khởi tạo vị trí ban đầu của thanh trượt
updateSlider((16 - minSpeed) / (maxSpeed - minSpeed))
-- =========================================================
-- ZENITH UI PATCH
-- Sidebar Scroll + Banner + Square Border
-- =========================================================

-- XÓA/THAY PHẦN SIDEBAR CŨ:
-- local Sidebar = Instance.new("Frame", MainFrame)
-- ...
-- local TabListLayout = Instance.new("UIListLayout", Sidebar)

-- =========================================================
-- 1. SIDEBAR CONTAINER
-- =========================================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 155, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
Sidebar.BorderSizePixel = 0
Sidebar.ClipsDescendants = true

-- Border vuông nhẹ
local SidebarStroke = Instance.new("UIStroke")
SidebarStroke.Parent = Sidebar
SidebarStroke.Color = Color3.fromRGB(32, 40, 55)
SidebarStroke.Thickness = 1

-- =========================================================
-- 2. BANNER Ở TRÊN DANH MỤC
-- =========================================================

local Banner = Instance.new("ImageLabel")
Banner.Name = "Banner"
Banner.Parent = Sidebar
Banner.Size = UDim2.new(1, -14, 0, 82)
Banner.Position = UDim2.new(0, 7, 0, 7)

-- Roblox không cho ImageLabel lấy trực tiếp ảnh HTTP bên ngoài.
-- Sau khi upload ảnh lên Roblox, thay dòng bên dưới bằng:
-- Banner.Image = "rbxassetid://YOUR_ASSET_ID"

Banner.Image = ""
Banner.BackgroundColor3 = Color3.fromRGB(18, 23, 32)
Banner.BackgroundTransparency = 0
Banner.BorderSizePixel = 0
Banner.ScaleType = Enum.ScaleType.Crop

-- Border gần vuông
local BannerStroke = Instance.new("UIStroke")
BannerStroke.Parent = Banner
BannerStroke.Color = Color3.fromRGB(0, 190, 255)
BannerStroke.Thickness = 1

local BannerCorner = Instance.new("UICorner")
BannerCorner.Parent = Banner
BannerCorner.CornerRadius = UDim.new(0, 4)

-- =========================================================
-- 3. KHU VỰC DANH MỤC CÓ THỂ KÉO LÊN/XUỐNG
-- =========================================================

local TabScroller = Instance.new("ScrollingFrame")
TabScroller.Name = "TabScroller"
TabScroller.Parent = Sidebar
TabScroller.Size = UDim2.new(1, -8, 1, -98)
TabScroller.Position = UDim2.new(0, 4, 0, 94)

TabScroller.BackgroundTransparency = 1
TabScroller.BorderSizePixel = 0

TabScroller.ScrollBarThickness = 3
TabScroller.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255)
TabScroller.ScrollBarImageTransparency = 0.15

TabScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y

TabScroller.ScrollingDirection = Enum.ScrollingDirection.Y
TabScroller.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabScroller
TabPadding.PaddingTop = UDim.new(0, 3)
TabPadding.PaddingBottom = UDim.new(0, 8)
TabPadding.PaddingLeft = UDim.new(0, 3)
TabPadding.PaddingRight = UDim.new(0, 3)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabScroller
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- =========================================================
-- 4. TẠO TAB BUTTON VÀO SCROLLER
-- =========================================================

local tabButtons = {}
local tabPages = {}

local function createTabButton(name, icon, transKey)

    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. name
    btn.Parent = TabScroller

    btn.Size = UDim2.new(1, -4, 0, 32)

    btn.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
    btn.BorderSizePixel = 0

    btn.TextColor3 = Color3.fromRGB(175, 185, 205)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Text = icon .. "   " .. LangDict[currentLang][transKey]

    local Padding = Instance.new("UIPadding")
    Padding.Parent = btn
    Padding.PaddingLeft = UDim.new(0, 11)

    -- Border vuông hơn
    local Corner = Instance.new("UICorner")
    Corner.Parent = btn
    Corner.CornerRadius = UDim.new(0, 4)

    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = btn
    Stroke.Color = Color3.fromRGB(35, 42, 58)
    Stroke.Thickness = 1
    Stroke.Transparency = 0.25

    -- Thanh active bên trái
    local Pill = Instance.new("Frame")
    Pill.Name = "ActiveBar"
    Pill.Parent = btn
    Pill.Size = UDim2.new(0, 3, 0, 18)
    Pill.Position = UDim2.new(0, 0, 0.5, -9)
    Pill.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
    Pill.BorderSizePixel = 0
    Pill.Visible = false

    local PillCorner = Instance.new("UICorner")
    PillCorner.Parent = Pill
    PillCorner.CornerRadius = UDim.new(0, 2)

    local entry = {
        Label = btn,
        Key = transKey,
        Button = btn,
        Pill = Pill,

        Update = function()
            btn.Text = icon .. "   " .. LangDict[currentLang][transKey]
        end
    }

    table.insert(translatableElements, entry)

    tabButtons[name] = entry

    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)

    -- Hover
    btn.MouseEnter:Connect(function()
        if tabPages[name] and not tabPages[name].Visible then
            btn.BackgroundColor3 = Color3.fromRGB(31, 38, 52)
        end
    end)

    btn.MouseLeave:Connect(function()
        if tabPages[name] and not tabPages[name].Visible then
            btn.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
        end
    end)
end

-- =========================================================
-- 5. SWITCH TAB
-- =========================================================

local function switchTab(name)

    for tabName, item in pairs(tabButtons) do

        local active = (tabName == name)

        if active then

            item.Button.BackgroundColor3 =
                Color3.fromRGB(38, 105, 190)

            item.Button.TextColor3 =
                Color3.fromRGB(255, 255, 255)

            item.Pill.Visible = true

            local stroke = item.Button:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Color = Color3.fromRGB(0, 200, 255)
                stroke.Transparency = 0
            end

        else

            item.Button.BackgroundColor3 =
                Color3.fromRGB(25, 30, 42)

            item.Button.TextColor3 =
                Color3.fromRGB(175, 185, 205)

            item.Pill.Visible = false

            local stroke = item.Button:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Color = Color3.fromRGB(35, 42, 58)
                stroke.Transparency = 0.25
            end
        end
    end

    for pageName, page in pairs(tabPages) do
        page.Visible = (pageName == name)
    end

    -- Cuộn sidebar về đầu khi đổi mục
    TabScroller.CanvasPosition =
        Vector2.new(0, 0)
end

-- =========================================================
-- 6. CREATE PAGE
-- =========================================================

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.Size = UDim2.new(1, -155, 1, -38)
ContentContainer.Position = UDim2.new(0, 155, 0, 38)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0

local function createPage(name)

    local page = Instance.new("ScrollingFrame")
    page.Name = "Page_" .. name
    page.Parent = ContentContainer

    page.Size = UDim2.new(1, 0, 1, 0)

    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0

    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255)

    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)

    page.ScrollingDirection = Enum.ScrollingDirection.Y

    local Padding = Instance.new("UIPadding")
    Padding.Parent = page
    Padding.PaddingTop = UDim.new(0, 9)
    Padding.PaddingBottom = UDim.new(0, 10)
    Padding.PaddingLeft = UDim.new(0, 7)
    Padding.PaddingRight = UDim.new(0, 7)

    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    page.Visible = false

    tabPages[name] = page

    return page
end

-- =========================================================
-- 7. BORDER CHO CÁC PANEL / TOGGLE
-- =========================================================

local function addSquareBorder(instance, color)

    local old = instance:FindFirstChild("ZenithBorder")

    if old then
        old:Destroy()
    end

    local stroke = Instance.new("UIStroke")
    stroke.Name = "ZenithBorder"
    stroke.Parent = instance

    stroke.Color = color or Color3.fromRGB(35, 43, 58)
    stroke.Thickness = 1
    stroke.Transparency = 0

    local corner = instance:FindFirstChildOfClass("UICorner")

    if corner then
        corner.CornerRadius = UDim.new(0, 4)
    end
end

-- =========================================================
-- 8. STYLE TOGGLE MỚI
-- =========================================================

local function styleToggleFrame(frame)

    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 29)
    frame.BorderSizePixel = 0

    local corner = frame:FindFirstChildOfClass("UICorner")

    if corner then
        corner.CornerRadius = UDim.new(0, 4)
    end

    addSquareBorder(
        frame,
        Color3.fromRGB(31, 39, 54)
    )
end

-- =========================================================
-- 9. STYLE BUTTON MỚI
-- =========================================================

local function styleButton(btn)

    btn.BackgroundColor3 =
        Color3.fromRGB(19, 25, 36)

    btn.BorderSizePixel = 0

    local corner = btn:FindFirstChildOfClass("UICorner")

    if corner then
        corner.CornerRadius = UDim.new(0, 4)
    end

    local stroke = btn:FindFirstChildOfClass("UIStroke")

    if stroke then
        stroke.Color = Color3.fromRGB(0, 170, 230)
        stroke.Thickness = 1
        stroke.Transparency = 0.2
    end
end

-- =========================================================
-- 10. BANNER URL GỐC CỦA BOSS MAN
-- =========================================================

local BannerSource =
    "https://sf-static.upanhlaylink.com/img/image_2026082253d95aa534405373c370963a0a058cb2.jpg"

-- URL trên chỉ là nguồn ảnh.
-- Roblox ImageLabel cần ảnh đã upload thành Roblox asset.
--
-- Ví dụ:
--
-- Banner.Image = "rbxassetid://1234567890"
--
-- Không thể dùng trực tiếp:
--
-- Banner.Image = BannerSource
--
-- Nếu môi trường chạy của boss man hỗ trợ tải ảnh HTTP
-- và chuyển thành asset riêng, có thể xử lý nguồn ảnh
-- ở phía môi trường đó.

-- =========================================================
-- 11. KÍCH THƯỚC MAIN UI
-- =========================================================

MainFrame.Size = UDim2.new(0, 560, 0, 350)

local MainCorner = MainFrame:FindFirstChildOfClass("UICorner")

if MainCorner then
    MainCorner.CornerRadius = UDim.new(0, 5)
end

local MainStroke = MainFrame:FindFirstChildOfClass("UIStroke")

if MainStroke then
    MainStroke.Color = Color3.fromRGB(32, 40, 55)
    MainStroke.Thickness = 1
end

-- =========================================================
-- 12. TOPBAR
-- =========================================================

TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(14, 18, 27)
TopBar.BorderSizePixel = 0

local TopStroke = Instance.new("UIStroke")
TopStroke.Parent = TopBar
TopStroke.Color = Color3.fromRGB(31, 40, 55)
TopStroke.Thickness = 1
TopStroke.Transparency = 0.3

-- =========================================================
-- 13. TẠO 7 TAB
-- =========================================================

local cats = {
    {"Farm",       "🌾", "tab_farm"},
    {"Fruit",      "🍎", "tab_fruit"},
    {"PVP-ESP",    "⚔️", "tab_pvp"},
    {"Server",     "🌐", "tab_server"},
    {"RAID",       "⚡", "tab_raid"},
    {"FARM ITEM",  "🗡️", "tab_item"},
    {"SETTING",    "⚙️", "tab_setting"}
}

for index, c in ipairs(cats) do

    createTabButton(c[1], c[2], c[3])
    createPage(c[1])

    if tabButtons[c[1]] then
        tabButtons[c[1]].Button.LayoutOrder = index
    end
end

switchTab("Farm")

-- =========================================================
-- 14. SCROLL BẰNG CHUỘT / TOUCH
-- =========================================================

TabScroller.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseWheel then

        local current = TabScroller.CanvasPosition.Y
        local target = math.clamp(
            current - input.Position.Z * 45,
            0,
            math.max(
                0,
                TabScroller.AbsoluteCanvasSize.Y
                - TabScroller.AbsoluteWindowSize.Y
            )
        )

        TabScroller.CanvasPosition =
            Vector2.new(0, target)
    end
end)

-- =========================================================
-- 15. SỬA MINIMIZE
-- =========================================================

local isMinimized = false

MinBtn.MouseButton1Click:Connect(function()

    isMinimized = not isMinimized

    if isMinimized then

        MainFrame:TweenSize(
            UDim2.new(0, 560, 0, 38),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quart,
            0.25,
            true
        )

        Sidebar.Visible = false
        ContentContainer.Visible = false
        MinBtn.Text = "+"

    else

        MainFrame:TweenSize(
            UDim2.new(0, 560, 0, 350),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quart,
            0.25,
            true
        )

        Sidebar.Visible = true
        ContentContainer.Visible = true
        MinBtn.Text = "−"
    end
end)

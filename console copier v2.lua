-- [[ CONSOLE V1 - ULTIMATE DRAGGABLE EDITION ]]
-- [[ MADE BY @voiditic_456 (Roblox: totallyoofedout) ]]

local LogService = game:GetService("LogService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local DISCORD_LINK = "https://discord.gg/U47JsDHCDE"
local capturedData = ""
local backupData = "" 

-- Universal Clipboard Copy
local function safeCopy(text)
    local success = pcall(function()
        if setclipboard then setclipboard(text)
        elseif toclipboard then toclipboard(text)
        elseif set_clipboard then set_clipboard(text)
        end
    end)
    return success
end

-- Drag Logic Function (Reusable for multiple GUIs)
local function makeDraggable(frame)
    local dragToggle, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Capture Logic
LogService.MessageOut:Connect(function(msg, messageType)
    local timestamp = os.date("%H:%M:%S")
    local formattedMsg = string.format("[%s] [%s]: %s", timestamp, messageType.Name, tostring(msg))
    capturedData = capturedData .. formattedMsg .. "\n"
end)

-- ============================================
-- MAIN UI SETUP (BOTTOM LEFT)
-- ============================================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ConsoleV1_Main"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0, 20, 1, -320)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
makeDraggable(MainFrame)

-- Sidebar & Buttons
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Branding = Instance.new("TextLabel", Sidebar)
Branding.Size = UDim2.new(1, 0, 0, 80); Branding.BackgroundTransparency = 1; Branding.TextColor3 = Color3.new(1,1,1)
Branding.Font = Enum.Font.GothamBold; Branding.TextSize = 16; Branding.TextWrapped = true
Branding.Text = "CONSOLE V1\n@voiditic_456\ntotallyoofedout"

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -150, 1, -20); Content.Position = UDim2.new(0, 150, 0, 10); Content.BackgroundTransparency = 1
Instance.new("UIListLayout", Content).Padding = UDim.new(0, 10)

local function createBtn(text, color)
    local b = Instance.new("TextButton", Content)
    b.Size = UDim2.new(1, -10, 0, 45); b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 18; b.Text = text
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8); return b
end

local CopyBtn = createBtn("📋 COPY DATA", Color3.fromRGB(0, 120, 215))
local DeleteBtn = createBtn("🗑️ DELETE ALL", Color3.fromRGB(200, 0, 0))
local RecoverBtn = createBtn("🔄 RECOVER", Color3.fromRGB(100, 50, 150))
local DiscordBtn = createBtn("󰙯 DISCORD", Color3.fromRGB(88, 101, 242))

local CloseX = Instance.new("TextButton", MainFrame)
CloseX.Size = UDim2.new(0, 30, 0, 30); CloseX.Position = UDim2.new(1, -35, 0, 5); CloseX.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseX.Text = "X"; CloseX.TextColor3 = Color3.new(1, 1, 1); CloseX.Font = Enum.Font.GothamBold; CloseX.TextSize = 18
Instance.new("UICorner", CloseX).CornerRadius = UDim.new(0, 8)
CloseX.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Stats = Instance.new("TextLabel", Content)
Stats.Size = UDim2.new(1, 0, 0, 30); Stats.BackgroundTransparency = 1; Stats.TextColor3 = Color3.fromRGB(150, 150, 200)
Stats.Font = Enum.Font.GothamBold; Stats.TextSize = 18; Stats.TextXAlignment = Enum.TextXAlignment.Left; Stats.Text = "Lines: 0 | Chars: 0"

-- ============================================
-- GUIDE UI SETUP (CENTER + DRAGGABLE)
-- ============================================
local GuideGui = Instance.new("ScreenGui", CoreGui)
local GFrame = Instance.new("Frame", GuideGui)
GFrame.Size = UDim2.new(0, 400, 0, 250); GFrame.Position = UDim2.new(0.5, -200, 0.5, -125); GFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
GFrame.Active = true; Instance.new("UICorner", GFrame).CornerRadius = UDim.new(0, 12)
makeDraggable(GFrame)

-- Guide Close X
local GCloseX = Instance.new("TextButton", GFrame)
GCloseX.Size = UDim2.new(0, 30, 0, 30); GCloseX.Position = UDim2.new(1, -35, 0, 5); GCloseX.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
GCloseX.Text = "X"; GCloseX.TextColor3 = Color3.new(1, 1, 1); GCloseX.Font = Enum.Font.GothamBold; GCloseX.TextSize = 18
Instance.new("UICorner", GCloseX).CornerRadius = UDim.new(0, 8)
GCloseX.MouseButton1Click:Connect(function() GuideGui:Destroy() end)

local GTitle = Instance.new("TextLabel", GFrame)
GTitle.Size = UDim2.new(1, 0, 0, 50); GTitle.BackgroundTransparency = 1; GTitle.Text = "USER GUIDE & INFO"
GTitle.TextColor3 = Color3.new(1, 1, 1); GTitle.Font = Enum.Font.GothamBold; GTitle.TextSize = 22

local GText = Instance.new("TextLabel", GFrame)
GText.Size = UDim2.new(1, -40, 0, 120); GText.Position = UDim2.new(0, 20, 0, 60); GText.BackgroundTransparency = 1; GText.TextWrapped = true
GText.Text = "⚠️ This script only captures logs created AFTER execution.\n\nJoin Discord for support and elite scripts!"
GText.TextColor3 = Color3.fromRGB(200, 200, 200); GText.Font = Enum.Font.GothamBold; GText.TextSize = 18

local GButton = Instance.new("TextButton", GFrame)
GButton.Size = UDim2.new(0.8, 0, 0, 40); GButton.Position = UDim2.new(0.1, 0, 0.8, 0); GButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
GButton.Text = "UNDERSTOOD"; GButton.TextColor3 = Color3.new(1, 1, 1); GButton.Font = Enum.Font.GothamBold; GButton.TextSize = 18
Instance.new("UICorner", GButton).CornerRadius = UDim.new(0, 8)
GButton.MouseButton1Click:Connect(function() GuideGui:Destroy() end)

-- Interaction Logic
CopyBtn.MouseButton1Click:Connect(function() safeCopy(capturedData); CopyBtn.Text = "DONE! ✅"; task.wait(1); CopyBtn.Text = "📋 COPY DATA" end)
DeleteBtn.MouseButton1Click:Connect(function() backupData = capturedData; capturedData = ""; DeleteBtn.Text = "WIPED! 🗑️"; task.wait(1); DeleteBtn.Text = "🗑️ DELETE ALL" end)
RecoverBtn.MouseButton1Click:Connect(function() capturedData = capturedData .. backupData; backupData = ""; RecoverBtn.Text = "RESTORED! 🔄"; task.wait(1); RecoverBtn.Text = "🔄 RECOVER" end)
DiscordBtn.MouseButton1Click:Connect(function() safeCopy(DISCORD_LINK); DiscordBtn.Text = "COPIED! 󰙯"; task.wait(1); DiscordBtn.Text = "󰙯 DISCORD" end)

task.spawn(function()
    while task.wait(0.5) do
        if ScreenGui and ScreenGui.Parent then
            local _, lines = capturedData:gsub("\n", "\n")
            Stats.Text = "Lines: " .. lines .. " | Chars: " .. #capturedData
        end
    end
end)

print("✅ CONSOLE V1 DEPLOYED | DOUBLE DRAG ENABLED")

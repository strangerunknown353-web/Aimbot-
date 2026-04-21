local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimbotEnabled = false
local TeamCheck = true

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "AimbotGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Aimbot: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.TextSize = 20
ToggleButton.Draggable = true -- Allows moving the button on screen

-- Function to find the closest enemy player
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Team Check Logic
            if TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end

            -- Health Check
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                continue
            end

            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- Toggle Logic
ToggleButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        ToggleButton.Text = "Aimbot: ON"
        ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        ToggleButton.Text = "Aimbot: OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

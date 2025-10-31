-- by vgzinsk0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configurações
local Settings = {
    Aimbot = false,
    TeamCheck = true,
    WallCheck = true,
    FOV = 100,
    HitPart = "Head", -- Head, Torso, HumanoidRootPart
    ShowFOV = true
}

-- Cores Cyberpunk
local COLORS = {
    Background = Color3.fromRGB(15, 5, 25),
    Primary = Color3.fromRGB(255, 0, 255),
    Secondary = Color3.fromRGB(0, 255, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Off = Color3.fromRGB(80, 80, 100),
    On = Color3.fromRGB(0, 255, 100)
}

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0, 20, 0, 100)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Efeito de borda brilhante
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.Primary),
    ColorSequenceKeypoint.new(1, COLORS.Secondary)
})
UIGradient.Rotation = 45

local Border = Instance.new("Frame")
Border.Parent = MainFrame
Border.Size = UDim2.new(1, 4, 1, 4)
Border.Position = UDim2.new(0, -2, 0, -2)
Border.BackgroundColor3 = Color3.new(1, 1, 1)
Border.BorderSizePixel = 0
Border.ZIndex = 0

local BorderGradient = UIGradient:Clone()
BorderGradient.Parent = Border

local InnerBorder = Instance.new("Frame")
InnerBorder.Parent = MainFrame
InnerBorder.Size = UDim2.new(1, 0, 1, 0)
InnerBorder.BackgroundColor3 = COLORS.Background
InnerBorder.BorderSizePixel = 0
InnerBorder.ZIndex = 1

-- Topbar
local TopBar = Instance.new("Frame")
TopBar.Parent = InnerBorder
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
TopBar.BorderSizePixel = 0

-- Título
local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "CYBER-AIM v1.0"
Title.TextColor3 = COLORS.Primary
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = TopBar
SubTitle.Size = UDim2.new(0, 200, 0, 15)
SubTitle.Position = UDim2.new(0, 10, 0, 18)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by vgzinsk0"
SubTitle.TextColor3 = COLORS.Secondary
SubTitle.TextSize = 10
Title.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Botões
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TopBar
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 2)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 14

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = TopBar
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 2)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.TextSize = 14

-- Conteúdo
local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = InnerBorder
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1

-- Função para criar toggle
local function createToggle(name, setting, yPos)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = ContentFrame
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.Position = UDim2.new(0, 0, 0, yPos)
    ToggleFrame.BackgroundTransparency = 1
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(0, 0, 0, 0)
    ToggleButton.BackgroundColor3 = Settings[setting] and COLORS.On or COLORS.Off
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.Size = UDim2.new(0, 150, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 60, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = COLORS.Text
    ToggleLabel.TextSize = 12
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Parent = ToggleFrame
    StatusLabel.Size = UDim2.new(0, 40, 1, 0)
    StatusLabel.Position = UDim2.new(1, -40, 0, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = Settings[setting] and "ON" or "OFF"
    StatusLabel.TextColor3 = Settings[setting] and COLORS.On or Color3.fromRGB(255, 50, 50)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.GothamBold
    
    ToggleButton.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        ToggleButton.BackgroundColor3 = Settings[setting] and COLORS.On or COLORS.Off
        StatusLabel.Text = Settings[setting] and "ON" or "OFF"
        StatusLabel.TextColor3 = Settings[setting] and COLORS.On or Color3.fromRGB(255, 50, 50)
    end)
    
    return ToggleFrame
end

-- Criar toggles
createToggle("AIMBOT", "Aimbot", 0)
createToggle("TEAM CHECK", "TeamCheck", 35)
createToggle("WALL CHECK", "WallCheck", 70)
createToggle("SHOW FOV", "ShowFOV", 105)

-- Dropdown de parte do corpo
local DropdownFrame = Instance.new("Frame")
DropdownFrame.Parent = ContentFrame
DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
DropdownFrame.Position = UDim2.new(0, 0, 0, 145)
DropdownFrame.BackgroundTransparency = 1

local DropdownLabel = Instance.new("TextLabel")
DropdownLabel.Parent = DropdownFrame
DropdownLabel.Size = UDim2.new(0, 120, 0, 20)
DropdownLabel.Position = UDim2.new(0, 0, 0, 0)
DropdownLabel.BackgroundTransparency = 1
DropdownLabel.Text = "HIT PART:"
DropdownLabel.TextColor3 = COLORS.Text
DropdownLabel.TextSize = 12
DropdownLabel.Font = Enum.Font.Gotham
DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

local DropdownButton = Instance.new("TextButton")
DropdownButton.Parent = DropdownFrame
DropdownButton.Size = UDim2.new(0, 120, 0, 25)
DropdownButton.Position = UDim2.new(0, 0, 0, 15)
DropdownButton.BackgroundColor3 = COLORS.Primary
DropdownButton.BorderSizePixel = 0
DropdownButton.Text = Settings.HitPart
DropdownButton.TextColor3 = COLORS.Text
DropdownButton.TextSize = 12

local parts = {"Head", "Torso", "HumanoidRootPart"}
local dropdownOpen = false

DropdownButton.MouseButton1Click:Connect(function()
    if not dropdownOpen then
        dropdownOpen = true
        for i, part in ipairs(parts) do
            local Option = Instance.new("TextButton")
            Option.Parent = DropdownFrame
            Option.Size = UDim2.new(0, 120, 0, 25)
            Option.Position = UDim2.new(0, 0, 0, 15 + (i * 25))
            Option.BackgroundColor3 = COLORS.Secondary
            Option.BorderSizePixel = 0
            Option.Text = part
            Option.TextColor3 = COLORS.Text
            Option.TextSize = 11
            
            Option.MouseButton1Click:Connect(function()
                Settings.HitPart = part
                DropdownButton.Text = part
                for _, child in ipairs(DropdownFrame:GetChildren()) do
                    if child:IsA("TextButton") and child ~= DropdownButton then
                        child:Destroy()
                    end
                end
                dropdownOpen = false
            end)
        end
    else
        for _, child in ipairs(DropdownFrame:GetChildren()) do
            if child:IsA("TextButton") and child ~= DropdownButton then
                child:Destroy()
            end
        end
        dropdownOpen = false
    end
end)

-- Slider de FOV
local SliderFrame = Instance.new("Frame")
SliderFrame.Parent = ContentFrame
SliderFrame.Size = UDim2.new(1, 0, 0, 50)
SliderFrame.Position = UDim2.new(0, 0, 0, 200)
SliderFrame.BackgroundTransparency = 1

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Parent = SliderFrame
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.Position = UDim2.new(0, 0, 0, 0)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "FOV CIRCLE: " .. Settings.FOV
SliderLabel.TextColor3 = COLORS.Text
SliderLabel.TextSize = 12
SliderLabel.Font = Enum.Font.Gotham

local SliderBar = Instance.new("Frame")
SliderBar.Parent = SliderFrame
SliderBar.Size = UDim2.new(1, 0, 0, 10)
SliderBar.Position = UDim2.new(0, 0, 0, 25)
SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
SliderBar.BorderSizePixel = 0

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderBar
SliderFill.Size = UDim2.new(Settings.FOV / 700, 0, 1, 0)
SliderFill.BackgroundColor3 = COLORS.Primary
SliderFill.BorderSizePixel = 0

local SliderButton = Instance.new("TextButton")
SliderButton.Parent = SliderBar
SliderButton.Size = UDim2.new(0, 20, 2, 0)
SliderButton.Position = UDim2.new(Settings.FOV / 700, -10, -0.5, 0)
SliderButton.BackgroundColor3 = COLORS.Secondary
SliderButton.BorderSizePixel = 0
SliderButton.Text = ""

-- Sistema FOV Circle
local function updateFOVCircle()
    if fovCircle then
        fovCircle:Destroy()
    end
    
    if Settings.ShowFOV then
        fovCircle = Instance.new("Frame")
        fovCircle.Parent = ScreenGui
        fovCircle.Size = UDim2.new(0, Settings.FOV * 2, 0, Settings.FOV * 2)
        fovCircle.Position = UDim2.new(0.5, -Settings.FOV, 0.5, -Settings.FOV)
        fovCircle.BackgroundTransparency = 0.8
        fovCircle.BackgroundColor3 = COLORS.Primary
        fovCircle.BorderSizePixel = 0
        
        local UICorner = Instance.new("UICorner")
        UICorner.Parent = fovCircle
        UICorner.CornerRadius = UDim.new(1, 0)
    end
end

-- Atualizar slider
local function updateSlider(value)
    Settings.FOV = math.clamp(value, 0, 700)
    SliderFill.Size = UDim2.new(Settings.FOV / 700, 0, 1, 0)
    SliderButton.Position = UDim2.new(Settings.FOV / 700, -10, -0.5, 0)
    SliderLabel.Text = "FOV CIRCLE: " .. Settings.FOV
    updateFOVCircle()
end

-- Controles do slider
local sliding = false

SliderButton.MouseButton1Down:Connect(function()
    sliding = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
        updateSlider(math.floor(relativeX * 700))
    end
end)

-- Sistema de arrastar
local dragging = false
local dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Botões
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    ContentFrame.Visible = not ContentFrame.Visible
    if ContentFrame.Visible then
        MainFrame.Size = UDim2.new(0, 300, 0, 350)
        MinimizeButton.Text = "_"
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 35)
        MinimizeButton.Text = "+"
    end
end)

-- AIMBOT SIMPLES (Para teste)
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        -- Sistema básico de aimbot para teste
        local closestPlayer = nil
        local closestDistance = Settings.FOV
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local character = player.Character
                local humanoid = character:FindFirstChild("Humanoid")
                local hitPart = character:FindFirstChild(Settings.HitPart)
                
                if humanoid and humanoid.Health > 0 and hitPart then
                    -- Team check
                    if Settings.TeamCheck and player.Team == LocalPlayer.Team then
                        continue
                    end
                    
                    -- Posição na tela
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                    
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
        
        if closestPlayer then
            -- Aqui iria a lógica de mover a mira
            -- Por enquanto só mostra no console
            print("🎯 Mirando em: " .. closestPlayer.Name .. " | Distância: " .. math.floor(closestDistance))
        end
    end
end)

-- Inicializar
updateFOVCircle()
print("🚀 CYBER-AIM v1.0 CARREGADO!")
print("👤 by vgzinsk0")

-- Touch controls para mobile
SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local relativeX = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
        updateSlider(math.floor(relativeX * 700))
    end
end)

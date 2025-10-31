-- Painel Aimbot Profissional by vgzinsk0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configurações com toggle
local Settings = {
    Aimbot = false,
    TeamCheck = true,
    WallCheck = true,
    FOV = 100,
    Smoothness = 0.1
}

-- Variáveis do painel
local dragging = false
local dragInput, dragStart, startPos
local minimized = false
local originalSize

-- Criar o painel principal
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")

-- Configurar a GUI
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "AimbotPanel"

-- Frame principal
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0, 50, 0, 50)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Topbar arrastável
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopBar.BorderSizePixel = 0

-- Título
Title.Parent = TopBar
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Aimbot Pro - vgzinsk0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Botão fechar
CloseButton.Parent = TopBar
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12

-- Botão minimizar
MinimizeButton.Parent = TopBar
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 12

-- Frame de conteúdo
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1

-- Função para criar toggle buttons
local function createToggle(name, setting, yPosition)
    local ToggleFrame = Instance.new("Frame")
    local ToggleButton = Instance.new("TextButton")
    local ToggleLabel = Instance.new("TextLabel")
    local StatusLabel = Instance.new("TextLabel")
    
    ToggleFrame.Parent = ContentFrame
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.Position = UDim2.new(0, 0, 0, yPosition)
    ToggleFrame.BackgroundTransparency = 1
    
    -- Botão toggle (caixinha)
    ToggleButton.Parent = ToggleFrame
    ToggleButton.Size = UDim2.new(0, 25, 0, 25)
    ToggleButton.Position = UDim2.new(0, 0, 0, 0)
    ToggleButton.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
    ToggleButton.BorderSizePixel = 1
    ToggleButton.BorderColor3 = Color3.fromRGB(150, 150, 150)
    ToggleButton.Text = ""
    
    -- Label da função
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.Size = UDim2.new(0, 150, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 35, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 12
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Status (ON/OFF)
    StatusLabel.Parent = ToggleFrame
    StatusLabel.Size = UDim2.new(0, 40, 1, 0)
    StatusLabel.Position = UDim2.new(1, -40, 0, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = Settings[setting] and "ON" or "OFF"
    StatusLabel.TextColor3 = Settings[setting] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.GothamBold
    
    -- Função de clique
    ToggleButton.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        ToggleButton.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
        StatusLabel.Text = Settings[setting] and "ON" or "OFF"
        StatusLabel.TextColor3 = Settings[setting] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
        print("🔧 " .. name .. ": " .. (Settings[setting] and "ATIVADO" or "DESATIVADO"))
    end)
    
    return ToggleFrame
end

-- Função para criar slider de FOV
local function createFOVSlider()
    local SliderFrame = Instance.new("Frame")
    local SliderLabel = Instance.new("TextLabel")
    local SliderBar = Instance.new("Frame")
    local SliderButton = Instance.new("TextButton")
    local ValueLabel = Instance.new("TextLabel")
    
    SliderFrame.Parent = ContentFrame
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.Position = UDim2.new(0, 0, 0, 120)
    SliderFrame.BackgroundTransparency = 1
    
    -- Label
    SliderLabel.Parent = SliderFrame
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.Position = UDim2.new(0, 0, 0, 0)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = "FOV (0-700):"
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 12
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Barra do slider
    SliderBar.Parent = SliderFrame
    SliderBar.Size = UDim2.new(1, 0, 0, 10)
    SliderBar.Position = UDim2.new(0, 0, 0, 25)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    SliderBar.BorderSizePixel = 0
    
    -- Botão deslizante
    SliderButton.Parent = SliderBar
    SliderButton.Size = UDim2.new(0, 15, 1, 4)
    SliderButton.Position = UDim2.new((Settings.FOV / 700) - 0.02, 0, 0, -2)
    SliderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    
    -- Valor atual
    ValueLabel.Parent = SliderFrame
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -50, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(Settings.FOV)
    ValueLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    ValueLabel.TextSize = 12
    ValueLabel.Font = Enum.Font.GothamBold
    
    -- Função de arrastar
    local dragging = false
    
    local function updateSlider(input)
        local relativeX = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        Settings.FOV = math.floor(relativeX * 700)
        SliderButton.Position = UDim2.new(relativeX - 0.02, 0, 0, -2)
        ValueLabel.Text = tostring(Settings.FOV)
    end
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    SliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return SliderFrame
end

-- Criar os toggle buttons
createToggle("Aimbot", "Aimbot", 0)
createToggle("Team Check", "TeamCheck", 30)
createToggle("Wall Check", "WallCheck", 60)

-- Criar slider de FOV
createFOVSlider()

-- Sistema de arrastar
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Botão fechar
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    print("🔒 Painel fechado")
end)

-- Botão minimizar
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ContentFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 320, 0, 30)
        MinimizeButton.Text = "+"
    else
        ContentFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 320, 0, 400)
        MinimizeButton.Text = "_"
    end
end)

-- Aimbot system (básico para teste)
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        -- Aqui vai a lógica do aimbot
        -- Por enquanto só mostra no console
        print("🎯 Aimbot ativo - FOV: " .. Settings.FOV)
    end
end)

print("🎮 Painel Aimbot carregado!")
print("👤 Criado por: vgzinsk0")

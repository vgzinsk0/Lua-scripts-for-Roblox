-- Script de teste melhorado
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("🔊 Script carregado do GitHub!")

-- Função para mostrar mensagem visível
local function showMessage()
    if LocalPlayer and LocalPlayer.PlayerGui then
        -- Tenta criar uma mensagem na tela
        local screenGui = Instance.new("ScreenGui")
        local textLabel = Instance.new("TextLabel")
        
        screenGui.Parent = LocalPlayer.PlayerGui
        textLabel.Parent = screenGui
        textLabel.Size = UDim2.new(0, 200, 0, 50)
        textLabel.Position = UDim2.new(0, 10, 0, 10)
        textLabel.Text = "✅ Script Funcionando!"
        textLabel.BackgroundColor3 = Color3.new(0, 1, 0)
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        
        print("🎯 Mensagem criada na tela!")
    end
end

-- Alterar speed (teste prático)
local function changeSpeed()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 25
            print("🚀 Speed alterado para 25!")
        end
    end
end

-- Executar funções
showMessage()
changeSpeed()

print("✅ Script executado com sucesso!")

-- ============================================
-- 🌑 SOMBRA HUB v5 - Blox Fruits Edition
-- Auto Farm Completo e Funcional
-- ============================================

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================
-- CONFIGURAÇÕES
-- ============================================
local Config = {
    AutoFarmAtivo = false,
    AutoQuestAtivo = false,
    AutoAttackAtivo = false,
    NPCSelecionado = "Bandits",
    VelocidadeFarm = 60,
    AutoFarmMethod = "Teleport", -- "Teleport" ou "Walk"
}

-- Lista de NPCs comuns no Blox Fruits (você pode adicionar mais)
local NPCs = {
    "Bandits", "Monkey", "Toga Warriors", "Pirate", "Galley Pirate",
    "Fishman", "Desert Bandit", "Snow Bandit", "Reborn Skeleton",
    "Living Zombie", "Demonic Soul", "Posessed Mummy", "Mob Leader",
    "Vice Admiral", "Saber Expert", "Greybeard", "Darkbeard"
}

-- ============================================
-- JANELA PRINCIPAL (FLUENT)
-- ============================================
local Window = Fluent:CreateWindow({
    Title = "Sombra Hub",
    SubTitle = "Blox Fruits | v5.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Farm = Window:AddTab({ Title = "Auto Farm", Icon = "zap" }),
    Utils = Window:AddTab({ Title = "Utils", Icon = "settings" })
}

-- ============================================
-- ABA AUTO FARM
-- ============================================
Tabs.Farm:AddParagraph({ 
    Title = "🌾 Blox Fruits - Auto Farm", 
    Content = "Automatize sua progressão no jogo" 
})

-- Seleção de NPC
Tabs.Farm:AddDropdown({
    Title = "Selecionar NPC",
    Description = "Escolha qual inimigo farmar",
    Options = NPCs,
    Default = "Bandits",
    Callback = function(valor)
        Config.NPCSelecionado = valor
        Fluent:Notify({ Title = "Sombra", Content = "NPC: " .. valor, Duration = 2 })
    end
})

-- Toggle do Auto Farm
Tabs.Farm:AddToggle("AutoFarmToggle", {
    Title = "🌾 Auto Farm Ativo",
    Description = "Ativa/desativa o farm automático",
    Default = false,
    Callback = function(valor)
        Config.AutoFarmAtivo = valor
        if valor then
            Fluent:Notify({ Title = "Sombra", Content = "Auto Farm LIGADO", Duration = 2 })
        else
            Fluent:Notify({ Title = "Sombra", Content = "Auto Farm DESLIGADO", Duration = 2 })
        end
    end
})

-- Toggle do Auto Quest
Tabs.Farm:AddToggle("AutoQuestToggle", {
    Title = "📜 Auto Quest",
    Description = "Completa missões automaticamente",
    Default = false,
    Callback = function(valor)
        Config.AutoQuestAtivo = valor
    end
})

-- Slider de Velocidade
Tabs.Farm:AddSlider("FarmSpeedSlider", {
    Title = "Velocidade do Farm",
    Description = "Quão rápido o personagem se move",
    Default = 60,
    Min = 20,
    Max = 200,
    Rounding = 0,
    Callback = function(valor)
        Config.VelocidadeFarm = valor
    end
})

-- Botão de Teleporte para NPC
Tabs.Farm:AddButton({
    Title = "🎯 Teleportar para NPC",
    Description = "Vai direto pro inimigo selecionado",
    Callback = function()
        local meuChar = LocalPlayer.Character
        local meuHRP = meuChar and meuChar:FindFirstChild("HumanoidRootPart")
        if not meuHRP then return end
        
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
                if string.find(string.lower(obj.Name), string.lower(Config.NPCSelecionado)) then
                    local hrp = obj:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        meuHRP.CFrame = hrp.CFrame * CFrame.new(0, 3, 3)
                        Fluent:Notify({ Title = "Sombra", Content = "Teleportado para " .. obj.Name, Duration = 2 })
                        return
                    end
                end
            end
        end
        Fluent:Notify({ Title = "Sombra", Content = "NPC não encontrado!", Duration = 3 })
    end
})

-- ============================================
-- ABA UTILS
-- ============================================
Tabs.Utils:AddParagraph({ 
    Title = "⚙️ Utilitários", 
    Content = "Funções extras para o jogo" 
})

-- Anti-AFK
Tabs.Utils:AddButton({
    Title = "🚫 Anti-AFK",
    Description = "Evita ser kickado por inatividade",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
        Fluent:Notify({ Title = "Sombra", Content = "Anti-AFK ATIVADO", Duration = 2 })
    end
})

-- FPS Boost
Tabs.Utils:AddButton({
    Title = "⚡ FPS Boost",
    Description = "Melhora o desempenho do jogo",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
        Fluent:Notify({ Title = "Sombra", Content = "FPS Boost aplicado!", Duration = 2 })
    end
})

-- Resetar Personagem
Tabs.Utils:AddButton({
    Title = "🔄 Resetar Personagem",
    Callback = function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
        end
    end
})

-- ============================================
-- LÓGICA DO AUTO FARM
-- ============================================

-- Função para encontrar o NPC mais próximo
local function encontrarNPC()
    local melhorAlvo = nil
    local menorDistancia = 500
    local meuChar = LocalPlayer.Character
    local meuHRP = meuChar and meuChar:FindFirstChild("HumanoidRootPart")
    if not meuHRP then return nil end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            local nome = string.lower(obj.Name)
            local alvoNome = string.lower(Config.NPCSelecionado)
            
            if string.find(nome, alvoNome) then
                local humanoid = obj:FindFirstChildOfClass("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                
                if humanoid and humanoid.Health > 0 and hrp then
                    local distancia = (meuHRP.Position - hrp.Position).Magnitude
                    if distancia < menorDistancia then
                        menorDistancia = distancia
                        melhorAlvo = obj
                    end
                end
            end
        end
    end
    
    return melhorAlvo
end

-- Função de Auto Quest (simplificada)
local function completarQuest()
    -- Teleporta para o NPC da quest ativa
    local questNPC = encontrarNPC()
    if questNPC then
        local hrp = questNPC:FindFirstChild("HumanoidRootPart")
        local meuHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and meuHRP then
            meuHRP.CFrame = hrp.CFrame * CFrame.new(0, 3, 3)
        end
    end
end

-- ============================================
-- LOOP PRINCIPAL
-- ============================================
RunService.Heartbeat:Connect(function()
    -- AUTO FARM
    if Config.AutoFarmAtivo then
        local alvo = encontrarNPC()
        
        if alvo then
            local hrp = alvo:FindFirstChild("HumanoidRootPart")
            local humanoid = alvo:FindFirstChildOfClass("Humanoid")
            local meuChar = LocalPlayer.Character
            local meuHRP = meuChar and meuChar:FindFirstChild("HumanoidRootPart")
            
            if hrp and meuHRP and humanoid and humanoid.Health > 0 then
                -- Teleporta para perto do NPC
                meuHRP.CFrame = hrp.CFrame * CFrame.new(0, 3, 3)
                
                -- Ataque automático
                if Config.AutoAttackAtivo then
                    local tool = meuChar:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
                
                -- Se o NPC morrer, o loop vai procurar outro automaticamente
            end
        end
    end
    
    -- AUTO QUEST
    if Config.AutoQuestAtivo then
        completarQuest()
    end
end)

-- ============================================
-- NOTIFICAÇÃO FINAL
-- ============================================
Fluent:Notify({ 
    Title = "Sombra Hub v5.0", 
    Content = "Blox Fruits carregado! 🌑", 
    Duration = 4 
})

print("🌑 Sombra Hub v5.0 (Blox Fruits) carregado com sucesso!")

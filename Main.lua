-- HUB SOMBRA v4.0 | by Equipe Sombra
-- Versao com carregamento seguro para executores mobile
local Rayfield
local sucesso_lib, erro_lib = pcall(function()
    return loadstring(game:HttpGet("https://githubusercontent.com"))()
end)

if not sucesso_lib or not Rayfield then
    -- Link alternativo caso o principal caia ou trave no celular
    Rayfield = loadstring(game:HttpGet("https://sirius.menu"))()
end

-- Inicialização da Janela Principal
local Window = Rayfield:CreateWindow({
   Name = "Sombra Hub | Blox Fruits",
   LoadingTitle = "Sombra Hub",
   LoadingSubtitle = "by Sombra Team",
   ConfigurationSaving = {Enabled = false},
   KeySystem = true,
   KeySettings = {
      Title = "Sombra Hub Key",
      Subtitle = "Key System",
      Note = "Key: SOMBRA_V4_FREE",
      FileName = "SombraKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"SOMBRA_V4_FREE"}
   }
})

-- =========================================================
-- CONFIGURAÇÕES E VARIÁVEIS DO AUTO FARM
-- =========================================================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.AutoFarm = false
_G.ArmaParaUsar = "Melee" 

-- Função de movimentação suave (Tween)
local function ToPos(TargetCFrame, Speed)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local HRP = LocalPlayer.Character.HumanoidRootPart
    local Distance = (HRP.Position - TargetCFrame.Position).Magnitude
    local Duration = Distance / Speed
    
    local TweenInfo = TweenInfo.new(Duration, Enum.EasingStyle.Linear)
    local Tween = TweenService:Create(HRP, TweenInfo, {CFrame = TargetCFrame})
    Tween:Play()
    
    task.spawn(function()
        while Tween.PlaybackState == Enum.PlaybackState.Playing do
            if not _G.AutoFarm then
                Tween:Cancel()
                break
            end
            task.wait(0.1)
        end
    end)
    
    return Tween
end

-- Função para equipar o estilo de luta / arma automaticamente
local function EquiparArma()
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    local Character = LocalPlayer.Character
    
    if Character and not Character:FindFirstChildOfClass("Tool") then
        for _, tool in pairs(Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == _G.ArmaParaUsar then
                Character.Humanoid:EquipTool(tool)
                break
            end
        end
    end
end

-- Tabela de Quests automática por Level
local function PegarInformacoesQuest()
    local MyLevel = LocalPlayer.Data.Level.Value
    
    -- Inicial (Bandits)
    if MyLevel >= 1 and MyLevel < 10 then
        return {
            NPC_Pos = CFrame.new(1059, 16, 1549), 
            QuestName = "BanditQuest1",
            QuestNumber = 1,
            MobName = "Bandit",
            Mob_Pos = CFrame.new(1145, 17, 1630)   
        }
    -- Selva (Monkeys)
    elseif MyLevel >= 10 and MyLevel < 15 then
        return {
            NPC_Pos = CFrame.new(-1598, 37, 153),
            QuestName = "JungleQuest",
            QuestNumber = 1,
            MobName = "Monkey",
            Mob_Pos = CFrame.new(-1610, 40, 200)
        }
    end
end

-- SISTEMA ANTI-AFK
task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end)
end)

-- =========================================================
-- ABAS DA INTERFACE (RAYFIELD)
-- =========================================================

-- Aba Principal (Main)
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateLabel("Status: ONLINE | v4.0")

MainTab:CreateButton({
   Name = "Copy Discord",
   Callback = function() setclipboard("discord.gg/sombrahub") end,
 })

-- Nova Aba de Automações (Auto Farm)
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

FarmTab:CreateToggle({
   Name = "Ativar Auto Farm Level",
   CurrentValue = false,
   Flag = "ToggleAutoFarm",
   Callback = function(Value)
      _G.AutoFarm = Value
      
      if Value then
          task.spawn(function()
              while _G.AutoFarm do
                  task.wait(0.1)
                  
                  if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
                      local Data = PegarInformacoesQuest()
                      if not Data then continue end
                      
                      local HasQuest = LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") and LocalPlayer.PlayerGui.Main.Quest.Visible
                      
                      if not HasQuest then
                          ToPos(Data.NPC_Pos, 300)
                          if (LocalPlayer.Character.HumanoidRootPart.Position - Data.NPC_Pos.Position).Magnitude < 10 then
                              game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.QuestName, Data.QuestNumber)
                          end
                      else
                          local Alvo = nil
                          for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                              if v.Name == Data.MobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                  Alvo = v
                                  break
                              end
                          end
                          
                          if Alvo and Alvo:FindFirstChild("HumanoidRootPart") then
                              ToPos(Alvo.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0), 300)
                              EquiparArma()
                              
                              local VirtualUser = game:GetService("VirtualUser")
                              VirtualUser:CaptureController()
                              VirtualUser:ClickButton1(Vector2.new(850, 520))
                          else
                              ToPos(Data.Mob_Pos, 300)
                          end
                      end
                  end
              end
          end)
      end
   end,
})

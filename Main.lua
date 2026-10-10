-- SOMBRA HUB v4.0 | by Sombra Team
-- Main Loader

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Sombra Hub | Blox Fruits",
   LoadingTitle = "Sombra Hub",
   LoadingSubtitle = "by Sombra Team",
   ConfigurationSaving = { Enabled = true, FolderName = "SombraHub", FileName = "Config" },
   KeySystem = true,
   KeySettings = {
      Title = "Sombra Hub Key",
      Subtitle = "Get key in Discord",
      Note = "Join discord.gg/sombrahub",
      FileName = "SombraKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"SOMBRA_V4_FREE"} -- muda tua key aqui
   }
})

-- Abas
local MainTab = Window:CreateTab("Main", 4483362458)
local FarmTab = Window:CreateTab("Farm", 4483362458)

MainTab:CreateLabel("Sombra Hub v4.0 - Status: ONLINE 🟣")

MainTab:CreateButton({
   Name = "Copy Discord",
   Callback = function()
       setclipboard("discord.gg/sombrahub")
       Rayfield:Notify({Title = "Sombra Hub", Content = "Discord copiado!", Duration = 3})
   end,
})

-- Exemplo de toggle (sem função cheat, só template)
FarmTab:CreateToggle({
   Name = "Auto Farm Template",
   CurrentValue = false,
   Callback = function(Value)
       -- COLOCA TUA LÓGICA DE FARM AQUI
       print("Auto Farm:", Value)
   end,
})

Rayfield:Notify({Title = "Sombra Hub Loaded", Content = "v4.0 Loaded Successfully!", Duration = 5})

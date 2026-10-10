local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
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
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateLabel("Sombra Hub v4.0 - ONLINE")
MainTab:CreateButton({
   Name = "Copy Discord",
   Callback = function() setclipboard("discord.gg/sombrahub") end,
})
Rayfield:Notify({Title = "Sombra Hub", Content = "Loaded!", Duration = 3})

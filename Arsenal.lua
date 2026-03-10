local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Arsenal Ultra Hub | 2026 Edition",
   LoadingTitle = "Carregando Protocolos...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = true, Folder = "ArsenalGemini" }
})

-- Variáveis de Controle
local _G = {
    AimbotEnabled = false,
    TeamCheck = true,
    ESPEnabled = false,
    FOV = 150
}

-- Funções Auxiliares
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function GetClosestPlayer()
    local MaximumDistance = _G.FOV
    local Target = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- 1. Check de Time
            if _G.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            -- 2. Check de Vida e Personagem
            if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                
                -- 3. Check de Void (Evita travar em quem caiu)
                if player.Character.HumanoidRootPart.Position.Y < -50 then continue end
                
                local ScreenPoint = Camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
                local VectorDistance = (Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X, game:GetService("UserInputService"):GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                
                if VectorDistance < MaximumDistance then
                    Target = player
                    MaximumDistance = VectorDistance
                end
            end
        end
    end
    return Target
end

-- UI Tabs
local MainTab = Window:CreateTab("Combate", 4483362458)

MainTab:CreateToggle({
   Name = "Ativar Aimbot",
   CurrentValue = false,
   Callback = function(Value)
      _G.AimbotEnabled = Value
   end,
})

MainTab:CreateToggle({
   Name = "Team Check (Não focar amigos)",
   CurrentValue = true,
   Callback = function(Value)
      _G.TeamCheck = Value
   end,
})

MainTab:CreateSlider({
   Name = "Aimbot FOV",
   Range = {50, 800},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 150,
   Callback = function(Value)
      _G.FOV = Value
   end,
})

-- Loop do Aimbot (Otimizado)
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
    end
end)

Rayfield:Notify({
   Title = "Script Ativado",
   Content = "Bom jogo! Lembre-se: use com cautela.",
   Duration = 5,
   Image = 4483362458,
})

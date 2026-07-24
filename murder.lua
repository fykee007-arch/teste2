local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "# Murder Nice",
   LoadingTitle = "Murder Mystery 2",
   LoadingSubtitle = "by Grok",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false,
})

local player = Players.LocalPlayer

-- ==================== VARIÁVEIS ====================
local highlights = {}

local ESP = {
    Entities = {Enabled = false, Color = Color3.fromHex("#ff1100")},   -- Murderer
    Sheriff = {Enabled = false, Color = Color3.fromHex("#5696e3")},   -- Xerife (novo)
    Players = {Enabled = false, Color = Color3.fromHex("#c452c4")}
}

local InfiniteStaminaEnabled = false

-- ==================== FUNÇÕES ====================
local function ClearHighlights()
    for _, hl in ipairs(highlights) do
        pcall(function() hl:Destroy() end)
    end
    highlights = {}
end

local function CreateHighlight(target, color)
    if not target or target:FindFirstChild("MM2ESP") then return end
    
    local hl = Instance.new("Highlight")
    hl.Name = "MM2ESP"
    hl.Adornee = target
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = 0.8
    hl.OutlineTransparency = 0.25
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = target
    table.insert(highlights, hl)
end

-- Detecção por Inventário (mais confiável no MM2)
local function GetRole(plr)
    if not plr or plr == player then return "None" end
    
    local backpack = plr:FindFirstChild("Backpack")
    local character = plr.Character
    
    -- Verificar Backpack
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("knife") or name:find("murd") then
                    return "Murderer"
                end
                if name:find("gun") or name:find("pistol") or name:find("sheriff") then
                    return "Sheriff"
                end
            end
        end
    end
    
    -- Verificar Character
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("knife") or name:find("murd") then
                    return "Murderer"
                end
                if name:find("gun") or name:find("pistol") or name:find("sheriff") then
                    return "Sheriff"
                end
            end
        end
    end
    
    return "Innocent"
end

local function UpdateESP()
    ClearHighlights()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == player or not plr.Character then continue end
        
        local role = GetRole(plr)
        
        -- Murderer
        if ESP.Entities.Enabled and role == "Murderer" then
            CreateHighlight(plr.Character, ESP.Entities.Color)
        end
        
        -- Sheriff (Xerife)
        if ESP.Sheriff.Enabled and role == "Sheriff" then
            CreateHighlight(plr.Character, ESP.Sheriff.Color)
        end
        
        -- Todos os Players
        if ESP.Players.Enabled then
            CreateHighlight(plr.Character, ESP.Players.Color)
        end
    end
end

local function StartInfiniteStamina()
    task.spawn(function()
        while InfiniteStaminaEnabled do
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:SetAttribute("Stamina", 100)
                    humanoid:SetAttribute("SprintSpeed", 100)
                end
            end
            task.wait(0.1)
        end
    end)
end

-- ==================== MONEY ====================
local function AddMoney(amount)
    if not amount or amount <= 0 then 
        Rayfield:Notify({Title = "Erro", Content = "Digite um valor válido!", Duration = 3})
        return 
    end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local moneyValue = leaderstats:FindFirstChild("Money") or leaderstats:FindFirstChild("Coins") or leaderstats:FindFirstChild("Cash")
        if moneyValue then
            moneyValue.Value = moneyValue.Value + amount
            Rayfield:Notify({Title = "Sucesso!", Content = "Adicionado +" .. amount .. "!", Duration = 4})
        else
            Rayfield:Notify({Title = "Erro", Content = "Não foi possível encontrar o dinheiro.", Duration = 4})
        end
    end
end

-- ==================== UI ====================
local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local EspTab = Window:CreateTab("ESP", 4483362458)
local StaminaTab = Window:CreateTab("Stamina", 6031097228)
local MoneyTab = Window:CreateTab("💰 Money", 6031097228)

-- Main Tab
MainTab:CreateSection("Murder Nice")

-- ==================== ABA ESP ====================
EspTab:CreateSection("Visualizar Murderer")

EspTab:CreateToggle({
   Name = "Visualizar Murderer",
   CurrentValue = false,
   Callback = function(Value)
      ESP.Entities.Enabled = Value
   end,
})

EspTab:CreateColorPicker({
   Name = "Cor do Murderer",
   Color = ESP.Entities.Color,
   Callback = function(Value)
      ESP.Entities.Color = Value
   end,
})

EspTab:CreateSection("Visualizar Xerife")

EspTab:CreateToggle({
   Name = "Visualizar Xerife",
   CurrentValue = false,
   Callback = function(Value)
      ESP.Sheriff.Enabled = Value
   end,
})

EspTab:CreateColorPicker({
   Name = "Cor do Xerife",
   Color = ESP.Sheriff.Color,
   Callback = function(Value)
      ESP.Sheriff.Color = Value
   end,
})

EspTab:CreateSection("Visualizar Players")

EspTab:CreateToggle({
   Name = "Visualizar Todos os Players",
   CurrentValue = false,
   Callback = function(Value)
      ESP.Players.Enabled = Value
   end,
})

EspTab:CreateColorPicker({
   Name = "Cor dos Players",
   Color = ESP.Players.Color,
   Callback = function(Value)
      ESP.Players.Color = Value
   end,
})

-- Stamina Tab
StaminaTab:CreateSection("Stamina")

StaminaTab:CreateToggle({
   Name = "Stamina Infinita",
   CurrentValue = false,
   Callback = function(Value)
      InfiniteStaminaEnabled = Value
      if Value then
         StartInfiniteStamina()
      end
   end,
})

-- Money Tab
MoneyTab:CreateSection("Adicionar Dinheiro")

local MoneyInput = MoneyTab:CreateInput({
   Name = "Quantidade de Dinheiro",
   PlaceholderText = "Digite o valor (ex: 5000)",
   RemoveTextOnFocusLost = false,
   Callback = function() end,
})

MoneyTab:CreateButton({
   Name = "+ Adicionar Dinheiro",
   Callback = function()
      local amount = tonumber(MoneyInput.CurrentValue)
      if amount then
         AddMoney(amount)
      else
         Rayfield:Notify({Title = "Erro", Content = "Digite um número válido!", Duration = 3})
      end
   end,
})

-- ==================== LOOP ====================
RunService.RenderStepped:Connect(function()
    if ESP.Entities.Enabled or ESP.Sheriff.Enabled or ESP.Players.Enabled then
        UpdateESP()
    else
        ClearHighlights()
    end
end)

Rayfield:Notify({
   Title = "Murder Nice",
   Content = "Script carregado com sucesso!",
   Duration = 5,
})

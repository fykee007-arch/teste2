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
    Items = {Enabled = false, Color = Color3.fromHex("#0dbf25")},
    Entities = {Enabled = false, Color = Color3.fromHex("#ff1100")},
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

local function GetValuableItems()
    local items = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") or obj.Name:find("Gun") or obj.Name:find("Knife") or 
           obj.Name:find("Sheriff") or obj.Name:find("Murder") then
            if obj:FindFirstChild("Handle") then
                table.insert(items, obj.Handle)
            end
        end
    end
    return items
end

local function GetMurderer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local ls = plr:FindFirstChild("leaderstats")
            if ls then
                for _, v in pairs(ls:GetChildren()) do
                    if v:IsA("StringValue") then
                        local val = v.Value:lower()
                        if val:find("murder") then 
                            return plr.Character 
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function UpdateESP()
    ClearHighlights()

    if ESP.Items.Enabled then
        for _, item in ipairs(GetValuableItems()) do
            CreateHighlight(item, ESP.Items.Color)
        end
    end

    if ESP.Entities.Enabled then
        local murderer = GetMurderer()
        if murderer then
            CreateHighlight(murderer, ESP.Entities.Color)
        end
    end

    if ESP.Players.Enabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                CreateHighlight(plr.Character, ESP.Players.Color)
            end
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

-- ==================== NOVA FUNÇÃO MONEY ====================
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
            Rayfield:Notify({
                Title = "Sucesso!", 
                Content = "Adicionado +" .. amount .. " de dinheiro!", 
                Duration = 4
            })
        else
            Rayfield:Notify({Title = "Erro", Content = "Não foi possível encontrar sua quantia de dinheiro.", Duration = 4})
        end
    else
        Rayfield:Notify({Title = "Erro", Content = "Leaderstats não encontrado.", Duration = 4})
    end
end

-- ==================== UI ====================
local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local EspTab = Window:CreateTab("ESP", 4483362458)
local StaminaTab = Window:CreateTab("Stamina", 6031097228)
local MoneyTab = Window:CreateTab("💰 Money", 6031097228)  -- Nova aba

-- ==================== ABA MAIN (mantida) ====================
MainTab:CreateSection("Informações")
MainTab:CreateParagraph({
    Title = "Murder Nice",
    Content = "Script feito para Murder Mystery 2"
})

-- ==================== ABA ESP ====================
EspTab:CreateSection("Visualizar Itens")

EspTab:CreateToggle({
   Name = "Visualizar Itens",
   CurrentValue = false,
   Callback = function(Value)
      ESP.Items.Enabled = Value
   end,
})

EspTab:CreateColorPicker({
   Name = "Cor dos Itens",
   Color = ESP.Items.Color,
   Callback = function(Value)
      ESP.Items.Color = Value
   end,
})

EspTab:CreateSection("Visualizar Entidades")

EspTab:CreateToggle({
   Name = "Visualizar Entidades (Murderer)",
   CurrentValue = false,
   Callback = function(Value)
      ESP.Entities.Enabled = Value
   end,
})

EspTab:CreateColorPicker({
   Name = "Cor das Entidades",
   Color = ESP.Entities.Color,
   Callback = function(Value)
      ESP.Entities.Color = Value
   end,
})

EspTab:CreateSection("Visualizar Players")

EspTab:CreateToggle({
   Name = "Visualizar Players",
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

-- ==================== ABA STAMINA ====================
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

-- ==================== NOVA ABA MONEY ====================
MoneyTab:CreateSection("Adicionar Dinheiro")

local MoneyInput = MoneyTab:CreateInput({
   Name = "Quantidade de Dinheiro",
   PlaceholderText = "Digite o valor (ex: 5000)",
   RemoveTextOnFocusLost = false,
   Callback = function(Text)
      -- Não faz nada aqui, só captura o texto
   end,
})

MoneyTab:CreateButton({
   Name = "+ Adicionar Dinheiro",
   Callback = function()
      local amount = tonumber(MoneyInput.CurrentValue)
      if amount then
         AddMoney(amount)
      else
         Rayfield:Notify({Title = "Erro", Content = "Por favor, digite um número válido!", Duration = 3})
      end
   end,
})

-- ==================== LOOP ====================
RunService.RenderStepped:Connect(function()
    if ESP.Items.Enabled or ESP.Entities.Enabled or ESP.Players.Enabled then
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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

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

local MainTab = Window:CreateTab("🏠 Main", 4483362458)

-- Variáveis ESP
local ESP_All = false
local ESP_Roles = false
local Color_All = Color3.fromHex("#00bf63")  -- Cor padrão dos jogadores
local Color_Murder = Color3.fromHex("#c90e0e")
local Color_Sheriff = Color3.fromHex("#5696e3")

local highlights = {}

local function ClearHighlights()
	for _, hl in ipairs(highlights) do pcall(function() hl:Destroy() end) end
	highlights = {}
end

local function CreateHighlight(char, color)
	if not char or char:FindFirstChild("MM2ESP") then return end
	local hl = Instance.new("Highlight")
	hl.Name = "MM2ESP"
	hl.Adornee = char
	hl.FillColor = color
	hl.OutlineColor = color
	hl.FillTransparency = 0.7
	hl.OutlineTransparency = 0.3
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = char
	table.insert(highlights, hl)
end

local function GetRole(plr)
	local ls = plr:FindFirstChild("leaderstats")
	if ls then
		local role = ls:FindFirstChild("Role") or ls:FindFirstChild("role")
		if role then
			local r = tostring(role.Value):lower()
			if r:find("murder") then return "Murderer" end
			if r:find("sheriff") or r:find("xerife") then return "Sheriff" end
		end
	end
	return "Innocent"
end

local function UpdateESP()
	ClearHighlights()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == player or not plr.Character then continue end
		local role = GetRole(plr)
		if ESP_All then CreateHighlight(plr.Character, Color_All) end
		if ESP_Roles then
			if role == "Murderer" then CreateHighlight(plr.Character, Color_Murder)
			elseif role == "Sheriff" then CreateHighlight(plr.Character, Color_Sheriff) end
		end
	end
end

RunService.RenderStepped:Connect(function()
	if ESP_All or ESP_Roles then UpdateESP() else ClearHighlights() end
end)

-- Interface
MainTab:CreateSection("ESP")

MainTab:CreateToggle({
   Name = "Visualizar Todos os Jogadores",
   CurrentValue = false,
   Callback = function(Value)
      ESP_All = Value
   end,
})

-- Color Picker para Jogadores
MainTab:CreateColorPicker({
   Name = "Cor dos Jogadores",
   Color = Color_All,
   Callback = function(Value)
      Color_All = Value
   end,
})

MainTab:CreateToggle({
   Name = "Visualizar Murder & Xerife",
   CurrentValue = false,
   Callback = function(Value)
      ESP_Roles = Value
   end,
})

Rayfield:Notify({
   Title = "Sucesso!",
   Content = "Menu carregado - Use os toggles acima",
   Duration = 6,
})

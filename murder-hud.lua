local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "# Murder Nice",
   LoadingTitle = "Murder Mystery 2",
   LoadingSubtitle = "by Grok",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("🏠 Main", 4483362458)

-- ESP Section
MainTab:CreateSection("ESP")

local ToggleAll = MainTab:CreateToggle({
   Name = "Visualizar Jogadores",
   CurrentValue = false,
   Callback = function(Value)
      ESP_All = Value
   end,
})

local ToggleRoles = MainTab:CreateToggle({
   Name = "Visualizar Murder & Xerife",
   CurrentValue = false,
   Callback = function(Value)
      ESP_Roles = Value
   end,
})

-- Cores (usando Dropdown como exemplo)
MainTab:CreateSection("Cores")

local AllColorDropdown = MainTab:CreateDropdown({
   Name = "Cor dos Jogadores",
   Options = {"Verde", "Azul", "Roxo", "Amarelo"},
   CurrentOption = {"Verde"},
   MultipleOptions = false,
   Callback = function(Option)
      if Option[1] == "Verde" then Color_All = Color3.fromHex("#00bf63")
      elseif Option[1] == "Azul" then Color_All = Color3.fromHex("#5696e3")
      elseif Option[1] == "Roxo" then Color_All = Color3.fromHex("#c452c4")
      elseif Option[1] == "Amarelo" then Color_All = Color3.fromHex("#ffd700") end
   end,
})

-- ESP Logic
local ESP_All = false
local ESP_Roles = false
local Color_All = Color3.fromHex("#00bf63")
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
	if ESP_All or ESP_Roles then
		UpdateESP()
	else
		ClearHighlights()
	end
end)

Rayfield:Notify({
   Title = "Murder Nice",
   Content = "Script carregado com sucesso!",
   Duration = 5,
   Image = 4483362458,
})

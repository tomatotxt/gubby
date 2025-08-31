-- Max Speed Money Generator API by tomato.txt
-- Modified to use the CherryBomb FoodDamage event

local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local LocalPlayer = Players.LocalPlayer
local PlayerData = ReplicatedStorage.PlayerData
local LocalPlayerData = PlayerData[LocalPlayer.Name]
local MoneyValue = LocalPlayerData.Inventory.Currencies.Money

-- Average money gained from one FoodDamage event call.
-- (9100 + 9450) / 2 = 9275
local MoneyPerCall = 9275 

-- Set up the path to the new remote event and its arguments
local RemoteEvents = ReplicatedStorage.Networking.Server.RemoteEvents
local ChangeSetting = cloneref(RemoteEvents.ChangeSetting)
local FoodDamage = cloneref(RemoteEvents.DamageEvents.FoodDamage)
local foodEventArgs = {
	"CherryBomb",
	vector.create(0, 0, 0)
}

-- This function fires the new FoodDamage event with the correct arguments
local function CallFoodDamage()
	FoodDamage:FireServer(unpack(foodEventArgs))
end

-- Calculates how many times to fire the event and spawns the calls
local function AddMoney(Amount)
    -- Calculate the number of times we need to call the event to reach the desired amount
	local callsNeeded = math.ceil(Amount / MoneyPerCall)
	for i = 1, callsNeeded do
		task.spawn(CallFoodDamage)
	end
end

-- Calculates the difference between the target amount and current money
local function DistanceToAmount(Amount)
	local Result = Amount - MoneyValue.Value
	if Result <= 0 then
		return 0
	end
	return Result
end

-- Sets the player's money to a target amount by adding the difference
local function SetMoney(TargetAmount)
	local amountToAdd = DistanceToAmount(TargetAmount)
	if amountToAdd > 0 then
		AddMoney(amountToAdd)
	end
	-- A final call to ensure the target is met or exceeded
	task.spawn(CallFoodDamage)
end

-- Prevent Lag or Crash by disabling money pop-ups
ChangeSetting:FireServer("ShowMoneyGUIs", false)

-- Expose the functions through the API table
local API = {}
API.AddMoney = AddMoney
API.SetMoney = SetMoney
return API
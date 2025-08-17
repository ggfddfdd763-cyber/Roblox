-- МойПервыйСкрипт.lua
print("Привет от моего скрипта!")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

character.Humanoid.WalkSpeed = 25 -- Увеличиваем скорость ходьбы
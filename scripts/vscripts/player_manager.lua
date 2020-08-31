
function GetPlayerHeroes()
    local heroes = {}
    for i = 0, PlayerResource:GetPlayerCount() do
        local player = PlayerResource:GetPlayer(i)
        if player ~= nil then
            local hero = player:GetAssignedHero()
            if hero ~= nil then
                table.insert(self.heroes, hero)
            end
        end
    end
    return heroes
end


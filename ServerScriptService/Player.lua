

local Player = {}

function Player.new(player)
    local self = {}

    self._Player = player
    self._Game = nil

    return self
end


return Player
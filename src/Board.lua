Board = Class{}


function Board:init(x, y)
    self.x = x
    self.y = y
    self.matches = {}

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}
    for tileY = 1, 8 do
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            table.insert(self.tiles[tileY], Tile(tileX, tileY))
        end
    end

    --[[while self:calculateMatches() do
        self:initializeTiles()
    end--]]
end

function Board:update(dt)

end

function Board:calculateMatches()
    local matches = {}

    local consecutive = 1

    for y = 1, 8 do
        local matchColor = self.tiles[y][1].color

        consecutive = 1

        for x = 2, 8 do

            if self.tiles[y][x].color == matchColor then
                consecutive = consecutive + 1

                if x == 8 and  consecutive >= 3 then
                    local match = {}
                    for matchx = x, x - consecutive, -1 do
                       table.insert(match, self.tiles[y][matchX]) 
                    end
                    table.insert(matches, match)
                end
            else
                matchColor = self.tiles[y][x].color 

                if consecutive >= 3 then
                    local match = {}

                    for matchx = x - 1, x - consecutive, -1 do
                        table.insert(match, self.tiles[y][matchX])
                    end 
                    table.insert(matches, match)
                end
                consecutive = 1
            end
        end
    end

    for x = 1, 8 do
        local matchColor = self.tiles[1][x].color
        consecutive = 1

        for y = 2, 8 do
            if matchColor == self.tiles[y][x].color then
                consecutive = consecutive + 1
                if consecutive >= 3 and y == 8 then
                    match = {}
                    for matchy = y, y - consecutive, -1 do
                        table.insert(match, self.tiles[matchY][x])
                    end
                    table.insert(matches, match)
                end
            else
                matchColor = self.tiles[y][x].color
                    if consecutive >= 3 then
                        match = {}
                        for matchy = y - 1, y - consecutive, -1 do
                            table.insert(match, self.tiles[matchY][x])
                        end
                        table.insert(matches, match)
                    end
                consecutive = 1
            end
        end
    end

    self.matches = matches

    return #self.matches > 0 and self.matches or false

end

function Board:removeMatches()
    for _, match in pairs(self.matches) do
        for _, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

function Board:getFallingTiles()
    local tweens = {}
    for x = 1, 8 do
        local space = false
        local spaceY = 0
        local y = 8

        while y >= 1 do
            local tile = self.tiles[y][x]

            if space then
                if tile then
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    self.tiles[y][x] = nil

                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    space = false
                    y = spaceY
                    spaceY = 0
                end
            elseif tile == nil then
                space = true

                if spaceY == 0 then
                    spaceY = y
                end
            end
            y = y -1
        end
    end

    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            if not tile then
                local tile = Tile(x, y)
                tile.y = -32
                self.tiles[y][x] = tile

                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end
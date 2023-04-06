DEBUG_DRAWER = {
    ClassName = "DEBUG_DRAW",
}

function DEBUG_DRAWER:New()
    self = BASE:Inherit(self, BASE:New())
    self.mark_id = 0
    return self
end

function DEBUG_DRAWER:UpdateMarkID()
    self.mark_id = self.mark_id + 1
    BASE:I(self.mark_id)
    return self.mark_id
end

function DEBUG_DRAWER:Quad(firstPoint, angle, length, width)
    local x, y, z = firstPoint.x, firstPoint.y, firstPoint.z

    -- calculate the half lengths and widths
    local hl = length / 2
    local hw = width

    -- calculate the corner points of the rectangle
    local p1 = { x = x - hw, y = y, z = z - hl }
    local p2 = { x = x + hw, y = y, z = z - hl }
    local p3 = { x = x + hw, y = y, z = z + hl }
    local p4 = { x = x - hw, y = y, z = z + hl }

    -- rotate the rectangle around the first point
    local sinAngle = math.sin(angle)
    local cosAngle = math.cos(angle)
    for _, point in ipairs({ p1, p2, p3, p4 }) do
        local x1 = point.x - x
        local z1 = point.z - z
        point.x = x1 * cosAngle - z1 * sinAngle + x
        point.z = z1 * cosAngle + x1 * sinAngle + z
    end

    local Coalition = -1
    local Color = {1,0,0}
    Color[4]=1.0
    local LineType = 1
    local FillColor = {1,0,0}
    self:I("Current mark ID " .. tostring(self.mark_id))
    trigger.action.removeMark(self.mark_id)
    --UTILS.RemoveMark(self.mark_id)
    trigger.action.quadToAll(Coalition, self:UpdateMarkID(), p1, p2, p3, p4, Color, FillColor, LineType, False, "this is text")
end

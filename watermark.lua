
local Draw = {}
local ScrSize = workspace.Camera.ViewportSize

function Draw:OutlinedRect(visible, pos_x, pos_y, width, height, clr, tablename)
   local temptable = Drawing.new("Square")
   temptable.Visible = visible
   temptable.Position = Vector2.new(pos_x, pos_y)
   temptable.Size = Vector2.new(width, height)
   temptable.Color = Color3.fromRGB(clr[1], clr[2], clr[3])
   temptable.Filled = false
   temptable.Thickness = 0
   temptable.Transparency = clr[4] / 255
   table.insert(tablename, temptable)
end
function Draw:OutlinedText(text, font, visible, pos_x, pos_y, size, centered, clr, clr2, tablename)
   local temptable = Drawing.new("Text")
   temptable.Text = text
   temptable.Visible = visible
   temptable.Position = Vector2.new(pos_x, pos_y)
   temptable.Size = size
   temptable.Center = centered
   temptable.Color = Color3.fromRGB(clr[1], clr[2], clr[3])
   temptable.Transparency = clr[4] / 255
   temptable.Outline = true
   temptable.OutlineColor = Color3.fromRGB(clr2[1], clr2[2], clr2[3])
   temptable.Font = font
   table.insert(tablename, temptable)
end
function Draw:FilledRect(visible, pos_x, pos_y, width, height, clr, tablename)
   local temptable = Drawing.new("Square")
   temptable.Visible = visible
   temptable.Position = Vector2.new(pos_x, pos_y)
   temptable.Size = Vector2.new(width, height)
   temptable.Color = Color3.fromRGB(clr[1], clr[2], clr[3])
   temptable.Filled = true
   temptable.Thickness = 0
   temptable.Transparency = clr[4] or 255 / 255
   table.insert(tablename, temptable)
end



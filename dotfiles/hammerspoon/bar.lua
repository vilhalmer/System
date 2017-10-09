local log = hs.logger.new('bar', 5)

for _, screen in ipairs(hs.screen.allScreens()) do
    local x, y = screen:position()
    local frame = screen:frame()

    local barRect = hs.geometry.rect(frame.x, frame.y - 22, frame.w / 2, 22)
    local box = hs.drawing.rectangle(barRect)
    box:setBehaviorByLabels({'canJoinAllSpaces'})

    box:setFillColor({red=0.1098, blue=0.1098, green=0.1098, alpha=1.0}):setFill(true)
    box:setStroke(false)
    box:show()

    local itemColor = {red=1, blue=1, green=1, alpha=1}

    local fruit = hs.styledtext.new("", {
        font={name=hs.styledtext.defaultFonts.menuBar, size=17.5}
    })

    local name = hs.host.localizedName()

    items = {fruit, name}

    currentX = 17
    padding = 17
    for _, item in ipairs(items) do
        item = hs.drawing.text(barRect, item)

        item:setTextSize(14)
        item:setTextColor(itemColor)
        item:setBehaviorByLabels({'canJoinAllSpaces'})
        item:clippingRectangle(box:frame())

        local idealWidth = hs.drawing.getTextDrawingSize(item:getStyledText()).w
        item:setTopLeft({x=currentX, y=0})
        currentX = currentX + idealWidth + padding

        item:show()
    end
end

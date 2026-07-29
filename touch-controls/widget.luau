--!nonstrict

local panelId = "dotredstone/touch-controls:panel"

local function render()
  barWidget.setGlyph("hand-finger")
  barWidget.setTooltip("Touch controls")
end

function update()
  noctalia.setUpdateInterval(60000)
  render()
end

function onClick()
  noctalia.togglePanel(panelId)
end

function onRightClick()
  noctalia.togglePanel("dotredstone/touch-controls:keyboard")
end

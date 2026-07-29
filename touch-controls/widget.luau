--!nonstrict

local panelId = "dotredstone/touch-controls:panel"

local function render()
  barWidget.setGlyph("grip-horizontal")
  barWidget.setTooltip("导航与窗口控制")
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

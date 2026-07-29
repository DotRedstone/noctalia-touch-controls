--!nonstrict

local keyboardPanel = "dotredstone/touch-controls:keyboard"

local function render()
  barWidget.setGlyph("keyboard")
  barWidget.setTooltip("屏幕键盘")
end

function update()
  noctalia.setUpdateInterval(60000)
  render()
end

function onClick()
  noctalia.togglePanel(keyboardPanel)
end

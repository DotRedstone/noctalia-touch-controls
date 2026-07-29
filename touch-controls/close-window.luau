--!nonstrict

local function render()
  barWidget.setGlyph("x")
  barWidget.setTooltip("关闭窗口")
end

function update()
  noctalia.setUpdateInterval(60000)
  render()
end

function onClick()
  if not noctalia.runAsync("sheng-niri-touch-action close") then
    noctalia.notifyError("窗口控制", "无法关闭窗口")
  end
end

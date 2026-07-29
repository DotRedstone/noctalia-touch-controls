--!nonstrict

local function render()
  barWidget.setGlyph("chevron-left")
  barWidget.setTooltip("返回 / 关闭窗口")
end

function update()
  noctalia.setUpdateInterval(60000)
  render()
end

function onClick()
  if not noctalia.runAsync("sheng-niri-touch-action close") then
    noctalia.notifyError("窗口控制", "无法返回或关闭窗口")
  end
end

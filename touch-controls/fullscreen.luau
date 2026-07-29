--!nonstrict

local function render()
  barWidget.setGlyph("arrows-maximize")
  barWidget.setTooltip("切换全屏")
end

function update()
  noctalia.setUpdateInterval(60000)
  render()
end

function onClick()
  if not noctalia.runAsync("sheng-niri-touch-action fullscreen") then
    noctalia.notifyError("窗口控制", "无法切换全屏")
  end
end

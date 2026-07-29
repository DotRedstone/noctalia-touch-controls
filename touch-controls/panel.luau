--!nonstrict

local function run(command, errorMessage)
  panel.close()
  if not noctalia.runAsync(command) then
    noctalia.notifyError("Touch Controls", errorMessage)
  end
end

local function actionButton(glyph, tooltip, handler, variant)
  return ui.button({
    glyph = glyph,
    glyphSize = 28,
    height = 72,
    flexGrow = 1,
    tooltip = tooltip,
    variant = variant or "secondary",
    onClick = handler,
  })
end

local function render()
  panel.render(ui.column({ flexGrow = 1, gap = 12, padding = 12 }, {
    ui.row({ align = "center", justify = "space_between", gap = 8, height = 42 }, {
      ui.glyph({ name = "minus", size = 28, color = "primary" }),
      ui.spacer({ flexGrow = 1 }),
      ui.button({
        glyph = "x",
        width = 44,
        height = 40,
        variant = "ghost",
        tooltip = "收起",
        onClick = "onClosePanel",
      }),
    }),

    ui.row({ gap = 10 }, {
      actionButton("apps", "应用", "onLauncher"),
      actionButton("layout-grid", "最近任务", "onOverview"),
      actionButton("keyboard", "屏幕键盘", "onKeyboard"),
      actionButton("adjustments-horizontal", "控制中心", "onControlCenter"),
    }),
    ui.row({ gap = 10 }, {
      actionButton("maximize", "最大化", "onMaximize"),
      actionButton("arrows-maximize", "全屏", "onFullscreen"),
      actionButton("x", "关闭窗口", "onCloseWindow", "destructive"),
      actionButton("power", "关闭屏幕", "onScreenOff"),
    }),
  }))
end

function onOpen(_context)
  render()
end

function onClosePanel()
  panel.close()
end

function onKeyboard()
  panel.close()
  noctalia.togglePanel("dotredstone/touch-controls:keyboard")
end

function onLauncher()
  run("sheng-niri-touch-action launcher", "无法打开应用启动器")
end

function onControlCenter()
  run("sheng-niri-touch-action control-center", "无法打开控制中心")
end

function onOverview()
  run("sheng-niri-touch-action overview", "无法打开窗口总览")
end

function onMaximize()
  run("sheng-niri-touch-action maximize", "无法最大化窗口")
end

function onFullscreen()
  run("sheng-niri-touch-action fullscreen", "无法切换全屏")
end

function onCloseWindow()
  run("sheng-niri-touch-action close", "无法关闭窗口")
end

function onScreenOff()
  run("sheng-niri-display off", "无法关闭屏幕")
end

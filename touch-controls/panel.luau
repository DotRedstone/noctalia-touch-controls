--!nonstrict

local function run(command, errorMessage)
  panel.close()
  if not noctalia.runAsync(command) then
    noctalia.notifyError("Touch Controls", errorMessage)
  end
end

local function actionButton(text, glyph, handler)
  return ui.button({
    text = text,
    glyph = glyph,
    height = 64,
    flexGrow = 1,
    onClick = handler,
  })
end

local function render()
  panel.render(ui.column({ flexGrow = 1, gap = 16 }, {
    ui.row({ align = "center", justify = "space_between", gap = 8 }, {
      ui.column({ gap = 2, flexGrow = 1 }, {
        ui.label({ text = "触控控制", fontSize = 18, fontWeight = "bold", color = "on_surface" }),
        ui.label({ text = "Niri 平板常用操作", color = "on_surface_variant" }),
      }),
      ui.button({ glyph = "x", onClick = "onClosePanel" }),
    }),

    ui.column({ gap = 12, flexGrow = 1 }, {
      ui.row({ gap = 12 }, {
        actionButton("屏幕键盘", "keyboard", "onKeyboard"),
        actionButton("应用启动器", "apps", "onLauncher"),
      }),
      ui.row({ gap = 12 }, {
        actionButton("控制中心", "adjustments-horizontal", "onControlCenter"),
        actionButton("窗口总览", "layout-grid", "onOverview"),
      }),
      ui.row({ gap = 12 }, {
        actionButton("最大化", "maximize", "onMaximize"),
        actionButton("全屏", "arrows-maximize", "onFullscreen"),
      }),
      ui.row({ gap = 12 }, {
        actionButton("关闭窗口", "x", "onCloseWindow"),
        actionButton("关闭屏幕", "power", "onScreenOff"),
      }),
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
  run("sheng-niri-osk-toggle", "无法切换屏幕键盘")
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

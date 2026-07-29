--!nonstrict

local layer = "letters"
local symbolPage = 1
local shiftMode = "off"
local lastShiftTap = 0

local letterRows = {
  {
    { "q", "q" }, { "w", "w" }, { "e", "e" }, { "r", "r" }, { "t", "t" },
    { "y", "y" }, { "u", "u" }, { "i", "i" }, { "o", "o" }, { "p", "p" },
  },
  {
    { "a", "a" }, { "s", "s" }, { "d", "d" }, { "f", "f" }, { "g", "g" },
    { "h", "h" }, { "j", "j" }, { "k", "k" }, { "l", "l" },
  },
  {
    { "z", "z" }, { "x", "x" }, { "c", "c" }, { "v", "v" },
    { "b", "b" }, { "n", "n" }, { "m", "m" },
  },
}

local symbolRows = {
  {
    { "1", "1" }, { "2", "2" }, { "3", "3" }, { "4", "4" }, { "5", "5" },
    { "6", "6" }, { "7", "7" }, { "8", "8" }, { "9", "9" }, { "0", "0" },
  },
  {
    { "@", "at" }, { "#", "hash" }, { "$", "dollar" }, { "%", "percent" },
    { "&", "ampersand" }, { "-", "minus" }, { "+", "plus" },
    { "(", "left-paren" }, { ")", "right-paren" },
  },
  {
    { "!", "exclam" }, { "\"", "double-quote" }, { "'", "apostrophe" },
    { ":", "colon" }, { ";", "semicolon" }, { "/", "slash" }, { "?", "question" },
  },
}

local symbolRowsMore = {
  {
    { "~", "tilde" }, { "`", "grave" }, { "_", "underscore" }, { "=", "equal" },
    { "[", "left-bracket" }, { "]", "right-bracket" }, { "{", "left-brace" },
    { "}", "right-brace" }, { "\\", "backslash" }, { "|", "pipe" },
  },
  {
    { "<", "less" }, { ">", "greater" }, { "^", "caret" }, { "*", "asterisk" },
    { ":", "colon" }, { ";", "semicolon" }, { "'", "apostrophe" },
    { "\"", "double-quote" }, { "?", "question" },
  },
  {
    { "@", "at" }, { "#", "hash" }, { "$", "dollar" }, { "%", "percent" },
    { "&", "ampersand" }, { "+", "plus" }, { "/", "slash" },
  },
}

local function send(token)
  if not noctalia.runAsync("sheng-niri-key " .. token) then
    noctalia.notifyError("屏幕键盘", "按键输入服务不可用")
  end
end

local function textKey(label, token, width, variant)
  return ui.button({
    key = token .. "-" .. label,
    text = label,
    fontSize = 20,
    fontWeight = "medium",
    height = 58,
    width = width,
    flexGrow = width == nil and 1 or nil,
    variant = variant or "default",
    onClick = function() onTextKey(token) end,
  })
end

local function glyphKey(glyph, token, width, selected, tooltip)
  return ui.button({
    key = token,
    glyph = glyph,
    glyphSize = 24,
    height = 58,
    width = width,
    selected = selected,
    variant = selected and "primary" or "secondary",
    tooltip = tooltip,
    onClick = function() onSpecialKey(token) end,
  })
end

local function addCharacterRow(keys, sidePadding)
  local children = {}
  if sidePadding then
    table.insert(children, ui.spacer({ width = sidePadding }))
  end

  for _, key in ipairs(keys) do
    local label = key[1]
    if layer == "letters" and shiftMode ~= "off" then
      label = string.upper(label)
    end
    table.insert(children, textKey(label, key[2]))
  end

  if sidePadding then
    table.insert(children, ui.spacer({ width = sidePadding }))
  end
  return ui.row({ gap = 8, height = 58 }, children)
end

local function render()
  local rows = {}
  local activeRows = letterRows
  if layer == "symbols" then
    activeRows = symbolPage == 1 and symbolRows or symbolRowsMore
  end

  table.insert(rows, ui.row({ gap = 8, height = 40, align = "center" }, {
    ui.button({
      glyph = "chevron-down",
      glyphSize = 21,
      width = 48,
      height = 38,
      variant = "ghost",
      tooltip = "收起键盘",
      onClick = "onClose",
    }),
    ui.glyph({ name = "grip-horizontal", size = 24, color = "on_surface_variant" }),
    ui.label({
      text = "浮动键盘",
      fontSize = 14,
      color = "on_surface_variant",
      flexGrow = 1,
    }),
    ui.button({
      glyph = "clipboard",
      glyphSize = 20,
      width = 48,
      height = 38,
      variant = "ghost",
      tooltip = "粘贴",
      onClick = "onPaste",
    }),
    ui.button({
      glyph = "settings",
      glyphSize = 20,
      width = 48,
      height = 38,
      variant = "ghost",
      tooltip = "调整悬浮位置",
      onClick = "onSettings",
    }),
  }))

  table.insert(rows, addCharacterRow(activeRows[1], nil))
  table.insert(rows, addCharacterRow(activeRows[2], 50))

  local thirdRow = {}
  if layer == "letters" then
    table.insert(thirdRow, glyphKey(
      shiftMode == "locked" and "capslock" or "arrow-big-up",
      "shift",
      112,
      shiftMode ~= "off",
      shiftMode == "locked" and "大写锁定" or "Shift"
    ))
  else
    local moreLabel = symbolPage == 1 and "#+=" or "123"
    table.insert(thirdRow, textKey(moreLabel, "symbols-more", 112, "secondary"))
  end

  for _, key in ipairs(activeRows[3]) do
    local label = key[1]
    if layer == "letters" and shiftMode ~= "off" then
      label = string.upper(label)
    end
    table.insert(thirdRow, textKey(label, key[2]))
  end
  table.insert(thirdRow, glyphKey("backspace", "backspace", 112, false, "退格"))
  table.insert(rows, ui.row({ gap = 8, height = 58 }, thirdRow))

  local layerLabel = layer == "letters" and "?123" or "ABC"
  table.insert(rows, ui.row({ gap = 8, height = 58 }, {
    textKey(layerLabel, "toggle-layer", 112, "secondary"),
    textKey(",", "comma", 74),
    glyphKey("world", "language", 74, false, "切换输入法"),
    textKey("空格", "space", nil),
    textKey(".", "dot", 74),
    glyphKey("corner-down-left", "enter", 112, false, "回车"),
  }))

  panel.render(ui.column({
    flexGrow = 1,
    gap = 8,
    padding = 12,
    fill = "surface/0.98",
    radius = 8,
  }, rows))
end

function onOpen(_context)
  render()
end

function onClose()
  panel.close()
end

function onSettings()
  noctalia.openSettings()
end

function onPaste()
  send("paste")
end

function onTextKey(token)
  if token == "toggle-layer" then
    layer = layer == "letters" and "symbols" or "letters"
    symbolPage = 1
    shiftMode = "off"
    render()
    return
  end

  if token == "symbols-more" then
    symbolPage = symbolPage == 1 and 2 or 1
    render()
    return
  end

  if layer == "letters" and shiftMode ~= "off" and string.len(token) == 1 then
    send("upper-" .. token)
    if shiftMode == "once" then
      shiftMode = "off"
      render()
    end
    return
  end

  send(token)
end

function onSpecialKey(token)
  if token == "shift" then
    local now = noctalia.nowMs()
    if shiftMode == "locked" then
      shiftMode = "off"
    elseif shiftMode == "once" and now - lastShiftTap <= 450 then
      shiftMode = "locked"
    elseif shiftMode == "once" then
      shiftMode = "off"
    else
      shiftMode = "once"
    end
    lastShiftTap = now
    render()
    return
  end

  send(token)
end

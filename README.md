# Noctalia Touch Controls

面向触控屏平板（小米平板 6S Pro / Niri）的 Noctalia 触控控制插件与兼容补丁。

## Noctalia v5 插件

`touch-controls/` 是原生 Noctalia v5 插件，提供触控友好的栏入口和大按钮控制面板：

- 独立的全屏与关闭窗口栏按钮
- 屏幕键盘
- 应用启动器
- 控制中心
- Niri 窗口总览
- 最大化与全屏
- 关闭窗口与关闭屏幕

插件 ID 为 `dotredstone/touch-controls`。将本仓库添加为 Noctalia Git 插件源并启用该 ID 即可使用。

```toml
[plugins]
enabled = ["dotredstone/touch-controls"]

[[plugins.source]]
name = "dotredstone-touch-controls"
kind = "git"
location = "https://github.com/DotRedstone/noctalia-touch-controls"
auto_update = false
```

窗口控制栏组件类型为：

```toml
[widget.fullscreen_control]
type = "dotredstone/touch-controls:fullscreen"

[widget.close_window_control]
type = "dotredstone/touch-controls:close-window"
```

原有大按钮控制面板入口仍可使用
`dotredstone/touch-controls:controls`。

插件调用以下 sheng Niri 辅助命令：

- `sheng-niri-touch-action`
- `sheng-niri-osk-toggle`
- `sheng-niri-display`

## Niri 边缘手势

`dotfiles-sheng` 额外提供由 `lisgd` 驱动的系统级手势：

- 顶部边缘双指下滑：关闭窗口
- 底部边缘双指上滑：切换全屏
- 右侧边缘双指左滑：最大化列

## 旧版补丁

`patches/launcher-touch-fix.patch` 仅适用于基于 Quickshell/QML 的 Noctalia v4，用于修复启动器滑动误触。Noctalia v5 已改用原生 C++ 界面，不应再应用这份 QML 补丁。

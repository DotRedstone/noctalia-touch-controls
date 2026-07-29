# Noctalia Touch Controls

面向触控屏平板（小米平板 6S Pro / Niri）的 Noctalia 触控控制插件与兼容补丁。

## Noctalia v5 插件

`touch-controls/` 是原生 Noctalia v5 插件，提供触控友好的栏入口、悬浮软键盘和窗口控制面板：

- 单一导航入口，避免在顶栏堆叠窗口按钮
- 手机式悬浮软键盘（内嵌候选词、输入框自动呼出、拖动/缩放、Shift/大写锁定、两页符号、输入法切换、粘贴）
- 应用启动器
- 控制中心
- Niri 窗口总览
- 最大化与全屏
- 关闭窗口与关闭屏幕

插件 ID 为 `dotredstone/touch-controls`。将本仓库添加为 Noctalia Git 插件源并启用该 ID 即可使用。

```toml
[plugins]
enabled = ["dotredstone/touch-controls"]
auto_update = true

[[plugins.source]]
name = "dotredstone-touch-controls"
kind = "git"
location = "https://github.com/DotRedstone/noctalia-touch-controls"
```

推荐只在顶栏保留一个导航入口：

```toml
[widget.touch_control]
type = "dotredstone/touch-controls:controls"

[widget.keyboard_control]
type = "dotredstone/touch-controls:keyboard-toggle"
```

原有独立返回、全屏与关闭组件仍保留兼容，但不再推荐同时放入顶栏。
键盘栏按钮会优先调用 `sheng-niri-osk-toggle`，由 sheng 的 GTK4
layer-shell 键盘接入 Fcitx5 虚拟键盘协议。它不会抢占应用焦点，
候选词显示在键盘内部，并会跟随输入框焦点自动呼出/收起；顶部手柄可拖动，
右下角手柄或双指缩放可调整尺寸，位置与尺寸会自动保存。

固定面板 `dotredstone/touch-controls:keyboard` 保留为兼容回退。它需要
Noctalia 插件 API 15。

插件调用以下 sheng Niri 辅助命令：

- `sheng-niri-touch-action`
- `sheng-niri-key`
- `sheng-niri-display`
- `sheng-niri-osk-toggle`

## Niri 导航手势

`dotfiles-sheng` 额外提供由 `lisgd` 驱动的系统级手势：

- 左右边缘向内滑：返回；总览打开时退出总览，全屏时先退出全屏
- 底部短距离上滑：回到第一个工作区
- 底部长距离上滑：打开最近任务
- 底部横滑：循环切换相邻窗口
- 顶部下滑：打开控制中心

关闭窗口和切换全屏属于有破坏性或低频操作，保留在导航控制面板中，
不再绑定容易误触的边缘手势。

## 旧版补丁

`patches/launcher-touch-fix.patch` 仅适用于基于 Quickshell/QML 的 Noctalia v4，用于修复启动器滑动误触。Noctalia v5 已改用原生 C++ 界面，不应再应用这份 QML 补丁。

# Noctalia Touch Controls

触控屏平板（小米平板 6S Pro / Niri 桌面）专用的 Noctalia 与 Niri 触控优化方案与补丁集。

## 包含优化项

### 1. 启动器触控误触修复 (Launcher Dismiss Fix)
- **现象**：在触摸屏上尝试滑动/浏览应用列表或点击空白区域时，启动器意外消失。
- **原因**：Noctalia 启动器 Delegate 及背景遮罩使用 `MouseArea.onClicked`，Qt 触控事件合成 click 直接触发了应用激活和面板关闭。
- **修复**：将 `MouseArea` 替换为触控原生的 `TapHandler` + `HoverHandler`，区分单点 Tap 与滑动/拖拽手势。

### 2. 启动器滑动与触控手势优化 (Launcher Touch Scrolling)
- **现象**：在触控屏上手指划动列表卡顿或无法触发 Flick 效果。
- **原因**：`NListView` 与 `NGridView` 的 `interactive` 属性受 mouse input 设置制约，阻碍触控拖拽。
- **修复**：在 `LauncherCore.qml` 中将 `interactive` 保持为 `true`，确保 `Flickable` 永远响应触控滑动。

### 3. Niri 边缘窗口触控手势 (Niri Edge Touch Gestures)
- **功能**：
  - **关闭窗口**：顶部边缘双指下滑 (`2,DU,T`)
  - **全屏切换**：底部边缘双指上滑 (`2,UD,B`)
  - **最大化列**：右侧边缘双指左滑 (`2,RL,R`)

## 文件结构

```
.
├── patches/
│   └── launcher-touch-fix.patch  # Noctalia Shell 统一补丁
└── README.md
```

## 应用方式

补丁已通过 NixOS Module 整合进 `dotfiles-sheng` 配置中：
平板运行 `git pull` 后执行 `nrs` (NixOS rebuild switch) 即可编译生效。

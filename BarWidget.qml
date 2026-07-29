import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  property var screen: null

  implicitWidth: windowControlCapsule.implicitWidth
  implicitHeight: Style.baseWidgetSize

  Rectangle {
    id: windowControlCapsule
    anchors.centerIn: parent
    implicitWidth: buttonRow.implicitWidth + Style.marginS * 2
    implicitHeight: Math.round(Style.baseWidgetSize * 0.85)
    radius: height / 2
    color: Qt.alpha(Color.mSurface, 0.85)
    border.color: Qt.alpha(Color.mOutline, 0.3)
    border.width: Style.borderS

    RowLayout {
      id: buttonRow
      anchors.centerIn: parent
      spacing: Style.marginXS

      // 1. 全屏 (Fullscreen)
      NavButton {
        iconName: "maximize"
        activeColor: Color.mPrimary
        tooltip: pluginApi?.tr("nav.fullscreen") ?? "Toggle Fullscreen"
        onPressedAction: function() { root.runNiriAction("fullscreen-window"); }
      }

      // 2. 关闭窗口 (Close Window)
      NavButton {
        iconName: "x"
        activeColor: Color.mError
        tooltip: pluginApi?.tr("nav.close") ?? "Close Window"
        onPressedAction: function() { root.runNiriAction("close-window"); }
      }
    }
  }

  component NavButton: Item {
    id: btn
    property string iconName: ""
    property color activeColor: Color.mPrimary
    property string tooltip: ""
    property var onPressedAction: null

    implicitWidth: Math.round(Style.baseWidgetSize * 0.9)
    implicitHeight: Math.round(Style.baseWidgetSize * 0.75)

    Rectangle {
      id: btnBg
      anchors.fill: parent
      radius: height / 2
      color: tapArea.pressed ? Qt.alpha(btn.activeColor, 0.25) : "transparent"

      Behavior on color {
        ColorAnimation {
          duration: Style.animationFast
        }
      }

      NIcon {
        anchors.centerIn: parent
        icon: btn.iconName
        pointSize: Style.fontSizeL
        color: tapArea.pressed ? btn.activeColor : Color.mOnSurface
      }
    }

    TapHandler {
      id: tapArea
      gesturePolicy: TapHandler.ReleaseWithinBounds
      onTapped: {
        if (btn.onPressedAction) {
          btn.onPressedAction();
        }
      }
    }
  }

  function runNiriAction(actionName) {
    niriProcess.command = ["niri", "msg", "action", actionName];
    niriProcess.running = true;
  }

  Process {
    id: niriProcess
  }
}

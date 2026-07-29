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

  implicitWidth: navCapsule.implicitWidth
  implicitHeight: Style.baseWidgetSize

  Rectangle {
    id: navCapsule
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
      spacing: Style.marginXXS

      // 1. Back (◀)
      NavButton {
        iconName: "chevron-left"
        tooltip: pluginApi?.tr("nav.back") ?? "Back"
        onPressedAction: function() { root.runNiriAction("close-window"); }
      }

      // 2. Home (⚪)
      NavButton {
        iconName: "circle"
        tooltip: pluginApi?.tr("nav.home") ?? "Home"
        onPressedAction: function() { root.runNiriAction("focus-workspace-down"); }
      }

      // 3. Recents (⏹)
      NavButton {
        iconName: "square"
        tooltip: pluginApi?.tr("nav.recents") ?? "Recents"
        onPressedAction: function() { root.runNiriAction("toggle-overview"); }
      }

      // 4. Keyboard (⌨)
      NavButton {
        iconName: "keyboard"
        tooltip: pluginApi?.tr("nav.keyboard") ?? "Keyboard"
        onPressedAction: function() { root.runCommand("sheng-niri-osk-toggle"); }
      }
    }
  }

  component NavButton: Item {
    id: btn
    property string iconName: ""
    property string tooltip: ""
    property var onPressedAction: null

    implicitWidth: Math.round(Style.baseWidgetSize * 0.85)
    implicitHeight: Math.round(Style.baseWidgetSize * 0.75)

    Rectangle {
      id: btnBg
      anchors.fill: parent
      radius: height / 2
      color: tapArea.pressed ? Color.mHover : "transparent"

      Behavior on color {
        ColorAnimation {
          duration: Style.animationFast
        }
      }

      NIcon {
        anchors.centerIn: parent
        icon: btn.iconName
        pointSize: Style.fontSizeL
        color: tapArea.pressed ? Color.mPrimary : Color.mOnSurface
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

  function runCommand(cmd) {
    cmdProcess.command = [cmd];
    cmdProcess.running = true;
  }

  Process {
    id: niriProcess
  }

  Process {
    id: cmdProcess
  }
}

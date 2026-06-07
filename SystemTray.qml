import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

PanelWindow {
    id: trayRoot
    anchors.bottom: true
    color: "transparent"
    implicitWidth: Screen.width / 1.5
    implicitHeight: TrayState.isHovered ? 50 : 16
    Behavior on implicitHeight { NumberAnimation { duration: 300; easing.type: Easing.OutCubic }}
    exclusiveZone: 0

    MouseArea {
       anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onEntered: {
            closeTimer.stop()
            TrayState.isHovered = true
        }
        onExited: closeTimer.restart()
        onClicked: (mouse) => mouse.accepted = false
    }

    Timer {
        id: closeTimer
        interval: 500
        onTriggered: if (!TrayState.tooltipVisible) TrayState.isHovered = false
    }

    Rectangle {
        id: trayContent
        anchors.fill: parent
        anchors.margins: 4
        radius: 10
        clip: true
        color: Color.charcoalNight
        border.color: Color.bloodEmber
        border.width: 3
        anchors.bottomMargin: -10
        opacity: TrayState.isHovered ? 1.0 : 0.85
        Behavior on opacity { NumberAnimation { duration: 200 } }

        Row {
            id: trayRow
            anchors.centerIn: parent
            spacing: 12
            opacity: TrayState.isHovered ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 150 } }

            Taskbar { monitorIndex: 0 }

            Repeater {
                model: SystemTray.items
                delegate: MouseArea {
                    implicitWidth: 24
                    implicitHeight: 24
                    IconImage {
                        anchors.fill: parent
                        source: modelData.icon
                    }
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.LeftButton) modelData.activate()
                        else modelData.display(this.window, mouse.x, mouse.y)
                    }
                }
            }
        }
    }
}
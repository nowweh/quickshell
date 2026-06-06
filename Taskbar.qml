import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

Item {
    id: taskbar
    property int monitorIndex: 0
    implicitHeight: 36
    implicitWidth: taskRow.implicitWidth + 16


    Row {
        id: taskRow
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: Hyprland.toplevels.values.filter(w => {
                if (monitorIndex === 0) return w.workspace && w.workspace.id <= 10
                else return w.workspace && w.workspace.id > 10
            })

            Rectangle {
                id: taskItem
                implicitWidth: 75
                implicitHeight: 44
                radius: 8
                color: Color.obsidianShadow
                border.width: 3
                border.color: Color.crimsonCore

                Behavior on border.color { ColorAnimation { duration: 200 } }

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    border.width: 3
                    border.color: Color.crimsonCore
                    color: Color.crimsonMist
                    visible: modelData === Hyprland.activeToplevel

                    SequentialAnimation on opacity {
                        running: modelData === Hyprland.activeToplevel
                        loops: Animation.Infinite
                        NumberAnimation { from: 0.2; to: 0.7; duration: 1200; easing.type: Easing.InOutSine }
                        NumberAnimation { from: 0.7; to: 0.2; duration: 1200; easing.type: Easing.InOutSine }
                    }
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 1

                    IconImage {
                        Layout.alignment: Qt.AlignHCenter
                        source: modelData.wayland ? `image://icon/${modelData.wayland.appId}` : ""
                        implicitWidth: 28
                        implicitHeight: 28
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: modelData.title.length > 8 ? modelData.title.substring(0, 8) + "…" : modelData.title
                        color: Color.meteorTrail
                        font.pixelSize: 11
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("focuswindow address:0x" + modelData.address)
                }
            }
        }
    }
}
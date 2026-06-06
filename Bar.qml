import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barWindow
            required property var modelData
            screen: modelData
            implicitWidth: Screen.width
            implicitHeight: 40
            color: "transparent"
            anchors.top: true

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                spacing: 0

                RowLayout {
                    id: leftModules
                    Layout.alignment: Qt.AlignLeft
                    ClockWidget {}
                    Workspaces {monitorIndex: barWindow.screen.name === "eDP-1" ? 0 : 1}
                }

                Item { Layout.fillWidth: true }

                RowLayout {
                    id: rightModules
                    Layout.alignment: Qt.AlignRight
                    VolumePill {}
                    WifiModule {}
                    Battery {}
                }
            }

            RowLayout {
                id: centerModules
                anchors.centerIn: parent
                spacing: 8
            }
        }
    }
}
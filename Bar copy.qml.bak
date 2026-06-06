import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: barWindow
    implicitWidth: Screen.width // Or however wide your bar should be
    implicitHeight: 40
    color: "transparent"
    anchors.top: true

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        spacing: 0

        RowLayout{
            id: leftModules
            Layout.alignment: Qt.AlignLeft

            // Modules:
            ClockWidget {}
            Workspaces {}
        }

        Item { Layout.fillWidth: true }

        RowLayout{
            id: rightModules
            Layout.alignment: Qt.AlignRight

            // Modules:
        }
    }

    RowLayout {
        id: centerModules
        anchors.centerIn: parent
        spacing: 8
        
        // Modules:
    }
}



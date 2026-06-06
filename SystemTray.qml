import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

PanelWindow {
    id: trayRoot
    
    anchors {
        bottom: true

    }
    
    // Set the window itself to be invisible
    color: "transparent"
    implicitWidth: Screen.width / 1.5
    implicitHeight: 50// Slightly taller to account for margins/shadows
    exclusiveZone: 0 

    property bool isHovered: false

    mask: Region {
        item: isHovered ? trayContent : triggerZone
    }

    // 1. The Invisible Trigger (Bottom 2px)
    Item {
        id: triggerZone
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 2

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: isHovered = true
        }
    }

    // 2. The Visual Bar
    // We use a Rectangle inside the Window to get borders/radius
    Rectangle {
        id: trayContent
        anchors.fill: parent
        anchors.margins: 4 // Creates a "floating" effect
        visible: isHovered
        
        // STYLING GOES HERE
        color: Color.smokedGraphite
        border.color: Color.bloodEmber
        border.width: 3
        radius: 10

        Row {
            id: trayRow
            anchors.centerIn: parent
            spacing: 12
            
            Taskbar {
                monitorIndex: 0
            }


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
                        if (mouse.button === Qt.LeftButton) {
                            modelData.activate()
                        } else {
                            modelData.display(this.window, mouse.x, mouse.y)
                        }
                    }
                }
            }
        }

        // Close on exit
        MouseArea {
            anchors.fill: parent
            z: -1 
            hoverEnabled: true
            onExited: isHovered = false
        }
    }
}

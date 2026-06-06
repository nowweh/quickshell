import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell
import Quickshell.Wayland

Rectangle {
    id: bGb
    property int monitorIndex: 0
    property var parentBar: bGb.Window.window
    implicitHeight: 36
    implicitWidth: mainRow.width + 25
    Behavior on implicitWidth { NumberAnimation { duration: 200 } }
    color: Qt.rgba(Color.charcoalNight.r, Color.charcoalNight.g, Color.charcoalNight.b, 0.7)
    radius: 100
    border.width: 3
    border.color: Color.bloodEmber


    PopupWindow {
        id: workspacesPreview
        visible: false
        implicitWidth: 350
        implicitHeight: 250
        color: "transparent"
        anchor.gravity: Edges.Bottom
        anchor.rect.y: (bGb.height + 5)

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(Color.charcoalNight.r, Color.charcoalNight.g, Color.charcoalNight.b, 0.9)
            radius: 8
            border.width: 3
            border.color: Color.bloodEmber
            clip: true

            ScreencopyView {
                id: previewView
                anchors.fill: parent
                anchors.margins: 4
                constraintSize: Qt.size(parent.width, parent.height)
                live: true
            }
        }
    }

    Row {
        id: mainRow
        anchors.centerIn: parent
        spacing: 5


        Repeater {
            model: Hyprland.workspaces.values.filter(ws => {
                if (monitorIndex === 0) return ws.id <= 10
                else return ws.id > 10 && ws.id <= 20
            })

            Rectangle {
                id: workBubble
                Component.onCompleted: console.log("ws", modelData.id, "monitor", modelData.monitor)
                implicitHeight: 24
                radius: 100
                border.width: 2
                layer.enabled: true

                property bool isActive: modelData.id === Hyprland.focusedMonitor?.activeWorkspace?.id
                property bool isHovered: hoverHandler.hovered

                implicitWidth: isActive ? 30 : 24
                color: isHovered ? Color.novaGlow : isActive ? Color.plasmaRed : Color.charcoalNight
                border.color: isHovered ? Color.bloodEmber : Qt.transparent
                scale: isHovered ? 1.1 : 1.0

                Behavior on implicitWidth { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 300; easing.type: Easing.InOutQuad } }
                Behavior on border.color { ColorAnimation { duration: 300; easing.type: Easing.InOutQuad } }
                Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }

                HoverHandler {
                    id: hoverHandler
                    onHoveredChanged: {
                        if (hovered) {
                            let windows = modelData.toplevels.values;
                            if (windows.length > 0) {
                                let target = windows[0];
                                if (target && target.wayland) {
                                    previewView.captureSource = null;
                                    workspacesPreview.visible = false;
                                    workspacesPreview.anchor.item = bGb;
                                    workspacesPreview.anchor.gravity = Edges.Bottom;
                                    workspacesPreview.anchor.rect.x = bGb.width / 2;
                                    workspacesPreview.anchor.updateAnchor();
                                    previewView.captureSource = target.wayland;
                                    workspacesPreview.visible = true;
                                }
                            }
                        } else {
                            workspacesPreview.visible = false;
                            previewView.captureSource = null;
                        }
                    }
                }

                Text {
                    id: textItem
                    anchors.centerIn: parent
                    text: modelData.id > 10 ? modelData.id % 10 : modelData.id
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: workBubble.isHovered ? Color.charcoalNight : "white"
                    font.pixelSize: 14
                    font.bold: workBubble.isActive
                    width: parent.height
                    height: parent.height
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + modelData.id)
                }
            }
        }
    }
}

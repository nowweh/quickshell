// WorkspacesWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell
import Quickshell.Wayland




Rectangle {
    id: bGb
    property var parentBar: bGb.Window.window
    implicitHeight: 36
    implicitWidth: mainRow.width + 20
    Behavior on implicitWidth { NumberAnimation { duration: 200 } }
    color: Qt.rgba(Color.charcoalNight.r, Color.charcoalNight.g, Color.charcoalNight.b,0.7)
    radius: 100
    border.width: 3
    border.color: Color.bloodEmber

    PopupWindow {
        id: workspacesPreview
        visible: false
        implicitWidth: 250
        implicitHeight: 150
        color: "transparent"


        anchor.gravity: Edges.Bottom
        anchor.rect.y: (bGb.height + 5)

        Rectangle{
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
            model: Hyprland.workspaces
   
                    Rectangle {
                        id: workBubble
                        implicitWidth: modelData.focused ? 28 : 24
                        implicitHeight: 24
                        radius: 100
                        color: modelData.focused ? Color.plasmaRed : Color.charcoalNight
                        border.width: 2
                        border.color: Qt.transparent
                        layer.enabled: true
                        Behavior on implicitWidth { 
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }
                        Behavior on color { ColorAnimation { duration: 300; easing.type: Easing.InOutQuad } }
                        Behavior on border.color { ColorAnimation { duration: 300; easing.type: Easing.InOutQuad } }
                        Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }

                        HoverHandler {
                            onHoveredChanged: {
                                if (hovered) {
                                    let windows = modelData.toplevels.values;

                                    workBubble.color = Color.novaGlow
                                    workBubble.border.color = Color.bloodEmber
                                    workBubble.scale = 1.1
                                    textItem.color = Color.charcoalNight

                                    if (windows.length > 0) {
                                        let target = windows[0];

                                        if (target && target.wayland) {
                                            previewView.captureSource = null;
                                            workspacesPreview.visible = false;
                                            
                                            workspacesPreview.anchor.item = bGb;
                                            workspacesPreview.anchor.gravity = Edges.Bottom
                                            workspacesPreview.anchor.rect.x = bGb.width / 2;
                                            workspacesPreview.anchor.updateAnchor();
                                            previewView.captureSource = target.wayland;
                                            workspacesPreview.visible = true;
                                        }
                                    }

                                } else {
                                    workspacesPreview.visible = false;
                                    previewView.captureSource = null;

                                    workBubble.color = modelData.focused ? Color.plasmaRed : Color.charcoalNight;
                                    workBubble.border.color = Qt.transparent
                                    workBubble.scale = 1.0
                                    textItem.color = "white"
                                }
                            }
                        }

                        Text {
                            id: textItem
                            anchors.centerIn: parent
                            text: modelData.id

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            color: "white"
                            font.pixelSize: 14
                            font.bold: modelData.focused

                            width: parent.height
                            height: parent.height
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Hyprland.dispatch("workspace " + (index + 1))
                        }
                    }


        }
    }
}

        

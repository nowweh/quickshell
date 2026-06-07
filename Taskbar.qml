import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

Item {
    id: taskbar
    property int monitorIndex: 0
    property var pinnedApps: ["firefox", "codium", "kitty", "thunar", "discord", "localsend"]
    implicitHeight: 36
    implicitWidth: taskRow.implicitWidth + 16

    Row {
        id: taskRow
        anchors.centerIn: parent
        spacing: 6

        // Pinned apps
    Repeater {
        model: pinnedApps

        Rectangle {
            id: pinnedItem
            implicitWidth: 50
            implicitHeight: taskbar.implicitHeight + 1
            radius: 8
            border.width: 3

            property bool isRunning: Hyprland.toplevels.values.some(w => w.wayland && w.wayland.appId.toLowerCase() === modelData.toLowerCase())
            property bool isActive: Hyprland.toplevels.values.some(w => w.wayland && w.wayland.appId.toLowerCase() === modelData.toLowerCase() && w === Hyprland.activeToplevel)
            property bool isHovered: hoverHandler.hovered

            color: Color.obsidianShadow
            border.color: isRunning ? Color.crimsonCore : Color.smokedGraphite
            Behavior on border.color { ColorAnimation { duration: 200 } }

            HoverHandler { id: hoverHandler }

            PopupWindow {
                id: pinnedTooltip
                onVisibleChanged: TrayState.tooltipVisible = visible
                visible: pinnedItem.isHovered
                implicitWidth: Math.min(pinnedTooltipText.implicitWidth + 16, 200)
                implicitHeight: pinnedTooltipText.implicitHeight + 2
                color: "transparent"
                anchor.item: pinnedItem
                anchor.gravity: Edges.Top
                anchor.rect.y: -2
                anchor.rect.x: pinnedItem.width / 2

                Rectangle {
                    anchors.fill: parent
                    color: Color.charcoalNight
                    border.color: Color.bloodEmber
                    border.width: 3
                    radius: 8

                    Text {
                        id: pinnedTooltipText
                        text: modelData
                        anchors.centerIn: parent
                        color: Color.meteorTrail
                        font.pixelSize: 11
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                border.width: 3
                border.color: Color.crimsonCore
                color: Color.crimsonMist
                visible: pinnedItem.isActive

                SequentialAnimation on opacity {
                    running: pinnedItem.isActive
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.2; to: 0.7; duration: 1200; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 0.7; to: 0.2; duration: 1200; easing.type: Easing.InOutSine }
                }
            }

            IconImage {
                anchors.centerIn: parent
                source: `image://icon/${modelData}`
                implicitWidth: pinnedItem.implicitWidth
                implicitHeight: pinnedItem.implicitHeight
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    let win = Hyprland.toplevels.values.find(w => w.wayland && w.wayland.appId === modelData)
                    if (win) {
                        Hyprland.dispatch("focuswindow address:0x" + win.address)
                    } else {
                        Hyprland.dispatch("exec " + modelData)
                    }
                }
            }
        }
    }

        // Separator
        Rectangle {
            width: 1
            height: taskbar.implicitHeight - 8
            anchors.verticalCenter: parent.verticalCenter
            color: Color.bloodEmber
            opacity: 0.5
        }

        // Dynamic windows
        Repeater {
            model: Hyprland.toplevels.values.filter(w => {
                const inMonitor = monitorIndex === 0 
                    ? w.workspace && w.workspace.id <= 10
                    : w.workspace && w.workspace.id > 10
                const isPinned = w.wayland && pinnedApps.some(p => p.toLowerCase() === w.wayland.appId.toLowerCase())
                return inMonitor && !isPinned
            })

            Rectangle {
                Component.onCompleted: console.log("appId:", modelData.wayland ? modelData.wayland.appId : "no wayland")
                id: taskItem
                implicitWidth: 50
                implicitHeight: taskbar.implicitHeight + 1
                radius: 8
                color: Color.obsidianShadow
                border.width: 3
                border.color: Color.crimsonCore
                Behavior on border.color { ColorAnimation { duration: 200 } }

                property bool isHovered: hoverHandler.hovered

                HoverHandler { id: hoverHandler }

                PopupWindow {
                    id: tooltipPopup
                    onVisibleChanged: TrayState.tooltipVisible += visible ? 1 : -1
                    visible: taskItem.isHovered
                    implicitWidth: Math.min(tooltipText.implicitWidth + 16, 200)
                    implicitHeight: tooltipText.implicitHeight + 2
                    color: "transparent"
                    anchor.item: taskItem
                    anchor.gravity: Edges.Top
                    anchor.rect.y: -2
                    anchor.rect.x: taskItem.width / 2

                    Rectangle {
                        anchors.fill: parent
                        color: Color.charcoalNight
                        border.color: Color.bloodEmber
                        border.width: 3
                        radius: 8

                        Text {
                            id: tooltipText
                            text: modelData.title.length > 20 ? modelData.title.substring(0, 20) + "…" : modelData.title
                            anchors.centerIn: parent
                            color: Color.meteorTrail
                            font.pixelSize: 11
                        }
                    }
                }

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

                IconImage {
                    anchors.centerIn: parent
                    source: modelData.wayland ? `image://icon/${modelData.wayland.appId}` : ""
                    implicitWidth: taskItem.implicitWidth
                    implicitHeight: taskItem.implicitHeight
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("focuswindow address:0x" + modelData.address)
                }
            }
        }
    }
}
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: batteryWidget
    implicitHeight: 36
    implicitWidth: 36
    radius: 100
    color: Qt.rgba(Color.charcoalNight.r, Color.charcoalNight.g, Color.charcoalNight.b, 0.7)
    border.width: 3
    border.color: Color.bloodEmber

    property int percent: 0
    property bool charging: false

    property real pulseDuration: batteryWidget.percent > 50 ? 2000 :
                              batteryWidget.percent > 30 ? 1000 :
                              batteryWidget.percent > 20 ? 500 : 200

    SequentialAnimation {
        running: !batteryWidget.charging
        loops: Animation.Infinite

        NumberAnimation {
            target: fillCircle
            property: "opacity"
            from: 1.0
            to: 0.4
            duration: batteryWidget.pulseDuration
            easing.type: Easing.InOutSine
        }
        NumberAnimation {
            target: fillCircle
            property: "opacity"
            from: 0.4
            to: 1.0
            duration: batteryWidget.pulseDuration
            easing.type: Easing.InOutSine
        }
    }

    Process {
        id: batteryProc
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT1/capacity && cat /sys/class/power_supply/BAT1/status"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.trim().split("\n")
                batteryWidget.percent = parseInt(lines[0])
                batteryWidget.charging = lines[1].trim() === "Charging"
            }
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: batteryProc.running = true
    }

    // Inner fill circle
        Rectangle {
            id: fillCircle
            anchors.centerIn: parent
            width: (parent.width * (batteryWidget.percent / 100) - 8) * (
                batteryWidget.percent > 50 ? 1.0 :
                batteryWidget.percent > 30 ? 0.85 :
                batteryWidget.percent > 20 ? 0.7 : 0.5
            )
            height: (parent.height * (batteryWidget.percent / 100) - 8) * (
                batteryWidget.percent > 50 ? 1.0 :
                batteryWidget.percent > 30 ? 0.85 :
                batteryWidget.percent > 20 ? 0.7 : 0.5
            )   
            radius: 100
            color: batteryWidget.percent <= 20 && !batteryWidget.charging ? Color.plasmaRed :
                batteryWidget.charging ? Color.novaGlow : Color.bloodEmber
            Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
            Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 300 } }
        }

    // Hover text
    Text {
        anchors.centerIn: parent
        text: batteryWidget.charging ? "󰂄" : batteryWidget.percent + "%"
        color: Color.meteorTrail
        font.pixelSize: 12
        font.bold: true
        opacity: hoverHandler.hovered ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    HoverHandler {
        id: hoverHandler
    }
}
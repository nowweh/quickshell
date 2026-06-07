import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: wifiWidget
    implicitWidth: contentRow.implicitWidth + 20
    implicitHeight: 36

    Process {
    id: networkProc
    command: ["bash", "-c", "if nmcli -t -f ACTIVE,SSID dev wifi | grep -q '^yes'; then nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2; elif nmcli -t -f TYPE,STATE dev | grep -q '^ethernet:connected'; then echo 'WIRED'; else echo 'NONE'; fi"]
    running: true
    stdout: StdioCollector {
        onStreamFinished: {
            var out = text.trim()
            if (out === "WIRED") {
                networkNameText.text = "󰈀 Wired"
            } else if (out === "NONE" || out.length === 0) {
                networkNameText.text = "󰖪  No Network"
            } else {
                networkNameText.text = "󰖩  " + out
            }
        }
    }
}

Timer { 
    interval: 5000
    running: true
    repeat: true
    onTriggered: networkProc.running = true
}

    Rectangle {
        anchors.fill: parent
        radius: 100
        color: Qt.rgba(Color.charcoalNight.r, Color.charcoalNight.g, Color.charcoalNight.b, 0.7)
        border.color: Color.bloodEmber
        border.width: 3

        RowLayout {
            id: contentRow
            anchors.centerIn: parent
            spacing: 6

            Text {
                id: networkNameText
                text: "..."
                color: Color.meteorTrail
                font.pixelSize: 13
            }
        }
    }
}
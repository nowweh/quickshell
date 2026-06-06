import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

Rectangle {
    id: volumeWidget
    implicitHeight: 36
    implicitWidth: 120
    radius: 100
    color: Qt.rgba(Color.charcoalNight.r, Color.charcoalNight.g, Color.charcoalNight.b, 0.7)
    border.width: 3
    border.color: Color.bloodEmber
    clip: true

    property real volume: 0.0
    property bool muted: false

    PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
    }   

    Component.onCompleted: {
        Qt.callLater(function() {
            if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.ready) {
                volumeWidget.volume = Pipewire.defaultAudioSink.audio.volume
                volumeWidget.muted = Pipewire.defaultAudioSink.audio.muted
            }
        })
    }

    Connections {
        target: Pipewire.defaultAudioSink
        function onReadyChanged() {
            console.log("ready changed:", Pipewire.defaultAudioSink.ready)
            if (Pipewire.defaultAudioSink.ready) {
                volumeWidget.volume = Pipewire.defaultAudioSink.audio.volume
                volumeWidget.muted = Pipewire.defaultAudioSink.audio.muted
            }
        }
    }

    Connections {
        target: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.ready ? Pipewire.defaultAudioSink.audio : null
        function onVolumeChanged() {
            volumeWidget.volume = Pipewire.defaultAudioSink.audio.volume
        }
        function onMutedChanged() {
            volumeWidget.muted = Pipewire.defaultAudioSink.audio.muted
        }
    }

    Rectangle {
    id: fillBar
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.margins: 5
    width: Math.min(Math.max((parent.width - 6) * volumeWidget.volume, radius * 2), parent.width - 6)
    radius: 100
    color: volumeWidget.muted ? Color.smokedGraphite : Qt.rgba(
    Color.crimsonCore.r + (Color.plasmaRed.r - Color.crimsonCore.r) * volumeWidget.volume,
    Color.crimsonCore.g + (Color.plasmaRed.g - Color.crimsonCore.g) * volumeWidget.volume,
    Color.crimsonCore.b + (Color.plasmaRed.b - Color.crimsonCore.b) * volumeWidget.volume,
    1.0
    )
    Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutExpo } }
    Behavior on color { ColorAnimation { duration: 200 } }
    }

    Text {
        anchors.centerIn: parent
        text: volumeWidget.muted ? "󰖁  Muted" : "󰕾  " + Math.round(volumeWidget.volume * 100) + "%"
        color: Color.meteorTrail
        font.pixelSize: 12
        font.bold: true
        z: 1
    }

    MouseArea {
        anchors.fill: parent
        enabled: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.ready
        onPositionChanged: (mouse) => {
            if (pressed) {
                var newVol = Math.max(0.0, Math.min(1.0, mouse.x / width))
                Pipewire.defaultAudioSink.audio.volume = newVol
            }
        }
        onClicked: {
            Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
        }
    }
}
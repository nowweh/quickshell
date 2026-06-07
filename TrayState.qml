pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: trayState
    property bool isHovered: false
    property int tooltipCount: 0
    property bool tooltipVisible: tooltipCount > 0
}
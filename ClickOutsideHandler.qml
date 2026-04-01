import QtQuick 2.15

Item {
    id: root

    // Item or Window we want to monitor
    property Item target

    signal clickedOutside()

    anchors.fill: parent
    z: 9999
    visible: target && target.visible

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true

        onPressed: (mouse) => {

            if (!root.target)
                return

            var global = root.mapToGlobal(mouse.x, mouse.y)

            var targetPos = root.target.mapToGlobal(0, 0)

            var inside =
                global.x >= targetPos.x &&
                global.x <= targetPos.x + root.target.width &&
                global.y >= targetPos.y &&
                global.y <= targetPos.y + root.target.height

            if (!inside)
                root.clickedOutside()

            mouse.accepted = false
        }
    }
}
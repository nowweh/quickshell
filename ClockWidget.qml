import QtQuick
import Quickshell
import QtQuick.Controls
import Quickshell.Hyprland

FocusScope {
    id: moduleRoot

    implicitHeight: clockRect.implicitHeight
    implicitWidth: clockRect.implicitWidth

    ClickOutsideHandler {
        target: calendarPopup
        onClickedOutside: calendarPopup.visible = false
    }

    Window {
        id: calendarPopup
        visible: false
        width: grid.width + 35
        height: calendarLayout.implicitHeight + calendarLayout.anchors.topMargin - 20
        color: "transparent"
        flags: Qt.Popup 

        property int currentMonth: new Date().getMonth()
        property int currentYear: new Date().getFullYear()

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(Color.charcoalNight.r, Color.charcoalNight.g, Color.charcoalNight.b, 0.9)
            radius: 15
            border.width: 3
            border.color: Color.bloodEmber
        

            Column {
                id: calendarLayout
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 15
                spacing: 8
                width: grid.width

                        Item {
                            width: calendarLayout.width
                            height: 30
                          

                            // Left Arrow
                            MouseArea {
                                id: leftArrow
                                width: 20
                                height: 20
                                cursorShape: Qt.PointingHandCursor
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                             
                                Text {
                                    anchors.centerIn: parent
                                    text: ""
                                    color: Color.dyingStar
                                    font.pixelSize: 16
                                }

                                onClicked: {
                                    calendarPopup.currentMonth--

                                    if (calendarPopup.currentMonth < 0) {
                                        calendarPopup.currentMonth = 11
                                        calendarPopup.currentYear--
                                    }
                                }
                            }

                            // Month Label
                            Text{ 
                                text: new Date(calendarPopup.currentYear,
                                                calendarPopup.currentMonth,
                                                1).toLocaleDateString(Qt.locale(), "MMMM yyyy")
                                color: Color.bloodEmber
                                font.pixelSize: 18
                                font.bold: true
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            
                            MouseArea {
                                width: 20
                                height: 20
                                cursorShape: Qt.PointingHandCursor
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right


                                Text {
                                    anchors.centerIn: parent
                                    text: ""
                                    color: Color.dyingStar
                                    font.pixelSize: 16
                                }

                                onClicked: {
                                    calendarPopup.currentMonth++

                                    if (calendarPopup.currentMonth > 11) {
                                        calendarPopup.currentMonth = 0
                                        calendarPopup.currentYear++
                                    }
                                }
                            }
                        }


                DayOfWeekRow {
                    locale: grid.locale
                    font.bold: true
                    width: grid.width
                    delegate: Text {
                        text: model.narrowName
                        color: Color.dyingStar
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
        
                MonthGrid {
                    id: grid 
                    month: calendarPopup.currentMonth
                    year: calendarPopup.currentYear
                

                    width: 210
                    height: 180

                    delegate: Item {
                        id: dayCell
                        width: grid.width / 7
                        height: grid.height / 6
                        visible: model.month == grid.month
                        property bool hovered: false
                        scale: hovered && !model.today ? 1.1 : 1
                        Behavior on scale {
                            NumberAnimation {duration: 120}
                        }

                        Rectangle {
                            id: highlight
                            anchors.centerIn: parent
                            width: 24
                            height: 24
                            radius: width / 2
                            
                            
                            visible: model.today
                                    && grid.month === calendarPopup.currentMonth
                                    && grid.year === calendarPopup.currentYear
                                    || dayCell.hovered
                            
                            
                            color: (model.today
                                    && grid.month === calendarPopup.currentMonth
                                    && grid.year === calendarPopup.currentYear)
                                    ? Color.bloodEmber
                                    : Qt.rgba(Color.bloodEmber.r, Color.bloodEmber.g, Color.bloodEmber.b, 0.25)

                            Behavior on opacity {
                                NumberAnimation { duration: 120 }
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: model.day

                            color: model.today ? Color.charcoalNight : (dayCell.hovered ? Color.bloodEmber : Color.dyingStar)
                            font.bold: model.today
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: dayCell.hovered = true
                            onExited: dayCell.hovered = false
                        }
                    }
                    
                }
            }
        }
    }

    Rectangle {
        id: clockRect
    
        color: Qt.rgba(Color.charcoalNight.r, Color.charcoalNight.g, Color.charcoalNight.b, 0.7)
        radius: 100
        border.width: 3
        border.color: Color.bloodEmber

        implicitWidth: timeLabel.implicitWidth + 15
        implicitHeight: 35


        Text {
            id: timeLabel
            text: " " + Time.time
        
            color: Color.dyingStar
            font.pixelSize: 15
            font.family: "anonymicePro Nerd Font Propo"
            font.bold: false
        
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked:{
                var screenPos = clockRect.mapToGlobal(0, 0);
                calendarPopup.x = screenPos.x - (calendarPopup.width / 2) + (clockRect.width / 2);
                calendarPopup.y = screenPos.y + clockRect.height + 5;
                
                calendarPopup.visible = !calendarPopup.visible;

                if (calendarPopup.visible) {
                    calendarPopup.raise();
                    calendarPopup.requestActivate();
                }
            }
        }
    }
}

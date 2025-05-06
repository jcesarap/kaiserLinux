// Copyright 2022 Alexey Varfolomeev <varlesh@gmail.com>
// Used sources & ideas:
// - Joshua Krämer from https://github.com/joshuakraemer/sddm-theme-dialog
// - Suraj Mandal from https://github.com/surajmandalcell/Elegant-sddm
// - Breeze theme by KDE Visual Design Group
// - SDDM Team https://github.com/sddm/sddm
import QtQuick 2.8
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import "components"

Rectangle {
    width: 640
    height: 480
    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int selectedModelIndex: userModel.lastIndex
    property var currentIndex: userModel.lastIndex
    property int identifiquerOfChanges: 0
    property int identifiquerOfChanges2: 0
    property int iconSize: 30

    TextConstants {
        id: textConstants
    }
    function updateView() {
        // Alternar la visibilidad del elemento 'view'
        view.visible = !view.visible;
    }
    // hack for disable autostart QtQuick.VirtualKeyboard
    Loader {
        id: inputPanel
        property bool keyboardActive: false
        source: "components/VirtualKeyboard.qml"
    }
    FontLoader {
        id: fontbold
        source: "fonts/SFUIText-Semibold.otf"
    }
    Connections {
        target: sddm
        onLoginSucceeded: {

        }
        onLoginFailed: {
            password.placeholderText = textConstants.loginFailed
            password.placeholderTextColor = "white"
            password.text = ""
            password.focus = false
            errorMsgContainer.visible = true
        }
    }

    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        Binding on source {
            when: config.background !== undefined
            value: config.background
        }
    }


    DropShadow {
        anchors.fill: panel
        horizontalOffset: 0
        verticalOffset: 0
        radius: 0
        samples: 17
        color: "#70000000"
        source: panel
        }

    Row {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.topMargin: 15

        Item {

            Image {
                id: shutdown
                height: 22
                width: 22
                source: "images/system-shutdown.svg"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        shutdown.source = "images/system-shutdown-hover.svg"
                        var component = Qt.createComponent(
                                    "components/ShutdownToolTip.qml")
                        if (component.status === Component.Ready) {
                            var tooltip = component.createObject(shutdown)
                            tooltip.x = -100
                            tooltip.y = 40
                            tooltip.destroy(600)
                        }
                    }
                    onExited: {
                        shutdown.source = "images/system-shutdown.svg"
                    }
                    onClicked: {
                        shutdown.source = "images/system-shutdown-pressed.svg"
                        sddm.powerOff()
                    }
                }
            }
        }
    }

    Row {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 70
        anchors.topMargin: 15

        Item {

            Image {
                id: reboot
                height: 22
                width: 22
                source: "images/system-reboot.svg"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        reboot.source = "images/system-reboot-hover.svg"
                        var component = Qt.createComponent(
                                    "components/RebootToolTip.qml")
                        if (component.status === Component.Ready) {
                            var tooltip = component.createObject(reboot)
                            tooltip.x = -100
                            tooltip.y = 40
                            tooltip.destroy(600)
                        }
                    }
                    onExited: {
                        reboot.source = "images/system-reboot.svg"
                    }
                    onClicked: {
                        reboot.source = "images/system-reboot-pressed.svg"
                        sddm.reboot()
                    }
                }
            }
        }
    }
Row {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 88
        anchors.topMargin: 15
        Text {
            id: kb
            color: "#eff0f1"
            text: keyboard.layouts[keyboard.currentLayout].shortName
            font.pointSize: 12
            font.weight: Font.DemiBold
        }
    }
        Row {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 110
        anchors.topMargin: 15

         ComboBox {
                    id: session
                    height: 22
                    width: 150
                    model: sessionModel
                    textRole: "name"
                    displayText: ""
                    currentIndex: sessionModel.lastIndex
                    background: Rectangle {
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    color: "transparent"
                }


                    delegate: MenuItem {
                        id: menuitems
                        width: slistview.width * 4
                        text: session.textRole ? (Array.isArray(session.model) ? modelData[session.textRole] : model[session.textRole]) : modelData
                        highlighted: session.highlightedIndex === index
                        hoverEnabled: session.hoverEnabled
                        onClicked: {
                            ava.source = "/var/lib/AccountsService/icons/" + user.currentText
                            session.currentIndex = index
                            slistview.currentIndex = index
                            session.popup.close()
                        }
                    }
                    indicator: Rectangle{
                        anchors.right: parent.right
                        anchors.rightMargin: 9
                        height: parent.height
                        width: 22
                        color: "transparent"
                        Image{
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: width
                            fillMode: Image.PreserveAspectFit
                            source: "images/conf.svg"
                        }
                    }
                    popup: Popup {
                        width: parent.width
                        height: parent.height * menuitems.count
                        implicitHeight: slistview.contentHeight
                        margins: 0
                        contentItem: ListView {
                            id: slistview
                            clip: true
                            anchors.fill: parent
                            model: session.model
                            spacing: 0
                            highlightFollowsCurrentItem: true
                            currentIndex: session.highlightedIndex
                            delegate: session.delegate
                        }
                    }

                }
    }

Item {
    width: parent.width
   Rectangle {
       height: 300
       width: 400
       anchors.horizontalCenter: parent.horizontalCenter
       color: "transparent"
            Clock {
            id: clock
            visible: true
            anchors.topMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        }
}
}

    Item {
        width: dialog.width
        height: dialog.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        Rectangle {
            id: dialog
            color: "transparent"
            height: 270
            width: 400
        }
            Grid {
                columns: 1
                spacing: 8
                verticalItemAlignment: Grid.AlignVCenter
                horizontalItemAlignment: Grid.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter


Rectangle {
    id: baseOfPath

    width: 150
    height: 150
    color: "transparent"
                    Column {
                        anchors.centerIn: parent
                    Item {

                        Rectangle {
                            id: mask
                            width: 85
                            height: 85
                            radius: 100
                            visible: false
                        }

                        DropShadow {
                            anchors.fill: mask
                            width: mask.width
                            height: mask.height
                            horizontalOffset: 0
                            verticalOffset: 0
                            radius: 8
                            samples: 10
                            color: "#40000000"
                            source: mask
                        }
                    }

                    Image {
                        id: ava
                        width: 86
                        height: 86
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: mask
                        }
                        source: "/var/lib/AccountsService/icons/" + user.currentText
                        MouseArea {
                          id: mouseAreados
                          anchors.fill: parent
                          onClicked: {
                               if (view.visible === true) {
                                   view.visible = false
                            } else {
                                view.visible = true
                            }
                            enabled = false;
                             }
                        }

                    }

                }
                ComboBox {
                    id: user
                    height: 40
                    width: 226
                    textRole: "name"
                    currentIndex: userModel.lastIndex
                    model: userModel
                    visible: false
                }
                                        PathView {
        id: view
        anchors.fill: parent
        highlight: appHighlight
        currentIndex: userModel.lastIndex
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: userModel
        visible: false
        onVisibleChanged: {
        mouseAreados.enabled = true;
    }
        path: Path {
            startX: (baseOfPath.width+iconSize)/2; startY: 0

                PathArc {
                    x: (baseOfPath.width+iconSize)/2; y: baseOfPath.height-(iconSize/2)
                    radiusX: 25; radiusY: 25
                     useLargeArc: true

                }
                PathPercent {value: (userModel.count < 5) ? 1.25 : (userModel.count < 9) ? 1 : .5 }

                PathArc {
                    x: (baseOfPath.width+iconSize)/2; y: 0
                    radiusX: 25; radiusY: 25
                     useLargeArc: true

                }
                PathPercent {value: (userModel.count > 9) ? .5 :  0 }
        }

                delegate: Item {
            id: icsSize
            width: iconSize
            height: iconSize

            Rectangle {
                width: parent.width
                height: parent.height
                radius: width/2
                color: "transparent"
                Rectangle {
                    id: maskmenu
                    width: parent.width
                    height: parent.height
                    radius: parent.radius
                    color: "black"
                    visible: false
                    z: 0
                }
                Image {
                    source: model.icon
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    z: 1
                    layer.enabled: true
                         layer.effect: OpacityMask {
                          maskSource: maskmenu
                                }
                   }
                Rectangle {
                    id: tooltip
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width*1.2
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height/2
                    width: nametooltip.width+parent.width
                    height: parent.height
                    color: "transparent"
                    visible: false
                    radius: height/2
                    z: 2
                    Text {
                        id: nametooltip
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true
                        font.pixelSize: tooltip.height/2
                        text: model.name
                        color: "white"
                        layer.effect: DropShadow {
                           horizontalOffset: 1
                           verticalOffset: 1
                           radius: 10
                           samples: 25
                           color: "#40000000"
                              }
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                     onEntered: {
                    tooltip.visible = true;
                             }
                    onExited: {
                          // Ocultar el elemento al dejar de pasar el puntero
                          tooltip.visible = false;
                         }
                    onClicked: {
                        userModel.selectedModelIndex = index;
                        ava.source = model.icon;
                        usernametext.text = model.name;
                        view.visible = (view.visible === true) ? false: true
                    }
                }
            }
        }
    }
Text {
                    id: usernametext
                    text: user.currentText
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 20
                    font.family: fontbold.name
                    font.capitalization: Font.Capitalize
                    font.weight: Font.DemiBold
                    color: "white"
                    layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 1
                verticalOffset: 1
                radius: 10
                samples: 25
                color: "#26000000"
            }
                }
}

                TextField {
                    id: password
                    height: 32
                    width: 250
                    color: "#fff"
                    echoMode: TextInput.Password
                    focus: true
                    placeholderText: textConstants.password
                    onAccepted: sddm.login(user.currentText, password.text,
                                           session.currentIndex)

                    background: Rectangle {
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    color: "#fff"
                    opacity: 0.2
                    radius: 15
                    }

                    Image {
                        id: caps
                        width: 24
                        height: 24
                        opacity: 0
                        state: keyboard.capsLock ? "activated" : ""
                        anchors.right: password.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 10
                        fillMode: Image.PreserveAspectFit
                        source: "images/capslock.svg"
                        sourceSize.width: 24
                        sourceSize.height: 24

                        states: [
                            State {
                                name: "activated"
                                PropertyChanges {
                                    target: caps
                                    opacity: 1
                                }
                            },
                            State {
                                name: ""
                                PropertyChanges {
                                    target: caps
                                    opacity: 0
                                }
                            }
                        ]

                        transitions: [
                            Transition {
                                to: "activated"
                                NumberAnimation {
                                    target: caps
                                    property: "opacity"
                                    from: 0
                                    to: 1
                                    duration: imageFadeIn
                                }
                            },

                            Transition {
                                to: ""
                                NumberAnimation {
                                    target: caps
                                    property: "opacity"
                                    from: 1
                                    to: 0
                                    duration: imageFadeOut
                                }
                            }
                        ]
                    }
                }

          Label {
                id: greetingLabel
                text: "Enter Password"
                color: "#fff"
                style: softwareRendering ? Text.Outline : Text.Normal
                styleColor: softwareRendering ? ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
                font.pointSize:8
                Layout.alignment: Qt.AlignHCenter
                font.family: config.font
                font.bold: true
            }
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return
                            || event.key === Qt.Key_Enter) {
                        sddm.login(user.currentText, password.text,
                                   session.currentIndex)
                        event.accepted = true
                    }
                }

                // Custom ComboBox for hack colors on DropDownMenu

            }
    }
}

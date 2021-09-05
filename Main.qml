/***********************************************************************/


import QtQuick 2.5

import SddmComponents 2.0


Rectangle {
    width: 640
    height: 480
    color: "#000000"

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        function onLoginSucceeded() {
            errorMessage.color = "a0a0a0"
            errorMessage.text = textConstants.loginSucceeded
        }

        function onLoginFailed() {
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }
    }


    Rectangle {
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
        color: "transparent"
        transformOrigin: Item.Top

        Rectangle {
            id: dialog
            anchors.centerIn: parent
            height: parent.height / 12 * 3
            width: height * 1.5
            color: "#0C0C0C"

            Column {
                id: mainColumn
                anchors.centerIn: parent
                width: parent.width * 0.9
                spacing: dialog.height / 22.5

                Row {
                    width: parent.width
                    spacing: Math.round(dialog.height / 70)
                    Text {
                        id: lblName
                        width: parent.width * 0.20; height: dialog.height / 7
                        color: "white"
                        text: textConstants.userName
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                        font.pixelSize: dialog.height / 22.5
                    }

                    TextBox {
                        id: name
                        width: parent.width * 0.8; height: dialog.height / 7
                        text: userModel.lastUser
                        font.pixelSize: dialog.height / 20

                        KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing : Math.round(dialog.height / 70)

                    Text {
                        id: lblPassword
                        width: parent.width * 0.2; height: dialog.height / 7
                        color: "white"
                        text: textConstants.password
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                        font.pixelSize: dialog.height / 22.5
                    }

                    PasswordBox {
                        id: password
                        width: parent.width * 0.8; height: dialog.height / 7
                        font.pixelSize: dialog.height / 20

                        tooltipBG: "lightgrey"
                        focus: true
                        Timer {
                            interval: 200
                            running: true
                            onTriggered: password.forceActiveFocus()
                        }

                        KeyNavigation.backtab: name; KeyNavigation.tab: session

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing: Math.round(dialog.height / 70)
                    z: 100

                    Text {
                        id: lblSession
                        width: parent.width * 0.2; height: dialog.height / 7
                        text: textConstants.session
                        verticalAlignment: Text.AlignVCenter
                        color: "white"
                        wrapMode: TextEdit.WordWrap
                        font.bold: true
                        font.pixelSize: dialog.height / 22.5
                    }

                    ComboBox {
                        id: session
                        width: parent.width * 0.8; height: dialog.height / 7
                        font.pixelSize: dialog.height / 20

                        arrowIcon: "angle-down.png"

                        model: sessionModel
                        index: sessionModel.lastIndex

                        KeyNavigation.backtab: password; KeyNavigation.tab: loginButton
                    }
                }

                Text {
                    id: errorMessage
                    text: " "
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    font.pixelSize: dialog.height / 22.5
                }

                Row {
                    spacing: Math.round(dialog.height / 40)
                    anchors.horizontalCenter: parent.horizontalCenter
                    property int btnWidth: Math.max(loginButton.implicitWidth,
                                                    shutdownButton.implicitWidth,
                                                    rebootButton.implicitWidth, dialog.height / 3) + 8
                    Button {
                        id: loginButton
                        text: textConstants.login
                        width: parent.btnWidth
                        height: dialog.height / 7
                        font.pixelSize: dialog.height / 20
                        color: "#3f3f3f"
                        activeColor: "#6e6e6e"
                        pressedColor: "#ababab"

                        onClicked: sddm.login(name.text, password.text, session.index)

                        KeyNavigation.backtab: session; KeyNavigation.tab: shutdownButton
                    }

                    Button {
                        id: shutdownButton
                        text: textConstants.shutdown
                        width: parent.btnWidth
                        height: dialog.height / 7
                        font.pixelSize: dialog.height / 20
                        color: "#3f3f3f"
                        activeColor: "#6e6e6e"
                        pressedColor: "#ababab"

                        onClicked: sddm.powerOff()

                        KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                    }

                    Button {
                        id: rebootButton
                        text: textConstants.reboot
                        width: parent.btnWidth
                        height: dialog.height / 7
                        font.pixelSize: dialog.height / 20
                        color: "#3f3f3f"
                        activeColor: "#6e6e6e"
                        pressedColor: "#ababab"

                        onClicked: sddm.reboot()

                        KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}

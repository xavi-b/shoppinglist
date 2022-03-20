import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Singleton

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    ColumnLayout {
        anchors.fill: parent

        ListView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            id: listview
            model: Singleton.model

            delegate: SwipeDelegate {
                id: swipeDelegate
                width: listview.width

                text: modelData.title

                contentItem: RowLayout {
                    Label {
                        Layout.fillWidth: true
                        text: modelData.title
                        color: "black"
                    }
                    CheckBox {
                        id: checkbox
                        checked: modelData.checked
                        onCheckedChanged: modelData.checked = checked
                    }
                }

                onClicked: {
                    checkbox.toggle()
                }

                ListView.onRemove: SequentialAnimation {
                    PropertyAction {
                        target: swipeDelegate
                        property: "ListView.delayRemove"
                        value: true
                    }
                    NumberAnimation {
                        target: swipeDelegate
                        property: "height"
                        to: 0
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAction {
                        target: swipeDelegate
                        property: "ListView.delayRemove"
                        value: false
                    }
                }

                swipe.right: Label {
                    id: deleteLabel
                    text: qsTr("Delete")
                    color: "white"
                    verticalAlignment: Label.AlignVCenter
                    padding: 12
                    height: parent.height
                    anchors.right: parent.right

                    SwipeDelegate.onClicked: {
                        Singleton.remove(index)
                    }

                    background: Rectangle {
                        color: deleteLabel.SwipeDelegate.pressed ? Qt.darker(
                                                                       "tomato",
                                                                       1.1) : "tomato"
                    }
                }
            }

            RoundButton {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 5
                text: "+"
                onClicked: {
                    popup.open()
                }
            }
        }
    }

    Popup {
        id: popup
        parent: Overlay.overlay
        anchors.centerIn: parent
        width: parent.width - 50
        height: 150

        modal: true
        focus: true

        onOpened: textedit.forceActiveFocus()

        contentItem: Item {
            TextField {
                id: textedit
                clip: true
                anchors.left: parent.left
                anchors.right: parent.right
            }

            Row {
                id: row
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                spacing: 5

                Button {
                    text: qsTr("Cancel")
                    onClicked: {
                        textedit.clear()
                        popup.close()
                    }
                }

                Button {
                    text: qsTr("Add")
                    onClicked: {
                        Singleton.add(textedit.text)
                        textedit.clear()
                        popup.close()
                    }
                }
            }
        }
    }
}

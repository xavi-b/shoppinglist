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

                onPressAndHold: {
                    popup.modelData = modelData
                    popup.edit = true
                    popup.open()
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
                id: plusBtn
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 5
                text: "+"
                onClicked: {
                    popup.edit = false
                    popup.open()
                }
            }

            RoundButton {
                anchors.right: plusBtn.left
                anchors.bottom: parent.bottom
                anchors.margins: 5
                text: "u"
                onClicked: {
                    for (var i = 0; i < Singleton.model.length; ++i) {
                        Singleton.model[i].checked = false
                    }
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

        property bool edit: false
        property var modelData: undefined

        contentItem: Item {
            TextField {
                id: textedit
                clip: true
                anchors.left: parent.left
                anchors.right: parent.right
                text: popup.edit ? popup.modelData.title : ""
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
                    text: popup.edit ? qsTr("Edit") : qsTr("Add")
                    onClicked: {
                        if (popup.edit) {
                            popup.modelData.title = textedit.text
                        } else {
                            Singleton.add(textedit.text)
                        }
                        textedit.clear()
                        popup.close()
                    }
                }
            }
        }
    }
}

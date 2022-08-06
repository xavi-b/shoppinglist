import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Singleton

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("ShoppingList")

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

                text: model.title

                function remove() {
                    Singleton.remove(index)
                }

                contentItem: RowLayout {
                    Label {
                        Layout.fillWidth: true
                        text: model.title
                        color: "black"
                    }
                    CheckBox {
                        id: checkbox
                        checked: model.selected
                        onCheckedChanged: model.selected = checkbox.checked
                    }
                }

                onPressAndHold: {
                    popup.modelData = model
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

                    SwipeDelegate.onClicked: swipeDelegate.remove()

                    background: Rectangle {
                        color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                    }
                }

                Timer {
                    id: timer
                }

                function delay(delayTime, cb) {
                    timer.interval = delayTime
                    timer.repeat = false
                    timer.triggered.connect(cb)
                    timer.start()
                }

                swipe.left: Rectangle {
                    color: "AliceBlue"
                    height: parent.height
                    anchors.left: parent.left
                    width: 100

                    SwipeDelegate.onClicked: swipeDelegate.swipe.close()
                }

                swipe.onCompleted: {
                    if (swipe.position == 1.0) {
                        checkbox.toggle()
                        delay(10, function () {
                            swipeDelegate.swipe.close()
                        })
                    }
                }
            }

            footer: Item {
                height: plusBtn.height + plusBtn.anchors.margins * 2
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
                id: unselectBtn
                anchors.right: plusBtn.left
                anchors.bottom: parent.bottom
                anchors.margins: 5
                text: "U"
                onClicked: {
                    for (var i = 0; i < Singleton.model.length; ++i) {
                        Singleton.model[i].checked = false
                    }
                }
            }

            RoundButton {
                anchors.right: unselectBtn.left
                anchors.bottom: parent.bottom
                anchors.margins: 5
                text: "S"
                onClicked: {
                    Singleton.sortByChecked()
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
                            listview.positionViewAtEnd()
                        }
                        textedit.clear()
                        popup.close()
                    }
                }
            }
        }
    }
}

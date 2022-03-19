import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
            model: 3

            delegate: SwipeDelegate {
                id: swipeDelegate
                width: listview.width

                spacing: 5

                text: modelData

                palette.base: checkbox.checked ? "lightgreen" : "salmon"
                palette.button: Qt.lighter(palette.base, 1.2)

                contentItem: RowLayout {
                    Label {
                        Layout.fillWidth: true
                        text: modelData
                    }
                    CheckBox {
                        id: checkbox
                        checked: true
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

                        // TODO
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

                    // TODO
                }
            }
        }
    }
}

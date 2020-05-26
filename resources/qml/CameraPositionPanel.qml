import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import UM 1.4 as UM
import Cura 1.0 as Cura

UM.Dialog
{
    Item
    {      
        Rectangle
        {
            id: cameraViewsContent
            width: parent.width
            height: parent.height
            anchors
            {
                top: parent.top
                left: parent.left
                leftMargin: UM.Theme.getSize("default_margin").width
                right: parent.right
                bottom: finishButton.top
                bottomMargin: UM.Theme.getSize("default_margin").height           
            }
            
            ScrollView
            {
                id: cameraViewsScrollView
                width: parent.width
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                visible: True
                anchors
                {
                    top: cameraViewsContent.bottom
                    topMargin: UM.Theme.getSize("default_margin").height
                    left: parent.left
                    leftMargin: UM.Theme.getSize("default_margin").width
                    right: parent.right
                    bottom: parent.bottom
                }
                
                Column
                {
                    id: cameraViewsColumn
                    spacing: 2 * UM.Theme.getSize("default_margin").height
                    Repeater
                    {
                        id: cameraViewsRepeater
                        model: manager.getStoredViewsModel()
                        delegate: Item
                            {
                                width: cameraViewsScrollView.width
                                height: contentColumn.height
                                
                                Column
                                {
                                    id: contentColumn
                                    Label
                                    {
                                        id: viewName
                                        leftPadding: UM.Theme.getSize("default_margin").width
                                        text: model.name
                                        font: UM.Theme.getFont("large_bold")
                                        color: UM.Theme.getColor("text")
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
}
import QtQuick 2.3
import QtQuick.Controls 1.4

import UM 1.4 as UM
import Cura 1.0 as Cura

import CameraPositionPlugin 1.0 as CPP

UM.Dialog
{
    id: dialog

    title: "Camera Position"

    minimumWidth: screenScaleFactor * 820;
    minimumHeight: screenScaleFactor * 400;
    width: groupBox.width
    height: { groupBox.height + screenScaleFactor * 80 }
//    modality: Qt.NonModal Todo: Make it work nonmodal
    
    signal storeViews
    
    GroupBox
    {
        id: groupBox
        title: "Views"
        height: { contents.height + screenScaleFactor * 40 }
        
        ExclusiveGroup { id: tabPositionGroup }
        Column
        {
            id: contents
            spacing: UM.Theme.getSize("thin_margin").width
            
            CPP.CustomCameraView
            {
                id: cameraView
                name: "actual"
                live: false
//                onTransformationChanged:
//                {
//                    actualLocation.text = cameraView.description
//                }
            }
            
            Label
            {
                id: actualLocation
                text: cameraView.description
            }
            // Todo: Make it work with a Reapeater
            CameraViewRow
            {
                name: "stored_1"
                id: "stored1"
                exclusiveGroup: tabPositionGroup
                live: false
                anchors.right: contents.right
                onChangedView:
                {
                    saveButton.enabled = true;
                }
            }
            CameraViewRow
            {
                name: "stored_2"
                id: "stored2"
                exclusiveGroup: tabPositionGroup
                live: false
                anchors.right: contents.right
                onChangedView:
                {
                    saveButton.enabled = true;
                }
            }
            CameraViewRow
            {
                name: "stored_3"
                id: "stored3"
                exclusiveGroup: tabPositionGroup
                live: false
                anchors.right: contents.right
                onChangedView:
                {
                    saveButton.enabled = true;
                }
            }
            CameraViewRow
            {
                name: "stored_4"
                id: "stored4"
                exclusiveGroup: tabPositionGroup
                live: false
                anchors.right: contents.right
                onChangedView:
                {
                    saveButton.enabled = true;
                }
            }
            CameraViewRow
            {
                name: "stored_5"
                id: "stored5"
                exclusiveGroup: tabPositionGroup
                live: false
                anchors.right: contents.right
                onChangedView:
                {
                    saveButton.enabled = true;
                }
            }
            CameraViewRow
            {
                name: "stored_6"
                id: "stored6"
                exclusiveGroup: tabPositionGroup
                live: false
                anchors.right: contents.right
                onChangedView:
                {
                    saveButton.enabled = true;
                }
            }
            CameraViewRow
            {
                name: "stored_7"
                id: "stored7"
                exclusiveGroup: tabPositionGroup
                live: false
                anchors.right: contents.right
                onChangedView:
                {
                    saveButton.enabled = true;
                }
            }
            CameraViewRow
            {
                name: "stored_8"
                id: "stored8"
                exclusiveGroup: tabPositionGroup
                live: false
                anchors.right: contents.right
                onChangedView:
                {
                    saveButton.enabled = true;
                }
            }
            CameraViewRow
            {
                name: "stored_9"
                id: "stored9"
                exclusiveGroup: tabPositionGroup
                live: false
                anchors.right: contents.right
                onChangedView:
                {
                    saveButton.enabled = true;
                }
            }
            CameraViewRow
            {
                name: "stored_10"
                id: "stored10"
                exclusiveGroup: tabPositionGroup
                live: false
                anchors.right: contents.right
                onChangedView:
                {
                    saveButton.enabled = true;
                }
            }  
        }
    }
    
    function decoupleLive()
    {
        stored1.live = false
        stored2.live = false
        stored3.live = false
        stored4.live = false
        stored5.live = false
        stored6.live = false
        stored7.live = false
        stored8.live = false
        stored9.live = false
        stored10.live = false
    }
    
    rightButtons: Button
    {
        id: closeButton
        text: "Close"
        
        onClicked:
         {
            dialog.decoupleLive();
            dialog.visible = false;
         }
    }
    leftButtons: Button
    {
        id: saveButton
        text: "Save"
        enabled: false

        onClicked:
        {
            dialog.decoupleLive();
            dialog.storeViews();
            dialog.visible = false;
        }
    }
}
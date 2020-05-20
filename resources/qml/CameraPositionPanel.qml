import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.4 as UM
import Cura 1.0 as Cura

import CameraPositionPlugin 1.0 as CPP

UM.Dialog
{
    id: dialog

    title: "Camera Position"
    width: contents.width
    minimumWidth: screenScaleFactor * 600;
    minimumHeight: screenScaleFactor * 400;
    height: { contents.height + screenScaleFactor * 80 }
    
    signal storeViews
    
    Column
    {
        id: contents
        padding: UM.Theme.getSize("thick_margin").width
        spacing: UM.Theme.getSize("thin_margin").width
        
        // Todo: Make it work with a Reapeater
        CameraViewRow
        {
            name: "stored_1"
            id: "stored1"
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
            live: false
            anchors.right: contents.right
            onChangedView:
            {
                saveButton.enabled = true;
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
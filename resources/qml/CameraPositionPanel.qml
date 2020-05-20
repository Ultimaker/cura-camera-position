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
    
    Column
    {
        id: contents
        padding: UM.Theme.getSize("thick_margin").width
        spacing: UM.Theme.getSize("thin_margin").width
        
        // Todo: Make it work with a Reapeater
        CameraViewRow
        {
            name: "stored_1"
            live: false
        }
        CameraViewRow
        {
            name: "stored_2"
            live: false
        }
        CameraViewRow
        {
            name: "stored_3"
            live: false
        }
        CameraViewRow
        {
            name: "stored_4"
            live: false
        }
        CameraViewRow
        {
            name: "stored_5"
            live: false
        }
        CameraViewRow
        {
            name: "stored_6"
            live: false
        }
        CameraViewRow
        {
            name: "stored_7"
            live: false
        }
        CameraViewRow
        {
            name: "stored_8"
            live: false
        }
        CameraViewRow
        {
            name: "stored_9"
            live: false
        }
        CameraViewRow
        {
            name: "stored_10"
            live: false
        }  
    }
    
    rightButtons: Button
    {
        id: closeButton
        text: "Close"

        onClicked: dialog.visible = false;
    }
}
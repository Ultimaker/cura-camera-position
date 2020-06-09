import QtQuick 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2

import UM 1.4 as UM
import Cura 1.0 as Cura

UM.Dialog
{
    id: base
    title: "Camera"
    modality: Qt.NonModal
    flags: Qt.Tool | Qt.Widget| Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowCloseButtonHint
    
    minimumHeight: positionColumn.height + finishButton.height + (2 * UM.Theme.getSize("default_margin").width) * screenScaleFactor;
    maximumHeight: minimumHeight;
    height: minimumHeight;
    
    minimumWidth: 100 * screenScaleFactor;
    width: 150 * screenScaleFactor;
    color: UM.Theme.getColor("main_background")
    
    Column
    {
        id: positionColumn
        
        anchors.leftMargin: UM.Theme.getSize("default_margin").width *  screenScaleFactor;
        anchors.rightMargin: base.widt - UM.Theme.getSize("default_margin").width * screenScaleFactor;
        
        TextFieldWithLabel
        {
            id: xField
            labelWidth: 20 * screenScaleFactor;
            textWidth: base.width - labelWidth -  spacing - (2 * UM.Theme.getSize("default_margin").width) * screenScaleFactor;
            
            text: "x"
            value: manager.x
            validator: IntValidator {bottom: -1000; top: 1000;}
            onEditingFinished: { manager.x = value; }
        }
        TextFieldWithLabel
        {
            id: yField
            labelWidth: 20 * screenScaleFactor;
            textWidth: base.width - labelWidth -  spacing - (2 * UM.Theme.getSize("default_margin").width) * screenScaleFactor;
            
            text: "y"
            value: manager.y
            validator: IntValidator {bottom: -1000; top: 1000;}
            onEditingFinished: { manager.y = value; } 
        }
        TextFieldWithLabel
        {
            id: zField
            labelWidth: 20 * screenScaleFactor;
            textWidth: base.width - labelWidth -  spacing - (2 * UM.Theme.getSize("default_margin").width) * screenScaleFactor;
            
            text: "z"
            value: manager.z
            validator: IntValidator {bottom: -1000; top: 1000;}
            onEditingFinished: { manager.z = value; }
        }
        
        TextFieldWithLabel
        {
            id: rollField
            labelWidth: 20 * screenScaleFactor;
            textWidth: base.width - labelWidth -  spacing - (2 * UM.Theme.getSize("default_margin").width) * screenScaleFactor;
            
            text: "roll"
            value: manager.roll
            validator: DoubleValidator {bottom: -360; top: 360;}
            onEditingFinished: { manager.roll = value; }
        }
        TextFieldWithLabel
        {
            id: pitchField
            labelWidth: 20 * screenScaleFactor;
            textWidth: base.width - labelWidth -  spacing - (2 * UM.Theme.getSize("default_margin").width) * screenScaleFactor;
            
            text: "pitch"
            value: manager.pitch
            validator: DoubleValidator {bottom: -360; top: 360;}
            onEditingFinished: { manager.pitch = value; } 
        }
        TextFieldWithLabel
        {
            id: yawField
            labelWidth: 20 * screenScaleFactor;
            textWidth: base.width - labelWidth -  spacing - (2 * UM.Theme.getSize("default_margin").width) * screenScaleFactor;
            
            text: "yaw"
            value: manager.yaw
            validator: DoubleValidator {bottom: -360; top: 360;}
            onEditingFinished: { manager.yaw = value; }
        }
    }
    Cura.PrimaryButton
    {
        id: finishButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "Finish"
        onClicked: { base.close() }
        enabled: true
    }
}




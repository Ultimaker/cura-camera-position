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
    flags: Qt.Tool | Qt.Widget| Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowStaysOnTopHint
    
    minimumHeight: positionColumn.height + finishButton.height + 2 * UM.Theme.getSize("default_margin").width;
    maximumHeight: minimumHeight
    height: minimumHeight
    
    minimumWidth: 100 * screenScaleFactor;
    width: 150 * screenScaleFactor;
    color: UM.Theme.getColor("main_background")
    
    Column
    {
        id: positionColumn
        
        height: childrenRect.height
        spacing: UM.Theme.getSize("narrow_margin").width
        x: UM.Theme.getSize("default_margin").width
        width: base.width - 2 * UM.Theme.getSize("default_margin").width
        
        TextFieldWithLabel
        {
            id: xField
            labelWidth: 20 * screenScaleFactor;
            textWidth: positionColumn.width - labelWidth - 2 * spacing;
            
            text: "x"
            value: manager.x
            validator: IntValidator {bottom: -1000; top: 1000;}
            onEditingFinished: { manager.x = value; }
        }
        TextFieldWithLabel
        {
            id: yField
            labelWidth: 20 * screenScaleFactor;
            textWidth: positionColumn.width - labelWidth - 2 * spacing;
            
            text: "y"
            value: manager.y
            validator: IntValidator {bottom: -1000; top: 1000;}
            onEditingFinished: { manager.y = value; } 
        }
        TextFieldWithLabel
        {
            id: zField
            labelWidth: 20 * screenScaleFactor;
            textWidth: positionColumn.width - labelWidth - 2 * spacing;
            
            text: "z"
            value: manager.z
            validator: IntValidator {bottom: -1000; top: 1000;}
            onEditingFinished: { manager.z = value; }
        }
        
        TextFieldWithLabel
        {
            id: rollField
            labelWidth: 20 * screenScaleFactor;
            textWidth: positionColumn.width - labelWidth - 2 * spacing;
            
            text: "roll"
            value: manager.roll
            validator: DoubleValidator {bottom: -360; top: 360;}
            onEditingFinished: { manager.roll = value; }
        }
        TextFieldWithLabel
        {
            id: pitchField
            labelWidth: 20 * screenScaleFactor;
            textWidth: positionColumn.width - labelWidth - 2 * spacing;
            
            text: "pitch"
            value: manager.pitch
            validator: DoubleValidator {bottom: -360; top: 360;}
            onEditingFinished: { manager.pitch = value; } 
        }
        TextFieldWithLabel
        {
            id: yawField
            labelWidth: 20 * screenScaleFactor;
            textWidth: positionColumn.width - labelWidth - 2 * spacing;
            
            text: "yaw"
            value: manager.yaw
            validator: DoubleValidator {bottom: -360; top: 360;}
            onEditingFinished: { manager.yaw = value; }
        }
        TextFieldWithLabel
        {
            id: zoomField
            labelWidth: 20 * screenScaleFactor;
            textWidth: positionColumn.width - labelWidth - 2 * spacing;
            visible: !manager.perspective;
            
            text: "zoom"
            value: manager.zoom
            // Hardcoded lower limit of the zoomfactor in Uranium is -0.495 everything below that value is undefined
            validator: DoubleValidator {bottom: -0.495; top: 10;}  
            onEditingFinished: { manager.zoom = value; }
        }
        CheckBox
        {
            id: perspectiveCheckBox
            text: "perspective"
            checked: manager.perspective;
            onClicked:
            {
                zoomField.visible = Qt.binding(function() { return !checked; });
                manager.perspective = Qt.binding(function() { return checked; });
                checked = Qt.binding(function() { return manager.perspective; });
            }
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

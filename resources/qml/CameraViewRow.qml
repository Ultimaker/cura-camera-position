import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.14

import UM 1.4 as UM
import Cura 1.0 as Cura

import CameraPositionPlugin 1.0 as CPP


RowLayout
{
    id: base
    
    property alias name: cameraView.name
    property alias live: cameraView.live
    property alias checked: live.checked
    property alias exclusiveGroup: live.exclusiveGroup
    height: UM.Theme.getSize("small_button").height
    
    signal changedView
    
    function updateValues()
    {
        x.value = cameraView.x;
        y.value = cameraView.y;
        z.value = cameraView.z;
        roll.value = cameraView.ai;
        pitch.value = cameraView.aj;
        yaw.value = cameraView.ak;
    }
    
    CPP.CustomCameraView
    {
        id: cameraView
        name: "testname"
        live: Qt.binding(function() { return live.checked;})
        onTransformationChanged:
        {
            base.updateValues();
        }
        onLiveChanged:
        {
            if (live){
                base.updateValues();
                changedView();
            }
        }
    }
    
    Label
    {
        id: label  
        text: cameraView.name
        horizontalAlignment: Text.AlignRight
        width: 50 * screenScaleFactor
    }
    
    RadioButton
    {
        id: live
        checked: cameraView.live

        onCheckedChanged:
        {
            if (checked)
            {
                cameraView.perspective = perspective.checked
                cameraView.x = x.value
                cameraView.y = y.value
                cameraView.z = z. value
                cameraView.ai = roll.value
                cameraView.aj = roll.value
                cameraView.ak = roll.value    
                cameraView.zoom = zoom.value
            }
            cameraView.live = checked;
        }
    }
    TextFieldWithLabel
    {
        id: x
        readOnly: !live.checked
        textWidth: 30 * screenScaleFactor
        labelWidth: 10 * screenScaleFactor
        text: "x"
        value: cameraView.x
        onEditingFinished:
        {
            cameraView.x = value;
        }
    }
    TextFieldWithLabel
    {
        id: y
        readOnly: !live.checked
        textWidth: 30 * screenScaleFactor
        labelWidth: 10 * screenScaleFactor       
        text: "y"
        value: cameraView.y
        onEditingFinished:
        {
            cameraView.y = value;
        }
    }
    TextFieldWithLabel
    {
        id: z
        readOnly: !live.checked
        textWidth: 30 * screenScaleFactor
        labelWidth: 10 * screenScaleFactor
        text: "z"
        onEditingFinished:
        {
            cameraView.z = value;
        }
    }
    TextFieldWithLabel
    {
        id: roll
        readOnly: !live.checked
        textWidth: 30 * screenScaleFactor
        labelWidth: 15 * screenScaleFactor
        text: "roll"
        onEditingFinished:
        {
            cameraView.ai = value;
        }
    }
    TextFieldWithLabel
    {
        id: pitch
        readOnly: !live.checked
        textWidth: 30 * screenScaleFactor
        labelWidth: 15 * screenScaleFactor
        text: "pitch"
        onEditingFinished:
        {
            cameraView.aj = value;
        }
    }
    TextFieldWithLabel
    {
        id: yaw
        readOnly: !live.checked
        textWidth: 30 * screenScaleFactor
        labelWidth: 15 * screenScaleFactor
        text: "yaw"
        onEditingFinished:
        {
            cameraView.ak = value;
        }
    }
    TextFieldWithLabel
    {
        id: zoom
        readOnly: !live.checked + perspective.checked
        textWidth: 30 * screenScaleFactor
        labelWidth: 15 * screenScaleFactor
        text: "zoom"
        onEditingFinished:
        {
            cameraView.zoom = value;
        }
    }
    CheckBox
    {
        id: perspective
        enabled: live.checked
        checked: cameraView.perspective
        text: "perspective"
        onClicked:
        {
            cameraView.perspective = checked
        }
    }

}
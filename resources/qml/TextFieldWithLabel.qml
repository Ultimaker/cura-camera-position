import QtQuick 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2

import UM 1.4 as UM
import Cura 1.0 as Cura

Row
{
    id: base
    
    property alias value: textField.text
    property alias text: label.text
    
    property alias textWidth: textField.width
    property alias labelWidth: label.width
    property alias validator: textField.validator
    
    height: childrenRect.height
    
    signal editingFinished();
    
    spacing: UM.Theme.getSize("narrow_margin").width * screenScaleFactor;
    
    Label
    {
        id: label  
        text: "Sample text"
        horizontalAlignment: Text.AlignRight
    }

    TextField
    {
        id: textField
        text: "0"
        
        onEditingFinished: base.editingFinished()
        Keys.onEnterPressed: base.editingFinished()
        Keys.onReturnPressed: base.editingFinished()
    }
}
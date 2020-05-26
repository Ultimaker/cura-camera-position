import QtQuick 2.7
import QtQuick.Controls 2.3

import UM 1.4 as UM
import Cura 1.0 as Cura

Row
{
    id: base
    
    property alias value: textField.text
    property alias text: label.text
    property alias readOnly: textField.readOnly
    
    property alias textWidth: textField.width
    property alias labelWidth: label.width
    height: childrenRect.height
    
    signal editingFinished();
    
    padding: UM.Theme.getSize("thick_margin").width
    spacing: UM.Theme.getSize("thin_margin").width
    
    Label
    {
        id: label  
        text: "Sample text"
        horizontalAlignment: Text.AlignRight
    }

    Cura.ReadOnlyTextField
    {
        id: textField
        text: "0"
        
        onEditingFinished:
        {
            base.editingFinished();
        }
    }
}
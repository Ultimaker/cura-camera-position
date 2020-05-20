import os
from typing import cast

from PyQt5.QtCore import QObject
from UM.Extension import Extension
from UM.Logger import Logger
from UM.PluginRegistry import PluginRegistry
from UM.i18n import i18nCatalog
from cura.CuraApplication import CuraApplication

from .CustomCameraView import CustomCameraView

i18n_catalog = i18nCatalog("cura")


class CameraPositionExtension(QObject, Extension):
    """A Cura plugin to let the user interact with the camera and store up to 10 defined views"""

    def __init__(self, parent=None) -> None:
        QObject.__init__(self, parent)
        Extension.__init__(self)

        self.setMenuName("Camera Position")
        self.addMenuItem("Set camera position", self.showPopup)

        self._view = None

        CuraApplication.getInstance().mainWindowChanged.connect(self._createView)

    def showPopup(self) -> None:
        """Show the pop-up dialog"""
        
        # Create the view if it wasn't all ready created
        if self._view is None:
            self._createView()
            if self._view is None:
                Logger.log("e", "Not creating Camera Position window since the QML component failed to be created.")
                return
            
        # Get all the different view points and set the controller
        for view in self._view.findChildren(CustomCameraView):
            view.controller.getScene().getActiveCamera().transformationChanged.connect(view.onTransformationChanged)
        self._view.show()

    def _createView(self) -> None:
        Logger.log("d", "Creating Camera Position plugin view.")

        # Create the plugin dialog component
        plugin_path = PluginRegistry.getInstance().getPluginPath(self.getPluginId())
        path = os.path.join(plugin_path, "resources", "qml", "CameraPositionPanel.qml")
        self._view = CuraApplication.getInstance().createQmlComponent(path, {"manager": self})
        for view in self._view.findChildren(CustomCameraView):
            view.controller = CuraApplication.getInstance().getController()
            self.addMenuItem(str(view), view)
            view.liveChanged.connect(self._updateMenu)

    def _updateMenu(self):
        pass

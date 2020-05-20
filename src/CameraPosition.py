import os
import ast
from typing import cast, List

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
        stored_views = self._initStoredViews()
        
        for idx, view in enumerate(self._view.findChildren(CustomCameraView)):
            view.controller = CuraApplication.getInstance().getController()
            view.load(stored_views[idx])
            self.addMenuItem(view.name, view)
            
    def _initStoredViews(self) -> List[CustomCameraView]:
        """Loads all views stored in preference if this is a first time use it will initialize the stored view
        preference"""
        
        self._view.storeViews.connect(self._storeViews)
        preferences = CuraApplication.getInstance().getPreferences()
        stored_views = preferences.getValue("CuraCameraPosition/stored_views")
        if stored_views is None:
            default = CustomCameraView()
            stored_views = []
            for idx in range(1, 11):
                default.name = 'stored_{}'.format(idx)
                stored_views.append(default.dump())
            preferences.addPreference("CuraCameraPosition/stored_views", stored_views)
        else:
            stored_views = ast.literal_eval(stored_views)
        return stored_views
            
    def _storeViews(self) -> None:
        """Store the views to the preference"""
        preferences = CuraApplication.getInstance().getPreferences()
        stored_views = [view.dump() for view in self._view.findChildren(CustomCameraView)]
        preferences.setValue("CuraCameraPosition/stored_views", stored_views)


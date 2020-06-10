import os
from math import pi
from typing import Optional

from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal
from UM.Controller import Controller
from UM.Extension import Extension
from UM.Logger import Logger
from UM.Math.Matrix import Matrix
from UM.Math.Quaternion import Quaternion
from UM.Math.Vector import Vector
from UM.PluginRegistry import PluginRegistry
from UM.Scene.Camera import Camera
from UM.i18n import i18nCatalog

from cura.CuraApplication import CuraApplication

i18n_catalog = i18nCatalog("cura")


class CameraPositionExtension(QObject, Extension):
    """A Cura plugin to let the user interact with the camera and store up to 10 defined views"""

    _props = ('x', 'y', 'z', 'roll', 'pitch', 'yaw', 'perspective', 'zoom')

    def __init__(self, parent=None) -> None:
        QObject.__init__(self, parent)
        Extension.__init__(self)

        self.setMenuName("Camera Position")
        self.addMenuItem("Set camera position", self.showPopup)

        self._manager = None  # type: Optional['CameraPositionExtension']
        self._controller = None  # type: Optional[Controller]
        self._camera = None  # type: Optional[Camera]

        self._position = Vector(0., 0., 0.)
        self._orientation = Vector(0., 0., 0.)
        self._perspective = True
        self._zoom = 1.

        CuraApplication.getInstance().mainWindowChanged.connect(self._createPlugin)

    def _createPlugin(self):
        Logger.log("d", "Creating CameraPositionPanel view")
        plugin_path = PluginRegistry.getInstance().getPluginPath(self.getPluginId())
        path = os.path.join(plugin_path, "resources", "qml", "CameraPositionPanel.qml")
        self._manager = CuraApplication.getInstance().createQmlComponent(path, {
            "manager": self})  # type: Optional['CameraPositionExtension']
        self._controller = CuraApplication.getInstance().getController()
        self._preferences = CuraApplication.getInstance().getPreferences()
        self._perspective = self._preferences.getValue("general/camera_perspective_mode") == 'perspective'
        self._camera = self._controller.getScene().getActiveCamera()
        self._camera.transformationChanged.connect(self._onTransformationChanged)
        self._camera.perspectiveChanged.connect(self._onTransformationChanged)

    def showPopup(self):
        self._onTransformationChanged(self._camera)
        self._manager.show()

    def _onTransformationChanged(self, camera: Camera):
        self._orientation = camera.getOrientation().toMatrix().getEuler() * 180 / pi
        self._position = camera.getPosition()
        self._perspective = camera.isPerspective()
        self._zoom = camera.getZoomFactor()
        self._bombsaway(*self._props)

    def _bombsaway(self, *args):
        for arg in args:
            getattr(self, '{}Changed'.format(arg)).emit()

    def _buildRotationQuaternion(self, vec: Vector):
        vec *= pi / 180
        rotation_matrix = Matrix()
        rotation_matrix.setByEuler(**dict(zip(('ai', 'aj', 'ak'), vec.getData())))
        return Quaternion.fromMatrix(rotation_matrix)

    def _actuateView(self, x, y, z, roll, pitch, yaw, perspective, zoom, live):
        self._camera.transformationChanged.disconnect(self._onTransformationChanged)
        self._camera.perspectiveChanged.disconnect(self._onTransformationChanged)
        self._camera.setPosition(self._position.set(x=x, y=y, z=z))
        self._camera.setOrientation(self._buildRotationQuaternion(self._orientation.set(x=roll, y=pitch, z=yaw)))
        self._preferences.setValue("general/camera_perspective_mode", "perspective" if perspective else "orthographic")
        self._camera.setPerspective(perspective)
        self._camera.setZoomFactor(zoom)
        self._camera.transformationChanged.connect(self._onTransformationChanged)
        self._camera.perspectiveChanged.connect(self._onTransformationChanged)
        self._bombsaway(*self._props)

    xChanged = pyqtSignal()
    """Signal that emits when the x value is changed"""

    @pyqtProperty(float, notify=xChanged)
    def x(self) -> float:
        """x component of the camera state vector in [mm]"""
        return round(self._position.x, 0)

    @x.setter
    def x(self, value: float):
        self._camera.setPosition(self._position.set(x=value))
        self.xChanged.emit()

    yChanged = pyqtSignal()
    """Signal that emits when the y value is changed"""

    @pyqtProperty(float, notify=yChanged)
    def y(self) -> float:
        """y component of the camera state vector in [mm]"""
        return round(self._position.y, 0)

    @y.setter
    def y(self, value: float):
        self._camera.setPosition(self._position.set(y=value))
        self.yChanged.emit()

    zChanged = pyqtSignal()
    """Signal that emits when the z value is changed"""

    @pyqtProperty(float, notify=zChanged)
    def z(self) -> float:
        """z component of the camera state vector in [mm]"""
        return round(self._position.z, 0)

    @z.setter
    def z(self, value: float):
        self._camera.setPosition(self._position.set(z=value))
        self.zChanged.emit()

    rollChanged = pyqtSignal()
    """Signal that emits when the roll value is changed"""

    @pyqtProperty(float, notify=rollChanged)
    def roll(self) -> float:
        """roll component of the camera state vector in [mm]"""
        return round(self._orientation.x, 2)

    @roll.setter
    def roll(self, value: float):
        self._camera.setOrientation(self._buildRotationQuaternion(self._orientation.set(x=value)), 1)
        self.rollChanged.emit()

    pitchChanged = pyqtSignal()
    """Signal that emits when the pitch value is changed"""

    @pyqtProperty(float, notify=pitchChanged)
    def pitch(self) -> float:
        """pitch component of the camera state vector in [mm]"""
        return round(self._orientation.y, 2)

    @pitch.setter
    def pitch(self, value: float):
        self._camera.setOrientation(self._buildRotationQuaternion(self._orientation.set(y=value)), 1)
        self.pitchChanged.emit()

    yawChanged = pyqtSignal()
    """Signal that emits when the yaw value is changed"""

    @pyqtProperty(float, notify=yawChanged)
    def yaw(self) -> float:
        """yaw component of the camera state vector in [mm]"""
        return round(self._orientation.z, 2)

    @yaw.setter
    def yaw(self, value: float):
        self._camera.setOrientation(self._buildRotationQuaternion(self._orientation.set(z=value)), 1)
        self.yawChanged.emit()

    perspectiveChanged = pyqtSignal()
    """Signal that emits when the perspective is changed"""

    @pyqtProperty(bool, notify=perspectiveChanged)
    def perspective(self) -> bool:
        """Perspective (True) or Orthographic (False)"""
        return self._perspective

    @perspective.setter
    def perspective(self, value: bool):
        self._preferences.setValue("general/camera_perspective_mode", "perspective" if value else "orthographic")
        self._controller.setCameraPerspective(value)
        self.perspectiveChanged.emit()

    zoomChanged = pyqtSignal()
    """Signal that emits when the zoom value is changed"""

    @pyqtProperty(float, notify=zoomChanged)
    def zoom(self) -> float:
        """Zoom factor only used when in orthographic mode"""
        return round(self._zoom, 3)

    @zoom.setter
    def zoom(self, value: float) -> None:
        self._camera.setZoomFactor(value)
        self._zoom = value
        self.zoomChanged.emit()

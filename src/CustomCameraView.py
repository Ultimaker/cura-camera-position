from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal
from math import pi
from typing import Dict

from UM.Controller import Controller
from UM.Scene.Camera import Camera
from math import pi

from PyQt5.QtCore import QObject, pyqtProperty, pyqtSignal
from UM.Controller import Controller
from UM.Scene.Camera import Camera


class CustomCameraView(QObject):
    """A stored camera view state"""
    
    def __init__(self, parent=None) -> None:
        super(CustomCameraView, self).__init__(parent)
        self._controller = None
        self._name = ''
        self._x = 0.
        self._y = 0.
        self._z = 0.
        self._ai = 0.
        self._aj = 0.
        self._ak = 0.
        self._live = False
        self._perspective = True
        self._zoom = 0.
        
    nameChanged = pyqtSignal()
    """Signal tha emits when the name changes"""
        
    transformationChanged = pyqtSignal()
    """Signal that emits when the State values are updated due to movement of the camera"""

    liveChanged = pyqtSignal()
    """Signal that emits when the State values are coupled with the active camera movement"""

    xChanged = pyqtSignal()
    """Signal that emits when the x value is changed"""

    yChanged = pyqtSignal()
    """Signal that emits when the y value is changed"""

    zChanged = pyqtSignal()
    """Signal that emits when the z value is changed"""

    aiChanged = pyqtSignal()
    """Signal that emits when the roll value is changed"""

    ajChanged = pyqtSignal()
    """Signal that emits when the pitch value is changed"""

    akChanged = pyqtSignal()
    """Signal that emits when the yaw value is changed"""

    perspectiveChanged = pyqtSignal()
    """Signal that emits when the perspective is changed"""
    
    zoomChanged = pyqtSignal()
    """Signal that emits when the zoom value is changed"""

    @pyqtProperty(bool, notify=liveChanged)
    def live(self) -> bool:
        """property indicating if the view is coupled with the active camera"""
        return self._live

    @live.setter
    def live(self, value: bool):
        if self._controller is not None:
            camera = self._controller.getScene().getActiveCamera()
            self._getCameraValues(camera)
            if value:
                camera.transformationChanged.connect(self.onTransformationChanged)
            else:
                camera.transformationChanged.disconnect(self.onTransformationChanged)
        if value != self._live:
            self._live = value
            self.liveChanged.emit()

    @pyqtProperty(float, notify=xChanged)
    def x(self) -> float:
        """x component of the camera state vector in [mm]"""
        return round(self._x)

    @x.setter
    def x(self, value: float):
        self._controller.setCameraPosition(value, self._y, self._z)
        self.xChanged.emit()

    @pyqtProperty(float, notify=yChanged)
    def y(self) -> float:
        """y component of the camera state vector in [mm]"""
        return round(self._y)

    @y.setter
    def y(self, value: float):
        self._controller.setCameraPosition(self._x, value, self._z)
        self.yChanged.emit()

    @pyqtProperty(float, notify=zChanged)
    def z(self) -> float:
        """z component of the camera state vector in [mm]"""
        return round(self._z)

    @z.setter
    def z(self, value: float):
        self._controller.setCameraPosition(self._x, self._y, value)
        self.zChanged.emit()

    @pyqtProperty(float, notify=aiChanged)
    def ai(self) -> float:
        """roll component of the camera state vector in [deg]"""
        return round(self._ai, 1)

    @ai.setter
    def ai(self, value: float):
        self._controller.setCameraOrientation(ai=value * pi / 180, aj=self._aj * pi / 180, ak=self._ak * pi / 180)
        self.aiChanged.emit()

    @pyqtProperty(float, notify=ajChanged)
    def aj(self) -> float:
        """pitch component of the camera state vector in [deg]"""
        return round(self._aj, 1)

    @aj.setter
    def aj(self, value: float):
        self._controller.setCameraOrientation(ai=self._ai * pi / 180, aj=value * pi / 180, ak=self._ak * pi / 180)
        self.ajChanged.emit()

    @pyqtProperty(float, notify=akChanged)
    def ak(self) -> float:
        """yaw component of the camera state vector in [deg]"""
        return round(self._ak, 1)

    @ak.setter
    def ak(self, value: float):
        self._controller.setCameraOrientation(ai=self._ai * pi / 180, aj=self._aj * pi / 180, ak=value * pi / 180)
        self.akChanged.emit()
        
    @pyqtProperty(bool, notify=perspectiveChanged)
    def perspective(self) -> bool:
        """Perspective (True) or Orthographic (False)"""
        return self._perspective
    
    @perspective.setter
    def perspective(self, value: bool):
        if value != self._controller:
            self._controller.setCameraPerspective(value)
            self._perspective = value
            self.perspectiveChanged.emit()
            
    @pyqtProperty(float, notify=zoomChanged)
    def zoom(self) -> float:
        """Zoom factor only used when in orthographic mode"""
        return self._zoom
    
    @zoom.setter
    def zoom(self, value: float) -> None:
        if not self._perspective:
            self._zoom = value
            self._controller.setCameraZoomFactor(value)
            self.zoomChanged.emit()

    def __call__(self) -> None:
        """Calling the instance sets the active camera to the described state vector"""
        self._controller.setCameraOrientation(ai=self._ai * pi / 180, aj=self._aj * pi / 180, ak=self._ak * pi / 180)
        self._controller.setCameraPosition(self._x, self._y, self._z)
        self._controller.setCameraPerspective(self._perspective)
        if not self._perspective:
            self._controller.setCameraZoomFactor(self._zoom)

    def __repr__(self) -> str:
        projection = ', perspective' if self._perspective else ', zoom: {}, orthographic '.format(self.zoom)
        return '{} = x: {}, y: {}, z: {}, roll: {}, pitch: {}, yaw: {}{}'.format(self.name, self.x, self.y, self.z,
                                                                               self.ai, self.aj, self.ak, projection)

    def __str__(self) -> str:
        return repr(self)
    
    def compareMenuEntry(self, other: str) -> bool:
        return other.startswith(self._name)
        
    @property
    def controller(self) -> Controller:
        """Sets the current for easy access"""
        return self._controller

    @controller.setter
    def controller(self, value: Controller) -> None:
        self._controller: Controller = value

    def onTransformationChanged(self, camera: Camera) -> None:
        """Callback that updates the values on the background when coupled with the active camera"""
        if self.live:
            self._getCameraValues(camera)
            self.transformationChanged.emit()

    def _getCameraValues(self, camera: Camera) -> None:
        euler_orientation = camera.getOrientation().toMatrix().getEuler()
        euler_orientation *= 180 / pi
        self._ai = euler_orientation.x
        self._aj = euler_orientation.y
        self._ak = euler_orientation.z
        self._x = camera.getPosition().x
        self._y = camera.getPosition().y
        self._z = camera.getPosition().z
        self._perspective = camera.isPerspective()
        self._zoom = camera.getZoomFactor()

    @pyqtProperty('QString', notify=nameChanged)
    def name(self) -> str:
        """Name of the view"""
        return self._name

    @name.setter
    def name(self, name: str):
        self._name = name
        
    @pyqtProperty('QString', notify=transformationChanged)
    def description(self) -> str:
        """Description of the view"""
        return str(self)
        
    def dump(self) -> Dict[str, float]:
        """Dumps the view state vector to a dict which can be serialize
        
        :return: Dictionary describing the state vector of the camera view
        """
        return {'name': self._name,
                'x': float(self._x),
                'y': float(self._y),
                'z': float(self._z),
                'ai': float(self._ai),
                'aj': float(self._aj),
                'ak': float(self._ak),
                'zoom': float(self._zoom),
                'perspective': self._perspective}
    
    def load(self, state_vector: Dict[str, float]) -> None:
        """Restores a state vector to a camera view
        
        :param state_vector: a dictionary describing x, y, z, ai, aj, ak
        """
        for k, v in state_vector.items():
            setattr(self, '_{}'.format(k), v)
        self.transformationChanged.emit()


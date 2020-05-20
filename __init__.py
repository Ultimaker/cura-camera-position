from .src import CameraPosition
from PyQt5.QtQml import qmlRegisterType
from .src.CustomCameraView import CustomCameraView

qmlRegisterType(CustomCameraView, 'CameraPositionPlugin', 1, 0, 'CustomCameraView')

def getMetaData():
    return {}


def register(app):
    return { "extension": CameraPosition.CameraPositionExtension()}

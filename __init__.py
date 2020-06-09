from .src import CameraPosition
from PyQt5.QtQml import qmlRegisterType


def getMetaData():
    return {}


def register(app):
    return {"extension": CameraPosition.CameraPositionExtension()}

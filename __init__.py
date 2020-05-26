from .src import CameraPosition
from PyQt5.QtQml import qmlRegisterType
from .src.StoredViewsModel import StoredViewsModel

qmlRegisterType(StoredViewsModel, 'CameraPositionPlugin', 1, 0, 'StoredViewsModel')

def getMetaData():
    return {}


def register(app):
    return { "extension": CameraPosition.CameraPositionExtension()}

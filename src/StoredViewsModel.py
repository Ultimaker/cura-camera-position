from typing import Optional, TYPE_CHECKING, List, Dict, Union

from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal
from UM.Qt.ListModel import ListModel

if TYPE_CHECKING:
    from cura.CuraApplication import CuraApplication


class StoredViewsModel(ListModel):
    storedViewsChanged = pyqtSignal(bool)

    def __init__(self, application: "CuraApplication", parent: Optional["QObject"] = None) -> None:
        super(StoredViewsModel, self).__init__(parent)

        self._stored_views: List[Dict[str, Union[str, float]]] = []
        self._application = application

    def addStoredViews(self, storedViews: List[Dict[str, Union[str, float]]]):
        self._stored_views.extend(storedViews)
        self._update()

        self.storedViewsChanged.emit(len(storedViews) > 0)

    @pyqtSlot()
    def clear(self) -> None:
        self._stored_views = []
        self._update()
        self.storedViewsChanged.emit(False)

    def _update(self) -> None:
        items = self._stored_views[:]
        items.sort(key=lambda k: k["name"])
        self.setItems(items)

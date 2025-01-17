from abc import ABC, abstractmethod
from collections.abc import Sequence
from typing import Generic, TypeVar

_T = TypeVar("_T")


class QueryService(ABC, Generic[_T]):

    @abstractmethod
    def find_by_id(self, id_: int) -> _T | None:
        raise NotImplementedError()

    @abstractmethod
    def findall(self) -> Sequence[_T]:
        raise NotImplementedError()

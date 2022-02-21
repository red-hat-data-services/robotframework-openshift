from abc import ABC, abstractmethod
from typing import Optional


class AuthClient(ABC):

    @abstractmethod
    def login(self, host: str, username: str, password: str,
              ssl_ca_cert: Optional[str] = None) -> str:
        pass

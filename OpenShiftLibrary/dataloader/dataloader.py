import base64
import os
import requests

from robot.api.exceptions import Error

from OpenShiftLibrary.dataloader import FileLoader
from OpenShiftLibrary.dataloader import UrlLoader


class DataLoader(FileLoader, UrlLoader):
    def from_file(self, path: str) -> str:
        if not os.path.isabs(path):
            path = os.path.join(os.getcwd(), path)
        with open(rf'{path}') as file:
            return file.read()

    def from_url(self, path: str) -> str:
        req = requests.get(path, verify=False)
        if req.status_code != requests.codes.ok:
            raise Error(f"Content was not found. Verify url {path} is correct")
        try:
            req = req.json()
        except Error:
            raise Error(f"Error decoding JSON. Verify that the endpoint {path} returns a proper json response.")
        return base64.b64decode(req["content"]).decode('ascii')

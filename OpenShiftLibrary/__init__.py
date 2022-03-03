import urllib3

from robotlibcore import DynamicCore


from OpenShiftLibrary.keywords import (
    GenericKeywords,
    EventKeywords,
    PodKeywords,
    ProjectKeywords,
    ServiceKeywords
)
from OpenShiftLibrary.client import AuthApiClient
from OpenShiftLibrary.client import GenericApiClient
from OpenShiftLibrary.dataloader import DataLoader
from OpenShiftLibrary.dataparser import DataParser
from OpenShiftLibrary.outputstreamer import LogStreamer
from OpenShiftLibrary.outputformatter import PlaintextFormatter
from OpenShiftLibrary.templateloader import TemplateLoader


from .version import VERSION


urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
__version__ = VERSION


class OpenShiftLibrary(DynamicCore):
    """
     This Test library provides keywords to work with openshift
      and various helper methods to check pod, service and related
      functionality via RobotFramework
    """
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = VERSION

    def __init__(self) -> None:
        libraries = [
            GenericKeywords(
                AuthApiClient(),
                GenericApiClient(),
                DataLoader(),
                DataParser(),
                PlaintextFormatter(),
                LogStreamer(),
                TemplateLoader()
            ),
            EventKeywords(
                GenericApiClient(),
                PlaintextFormatter(),
                LogStreamer()
            ),
            PodKeywords(
                GenericApiClient(),
                PlaintextFormatter(),
                LogStreamer()
            ),
            ProjectKeywords(
                GenericApiClient(),
                DataParser(),
                PlaintextFormatter(),
                LogStreamer()
            ),
            ServiceKeywords(
                GenericApiClient(),
                PlaintextFormatter(),
                LogStreamer()
            )]
        DynamicCore.__init__(self, libraries)

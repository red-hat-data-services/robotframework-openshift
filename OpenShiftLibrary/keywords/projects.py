from typing import Optional

from robotlibcore import keyword

from OpenShiftLibrary.client import GenericClient
from OpenShiftLibrary.dataparser import DataParser
from OpenShiftLibrary.outputformatter import OutputFormatter
from OpenShiftLibrary.outputstreamer import OutputStreamer
from OpenShiftLibrary.errors import ResourceNotFound


class ProjectKeywords(object):
    def __init__(self, client: GenericClient, data_parser: DataParser, output_formatter:  OutputFormatter, output_streamer: OutputStreamer) -> None:
        self.client = client
        self.data_parser = data_parser
        self.output_formatter = output_formatter
        self.output_streamer = output_streamer

    @keyword
    def new_project(self, name: str) -> None:
        """Creates new Project

        Args:
            name (str): Project name
        """
        project = f"""
        apiVersion: project.openshift.io/v1
        kind: Project
        metadata:
          name: {name}
        spec:
          finalizers:
          - kubernetes
        """
        self.client.create(kind='Project', body=self.data_parser.from_yaml(project)[0])

    @keyword
    def projects_should_contain(self, name: str) -> None:
        """Gets projects containing name

        Args:
          name: String that the name of the project must contain
        """
        projects = self.client.get(kind='Project')['items']
        result = [project for project in projects if name in project['metadata']['name']]
        if not result:
            error_message = f'Projects with name containing {name} not found'
            self.output_streamer.stream(error_message, "error")
            raise ResourceNotFound(error_message)
        output = [{project['metadata']['name']: project['status']['phase'] for project in result}]
        formatted_output = self.output_formatter.format(output, "Projects found")
        self.output_streamer.stream(formatted_output, "info")

    @keyword
    def wait_until_project_exists(self, name: Optional[str] = None, timeout: Optional[int] = 100) -> None:
        """Waits until a Project exists

        Args:
            name (Optional[str], optional): Project to wait for. Defaults to None.
            timeout (Optional[int], optional): Time to wait. Defaults to 100.
        """
        for event in self.client.watch(kind='Project', namespace=None, name=None, timeout=timeout):
            if event['object']['metadata']['name'] == name:
                self.output_streamer.stream(f"Project {name} found", "info")
                self.output_streamer.stream(
                    f"{event['object']['metadata']['name']}\nStatus:{event['object']['status']['phase']}", "info")
                break

    @keyword
    def wait_until_project_does_not_exists(self, name: Optional[str] = None, timeout: Optional[int] = 100) -> None:
        """Waits until a Project does not exists

        Args:
            name (Optional[str], optional): Project to wait for. Defaults to None.
            timeout (Optional[int], optional): Time to wait. Defaults to 100.
        """
        for event in self.client.watch(kind='Project', namespace=None, name=None, timeout=timeout):
            if event['object']['metadata']['name'] == name and event['type'] == "DELETED":
                self.output_streamer.stream(f"Project {name} Deleted", "info")
                break

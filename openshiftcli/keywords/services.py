from typing import Optional

from robotlibcore import keyword

from openshiftcli.client import GenericClient
from openshiftcli.outputformatter import OutputFormatter
from openshiftcli.outputstreamer import OutputStreamer
from openshiftcli.errors import ResourceNotFound


class ServiceKeywords(object):
    def __init__(self, client: GenericClient, output_formatter: OutputFormatter,
                 output_streamer: OutputStreamer) -> None:
        self.client = client
        self.output_formatter = output_formatter
        self.output_streamer = output_streamer

    @keyword
    def services_should_contain(self, name: str, namespace: Optional[str] = None) -> None:
        """
        Get services containing name

        Args:
          name (str): String that the name of the service must contain
          namespace (Optional[str], optional): Namespace where the Service exists. Defaults to None.
        """
        services = self.client.get(kind='Service', namespace=namespace)['items']
        result = [service for service in services if name in service['metadata']['name']]
        if not result:
            error_message = f"Services with name containing {name} not found"
            self.output_streamer.stream(error_message, 'error')
            raise ResourceNotFound(error_message)
        output = [{service['metadata']['name']: f"{service['spec']['clusterIPs']}:{service['spec']['ports']}"}
                  for service in result]
        formatted_output = self.output_formatter.format(output, "Services found")
        self.output_streamer.stream(formatted_output, "info")

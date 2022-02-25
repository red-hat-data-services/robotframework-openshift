from typing import Optional

from robotlibcore import keyword

from openshiftcli.client import GenericClient
from openshiftcli.outputformatter import OutputFormatter
from openshiftcli.outputstreamer import OutputStreamer
import datetime


class EventKeywords(object):
    def __init__(self, client: GenericClient, output_formatter: OutputFormatter,
                 output_streamer: OutputStreamer) -> None:
        self.client = client
        self.output_formatter = output_formatter
        self.output_streamer = output_streamer

    @keyword
    def get_events(self,
                   name: Optional[str] = None,
                   namespace: Optional[str] = None,
                   label_selector: Optional[str] = None,
                   field_selector: Optional[str] = None,
                   **kwargs: str) -> None:
        """Get all events

        Args:
            namespace (str, optional): Namespace. Defaults to None.
        """
        result = self.client.get(kind='Event', name=name, namespace=namespace,
                                 label_selector=label_selector, field_selector=field_selector,
                                 ** kwargs)["items"]
        output = [
            f"Time: {datetime.datetime.strptime(item['metadata']['creationTimestamp'], '%Y-%m-%dT%H:%M:%SZ').strftime('%d-%m-%Y %H:%M:%S')}\n"
            f"Reason: {item['reason']}\n"
            f"Component: {item['source']['component']}\n"
            f"Host: {item['source']['host']}\n"
            f"Resource: {item['involvedObject']['kind']}/{item['metadata']['name']}\n"
            f"Type: {item['type']}\n"
            f"Message: {item['message']}\n"
            for item in result
        ]
        self.output_streamer.stream(
            self.output_formatter.format(output, "Events"), "info"
        )

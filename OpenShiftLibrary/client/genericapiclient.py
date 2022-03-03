from typing import Any, Dict, List, Optional

from kubernetes import client, config
from openshift.dynamic import DynamicClient

from urllib import parse

from OpenShiftLibrary.client import GenericClient


class GenericApiClient(GenericClient):

    def apply(self, kind: str, body: str, api_version: Optional[str] = None,
              namespace: Optional[str] = None, **kwargs: str) -> Dict[str, Any]:
        return self._get_resources(kind, api_version).apply(body=body, namespace=namespace,
                                                            **kwargs).to_dict()

    def create(self, kind: str, body: str, api_version: Optional[str] = None,
               namespace: Optional[str] = None, **kwargs: str) -> Dict[str, Any]:
        return self._get_resources(kind, api_version).create(body=body, namespace=namespace,
                                                             **kwargs).to_dict()

    def delete(self, kind: str, api_version: Optional[str] = None, name: Optional[str] = None,
               namespace: Optional[str] = None, body: Optional[str] = None,
               label_selector: Optional[str] = None, field_selector: Optional[str] = None,
               **kwargs: str) -> Dict[str, Any]:
        return self._get_resources(kind, api_version).delete(name=name, namespace=namespace, body=body,
                                                             label_selector=label_selector,
                                                             field_selector=field_selector,
                                                             **kwargs).to_dict()

    def get(self, kind: str, api_version: Optional[str] = None, name: Optional[str] = None, namespace: Optional[str] = None,
            label_selector: Optional[str] = None, field_selector: Optional[str] = None,
            **kwargs: str) -> Dict[str, Any]:
        return self._get_resources(kind, api_version).get(name=name, namespace=namespace,
                                                          label_selector=label_selector,
                                                          field_selector=field_selector,
                                                          **kwargs).to_dict()

    def get_pod_logs(self, name: str, namespace: str, **kwargs: Optional[str]) -> Any:
        query = parse.urlencode(kwargs)
        url = f"/api/v1/namespaces/{namespace}/pods/{name}/log?{query}"
        return self.dynamic_client.request('GET', url)

    def patch(self, kind: str, name: str, body: str, api_version: Optional[str] = None, namespace: Optional[str] = None,
              **kwargs: str) -> Dict[str, Any]:
        return self._get_resources(kind, api_version).patch(name=name, body=body, namespace=namespace,
                                                            **kwargs).to_dict()

    def watch(self, kind: str, api_version: Optional[str] = None, namespace: Optional[str] = None, name: Optional[str] = None,
              label_selector: Optional[str] = None, field_selector: Optional[str] = None,
              resource_version: Optional[str] = None,
              timeout: Optional[int] = None) -> List[Dict[str, Any]]:
        events = self._get_resources(kind, api_version).watch(namespace=namespace, name=name,
                                                              label_selector=label_selector,
                                                              field_selector=field_selector,
                                                              resource_version=resource_version,
                                                              timeout=timeout)
        return [{'type': event['type'], 'object': event['object'].to_dict()} for event in events]

    def reload_config(self, token: Optional[str] = None,
                      host: Optional[str] = None,
                      ssl_ca_cert: Optional[str] = None) -> None:
        if token and host:
            configuration = client.Configuration()
            configuration.api_key['authorization'] = token
            configuration.api_key_prefix['authorization'] = 'Bearer'
            configuration.host = host
            configuration.ssl_ca_cert = ssl_ca_cert
            configuration.verify_ssl = True if ssl_ca_cert else False
        else:
            configuration = config.load_kube_config()

        self.dynamic_client = DynamicClient(client.ApiClient(configuration))

    def _get_resources(self, kind: str, api_version: Optional[str] = None) -> Any:
        try:
            getattr(self, 'dynamic_client')
        except AttributeError:
            self.reload_config()

        return self.dynamic_client.resources.get(api_version=api_version or self._get_api_version(kind),
                                                 kind=kind)

    def _get_api_version(self, kind: str) -> str:
        result = ""
        core = self.dynamic_client.request('GET', '/api/v1')
        if any(resource for resource in core.resources if resource.kind == kind):
            result = core.groupVersion
        else:
            groups = self.dynamic_client.request('GET', '/apis').groups
            for group in groups:
                api = self.dynamic_client.request('GET', f"/apis/{group.name}/{group.preferredVersion.version}")
                if any(resource for resource in api.resources if resource.kind == kind):
                    result = group.preferredVersion.groupVersion
                    break
        return result

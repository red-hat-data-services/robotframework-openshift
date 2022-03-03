import requests

from typing import Any, Dict, Optional, Tuple, Union

from requests_oauthlib import OAuth2Session
from urllib3.util import make_headers
from urllib.parse import parse_qsl, urlencode, urlparse

from robot.api.exceptions import Error

from OpenShiftLibrary.client import AuthClient


class AuthApiClient(AuthClient):

    def login(self, host: str, username: str, password: str,
              ssl_ca_cert: Optional[str] = None) -> str:

        verify = ssl_ca_cert or False

        auth_endpoint, token_endpoint = self._get_auth_server_metadata(host, verify)

        auth = OAuth2Session(client_id='openshift-challenging-client')

        auth_url, state = self._form_auth_url(auth, auth_endpoint)

        auth_headers = self._generate_auth_headers(username, password)

        response = self._request_authorize_code(auth, auth_url, auth_headers, state, verify)

        params = self._get_auth_params(response.headers['Location'])

        self.access_token = self._request_access_token(auth, token_endpoint, params, verify)

        return self.access_token

    def _get_auth_server_metadata(self, host: str, verify: Union[str, bool]) -> Tuple[str, str]:
        url = f"{host}/.well-known/oauth-authorization-server"

        response = requests.get(url=url, verify=verify)

        if response.status_code != 200:
            raise Error(f"OpenShift OAuth Server Metadata Request Failed"
                        f"Reason:{response.reason}"
                        f"Status Code: {response.status_code}")

        try:
            auth_server_metadata = response.json()
        except Exception as error:
            raise Error(f"Decoding Response from OpenShift OAuth Server Metadata Failed:\n{error}")

        auth_endpoint = auth_server_metadata.get('authorization_endpoint')
        token_endpoint = auth_server_metadata.get('token_endpoint')

        if not auth_endpoint or not token_endpoint:
            raise Error("Get OpenShift OAuth Server Metadata Failed")

        return (auth_endpoint, token_endpoint)

    def _form_auth_url(self, auth: OAuth2Session, auth_endpoint: str) -> Tuple[str, str]:
        return auth.authorization_url(auth_endpoint,
                                      state="1",
                                      code_challenge_method='S256')

    def _generate_auth_headers(self, username: str, password: str) -> Dict[str, str]:
        return make_headers(basic_auth=f"{username}:{password}")

    def _request_authorize_code(self, auth: OAuth2Session, auth_url: str,
                                auth_headers: Dict[str, str], state: str,
                                verify: Union[str, bool]) -> Dict[str, Any]:
        headers = {'X-Csrf-Token': state, 'authorization': auth_headers.get('authorization')}
        response = auth.get(auth_url, headers=headers, verify=verify,
                            allow_redirects=False)

        if response.status_code != 302:
            raise Error(f"Authorization failed"
                        f"Reason:{response.reason}"
                        f"Status Code: {response.status_code}")

        return response

    def _get_auth_params(self, url: str) -> Dict[str, str]:
        params = dict(parse_qsl(urlparse(url).query))
        params['grant_type'] = 'authorization_code'

        return params

    def _request_access_token(self, auth: OAuth2Session, token_endpoint: str,
                              params: str, verify: Union[str, bool]) -> str:
        base64_encoded_client_id = 'b3BlbnNoaWZ0LWNoYWxsZW5naW5nLWNsaWVudDo='
        headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': f'Basic {base64_encoded_client_id}'
        }
        response = auth.post(url=token_endpoint, headers=headers,
                             data=urlencode(params), verify=verify)

        if response.status_code != 200:
            raise Error(f"Failed to obtain an Access Token"
                        f"Reason:{response.reason}"
                        f"Status Code: {response.status_code}")

        return response.json()['access_token']

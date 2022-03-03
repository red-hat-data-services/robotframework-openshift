*** Settings ***
Documentation     OpenShiftLibrary Library
Library      OpenShiftLibrary         
*** Test Cases ***
Test Auth Keywords
  Oc Get  kind=Project
  Oc Login  host=${host1}  username=${username1}  password=${password1}
  Oc Create  kind=Project  src=test-data/project.yaml
  Oc Get  kind=Project  label_selector=kubernetes.io/metadata.name=my-project
  Oc Login  host=${host2}  username=${username2}  password=${password2}
  Run Keyword And Expect Error  ResourceOperationFailed: Get failed\nReason: Not Found
  ...  Oc Get  kind=Project  label_selector=kubernetes.io/metadata.name=my-project
  Oc Login  host=${host1}  username=${username1}  password=${password1}
  Oc Delete  kind=Project  name=my-project
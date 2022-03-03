*** Settings ***
Documentation     OpenShiftLibrary Library
Library      OpenShiftLibrary

*** Test Cases ***
Test Keywords
  New Project  test-project-1
  New Project  test-project-2
  New Project  test-project-3
  Oc Create  kind=Service  src=test-data/services_namespaced.yaml
  Oc Get  kind=Service  namespace=test-project-1
  Oc Get  kind=Service  namespace=test-project-2
  Oc Get  kind=Service  field_selector=metadata.name==my-service-1
  Oc Get  kind=Service  field_selector=metadata.name==my-service-1,metadata.namespace==test-project-2
  Oc Get  kind=Service  field_selector=metadata.name==my-service-1  namespace=test-project-2
  Oc Get  kind=Service  namespace=test-project-2  field_selector=metadata.name==my-service-1  
  Run Keyword And Expect Error  ResourceOperationFailed: Get failed\nReason: Not Found
  ...  Oc Get  kind=Service  field_selector=metadata.name==my-service-1,metadata.namespace==test-project-2  namespace=test-project-1
  Oc Get  kind=Service  name=my-service-1  namespace=test-project-1
  Oc Get  kind=Service  namespace=test-project-1  name=my-service-1  
  Oc Get  kind=Service  name=my-service-1
  Oc Get  kind=Service  name=my-service-1  field_selector=metadata.namespace==test-project-2
  Oc Delete  kind=Service  src=test-data/services_namespaced.yaml
  Oc Delete  kind=Project  name=test-project-1
  Oc Delete  kind=Project  name=test-project-2
  Oc Delete  kind=Project  name=test-project-3
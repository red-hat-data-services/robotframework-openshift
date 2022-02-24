*** Settings ***
Documentation     openshiftcli Library
Library      openshiftcli

*** Test Cases ***
Test keywords return values
    New Project  test-return-values
    Oc Create  kind=Service  src=test-data/service_return_values.yaml  namespace=test-return-values
    @{list} =  Oc Get  kind=Service  field_selector=metadata.name==my-service-6
    Log   ${list}[0]
    Oc Apply  kind=Service  src=${list}[0]  namespace=test-return-values
    &{dictionary} =  Set Variable  ${list}[0]
    Log  ${dictionary.metadata.name}
    Oc Patch  kind=Service  name=${dictionary.metadata.name}  src={"metadata": {"labels": {"environment": "production"}}}  namespace=test-return-values
    Oc Delete  kind=Service  name=my-service-6  namespace=test-return-values
    Oc Delete  kind=Project  name=test-return-values
    
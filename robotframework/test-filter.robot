*** Settings ***
Documentation     OpenShiftLibrary Library
Library      OpenShiftLibrary

*** Test Cases ***
Test Filter
  New Project  test-project-1
  New Project  test-project-2
  New Project  test-project-3
  Oc Create  kind=Service  src=test-data/services_namespaced.yaml
  
  Oc Get  kind=Service  name=my-service-2
  Oc Get  kind=Service  name=my-service-2  fields=['metadata']
  Oc Get  kind=Service  name=my-service-2  fields=['spec']
  Oc Get  kind=Service  name=my-service-2  fields=['status']
  Oc Get  kind=Service  name=my-service-2  fields=['metadata', 'spec', 'status']
  Oc Get  kind=Service  name=my-service-2  fields=['metadata.name']
  Oc Get  kind=Service  name=my-service-2  fields=['status.loadBalancer']
  Oc Get  kind=Service  name=my-service-2  fields=['metadata.name', 'status.api_version']
  Oc Get  kind=Service  name=my-service-2  fields=['metadata.name', 'status.api.api_version']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[*].port']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[*].port.number']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[].port']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[].port.number']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports.port']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports.port.number']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[0]']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[0].port']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[0].port.number']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[a]']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[@]']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[666]']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[\]']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[[]].port']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[a].port']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[@].port']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[666].port']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[\].port']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[[]].port']
  Oc Get  kind=Service  name=my-service-2  fields=['metadata.managedFields[*].fieldsV1.f:spec.f:ports']
  
  Oc Get  kind=Service  name=my-service-1
  Oc Get  kind=Service  name=my-service-1  fields=['metadata']
  Oc Get  kind=Service  name=my-service-1  fields=['spec']
  Oc Get  kind=Service  name=my-service-1  fields=['status']
  Oc Get  kind=Service  name=my-service-1  fields=['metadata', 'spec', 'status']
  Oc Get  kind=Service  name=my-service-1  fields=['metadata.name']
  Oc Get  kind=Service  name=my-service-1  fields=['status.loadBalancer']
  Oc Get  kind=Service  name=my-service-1  fields=['metadata.name', 'status.api_version']
  Oc Get  kind=Service  name=my-service-1  fields=['metadata.name', 'status.api.api_version']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[*].port']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[*].port.number']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[].port']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[].port.number']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports.port']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports.port.number']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[0]']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[0].port']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[0].port.number']
  Oc Get  kind=Service  name=my-service-1  fields=['metadata.managedFields[*].fieldsV1.f:spec.f:ports']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[a]']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[@]']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[666]']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[\]']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[[]].port']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[a].port']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[@].port']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[666].port']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[\].port']
  Oc Get  kind=Service  name=my-service-1  fields=['spec.ports[[]].port']
  Oc Get  kind=Service  name=my-service-1  fields=['metadata.managedFields[*].fieldsV1.f:spec.f:ports']

  Oc Delete  kind=Service  src=test-data/services_namespaced.yaml
  Oc Delete  kind=Project  name=test-project-1
  Oc Delete  kind=Project  name=test-project-2
  Oc Delete  kind=Project  name=test-project-3


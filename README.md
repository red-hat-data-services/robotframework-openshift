# Robotframework OpenShiftLibrary 
 OpenshiftLibrary is a robotframework library for [Kubernetes](https://kubernetes.io) and [OpenShift](https://openshift.com) APIs. The project is hosted on GitHub and downloads can be found from PyPI

# Installation
The recommended installation method is using pip:
```
pip install robotframework-openshift
```
To install latest source from the master branch, use this command:
``` 
pip install git+https://github.com/red-hat-data-services/robotframework-openshift.git
```
# Usage
## Keywords Documentation

To get the Documentation is necessary to be connected to a cluster with the oc command
```
python3 -m virtualenv .venv 
source .venv/bin/activate
python3 -m pip install -r requirements.txt
python3 task.py
```
A new folder will be created /docs/ with the documentation OpenShiftLibrary.html

## Features
### Login to OpenShift 
If you are logged in to a cluster locally, by default, OpenShiftLibrary will use the cluster that you're logged in. If you are not logged in, or you want to log in to another cluster, or use other credentials, you can do so using the keyword Oc Login:

```
*** Settings ***
Library      OpenShiftLibrary

*** Test Cases ***
Cluster Login
   Oc Login  host=${host1}  username=${username1}  password=${password1}
```
None of the above will affect or change anything of your local configuration.

### Generic Operations
OpenShiftLibrary can detect all kind of resources that are available in your cluster like pods, configmaps or custom resources. Generic operations can Apply, Create, Delete, Get, Patch, and Watch Resources. 
```
*** Settings ***
Library      OpenShiftLibrary

*** Test Cases ***
Test Generic Keywords Kind Project
   Oc New Project  test
   Oc Delete  kind=Project  name=test

```
### Templates
OpenShiftLibrary allows to use data dinamically with templates.

```
Test Templates
  Oc Apply  kind=Pod  src=test-data/template.yaml  namespace=default  template_data={image: nginx, name: web}
```

template.yaml
```
apiVersion: v1
kind: Pod
metadata:
  name: {{ name }}
  namespace: default
  labels:
    role: myrole
spec:
  containers:
    - name: container
      image: {{ image }}
      ports:
        - name: web
          containerPort: 80
          protocol: TCP
```
### Using yaml files from repository
OpenShiftLibrary uses the repository api to get the data without clone the repository
```
*** Settings ***
Library      OpenShiftLibrary

*** Test Cases ***
  Oc Create  kind=Service  src=https://api.github.com/repos/pablofelix/robotframework-openshift/contents/test-data/service.yaml?ref\=/master  namespace=test-services
```
### Real Time
Adding the api version you will increase the performance in the call. It is recommended for real time tests.

```
*** Settings ***
Library      OpenShiftLibrary

*** Test Cases ***
Real Time With API Version Option
   Oc Get  kind=ConfigMap  name=my-configmap  api_version=v1
```
### Filter Results
Get operations retrieve a list of objects.
Example: Getting the data field

```
*** Settings ***
Documentation     OpenShiftLibrary Library
Library      OpenShiftLibrary

*** Test Cases ***

Get configmap
  ${configmap}=  Oc Get  kind=ConfigMap  namespace=test-configmap  name=myconfigmap  api_version=v1
  Log  ${configmap[0]['data']}  

```

Sometimes you may need to filter the result obtained by getting some resources in development. OpenShiftLibrary gave us a Fields option to filter views those results.

```
*** Settings ***
Library      OpenShiftLibrary

*** Test Cases ***
Filter Get Results By Fields
  Oc Get  kind=Service  name=my-service-2  fields=['metadata', 'spec', 'status']
  Oc Get  kind=Service  name=my-service-2  fields=['metadata.name']
  Oc Get  kind=Service  name=my-service-2  fields=['status.loadBalancer']
  Oc Get  kind=Service  name=my-service-2  fields=['metadata.name', 'status.api_version']
  Oc Get  kind=Service  name=my-service-2  fields=['metadata.name', 'status.api.api_version']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports']
  Oc Get  kind=Service  name=my-service-2  fields=['spec.ports[*].port']
```
### Logs Pods
```
*** Settings ***
Documentation     OpenShiftLibrary Library
Library      OpenShiftLibrary

*** Test Cases ***

Pod Logs
  Oc Get Pod Logs  name=my-pod  namespace=test-pod-logs  container=web
  Oc Get Pod Logs  name=my-pod  namespace=test-pod-logs  timestamps=true  tailLines=2  container=web
  Oc Get Pod Logs  name=my-pod  namespace=test-pod-logs  timestamps=true  container=second-web
```
### Get more info about OpenShiftLibrary

Demo Use Cases OpenShiftLibrary: https://github.com/pablofelix/openshiftlibrary-demo


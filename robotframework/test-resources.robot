*** Settings ***
Documentation     OpenShiftLibrary Library
Library      OpenShiftLibrary

*** Test Cases ***
Test Service
  New Project  test-services
  Run Keyword And Expect Error  ResourceOperationFailed: Get failed\nReason: Not Found
  ...  Oc Get  kind=Service  namespace=test-services
  Run Keyword And Expect Error  ResourceOperationFailed: Create failed\nReason: Namespace is required for v1.Service 
  ...  Oc Create  kind=Service  src=test-data/service.yaml
  Run Keyword And Expect Error  STARTS: ResourceOperationFailed: Create failed\nReason: 400\nReason: Bad Request
  ...  Oc Create  kind=Service  src=test-data/srvice.yaml  namespace=test-services
  Oc Create  kind=Service  src=https://api.github.com/repos/pablofelix/robotframework-OpenShiftCLI/contents/test-data/service.yaml?ref\=/master  namespace=test-services
  Oc Create  kind=Service  src=test-data/services.yaml  namespace=test-services
  Run Keyword And Expect Error   AttributeError: 'str' object has no attribute 'get'	
  ...  Oc Apply  kind=Service  src=test-data/service_apply_creat.yaml
  Run Keyword And Expect Error   ResourceOperationFailed: Apply failed\nReason: Namespace is required for v1.Service	
  ...  Oc Apply  kind=Service  src=test-data/service_apply_create.yaml
  Oc Apply  kind=Service  src=test-data/service_apply_create.yaml  namespace=test-services
  Oc Create  kind=Service  src=test-data/service_create.yaml  namespace=test-services
  Oc Apply  kind=Service  src=test-data/service_apply.yaml  namespace=test-services
  Oc Create  kind=Service  src=test-data/service_delete.yaml  namespace=test-services
  Oc Get  kind=Service  namespace=test-services
  Oc Get  Service
  Oc Get  kind=Service
  Oc Get  kind=Service  namespace=test-services
  Oc Get  kind=Service  name=my-service-4
  Oc Get  kind=Service  name=my-service-4  namespace=test-services
  Oc Get  kind=Service  namespace=test-services  name=my-service-4
  Oc Get  kind=Service  field_selector=metadata.name==my-service-4  namespace=test-services
  Oc Get  kind=Service  namespace=test-services  field_selector=metadata.name==my-service-4    
  Run Keyword And Expect Error  STARTS: ResourceOperationFailed: Get failed\nReason: Not Found
  ...  Oc Get  kind=Service  namespace=test-services  name=my-service-6
  Oc Get  kind=Service  label_selector=environment=production  namespace=test-services
  Services Should Contain  my-service  namespace=test-services
  Oc Patch  kind=Service  name=my-service-4  src={"spec": {"ports": [{"name": "https", "protocol": "TCP", "port": 443, "targetPort": 9377}]}}  namespace=test-services
  Oc Patch  kind=Service  name=my-service-4  src={"metadata": {"labels": {"environment": "stage"}}}  namespace=test-services
  Oc Patch  kind=Service  name=my-service-4  src={"metadata": {"labels": {"newlabel": "newvalue"}}}  namespace=test-services
  Oc Watch  kind=Service  namespace=test-services 
  Oc Watch  kind=Service  name=my-service-4
  Oc Watch  kind=Service  namespace=test-services  name=my-service-4
  Oc Watch  kind=Service  name=my-service-4  namespace=test-services
  Oc Watch  kind=Service  namespace=test-services  label_selector=environment=stage
  Oc Watch  kind=Service  namespace=test-services  field_selector=metadata.name==my-service-4
  Oc Watch  kind=Service  namespace=test-services  resource_version=0
  Oc Get  kind=Service  namespace=test-services
  Run Keyword And Expect Error  ResourceOperationFailed: Delete failed\nReason: Src or at least one of name, label_selector or field_selector is required
  ...  Oc Delete  kind=Service
  Oc Delete  kind=Service  src=https://api.github.com/repos/pablofelix/robotframework-OpenShiftCLI/contents/test-data/service.yaml?ref\=/master  namespace=test-services
  Oc Delete  kind=Service  namespace=test-services  src=test-data/services.yaml
  Oc Delete  kind=Service  src=test-data/service_apply_create.yaml  namespace=test-services
  Run Keyword And Expect Error  ResourceOperationFailed: Delete failed\nReason: At least one of namespace|label_selector|field_selector is required
  ...  Oc Delete  kind=Service  src=test-data/service_apply.yaml
  Run Keyword And Expect Error  ResourceOperationFailed: Delete failed\nReason: Src or at least one of name, label_selector or field_selector is required, but not both
  ...  Oc Delete  kind=Service  src=test-data/service_apply.yaml  name=my-service-4
  Run Keyword And Expect Error  STARTS: ResourceOperationFailed: Delete failed\nReason: 404\nReason: Not Found
  ...  Oc Delete  kind=Service  name=my-service-4  label_selector=environment=stage
  Run Keyword And Expect Error  STARTS: ResourceOperationFailed: Delete failed\nReason: At least one of namespace|label_selector|field_selector is required
  ...  Oc Delete  kind=Service  name=my-service-4
  Oc Delete  kind=Service  name=my-service-4  namespace=test-services  label_selector=environment=stage 
  Oc Delete  kind=Service  name=my-service-5  namespace=test-services 
  Oc Watch  kind=Service  namespace=test-services  timeout=120
  Oc Delete  kind=Project  name=test-services

Test Project
  New Project  test-projects
  Wait Until Project Exists  test-projects
  Oc Get  kind=Project
  Oc Get  kind=Project  namespace=test-projects
  Oc Get  kind=Project  name=test-projects
  Oc Get  kind=Project  field_selector=metadata.name==test-projects
  Oc Get  kind=Project  field_selector=metadata.name==rhods-notebooks
  Projects Should Contain  test-projects
  Run Keyword And Expect Error  ResourceOperationFailed: Delete failed\nReason: Src or at least one of name, label_selector or field_selector is required, but not both 	
  ...  Oc Delete  kind=Project  src=None  name=test-projects
  Oc Delete  kind=Project  name=test-projects
  Wait Until Project Does Not Exists  test-projects  timeout=10

Test Deployment
   New Project  test-deployments
   Oc Create   kind=Deployment  src=test-data/deployment.yaml  namespace=test-deployments
   Oc Get  kind=Deployment  field_selector=metadata.name==my-deployment  namespace=test-deployments
   Oc Apply  kind=Deployment  src=test-data/deployment_apply.yaml  namespace=test-deployments
   Oc Get  kind=Deployment  field_selector=metadata.name==my-deployment  namespace=test-deployments
   Oc Patch  kind=Deployment  name=my-deployment  src={"spec": {"progressDeadlineSeconds":400}}  namespace=test-deployments
   Oc Get  kind=Deployment  field_selector=metadata.name==my-deployment  namespace=test-deployments
   Oc Delete  kind=Deployment  name=my-deployment  namespace=test-deployments
   Run Keyword And Expect Error  ResourceOperationFailed: Get failed\nReason: Not Found
   ...  Oc Get  kind=Deployment  field_selector=metadata.name==my-deployment  namespace=test-deployments
   Oc Delete  kind=Project  name=test-deployments

Test List
  New Project  test-lists
  Run Keyword And Expect Error  ResourceOperationFailed: Create failed\nReason: string indices must be integers    
  ...  Oc Create  kind=List  src=test-data/lis.yaml  namespace=test-lists
  Oc Create  kind=List  src=test-data/list.yaml  namespace=test-lists
  Oc Apply   kind=List  src=test-data/list_apply.yaml  namespace=test-lists
  Oc Delete  kind=List  src=test-data/list_apply.yaml  namespace=test-lists
  Oc Delete  kind=List  src=test-data/list.yaml  namespace=test-lists
  Oc Delete  kind=Project  name=test-lists

Test Secret
  New Project  test-secrets
  Oc Create  kind=Secret  src=test-data/secret.yaml  namespace=test-secrets
  Oc Create  kind=Secret  src=test-data/secrets.yaml  namespace=test-secrets
  Oc Apply  kind=Secret  src=https://api.github.com/repos/pablofelix/robotframework-OpenShiftCLI/contents/test-data/secret.yaml?ref\=/master  namespace=test-secrets
  Run Keyword And Expect Error  ResourceOperationFailed: Apply failed\nReason: Load data from url failed\nContent was not found. Verify url https://api.github.com/repos/pablofelix/robotframework-OpenShiftCLI/contents/test-data/secreto.yaml?ref\=/feature/templates is correct
  ...  Oc Apply  kind=Secret  src=https://api.github.com/repos/pablofelix/robotframework-OpenShiftCLI/contents/test-data/secreto.yaml?ref\=/feature/templates  namespace=test-secrets
  Oc Apply  kind=Secret  src=test-data/secret_apply.yaml  namespace=test-secrets
  Oc Delete  kind=Secret  name=my-secret  namespace=test-secrets
  Oc Delete  kind=Secret  src=test-data/secrets.yaml  namespace=test-secrets
  Oc Delete  kind=Secret  src=test-data/secret_apply.yaml
  Oc Delete  kind=Project  name=test-secrets

Test ConfigMap
  New Project  test-configmaps
  Oc Create  kind=ConfigMap  src=test-data/configmap.yaml  namespace=test-configmaps
  Oc Create  kind=ConfigMap  src=test-data/configmaps.yaml  namespace=test-configmaps
  Oc Patch  kind=ConfigMap  name=my-configmap  src={"data": {"player_initial_lives": "4"}}  namespace=test-configmaps
  Oc Delete  kind=ConfigMap  src=test-data/configmaps.yaml  namespace=test-configmaps
  Oc Delete  kind=ConfigMap  name=my-configmap  namespace=test-configmaps
  Oc Delete  kind=Project  name=test-configmaps

Test Group
  Oc Create  kind=Group  src=test-data/group.yaml
  Oc Delete  kind=Group  name=my-group

Test CustomResourceDefinition
  New Project  test-crds
  Oc Create  kind=CustomResourceDefinition  src=test-data/crd.yaml  namespace=test-crds
  Oc Delete  kind=CustomResourceDefinition  name=crontabs.stable.example.com
  Oc Delete  kind=Project  name=test-crds

Test User, Role and RoleBinding 
  New Project  test-roles
  Oc Create  kind=User  src=test-data/user.yaml
  Oc Create  kind=Role  src=test-data/role.yaml
  Oc Create  kind=RoleBinding  src=test-data/rolebinding.yaml
  Oc Delete  kind=RoleBinding  name=read-pods  namespace=test-roles
  Oc Delete  kind=Role  name=pod-reader  namespace=test-roles
  Oc Delete  kind=User  name=Pablo
  oc Delete  kind=Project  name=test-roles

Test User, ClusterRole and ClusterRoleBinding
  New Project  test-clusterroles
  Oc Create  kind=User  src=test-data/user.yaml
  Oc Create  kind=ClusterRole  src=test-data/clusterrole.yaml
  Oc Create  kind=ClusterRoleBinding  src=test-data/clusterrolebinding.yaml
  Oc Delete  kind=ClusterRoleBinding  name=read-secrets-global
  Oc Delete  kind=ClusterRole  name=secret-reader
  Oc Delete  kind=User  name=Pablo
  Oc Delete  kind=Project  name=test-clusterroles

Test KfDef
  New Project  test-kfdefs
  Oc Create  kind=KfDef  src=test-data/kfdef.yaml  namespace=test-kfdefs
  Oc Get  kind=KfDef  namespace=test-kfdefs
  Oc Patch  kind=KfDef  name=test  src={"metadata": {"finalizers": []}}  namespace=test-kfdefs
  Sleep  10
  Oc Delete  kind=KfDef  name=test   namespace=test-kfdefs
  Oc Delete  kind=Project  name=test-kfdefs

Test Pod
  New Project  test-pods
  Oc Create  kind=Pod  src=test-data/pod.yaml  namespace=test-pods
  Oc Create  kind=Pod  src=test-data/pods.yaml  namespace=test-pods
  Wait For Pods Number  1  namespace=test-pods
  Wait For Pods Status  namespace=test-pods
  Oc Get  kind=Pod  namespace=test-pods
  Search Pods  my  namespace=test-pods  label_selector=role=myrole
  Oc Delete  kind=Pod  name=my-pod  namespace=test-pods
  Oc Delete  kind=Pod  name=my-pod-1  namespace=test-pods
  Oc Delete  kind=Pod  name=my-pod-2  namespace=test-pods
  Oc Delete  kind=Project  name=test-pods

Test Event
  New Project  test-events
  Get Events  namespace=redhat-ods-applications
  Oc Get  kind=Event  namespace=redhat-ods-applications
  Oc Delete  kind=Project  name=test-events






*** Settings ***
Documentation     openshiftcli Library
Library      openshiftcli

*** Test Cases ***
Test Generic Keywords Kind Project
  New Project  test-projects
  Oc Get  kind=Project  api_version=project.openshift.io/v1
  Oc Get  kind=Project  api_version=project.openshift.io/v1  field_selector=metadata.name==test-projects
  Oc Get  kind=Project  api_version=project.openshift.io/v1  field_selector=metadata.name==rhods-notebooks
  Oc Get  kind=Project  api_version=project.openshift.io/v1  name=test-projects
  Oc Get  kind=Project  api_version=project.openshift.io/v1  namespace=test-projects
  Run Keyword And Expect Error  ResourceOperationFailed: Delete failed\nReason: Src or at least one of name, label_selector or field_selector is required, but not both 	
  ...  Oc Delete  kind=Project  api_version=project.openshift.io/v1  src=None  name=test-projects
  Oc Delete  kind=Project  api_version=project.openshift.io/v1  name=test-projects

Test Generic Keywords Kind Deployment
   New Project  test-deployments
   Oc Create   kind=Deployment  src=test-data/deployment.yaml  api_version=v1  namespace=test-deployments
   Oc Get  kind=Deployment  api_version=v1  field_selector=metadata.name==my-deployment  namespace=test-deployments
   Oc Apply  kind=Deployment  src=test-data/deployment_apply.yaml  api_version=v1  namespace=test-deployments
   Oc Get  kind=Deployment  api_version=v1  field_selector=metadata.name==my-deployment  namespace=test-deployments
   Oc Patch  kind=Deployment  api_version=v1  name=my-deployment  src={"spec": {"progressDeadlineSeconds":400}}  namespace=test-deployments
   Oc Get  kind=Deployment  api_version=v1  field_selector=metadata.name==my-deployment  namespace=test-deployments
   Oc Delete  kind=Deployment  api_version=v1  name=my-deployment  namespace=test-deployments
   Run Keyword And Expect Error  ResourceOperationFailed: Get failed\nReason: Not Found
   ...  Oc Get  kind=Deployment  api_version=v1  field_selector=metadata.name==my-deployment  namespace=test-deployments
   Oc Delete  kind=Project  api_version=project.openshift.io/v1  name=test-deployments

Test Generic Keywords Kind List
  New Project  test-lists
  Run Keyword And Expect Error  ResourceOperationFailed: Create failed\nReason: string indices must be integers    
  ...  Oc Create  kind=List  src=test-data/lis.yaml  api_version=v1  namespace=test-lists
  Oc Create  kind=List  src=test-data/list.yaml  api_version=v1  namespace=test-lists
  Oc Apply   kind=List  src=test-data/list_apply.yaml  api_version=v1  namespace=test-lists
  Oc Delete  kind=List  src=test-data/list_apply.yaml  api_version=v1  namespace=test-lists
  Oc Delete  kind=List  src=test-data/list.yaml  api_version=v1  namespace=test-lists
  Oc Delete  kind=Project  api_version=project.openshift.io/v1  name=test-lists

Test Generic Keywords Kind Secret
  New Project  test-secrets
  Oc Create  kind=Secret  src=test-data/secret.yaml  api_version=v1  namespace=test-secrets
  Oc Create  kind=Secret  src=test-data/secrets.yaml  api_version=v1  namespace=test-secrets
  Oc Apply  kind=Secret  src=https://api.github.com/repos/pablofelix/robotframework-OpenShiftCLI/contents/test-data/secret.yaml?ref\=/master  api_version=v1  namespace=test-secrets
  Run Keyword And Expect Error  ResourceOperationFailed: Apply failed\nReason: Load data from url failed\nContent was not found. Verify url https://api.github.com/repos/pablofelix/robotframework-OpenShiftCLI/contents/test-data/secreto.yaml?ref\=/feature/templates is correct
  ...  Oc Apply  kind=Secret  src=https://api.github.com/repos/pablofelix/robotframework-OpenShiftCLI/contents/test-data/secreto.yaml?ref\=/feature/templates  api_version=v1  namespace=test-secrets
  Oc Apply  kind=Secret  src=test-data/secret_apply.yaml  api_version=v1  namespace=test-secrets
  Oc Delete  kind=Secret  api_version=v1  name=my-secret  namespace=test-secrets
  Oc Delete  kind=Secret  src=test-data/secrets.yaml  api_version=v1  namespace=test-secrets
  Oc Delete  kind=Secret  src=test-data/secret_apply.yaml  api_version=v1
  Oc Delete  kind=Project  api_version=project.openshift.io/v1  name=test-secrets

Test Generic Keywords Kind ConfigMap
  New Project  test-configmaps
  Oc Create  kind=ConfigMap  src=test-data/configmap.yaml  api_version=v1  namespace=test-configmaps
  Oc Create  kind=ConfigMap  src=test-data/configmaps.yaml  api_version=v1  namespace=test-configmaps
  Oc Patch  kind=ConfigMap  name=my-configmap  src={"data": {"player_initial_lives": "4"}}  api_version=v1  namespace=test-configmaps
  Oc Delete  kind=ConfigMap  api_version=v1  src=test-data/configmaps.yaml  namespace=test-configmaps
  Oc Delete  kind=ConfigMap  api_version=v1  name=my-configmap  namespace=test-configmaps
  Oc Delete  kind=Project  api_version=project.openshift.io/v1  name=test-configmaps

Test Generic Keywords Kind Group
  Oc Create  kind=Group  src=test-data/group.yaml  api_version=user.openshift.io/v1
  Oc Delete  kind=Group  api_version=user.openshift.io/v1  name=my-group

Test Generic Keywords Kind CustomResourceDefinition
  New Project  test-crds
  Oc Create  kind=CustomResourceDefinition  src=test-data/crd.yaml  api_version=apiextensions.k8s.io/v1  namespace=test-crds
  Oc Delete  kind=CustomResourceDefinition  api_version=apiextensions.k8s.io/v1  name=crontabs.stable.example.com
  Oc Delete  kind=Project  api_version=project.openshift.io/v1  name=test-crds

Test Generic Keywords User, Role and RoleBinding 
  New Project  test-roles
  Oc Create  kind=User  src=test-data/user.yaml  api_version=user.openshift.io/v1
  Oc Create  kind=Role  src=test-data/role.yaml  api_version=rbac.authorization.k8s.io/v1
  Oc Create  kind=RoleBinding  src=test-data/rolebinding.yaml  api_version=rbac.authorization.k8s.io/v1
  Oc Delete  kind=RoleBinding  api_version=rbac.authorization.k8s.io/v1  name=read-pods  namespace=test-roles
  Oc Delete  kind=Role  api_version=rbac.authorization.k8s.io/v1  name=pod-reader  namespace=test-roles
  Oc Delete  kind=User  name=Pablo  api_version=user.openshift.io/v1
  oc Delete  kind=Project  api_version=project.openshift.io/v1  name=test-roles

Test Generic Keywords Kind User, ClusterRole and ClusterRoleBinding
  New Project  test-clusterroles
  Oc Create  kind=User  src=test-data/user.yaml  api_version=user.openshift.io/v1
  Oc Create  kind=ClusterRole  src=test-data/clusterrole.yaml  api_version=rbac.authorization.k8s.io/v1
  Oc Create  kind=ClusterRoleBinding  src=test-data/clusterrolebinding.yaml  api_version=rbac.authorization.k8s.io/v1
  Oc Delete  kind=ClusterRoleBinding  api_version=rbac.authorization.k8s.io/v1  name=read-secrets-global
  Oc Delete  kind=ClusterRole  api_version=rbac.authorization.k8s.io/v1  name=secret-reader
  Oc Delete  kind=User  name=Pablo  api_version=user.openshift.io/v1
  Oc Delete  kind=Project  api_version=project.openshift.io/v1  name=test-clusterroles

Test Keywords KfDef
  New Project  test-kfdefs
  Oc Create  kind=KfDef  src=test-data/kfdef.yaml  api_version=kfdef.apps.kubeflow.org/v1  namespace=test-kfdefs
  Oc Get  kind=KfDef  api_version=kfdef.apps.kubeflow.org/v1  namespace=test-kfdefs
  Oc Patch  kind=KfDef  name=test  src={"metadata": {"finalizers": []}}  api_version=kfdef.apps.kubeflow.org/v1  namespace=test-kfdefs
  Sleep  10
  Oc Delete  kind=KfDef  api_version=kfdef.apps.kubeflow.org/v1  name=test   namespace=test-kfdefs
  Oc Delete  kind=Project  api_version=project.openshift.io/v1  name=test-kfdefs

Test Generic Keywords Kind Pod
  New Project  test-pods
  Oc Create  kind=Pod  src=test-data/pod.yaml  api_version=v1  namespace=test-pods
  Oc Create  kind=Pod  src=test-data/pods.yaml  api_version=v1  namespace=test-pods
  Oc Get  kind=Pod  api_version=v1  namespace=test-pods
  Oc Delete  kind=Pod  api_version=v1  name=my-pod  namespace=test-pods
  Oc Delete  kind=Pod  api_version=v1  name=my-pod-1  namespace=test-pods
  Oc Delete  kind=Pod  api_version=v1  name=my-pod-2  namespace=test-pods
  Oc Delete  kind=Project  api_version=project.openshift.io/v1  name=test-pods

Test Generic Keywords Kind Event
  New Project  test-events
  Oc Get  kind=Event  api_version=v1  namespace=redhat-ods-applications
  Oc Delete  kind=Project  api_version=project.openshift.io/v1  name=test-events






# Examples

Test with docker the examples.

Check README.md files for each example for more details.

#### Table of Contents

1. [How it works](#how-it-works)
2. [Example commands](#example-commands)

## How it works

Examples repositories will be used for this explanation. Check [Test the examples](#test-the-examples) for the installation.

K8comp will check the projects from /opt/k8comp/projects folder. Based on the command line arguments, k8comp will try to deploy that specific file or files.

Below can be found the service yaml of the andromeda application.

```
cat projects/galaxies/andromeda/service.yaml

---
kind: Service
apiVersion: v1
metadata:
  labels:
    app: %{application}-%{environment}-svc
  name: %{application}-%{environment}-svc
  namespace: %{project}-%{environment}
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: %{nodeport}
    protocol: TCP
  selector:
    app: nginx
```

Based on the hierarchy defined in hiera.yaml this example will pull the variable from development.yaml (all hierarchy will be queried). More on how to use hiera can be found using https://docs.puppet.com/hiera/3.2/puppet.html

```
cat hieradata/apps/galaxies/andromeda/development.yaml

---
nodeport: 31601
```

Executing ```k8comp -p galaxies -a andromeda/service -e development``` will print

```
---
kind: Service
apiVersion: v1
metadata:
  labels:
    app: andr-dev-svc
  name: andr-dev-svc
  namespace: glxs-dev
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 31601

    protocol: TCP
  selector:
    app: nginx
######################

# NOTICE - Deployment from /opt/k8comp/projects/galaxies/andromeda/service.yaml
```

What k8comp has done:
- has pulled the project/galaxies/andromeda/service.yaml file
- checked for all the variables required by the service.yaml file. The variables format is %{variable}
- checked for any mappings in extras/mapping (any file found in extras/mapping/ folder will be checked for mappings, for this example only "map" is available)
- replaced any variables used in the command line (galaxies, andromeda, development) with their mappings
```
galaxies=glxs
andromeda=andr
development=dev
```
- any other variables were pulled from hiera, in this case the %{nodeport}
- and print the result in the console

The %{nodeport} variable can be overwritten from command line using:

```
k8comp -p galaxies -a andromeda/service -e development -x nodeport=32500

---
kind: Service
apiVersion: v1
metadata:
  labels:
    app: andr-dev-svc
  name: andr-dev-svc
  namespace: glxs-dev
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 32500

    protocol: TCP
  selector:
    app: nginx
######################

# NOTICE - Deployment from /opt/k8comp/projects/galaxies/andromeda/service.yaml
```

## Example commands

Deploy from projects/project1/application1/ all the files or projects/project1/application1.* file using as hiera variables project1, application1 and development.
```
k8comp -p project1 -a application1 -e development | kubectl apply -f -
```
Deploy from projects/project1/application1/ only rc.* file using as hiera variables project1, application1 and development
```
k8comp -p project1 -a application1/rc -e development | kubectl apply -f -
```
Dry run from projects/project1/application1/ only service.* file using as hiera variables project1, application1 and development
```
k8comp -p project1 -a application1/service -e development
```
Dry run from projects/project1/application1/ all the files or projects/project1/application1.* file using as hiera variables project1 and application1
```
k8comp -p project1 -a application1
```
Dry run from projects/project1.* file using as hiera variables project1 and development
```
k8comp -p project1 -e development
```
Dry run from projects/project1.* file using as hiera variable project1
```
k8comp -p project1
```
Deploy from projects/project1/application1/ all the files or projects/project1/application1.* file using as hiera variables project1, application1 and development. Overwrite hiera variables var1 and var2.
```
k8comp -p project1 -a application1 -e development -x var1=value1 -x var2=value2 | kubectl create -f -
```
Deploy from projects/project1/application1/ all the files or projects/project1/application1.* file using as hiera variables project1 and application1. Overwrite hiera variables var1 and var2.
```
k8comp -p project1 -a application1 -x var1=value1 -x var2=value2 | kubectl apply -f -
```

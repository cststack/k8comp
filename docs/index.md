---
title: About
---

K8comp is a tool which substitutes any templates variables declared in the format %{VARIABLE default "DEFAULT_VALUE"} or %{VARIABLE} with values from a files hierarchy using [hiera](https://rubygems.org/gems/hiera/versions/3.2.0).

AWS Secrets Manager is also supported with the following variables format, AWSSM(BASE64,aws-secret-manager-id) from hiera or %{AWSSM(BASE64,aws-secret-manager-id)} from templates. Check the [How to](https://cststack.github.io/k8comp/04-how-to/02-encrypt-variables/#aws-sm-secret) section of the documentation for more details.

The tool was created to simplify apps deployments for Kubernetes but it can be used to template any other type of files.  

K8comp doesn't interact with Kubernetes API in any way which means is not tight to any Kubernetes version, it just prints to stdout the deployment files. Because of this the user needs to make sure the deployment files are compatible with the Kubernetes version where the files will be deployed.

To install k8comp as helm plugin use:
```
helm plugin install https://github.com/cststack/k8comp
```

> To deploy/delete apps using k8comp just pipe everything to kubectl. K8comp requires kubectl to be installed and configured locally.

How k8comp works?
![how-it-works]({{ site.baseurl }}/assets/docs-images/template-processing.png)

## [](#goals)Goals

- use the default yaml/json Kubernetes syntax
- to have a templates library which can be used in multiple environments and be version controlled using GIT
- have full control of all deployable resources without a complicated deployment setup
- store any secrets encrypted in a GIT repository

## [](#features)Features

- support for yaml, json, yml
- encrypted variables using eyaml
- multiline variables (only for yaml files)
- auto git pull on deployment or manual git pull via ```k8comp pull```
- multi branch deployment
- support for remote templates
- use as helm plugin
- support for AWS Secrets Manager
```
helm plugin install https://github.com/cststack/k8comp
```

## [](#quick-start)Quick start

The easiest way to start using k8comp is with [docker CI container](https://hub.docker.com/r/cststack/k8comp-ci-ssh/)

1) Create a local folder to store the projects
```
mkdir k8comp-projects
```
2) Run the latest k8comp CI container
```
cd k8comp-projects
docker run -v `pwd`:/home/jenkins/code -it cststack/k8comp-ci-ssh bash
cd code
```
3) Pull the default hiera.yaml
```
curl -o hiera.yaml https://raw.githubusercontent.com/cststack/k8comp/master/examples/defaults/hiera.yaml
```
4) Generate the eyaml keys. The keys will be generated in ./keys folder
```
eyaml createkeys
```
5) Create projects and hieradata folders structure
```
mkdir -p hieradata/apps/nginx/
mkdir -p projects/nginx
```
6) Pull the nginx example
```
curl -o projects/nginx/deployment.yaml https://raw.githubusercontent.com/cststack/k8comp-app-hiera-examples/master/projects/nginx/deployment.yaml
curl -o projects/nginx/ingress.yaml https://raw.githubusercontent.com/cststack/k8comp-app-hiera-examples/master/projects/nginx/ingress.yaml
curl -o projects/nginx/service.yaml https://raw.githubusercontent.com/cststack/k8comp-app-hiera-examples/master/projects/nginx/service.yaml
```
7) Pull the hieradata common.yaml, development.yaml and production.yaml examples
```
curl -o hieradata/common.yaml https://raw.githubusercontent.com/cststack/k8comp-app-hiera-examples/master/hieradata/common.yaml
curl -o hieradata/apps/nginx/development.yaml https://raw.githubusercontent.com/cststack/k8comp-app-hiera-examples/master/hieradata/apps/nginx/development.yaml
curl -o hieradata/apps/nginx/production.yaml https://raw.githubusercontent.com/cststack/k8comp-app-hiera-examples/master/hieradata/apps/nginx/production.yaml
```
8) Test the deployment
```
k8comp -a nginx -e development
```
or for production environment
```
k8comp -a nginx -e production
```

To deploy the example pipe the output to kubectl.  
> Make sure the ~/.kube/config is available in the container.

9) `Ctrl`+`d` to exit the container. All the files generated are now available on the local folder created. The files can now be saved on a single or mutiple GIT repositories.

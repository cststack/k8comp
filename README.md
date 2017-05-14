# k8comp

Separate the variables from the code.

#### Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [How it works](#how-it-works)
4. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
5. [Usage - Configuration options and additional functionality](#usage)
    * [Main variables mapping](#main-variables-mapping)
    * [Variables](#variables)
    * [eyaml variables (encrypted variables)](#eyaml-variables)
    * [External files](#external-files)
    * [Examples](#examples)
      * [Test the examples](#test-the-examples)

## Overview

This is a tool which can help with the management of the deployment files. As different environments can have different requirements the tool simplifies the management of secrets (eyaml) and any value which is different from one environment to another (node ports, scaling requirements, environment variables and not only). A single file can be deployed to multiple environments.

The tool can automatically deploy from a specific branch, can be configured to automatically pull any new changes from the remote repository.

Auto or manual git pull for projects and hieradata from a single or multiple repositories. If set to true it will pull on every deployment. Otherwise use ```k8comp pull``` for main_deployment_branch (set in k8comp.conf) or ```k8comp pull -b your_branch``` to pull a specific branch.

The tool will read a file or multiple files from projects hierarchy, query hiera for the variables detected, replace them and create a new deployment output.

The output can be piped to kubectl or viewed on the console.

## Features

- support for yaml, json, yml
- multiline variables (only for yaml files)
- hiera with yaml and eyaml as backend
- auto git pull on deployment or manual git pull via ```k8comp pull```
- multi branch deployment
- deployment from URL

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

## Setup

To install the tool just clone the repository in /opt/k8comp/

Make the tool executable
```
chmod +x /opt/k8comp/bin/k8comp
```
And create also a symlink to /bin for example
```
ln -s /opt/k8comp/bin/k8comp /bin/k8comp
```
### Setup Requirements

The tool requires a functional hiera configuration in the main k8comp folder.

A fully working kubernetes installation and kubectl installed on the local host from where the tool will be used.

Requirements:
 - hiera >= 3.x
 - ed
```
gem install hiera
gem install hiera-eyaml
```
Configure hiera or use the example provided.

## Usage

Create a custom hierarchy based on the 4 variable provided, project, application, environment and location. The example provided might be useful to start with but it might not fully cover all the scenarios.

The configuration file k8comp.conf can be customized as required.

The usage can be found also by running ```k8comp -h```
```
Usage: $programname [-h | pull | -p <project_name> -a <application> -e <environment> -b <git_branch>]

Supported formats: yaml, yml, json

Mandatory variables -p <project_name>

-h | --help :                           Display usage information.
-p | --project <project_name> :         Project name as specified on the projects folder.
                                        Configuration specified in k8comp.conf.
                                        Current projects path ${projects_path}.
                                        If only <project> or <project> and <environment> are
                                        specified the deployment will be from
                                        ${projects_path}/<project>.* file

-a | --application <application> :      The name of the application which need to be deployed.
                                        <application> file has priority over <application> folder.
                                        If ${projects_path}/<project>/<application>.* file is present
                                        the deployment will be from that file.
                                        If there is no file in the above mentioned location the
                                        deployment will be from ${projects_path}/<project>/<application>/ folder.
                                        There are no naming restrictions for the files from
                                        ${projects_path}/<project>/<application>/ folder.
                                        If no <application> is specified in the cmd the deployment
                                        will be from ${projects_path}/<project>.* file.

-e | --environment <environment> :      The environment will be checked from hiera. If no values are
                                        found in hiera the variables will not be replaced.
                                        NOT PART OF projects FILE STRUCTURE but can be added as
                                        variable in the yaml|yml|json template.
                                        Available only in hiera

-l | --location <location> :            The location will be checked from hiera. If no values are
                                        found in hiera the variables will not be replaced.
                                        NOT PART OF projects FILE STRUCTURE but can be added as
                                        variable in the yaml|yml|json template.
                                        Available only in hiera

-x | --xtra <variable> :                The variable specified on the cmd run will be used to update
                                        a value on the final deployment file.
                                        This will have priority over hiera value. Is not mandatory
                                        to be specified.
                                        The format is variable=value.

-b | --branch <variable> :              Specify a branch from where to do the deployment.
                                        It requires k8comp_environments to be

pull | --pull :                         If k8comp_environments is enabled and auto_git_pull is false
                                        use >k8comp pull< without any arguments to pull main_deployment_branch or >k8comp pull -b your_branch< for
                                        a specific git branch.
                                        For pulling via ssh make sure the private key is available
                                        on the server/container.

Examples:
 k8comp pull
 k8comp pull -b test_branch

 k8comp -p project -a application -e development -b test_branch | kubectl apply -f -
 k8comp -p project -a application/rc
 k8comp -p project -e development
 k8comp -p project
 k8comp -p project -a application -e development -x var1=value1 -x var2=value2 | kubectl create -f -
 k8comp -p project -a application -x var1=value1 -x var2=value2 | kubectl apply -f -

 Dry run:

 k8comp -p project -a application -e development
 k8comp -p project -a application -e development -x var1=value1
```

### Main variables mapping

To avoid reaching the maximum limit of a resource name length create any mappings in the "extras/mapping" folder.
Any mapping will be used only on the deployment. Hieradata and projects files need to match the cmd values.

### Variables

Replace the configs which are environment specific with
```
 %{variable_name}
```

On the hieradata hierarchy file add
```
variable_name: value
```

### eyaml variables (encrypted variables)

Encrypt any sensitive information using eyaml. The repository includes a working example. The variables are encrypted in hiera and are getting decrypted at the run time.

NOTE: Make sure the keys are stored secure, not on the same repository as the deployment files.

For more information on how to use eyaml check below URL:

https://github.com/TomPoulton/hiera-eyaml

### External files

The tool will check the deployment files for any external resources to be deployed.
Any line which starts with "http" it will be considered an external resource and it will be part of the deployment.

The URLs can also contain variables. The variables will be pulled from hiera or replaced from the command line arguments.

### Examples:

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

#### Test the examples

Start by cloning the repositories
```
git clone https://github.com/cststack/k8comp-hiera-examples.git /opt/k8comp/hieradata

git clone https://github.com/cststack/k8comp-app-examples.git /opt/k8comp/projects
```
Once the repositories are set try any of the below commands
```
k8comp -p galaxies -a andromeda -e development
k8comp -p galaxies -a andromeda/rc -e development
k8comp -p galaxies -a andromeda/service -e development
k8comp -p kube-system -a kubetree
```

## Limitations

Tested on CentOS 7, Ubuntu 16.04 with kubernetes 1.2.0, 1.4.0, 1.4.6, 1.5.0, 1.5.7

---
title: K8comp args
category: User guide
order: 1
---
The arguments passed to k8comp are used to find the deployment templates and query hiera.

K8comp uses a files structure to organise all the deployment files.

## [](#project)project

The "project" k8comp argument is used to locate deployment files in the `projects` folder and to query hiera. The argument aliases are:
- -p
- -project
- project

A project can have a single or multiple files. Each project can contain multiple applications which will be deployed individually. This structure comes handy where multiple projects will use have applications named similarly (e.g: api, cache...)

**Example:**  
Below command will deploy the application andromeda nested on galaxies project
```
k8comp -p galaxies -a andromeda -e development
```
Below command will deploy **only the file called 'galaxies.yaml|json|yml'** from the `projects/galaxies/` folder. No applications will be deployed part of this deployment.
```
k8comp -p galaxies -e development
```
Below command will deploy **all the files** of the project galaxies stored in the folder `projects/galaxies/`. None of the applications will be deployed part of this deployment.
```
k8comp -a galaxies -e development
```

## [](#application)application

The "application" k8comp argument is used to locate deployment files in the `projects` folder and to query hiera. The argument aliases are:
- -a
- -application
- application

An application can be part of a project or can be on it's own having the files stored in the `projects` top level.  
A k8comp command issues without a project argument will only check deployments in the `projects` top level.

**Example:**  
Below command will deploy the application andromeda nested in galaxies project
```
k8comp -p galaxies -a andromeda -e development
```

Below command will deploy the application andromeda stored in the `projects` folder top level
```
k8comp -a andromeda -e development
```

Below command will deploy **all the files** of the project galaxies stored in the folder `projects/galaxies/`. None of the applications will be deployed part of this deployment.
```
k8comp -a galaxies -e development
```

## [](#environment)environment

The "environment" k8comp argument is used only to query hiera. The argument aliases are:
- -e
- -environment
- environment

**Example:**  
For the below command to work the hieradata files structure needs to contain a file in `hieradata/apps/galaxies/andromeda/development.yaml` or `hieradata/apps/galaxies/andromeda.yaml` or `hieradata/apps/galaxies.yaml` or `hieradata/common.yaml` with the variables of the templates from `projects/galaxies/andromeda/`. Hiera will retrieve the variables based on the hiera.yaml configuration.
```
k8comp -p galaxies -a andromeda -e development
```

For the below command to work the hieradata files structure needs to contain a file in `hieradata/apps/andromeda/development.yaml` or `hieradata/apps/andromeda.yaml` or `hieradata/common.yaml` with the variables of the templates from `projects/andromeda/`. Hiera will retrieve the variables based on the hiera.yaml configuration.
```
k8comp -a andromeda -e development
```

## [](#location)location

The "location" k8comp argument is used only to query hiera. The argument aliases are:
- -l
- -location
- location

The location argument can be used to enhance the hiera structure.


## [](#template)template

The "template" k8comp argument it's only used to locate deployment files in the `projects/_templates/` folder. The argument aliases are:
- -t
- -template
- template

The template argument can be used to deploy components which needs to be part of different applications.

**Example:**  
Below command will use a template from `projects/_templates/healthcheck` and use the hiera variables from andromeda application.

```
k8comp -t healthcheck -a andromeda -e development
```

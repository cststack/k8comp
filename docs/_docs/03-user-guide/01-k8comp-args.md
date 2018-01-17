---
title: K8comp args
category: User guide
order: 1
---
The arguments passed to k8comp are used to find the deployment templates and query hiera.

K8comp uses a files structure to organise all the deployment files.

An explanation can be also found by executing `k8comp --help`

## [](#project)project

The "project" k8comp argument is used to locate deployment files in the `projects` folder and to query hiera. The argument aliases are:
- -p
- --project
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
- --application
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

Deploy only a specific file, in below example only the service file. Please note that a file with the name service.yaml|json|yml needs to be available within the application folder
```
k8comp -a andromeda/service -e development
```

## [](#environment)environment

The "environment" k8comp argument is used only to query hiera. The argument aliases are:
- -e
- --environment
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
- --location
- location

The location argument can be used to enhance the hiera structure.


## [](#template)template

The "template" k8comp argument it's only used to locate deployment files in the `projects/_templates/` folder. The argument aliases are:
- -t
- --template
- template

The template argument can be used to deploy components which needs to be part of different applications.

**Example:**  
Below command will use a template from `projects/_templates/healthcheck` and use the hiera variables from andromeda application.

```
k8comp -t healthcheck -a andromeda -e development
```


## [](#xtra)xtra

The "xtra" k8comp argument it's used to overwrite any variables values. The argument aliases are:
- -x
- --xtra
- xtra


**Example:**  
If the variable value for the healthcheck_tag is in hiera 3001, below command will overwrite that value with 4009.

```
k8comp -t healthcheck -a andromeda -e development -x healthcheck_tag=4009
```

> Multiple "xtra" arguments can be used at a time

## [](#branch)branch

**Dependencies**  
- k8comp_environments set to enabled in k8comp.conf
- hiera.yaml should support branch deployments [hiera.yaml example](https://github.com/cststack/k8comp/blob/master/examples/single_repo/hiera.yaml)

**Recommended options**  
- projects_repo set in k8comp.conf (for single or multi repo setup)
- hieradata_repo set in k8comp.conf (for multi repo setup)
- the user which runs k8comp to have git ssh read only access to the "projects_repo" and/or "hieradata_repo"
- auto_git_pull set to true in k8comp.conf

The only way of using the "branch" feature is in conjunction with "k8comp_environments" set to "enabled".  
If "projects_repo" and/or "hieradata_repo" are set k8comp can create the correct paths for the projects/hieradata.  

The "projects" and "hieradata" are expected to be in "projects/environments/`branch`/"  

> The default branch is "master". To customise the branch change "main_deployment_branch" in k8comp.conf  

The "branch" k8comp argument it's only used to set the path to the deployment files. The argument aliases are:
- -b
- --branch
- branch


There are two setup options for k8comp_environments feature:
- single repository
- multiple repositories

> `k8comp pull` can create the structure automatically if the user which executes k8comp commands has ssh git access  


**Example**  
```
k8comp -p galaxies -a andromeda -e development -b development
```

### [](#single-repo)Single repo

The single repository option requires that both "projects" and "hieradata" to be in the same repository. An example can be found [here](https://github.com/cststack/k8comp-app-hiera-examples).

If the user which runs k8comp has access to the repos via ssh the repository can be configured on the "projects_repo". K8comp will create automatically the folders structure when` k8comp pull` command is executed.

### [](#multi-repo)Multi repo

The multi repository option requires that the "projects" and "hieradata" to have dedicated repositories. The files should be saved in the root level. Examples for [projects repository](https://github.com/cststack/k8comp-app-examples) and [hieradata](https://github.com/cststack/k8comp-hiera-examples)


## [](#pull-and-auto-pull)pull & auto pull

**Dependencies**  
- k8comp_environments set to enabled in k8comp.conf
- hiera.yaml should support branch deployments [hiera.yaml example](https://github.com/cststack/k8comp/blob/master/examples/single_repo/hiera.yaml)
- projects_repo set in k8comp.conf (for single or multi repo setup)
- hieradata_repo set in k8comp.conf (for multi repo setup)
- the user which runs k8comp to have git ssh read only access to the "projects_repo" and/or "hieradata_repo"
- for auto git pull "auto_git_pull" set to "true" in kcomp.conf


The "pull" k8comp argument cannot be used as part of a deployment. The argument aliases are:
- pull
- --pull


**Example:**  
Pull the "main_deployment_branch"

```
k8comp pull
```

Pull a specific branch

```
k8comp pull -b development
```

If "auto_git_pull" is set to "true" on every deployment k8comp will pull the specified branch/main_deployment_branch
```
k8comp -a andromeda -e development -b development
```

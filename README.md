# k8comp

Separate the variables from the code.

#### Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Goals](#goals)
4. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
5. [Usage - Configuration options and additional functionality](#usage)
    * [Main variables mapping](#main-variables-mapping)
    * [Variables](#variables)
    * [eyaml variables (encrypted variables)](#eyaml-variables)
    * [External files](#external-files)

## Overview

This is a tool which can help with the deployment files management. As different environments can have different requirements the tool simplifies the management of secrets (eyaml) and any value which is different from one environment to another (node ports, scaling requirements, environment variables and not only). A single file can be deployed to multiple environments.

The tool will read a file or multiple files from projects folder hierarchy, query hiera for the variables detected, replace them and create a new deployment output.

The output can be piped to kubectl or viewed on the console.

## Features

- support for yaml, json, yml
- encrypted variables ([eyaml](#eyaml-variables))
- multiline variables [app](https://github.com/cststack/k8comp-app-hiera-examples/blob/master/projects/galaxies/andromeda/rc.yaml), [hiera](https://github.com/cststack/k8comp-app-hiera-examples/blob/master/hieradata/common.yaml) (only for yaml files)
- hiera backend
- auto git pull on deployment or manual git pull via ```k8comp pull```
- multi branch deployment
- deployment from URL

## Setup

Test with [docker](https://hub.docker.com/r/cststack/k8comp/) using the [examples](https://github.com/cststack/k8comp/tree/master/examples)
- [single repository with manual git pull](https://github.com/cststack/k8comp/tree/master/examples/single_repo)
- [multi repository with auto git pull](https://github.com/cststack/k8comp/tree/master/examples/multi_repo)

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
                                        deployment will be from
                                        ${projects_path}/<project>/<application>/ folder.
                                        There are no naming restrictions for the files from
                                        ${projects_path}/<project>/<application>/ folder.
                                        If no <application> is specified in the cmd the deployment
                                        will be from ${projects_path}/<project>.* file.
                                        An application folder or file can be located also
                                        at the projects folder root. The hiera config requires
                                        changes for this to work as expected.

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
                                        use >k8comp pull< without any arguments to pull
                                        main_deployment_branch or >k8comp pull -b your_branch< for
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

 k8comp -a application -e environment
 k8comp -a application

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

Check examples folder.

## Limitations

Tested on CentOS 7, Ubuntu 16.04 with kubernetes 1.2.0, 1.4.0, 1.4.6, 1.5.0, 1.5.7

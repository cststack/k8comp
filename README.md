# k8comp

Separate the variables from the code.

#### Table of Contents

1. [Overview](#overview)
2. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Main variables mapping](#main-variables-mapping)
    * [Variables](#variables)
    * [eyaml variables (encrypted variables)](#eyaml-variables)
    * [External files](#external-files)
    * [Examples](#examples)
4. [To do](#to-do)

## Overview

This is a tool which can help with the management of the deployment files.
The tool will read a file or multiple files from projects hierarchy, query hiera for the variables detected, replace them and create a new deployment output. The files can be in any of the kubernetes supported formats (json, yaml, yml).

The output can be piped to kubectl or viewed on the console.

## Setup

To install the script just clone the repository in /opt/k8comp/

Make the script executable
```
chmod +x /opt/k8comp/bin/k8comp
```
And create also a symlink to /bin for example
```
ln -s /opt/k8comp/bin/k8comp /bin/k8comp
```
### Setup Requirements

The script requires a functional hiera configuration in the main k8comp folder.

A fully working kubernetes installation and kubectl installed on the local host from where the script will be used.

To install hiera in CentOS 7 download and install puppet repository.
```
rpm -Uvh https://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-12.noarch.rpm
```
and install the package
```
yum install hiera -y
gem install hiera-eyaml
```
Configure hiera or use the example provided.

## Usage

Create a custom hierarchy based on the 4 variable provided, project, application, environment and location. The example provided might be useful to start with but it might not fully cover all the scenarios.

The configuration file k8comp.conf can be customized as required.

The usage can be found also by running
```
k8comp -h
```
```
Usage: $programname [-h | -p <project_name> -a <application> -e <environment> ]

The order of the arguments on the cmd defines the hierarchy.

   -p project -a app -l location IS NOT EQUAL TO -p project -l location -a app

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

## Limitations

Tested on CentOS 7 and kubernetes 1.2.0, 1.4.0, 1.4.6 and 1.5.0

## To do

* r10k integration example

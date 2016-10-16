# k8comp

Separate the variables from the code.

#### Table of Contents

1. [Overview](#overview)
2. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Yaml variables](#yaml-variables)
4. [To do](#to-do)

## Overview

This is a bash script which help with the management of the deployment files.
The script will just query hiera for the variables detected, replace them and create a new deployment. The files can be in any of the kubernetes supported formats (json, yaml, yml).

The output can be piped to kubectl or viewed on the console.

## Setup

To install the script just clone the repository in /opt/k8comp/

Make the script executable
```
chmod +x /opt/k8comp/k8comp
```
Create also a symlink
```
ln -s /opt/k8comp/k8comp /bin/k8comp
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
```
Configure hiera or use the example provided.

## Usage

Create a custom hierarchy based on the 3 variable provided, project, application and environment. The example provided might be useful to start with but it might not fully cover all the scenarios.

The configuration file k8comp.conf can be customized as required.

The usage can be found also by running
```
k8comp -h
```
```
Usage: $programname [-h | -p <project_name> -a <application> -e <environment> ]

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

-x | --xtra <variable> :                The variable specified on the cmd run will be used to update
                                        a value on the final deployment file.
                                        This will have priority over hiera value. Is not mandatory
                                        to be specified.
                                        The format is variable=value.

Examples:

 k8comp -p project -a app -e development | kubectl apply -f -
 k8comp -p project -a app
 k8comp -p project -e development
 k8comp -p project
 k8comp -p project -a app -e development -x var1=value1 -x var2=value2 | kubectl create -f -
 k8comp -p project -a app -x var1=value1 -x var2=value2 | kubectl apply -f -

 Dry run:

 k8comp -p project -a app -e development
 k8comp -p project -a app -e development -x var1=value1
 ```

### Yaml variables
Replace the configs which are environment specific with
```
 %{variable_name}
```

On the hieradata file hierarchy add
```
variable_name: value
```
## Limitations

Tested only with CentOS 7 and kubernetes 1.2.0.

## To do

* r10k integration example

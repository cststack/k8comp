# k8comp

Separate the variables from the code for kubernetes and docker-compose.

#### Table of Contents

1. [Overview](#overview)
2. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Yaml variables](#yaml-variables)
4. [To do](#to-do)

## Overview

This is a bash script which help with the management and deployment of yaml files. It can be used with kubernetes or docker-compose.
The yaml files need be specifically created for kubernetes or docker-compose.
The script will just query hiera for the variables detected, replace them and create a new yaml files on the deployment folder.

The output can be piped to kubectl or viewed on the console.

## Setup

To install the script just clone the repository in /opt/k8comp/

Make the script executable
```
chmod +x /opt/k8comp/k8comp
```
Create also a symlink
```
ln -s /opt/k8comp/k8comp /usr/local/bin/k8comp
```
### Setup Requirements

The script requires a functional hiera configuration. On the example folder can be found a working configuration.

A fully working kubernetes installation and kubectl installed on the local host from where the script will be used.

To install hiera in CentOS 7 download and install puppet repository
```
rpm -Uvh https://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-12.noarch.rpm
```
and install the package
```
yum install hiera -y
```
Configure hiera or use the example provided. To use the example provided follow below steps.

Copy the example provided.
```
cp -r /opt/k8comp/example/* /opt/k8comp/
```
Replace the main hiera.yaml configuration file with the file provided on the example
```
rm -rf /etc/hiera.yaml
ln -s /opt/k8comp/hiera.yaml /etc/hiera.yaml
```

Test nginx example. Running below command will create a new folder deployments in /opt/k8comp for the output files. Also it will print on the console the output of the compiled file.

Please note that a functional kubernetes master is required before running the commands.
```
k8comp -p project1 -a app1 -e development
```
Deploy to kubernetes
```
k8comp -p project1 -a app1 -e development | kubectl create -f -
```

## Usage

The script will work currently only with the current yaml hierarchy provided and requires the files structure to be like on the example provided. Hopefully this will change in the future and the tool will allow a flexible configuration.

The configuration file k8comp.conf can be customized as required.

The usage can be found also by running
```
k8comp -h
```
```
Usage: /usr/local/bin/k8comp [-h | -p <project_name> -a <application> -e <environment> ]
 -h | --help :                           Display usage information.
 -p | --project <project_name> :         Project name as specified on the projects folder. Configuration specified in k8comp.conf. Current path /opt/k8comp/projects
 -a | --application <application> :      The name of the application which need to be deployed. /opt/k8comp/projects/<project>/<application>/<application>.yaml
 -e | --environment <environment> :      The environment will be checked from hiera. If no values are found in hiera the variables will not be replaced.

Example:

 k8comp -p project1 -a app1 -e development | kubectl create -f -
 k8comp -p project1 -a app1 -e development | kubectl apply -f -

 Dry run:

 k8comp -p project1 -a app1 -e development
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
* flexible configuration for a custom hierarchy
* rewrite the tool

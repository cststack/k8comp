# [](#about)About

K8comp is a tool which substitutes any templates variables declared in the format %{variable} with values from a files hierarchy using [hiera](https://rubygems.org/gems/hiera/versions/3.2.0).
The tool was created to simplify apps deployments for Kubernetes but it can be used to template any other type of files.  

K8comp doesn't interact with Kubernetes API in any way which means is not tight to any Kubernetes version, it just prints to stdout the templates. Because of this the user needs to make sure the deployment files are compatible with the Kubernetes version where the files will be deployed.  
The tool requires kubectl installed and configured locally.

# [](#goals)Goals

- to have a templates library which can be used in multiple environments and be version controlled using git
- have full control of all deployable resources without a complicated deployment setup
- use the default yaml/json Kubernetes syntax
- store any secrets encrypted in a git repository (eyaml)

# [](#features)Features

## [](#format)Templates format
The templates can be in any Kubernetes supported formats yaml,json,yml

## [](#variables)Variables
The variable format is %{VARIALE_NAME}.
There are few types of variables supported:
- single value variables
- multi line variables (only for yaml template). These are handy for all kind of headers and metadata values.  
    **Example:**  
    Instead of having on each template the kind and API version the configs can be extracted to variables in common.yaml
    ```
    kind: ReplicationController
    apiVersion: v1
    ```
    will become
    ```
    %{kind_replication}
    ```
    and the common.yaml will look like below  
    ```
    kind_replication:
        kind: ReplicationController
        apiVersion: v1
    ```
- encrypted variables using [eyaml](https://github.com/voxpupuli/hiera-eyaml)
- composed variables. A single variable can have multiple values collected from hierarchy. [explanation](https://stackoverflow.com/questions/40615946/iterate-over-a-deeply-nested-hiera-hash-in-puppet-manifest)


## [](#auto_git_pull)Auto GIT pull
Auto git pull means that k8comp will update the current templates before each deployment. This option can be set to false for manual pull using `k8comp pull`.  
For this option to work the environment from where k8comp will be run needs to have ssh access to the projects/hieradata repositories.  
k8comp.conf needs to have
- k8comp_environments=enabled
- auto_git_pull=true
- a projects_repo and a hieradata_repo (depending on the case)  

A config example can be found  [here](#hierayaml)

# [](#requirements)Requirements

k8comp was only tested in Linux. Below can be found the details of a working setup.
kubectl should be installed and configured locally.

## [](#os)OS

K8comp was tested in CentOS 7 and Ubuntu 16.04. It might work with other Unix distributions.

## [](#dependencies)Package dependencies

The tool requires:
- ed
- hiera >= 3.x
- hiera-eyaml >= 2.X

### [](#centos)CentOS 7 dependencies
```
yum install ed git ruby
gem install --no-ri --no-rdoc hiera-eyaml hiera
```
### [](#ubuntu)Ubuntu 16.04 dependencies
```
apt-get install rubygems ed
gem install --no-ri --no-rdoc hiera-eyaml hiera
```

# [](#install)Install

Once the dependencies are installed pull the latest version of the tool using
```
curl -L https://raw.githubusercontent.com/cststack/k8comp/master/bin/k8comp -o /usr/local/bin/k8comp
chmod +x /usr/local/bin/k8comp
```

# [](#setup)Setup

K8comp requires a k8comp.conf file present on the /opt/k8comp/ or on the same folder from where the command is executed (pwd).

## [](#config)k8comp.conf

| variable               | default value               | supported values         | description                                             |
|:-----------------------|:----------------------------|:-------------------------|:--------------------------------------------------------|
| k8comp_dir             | $PWD                        | any                      | Application main folder                                 |
| custom_hiera           | $PWD/hiera.yaml             | any                      | Custom hiera config file                                |
| hiera_path             | /usr/local/bin              | any                      | hiera binary location                                   |
| projects_path          | $PWD/projects               | any                      | deployment files location                               |
| templates_path         | _templates                  | any                      | templates folder name. The folder is in `projects_path` |
| var_fail_safe          | false                       | true/false               | set if the deployment should fail on variable not found |
| k8comp_environments    | disabled                    | disabled/enabled         | each git branch equals an environment                   |
| auto_git_pull          | false                       | true/false               | git pull before each deployment                         |
| main_deployment_branch | master                      | any                      | works in conjunction with `k8comp_environments`          |
| projects_repo          | empty                       | any                      | works in conjunction with `auto_git_pull`               |
| hieradata_repo         | empty                       | any                      | works in conjunction with `auto_git_pull`               |
| mapping                | extras/mapping | none                     | override deployment values. [example](https://github.com/cststack/k8comp/blob/master/examples/common/extras/mapping/map) |

Example [k8comp.conf](https://github.com/cststack/k8comp/blob/master/examples/defaults/k8comp.conf).

The default k8comp.conf file is not required but is recommended to have a custom k8comp.conf in case the defaults will change.  
Download the example k8comp.conf using below command.
```
mkdir $PWD/k8comp_projects
curl -L https://raw.githubusercontent.com/cststack/k8comp/master/examples/defaults/k8comp.conf -o $PWD/k8comp_projects/k8comp.conf
```
## [](#hiera)hiera.yaml

k8comp relies on hiera to store all the variables.  
**Set up examples:**
- hiera.yaml example for manual projects setup [here](https://github.com/cststack/k8comp/tree/master/examples/manual_repo_setup).  
- hiera.yaml example for multi branch and multiple repository setup (projects and hieradata separated) [here](https://github.com/cststack/k8comp/tree/master/examples/multi_repo).  
- hiera.yaml example for multi branch and single repository setup (projects and hieradata on the same repo) [here](https://github.com/cststack/k8comp/tree/master/examples/multi_repo).

Puppet experience might be useful to understand how hiera works. Otherwise [google might help](https://www.google.co.uk/search?q=how+hiera+works&oq=how+hiera+works).

**Short explanation:**  
Hiera uses a files hierarchy which is defined in hiera.yaml. Based on that hierarchy the variables will be retrieved. Priority will always have the upper layers.

**Example:**  
hiera.yaml looks like [here](https://github.com/cststack/k8comp/blob/master/examples/defaults/hiera.yaml).  
files hierarchy looks like below
```
hieradata
├── apps
│   ├── galaxies
│   │   ├── andromeda
│   │   │   ├── development.yaml
│   │   │   └── qa.yaml
│   │   ├── andromeda.yaml
│   └── galaxies.yaml
└── common.yaml
```

A variable called %{nginx_image} is stored in andromeda.yaml with value 1.9.13 and in development.yaml with value 1.13.10.

For `k8comp -p galaxies -a andromeda` hiera will pass back nginx_image=1.9.13  
For `k8comp -p galaxies -a andromeda -e dev` hiera will pass back nginx_image=1.13.10

%{nginx_image} can have other values in qa.yaml, galaxies.yaml and common.yaml. k8comp will make sure the nginx_image value is the correct one based on the arguments passed.

## [](#mapping)mapping
Kubernetes allows a limited number of characters for resource name. To avoid reaching the maximum limit of a resource name length create mapping files in `extras/mapping` folder. Multiple files with multiple names are supported. The mapping names will only be used for the deployed resources.  
An example of mapping can be found [here](https://github.com/cststack/k8comp/blob/master/examples/common/extras/mapping/map)

**Example:**  
If `extras/mapping/map` contains:
```
# projects
galaxies=glxs

# applications
andromeda=andr

# environments
development=dev
```
Hieradata contains
```
hieradata
├── apps
│   ├── galaxies
│   │   ├── andromeda
│   │   │   ├── development.yaml
│   │   │   └── qa.yaml
│   │   ├── andromeda.yaml
│   └── galaxies.yaml
└── common.yaml
```
The k8comp command is
`k8comp -p galaxies -a andromeda -e development`  
The template variables will be `glxs`, `andr` and `dev`

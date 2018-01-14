---
title: Configuration files
category:
order: 3
---

K8comp requires a k8comp.conf file present on the /opt/k8comp/ or on the same folder from where the command is executed (pwd).

## [](#config)k8comp.conf

Below can be found the default values for k8comp. If the default values are a good match then k8comp.conf is not required.

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

> The default k8comp.conf file is not required but is recommended to have a custom k8comp.conf in case the defaults will change.  

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

> Puppet experience might be useful to understand how hiera works. Otherwise [google might help](https://www.google.co.uk/search?q=how+hiera+works&oq=how+hiera+works).

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

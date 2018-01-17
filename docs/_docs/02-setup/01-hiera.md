---
title: hiera.yaml
category: Setup
order: 1
---

k8comp relies on hiera to store all the variables. To have a working setup k8comp requires a hiera.yaml.  
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
For `k8comp -p galaxies -a andromeda -e development` hiera will pass back nginx_image=1.13.10

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

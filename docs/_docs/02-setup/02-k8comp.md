---
title: k8comp.conf
category: Setup
order: 2
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

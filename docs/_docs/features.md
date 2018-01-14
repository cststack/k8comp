---
title: Features
category:
order: 1
---

## [](#templates-format)Templates format

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

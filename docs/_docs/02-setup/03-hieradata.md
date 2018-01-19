---
title: Hieradata
category: Setup
order: 3
---

The dedicated folder where hiera will store the files hierarchy is called `hieradata` and is located in the same folder as the `projects` folder. Currently this folder name cannot be customised.  

If hiera.yaml has been customised the files structure needs to match that configuration.

The variables use to query hiera are:
- project (-p)
- application (-a)
- environment (-e)
- location (-l)
- any mappings created using the `extra/mappings/*` folder will be passed to hiera

## [](#variables)Variables

The variable format is %{VARIABLE default "DEFAULT_VALUE"} or %{VARIABLE}.  
The variable retrieval order is:
- hiera
- default value specified as part of variable template  

> The value before "default" (in the above example "VARIABLE") will be retrieved from hiera. If no value is available in hiera the value after "default" (in the above example "DEFAULT_VALUE") will be used as default.

There are few types of variables supported:
- single value variables
- multi line variables (only for yaml template). These are handy for all kind of headers, metadata values or any other data difference between deployments which has more than a single value.  
    **Example:**  
    Instead of having in each template the kind and API version the configs can be extracted to variables in common.yaml
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

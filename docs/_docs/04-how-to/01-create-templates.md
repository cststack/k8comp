---
title: Create templates
category: How to
order: 1
---

Every single part of a deployment file regardless of the type of file can be stored in hiera as a variable. As mentioned in the [Hieradata variables section]({{ site.baseurl }}/02-setup/03-hieradata/#variables) there are multiple ways of slicing a deployment files in to variables. To go extreme a deployment file can be fully sliced in variables and everything can be retrieved from hiera.

## [](#single-value-variable)Single value variable

For simple values like cpu/memory or container tags the single values variables are the recommended way. The secrets can be stored as single value variables and can be also encrypted using eyaml if required.

By using %%{::}{variable_name} in hiera different variables can be passed back in the deployment file.

**Example**  
A secret version can have the value of application+container_tag. This comes handy for rollbacks when the secret has changed from one deployment to another.  
Below example is from a hieradata file.
```
---
secret_version: "%%{::}{application}-%%{::}{container_tag}"
```
> Make sure the variables are quoted

## [](#multiline-variable)Multiline variable

For more advanced customisations the multiline variables might be a better fit. A multiline variable can collect multiple values from hiera, [explanation](https://stackoverflow.com/questions/40615946/iterate-over-a-deeply-nested-hiera-hash-in-puppet-manifest). This comes handy when different environments have different number of arguments.

**Example**  
An application will require a variable ***z*** set to 300 on all environments but for each environment it will require a variable ***y*** with a different value.
This can be easily achieved by setting at the environment level the variable ***y*** with different value on each environment and on the application level the variable ***z*** with the common value of 300.  
> Please note that the format needs to be in a multiline style  

Hiera will return the multiline variable with the correct values for each environment

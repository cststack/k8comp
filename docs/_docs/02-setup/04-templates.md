---
title: Templates
category: Setup
order: 3
---

The templates can be in any of the Kubernetes supported formats yaml,json,yml.

The variables used to get the templates from the ***projects*** folder are:
- project (-t)
- application (-a)
- template (-t)

K8comp has three types of templates:
 - application templates
 - remote templates
 - generic templates

The default location for all the templates is ***projects*** folder. To use a custom location update ***projects_path*** value in k8comp.conf.

## [](#application-templates)Application templates

Application templates are the deployment files stored in a specific folder within the ***projects*** folder. All the arguments passed to k8comp will be used as variables.  
If the files doesn't exist k8comp will print an error message that there are no deployment files in that specific folder.

## [](#remote-templates)Remote templates

Any line which starts with ***http*** will be treated as a remote template. This feature can be useful if the user tries to use deployment files stored for example in github.  
To use this option create a new deployment file in the ***projects*** folder with the URLs of the files. K8comp will make sure that the files will be pulled and concatenated to a deployment file.

## [](#generic-templates)Generic templates

The generic templates have a dedicated folder within the ***projects*** folder called ***_templates***. The default value can be changed by updating the ***templates_path*** value in k8comp.conf.

A generic template can be used for components which needs to be deployed in multiple projects/applications. It might be an nginx error page or a health check service.  
> K8comp will not use the template name as a variable in the deployment other than to locate the files which needs to be deployed.

**Example**

The below command will deploy a component called ***healthcheck*** for an ***andromeda*** called application in the environment ***development***.
```
k8comp -t healthcheck -a andromeda -e development
```

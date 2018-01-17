---
title: Git control
category: User guide
order: 2
---
TBU

## [](#auto_git_pull)Auto GIT pull

Auto git pull means that k8comp will update the current templates before each deployment. This option can be set to false for manual pull using `k8comp pull`.  
For this option to work the environment from where k8comp will be run needs to have ssh access to the projects/hieradata repositories.  
k8comp.conf needs to have
- k8comp_environments=enabled
- auto_git_pull=true
- a projects_repo and a hieradata_repo (depending on the case)  

A config example can be found  [here](#hierayaml)

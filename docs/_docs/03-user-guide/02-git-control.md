---
title: Git control
category: User guide
order: 2
---
Most of the k8comp configs can be stored in git repositories.

**Advanced setup**
- git repo for projects with/without hieradata
- git ssh access to the projects/hieradata repositories for the deployment user
- k8comp configs repository (hiera.yaml, k8comp.conf and extra folder)
- remote location where to store eyaml keys

**Simple setup**
- single repository for projects and hieradata
- single repository for k8comp configs including eyaml keys
- git ssh access to all of above repositories

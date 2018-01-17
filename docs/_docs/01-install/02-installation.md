---
title: Installation
category: Install
order: 2
---

To install the latest unstable version of k8comp pull the latest version from github using below command.
For the latest stable version check the [releases from github](https://github.com/cststack/k8comp/releases)

```
curl -o /usr/local/bin/k8comp https://raw.githubusercontent.com/cststack/k8comp/master/bin/k8comp
chmod +x /usr/local/bin/k8comp
```

## [](#docker)Docker

There is an official k8comp container which can be used for local testing and Jenkins CI.  
The container is based on the [official jenkins ssh slave](https://hub.docker.com/r/jenkins/ssh-slave/). The repository can be found [here](https://hub.docker.com/r/cststack/k8comp-ci-ssh/).  

Check [Quick start]({{ site.baseurl }}#quick-start) for more details

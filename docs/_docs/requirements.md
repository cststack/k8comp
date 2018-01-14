---
title: Requirements
category:
order: 2
---

K8comp was only tested in Linux. Below can be found the details of a working setup.
kubectl should be installed and configured locally.

## [](#os)OS

K8comp was tested in CentOS 7 and Ubuntu 16.04. It might work with other Unix distributions.

## [](#dependencies)Package dependencies

The tool requires:
- ed
- hiera >= 3.x
- hiera-eyaml >= 2.X

### [](#centos)CentOS 7 dependencies
```
yum install ed git ruby
gem install --no-ri --no-rdoc hiera-eyaml hiera
```
### [](#ubuntu)Ubuntu 16.04 dependencies
```
apt-get install rubygems ed
gem install --no-ri --no-rdoc hiera-eyaml hiera
```

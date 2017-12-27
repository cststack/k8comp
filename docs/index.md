# [](#about)About

k8comp is a tool which substitutes any variables declared in the format %{variable} with values from a files hierarchy using [hiera](https://rubygems.org/gems/hiera/versions/3.2.0).
The tool was created to simplify apps deployments for kubernetes but it can be used to template any other type of files.

k8comp doesn't interact with kubernetes api in any way which means is not tight to any kubernetes version, it just prints to stdout the templates.
The tool requires kubectl installed and configured locally.

# [](#goals)Goals

The goals of this project are as follows:

- to have a kubernetes library which can be version controlled using git
- have full control of all deployable resources without a complicated deployment setup
- use the default yaml/json kubernetes syntax
- store any secrets encrypted in a git repository (eyaml)

# [](#requirements)Requirements

k8comp was only tested in Linux. Below can be found the details of a working setup.

## [](#os)OS

k8comp was tested in CentOS 7 and Ubuntu 16.04. It might work with any other Unix distributions.

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

# [](#install)Install

Once the dependencies are installed pull the latest version of the tool using
```
curl -L https://raw.githubusercontent.com/cststack/k8comp/master/bin/k8comp -o /usr/local/bin/k8comp
chmod +x /usr/local/bin/k8comp
```

# [](#setup)Setup

k8comp requires a k8comp.conf file present on the /opt/k8comp/ or on the same folder from where the command is executed (pwd).

## [](#config)k8comp.conf

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
| main_deployment_branch | master                      | any                      | works in conjunction with `k8comp_environment`          |
| projects_repo          | empty                       | any                      | works in conjunction with `auto_git_pull`               |
| hieradata_repo         | empty                       | any                      | works in conjunction with `auto_git_pull`               |
| mapping                | extras/mapping | none                     | override deployment values. [example](https://github.com/cststack/k8comp/blob/master/examples/common/extras/mapping/map) |

Example [k8comp.conf](https://github.com/cststack/k8comp/blob/master/examples/defaults/k8comp.conf).

The default k8comp.conf file is not required but is recommended to have a custom k8comp.conf in case the defaults will change.

Download the example k8comp.conf using below command.
```
mkdir $PWD/k8comp_projects
curl -L https://raw.githubusercontent.com/cststack/k8comp/master/examples/defaults/k8comp.conf -o $PWD/k8comp_projects/k8comp.conf
```

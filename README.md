# k8comp

For more information about k8comp check https://cststack.github.io/k8comp/

## About

K8comp is a tool which substitutes any templates variables declared in the format %{variable} with values from a files hierarchy using [hiera](https://rubygems.org/gems/hiera/versions/3.2.0).
The tool was created to simplify apps deployments for Kubernetes but it can be used to template any other type of files.  

## Features

- support for yaml, json, yml
- encrypted variables using eyaml
- multiline variables (only for yaml files)
- auto git pull on deployment or manual git pull via ```k8comp pull```
- multi branch deployment
- support for remote templates

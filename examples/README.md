# Examples

Check README.md files for each example for more details.

## Example commands

Deploy from projects/project1/application1/ all the files or projects/project1/application1.* file using as hiera variables project1, application1 and development.
```
k8comp -p project1 -a application1 -e development | kubectl apply -f -
```
Deploy from projects/project1/application1/ only rc.* file using as hiera variables project1, application1 and development
```
k8comp -p project1 -a application1/rc -e development | kubectl apply -f -
```
Dry run from projects/project1/application1/ only service.* file using as hiera variables project1, application1 and development
```
k8comp -p project1 -a application1/service -e development
```
Dry run from projects/project1/application1/ all the files or projects/project1/application1.* file using as hiera variables project1 and application1
```
k8comp -p project1 -a application1
```
Dry run from projects/project1.* file using as hiera variables project1 and development
```
k8comp -p project1 -e development
```
Dry run from projects/project1.* file using as hiera variable project1
```
k8comp -p project1
```
Deploy from projects/project1/application1/ all the files or projects/project1/application1.* file using as hiera variables project1, application1 and development. Overwrite hiera variables var1 and var2.
```
k8comp -p project1 -a application1 -e development -x var1=value1 -x var2=value2 | kubectl create -f -
```
Deploy from projects/project1/application1/ all the files or projects/project1/application1.* file using as hiera variables project1 and application1. Overwrite hiera variables var1 and var2.
```
k8comp -p project1 -a application1 -x var1=value1 -x var2=value2 | kubectl apply -f -
```

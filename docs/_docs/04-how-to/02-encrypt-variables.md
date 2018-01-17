---
title: Encrypted variables
category: How to
order: 2
---
To encrypt any type of file/string k8comp relies on eyaml and hiera.  

In the [Quick start]({{ site.baseurl }}#quick-start) can be found the command to generate the keys to encrypt variables. hiera.yaml needs to have the correct values for this purpose. Example of [hiera.yaml](https://github.com/cststack/k8comp/blob/master/examples/defaults/hiera.yaml) with eyaml enabled.

> Please note that the secret in the final deployment file will be in the initial format before encryption. Usually kubernetes requires the secrets to be in base64 format.

The steps to create an encrypted secret are:
- encode the variable
- encrypt the variable
- save the encrypted string in hiera as variable value

> The eyaml command needs to be executed from the folder with the keys.

## [](#single-value-variable)Single value variable

To encode and encrypt a variable in Linux is enough to pipe the value to the base64 tool and eyaml
```
eyaml encrypt -s $(echo test100 | base64 -w 0)
```
The value obtained can now be stored in hiera as a variable value.

## [](#file-as-variable)File as variable

If a single value is not enough a file can be also encrypted as a secret. It can be any type of file (properties, env, tar, zip... etc).  
To encode a file use below command:
```
eyaml encrypt -s $(cat secret.tar.gz | base64 -w 0)
```
The value obtained can now be stored in hiera as a variable value.

> Please note that the container should be able to handle this type of secrets.

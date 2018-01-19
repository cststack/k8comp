---
title: Encrypted variables
category: How to
order: 2
---
To encrypt any type of file/string k8comp relies on eyaml and hiera.  

In the [Quick start]({{ site.baseurl }}#quick-start) can be found the command to generate the keys to encrypt variables. hiera.yaml needs to have the correct values for this purpose. Example of [hiera.yaml](https://github.com/cststack/k8comp/blob/master/examples/defaults/hiera.yaml) with eyaml enabled.

> Please note that the secret in the final deployment file will be in the initial format before encryption. Usually kubernetes requires the secrets to be in base64 format. The yaml files can be stored in GIT as the secrets are encrypted.

The steps to create an encrypted secret are:
- encode the variable
- encrypt the variable
- save the encrypted string in hiera as variable value

> The eyaml command needs to be executed from the folder with the keys.

**Example 1**  

The example is done using the latest CI container

1) Create a local folder to store the projects
```
mkdir k8comp-projects
```
2) Run the latest k8comp CI container
```
cd k8comp-projects
docker run -v `pwd`:/home/jenkins/code -it cststack/k8comp-ci-ssh bash
cd code
```
3) Pull the default hiera.yaml
```
curl -o hiera.yaml https://raw.githubusercontent.com/cststack/k8comp/master/examples/defaults/hiera.yaml
```
4) Generate the eyaml keys. The keys will be generated in ./keys folder
```
eyaml createkeys
```
5) Create projects and hieradata folders structure
```
mkdir -p hieradata/apps/nginx/
mkdir -p projects/nginx
```

## [](#single-value-variable)Single value variable

To encode and encrypt a variable in Linux is enough to pipe the value to the base64 tool and eyaml
```
eyaml encrypt -s $(echo test100 | base64 -w 0)
```
The value obtained can now be stored in hiera as a variable value.

**Example 2**  

Continue from Example 1  

6) Create a secret.yaml file
```
echo '
apiVersion: "v1"
kind: "Secret"
metadata:
  name: %{application}-%{secret_version}
  namespace: %{environment}
type: Opaque
data:
  secret.properties: "%{secret_var}"
' > projects/nginx/secret.yaml
```
7) Create the secret
```
eyaml encrypt -s $(echo mySecretPassword | base64 -w 0)
```

8) Create hiera file with the secret created
```
echo '---
secret_version: 1516397999
secret_var: "ENC[PKCS7,MIIBiQYJKoZIhvcNAQcDoIIBejCCAXYCAQAxggEhMIIBHQIBADAFMAACAQEwDQYJKoZIhvcNAQEBBQAEggEAS/iMdJVXxCe0aSw2FLokKexGZ7ILfioWizFf9zzCEsgeJ2qr54/nNhXc4hf9MktShIEzLovQvqPSRWZL3RoOok5d1fVE5EU+3vlG96MLyYjQBXXCpPN3KlJqEdjLGy9QgnOQg+m1kOrqtVooZEfPpR0eI504i7uhDk9CqE4D+SbcQbziNIxNIbRG5pQovNZK/DfFNc/7CHUn1rUb1UrYBvCTvst/8C2LbUI7vzCyEQmzuNyS/pvZLL3X1E4JNWc+IkzF6emez3/PT2ZP9617HAxW4sYKV6u2Q+yEEH2sKitpbS+XYi/hxuZHGG+Uw9Ur0PPVhxuegPSDuGubiuUyZDBMBgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBCsosZIwHPILt6myRXc0RhygCBIsZYFpHPSAaZznCHhoDoNy5qZJ9kJCBmsyRxi2ZUicw==]"
' > hieradata/apps/nginx/development.yaml
```

9) Test the deployment
```
k8comp -a nginx -e development
```

## [](#file-as-variable)File as variable

If a single value is not enough a file can be also encrypted as a secret. It can be any type of file (properties, env, tar, zip... etc).  
To encode a file use below command:
```
eyaml encrypt -s $(cat secret.tar.gz | base64 -w 0)
```
The value obtained can now be stored in hiera as a variable value.

> Please note that the container should be able to handle this type of secrets.

**Example 3**  

Continue from Example 1  

6) Create few test files
```
mkdir archive
echo '
url: http://example.com/api/v1
api_key: aaaaaaaaaaaaaaaaaaaaaaaaab
' > archive/vars

echo '
feature_x: enabled
feature_z: disabled
' > archive/features
```
7) Create and encrypt the archive
```
tar -cvzf archive.tar.gz -C archive .
eyaml encrypt -s $(cat archive.tar.gz | base64 -w 0)
rm -rf archive.tar.gz
```
8) Create a secret.yaml file
```
echo '
apiVersion: "v1"
kind: "Secret"
metadata:
  name: %{application}-%{secret_version}
  namespace: %{environment}
type: Opaque
data:
  archive.tar.gz: "%{archive_var}"
' > projects/nginx/secret.yaml
```

9) Create hiera file with the secret archive created
```
echo '---
secret_version: 1516397999
archive_var: "ENC[PKCS7,MIICzQYJKoZIhvcNAQcDoIICvjCCAroCAQAxggEhMIIBHQIBADAFMAACAQEwDQYJKoZIhvcNAQEBBQAEggEAQh9Knp6Ks8cS5OotRw9+vkxg3647gMEGsc444k2D+7DC1RoyrTGPGPlNcqHuhmIneSG7f0efU8rlp0ua1EIBLOpPbCa4NpbRmtDx6iHJBA2ZBHoQaaLXZL/YId+VFpULLebzaGnFCZo29FKNnECKnq91WKG8/F85bIuyamvydt4nB9ewWE98jJM+v+c4mYOXHfdmRe1DGZXhNADW8trcaaXypRzYFS2lr3NOo9cieeozKxpyQ3Hi6DtC92H//HvfxUGaO4JGFtYkB3yB5K8MwzouAM38eXuaI8N1qS4N4pyjoRREl/sSQmkxtywLFKeN6QQfOaBndoMb4UAEtEAJ+jCCAY4GCSqGSIb3DQEHATAdBglghkgBZQMEASoEEAicA4vDE5nyyxGEeRqEVNuAggFg5VUV5Jo+JrwnNF5rIW0YvKSOXa7H/T8EqXku4sZUyrAb/lfEIxrwkhyZiF6BUo4zTpeiu2hHN8gKrI1wfzmkw7BA8ymh9DE/qw2OkChAqe+wapEHmSbDDhTqkioXe4d7h315OUfz3TyvYiS9k9Dld/pjkGChVoza94f8k3GgSMTbMU0Zi0nRsKqM7BfsI/uy+H+lOP15n/NQ7JX7/4FMgCy1Uo22M/qjp+G34qIHC6TnvZeWz/uLER48Oqb07OlchY9PK5IY4kh82ImOJCf/0IO/8oKCQD+8VCFbjKP4BA2mWpwv2zzgT6stGIOmy5BVCEY87TBCt1K7XBB7VgScwXFEs59TcQEnYowjLi9cPLpfkt7y/Q7UpAG0I2/ul7yzQnThVyJhBCBa/uVCGzwbGB56xkJ0IloFGBO5l3qJ/FxnU0DEOeaOdrjHjlT10/rKKt/WsSpDeveJSkS7evl2Og==]"
' > hieradata/apps/nginx/development.yaml
```

10) Test the deployment
```
k8comp -a nginx -e development
```

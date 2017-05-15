# Multi repo

The example is for multiple repositories, one for projects and another one for hieradata. The k8comp.conf has auto_git_pull set to true which equals to a git pull for each deployment.

Clone main k8comp repository

Projects
```
https://github.com/cststack/k8comp-app-examples.git
```

Hieradata
```
https://github.com/cststack/k8comp-hiera-examples.git
```
Both repositories have all the files on the git root. The folders ```projects`` and ``hieradata``` will be created automatically when the repos will be pulled.

## Set the configs

Clone examples repository

```
git clone https://github.com/cststack/k8comp.git
```

## Start docker container

```
docker run --rm \
-v `pwd`/k8comp/examples/common/extras:/opt/k8comp/extras \
-v `pwd`/k8comp/examples/common/keys:/opt/k8comp/keys \
-v `pwd`/k8comp/examples/multi_repo/hiera.yaml:/opt/k8comp/hiera.yaml \
-v `pwd`/k8comp/examples/multi_repo/k8comp.conf:/opt/k8comp/k8comp.conf \
-p 8080:8080 \
--name k8comp \
cststack/k8comp
```
## Test k8comp

Open your browser to http://127.0.0.1:8080 or execute ```docker run -it k8comp bash```

Optional pull the master branch with
```
k8comp pull
```
Deploy from master branch with
```
k8comp -p galaxies -a andromeda -e development
```

Deployment from development branch with
```
k8comp -p galaxies -a andromeda -e development -b development
```

Stop the container and remove the image with a double ctrl+c and
```
docker rmi cststack/k8comp
```

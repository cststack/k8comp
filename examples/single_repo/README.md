# Single repo

The example if for single repository which contains both projects and hieradata.

The example repository which containes both folders ```projects``` and ```hieradata``` on the git root is
```
https://github.com/cststack/k8comp-app-hiera-examples.git
```

## Set the configs

Clone main k8comp repository

```
git clone https://github.com/cststack/k8comp.git
```

## Start docker container

```
docker run --rm \
-v `pwd`/k8comp/examples/common/extras:/opt/k8comp/extras \
-v `pwd`/k8comp/examples/common/keys:/opt/k8comp/keys \
-v `pwd`/k8comp/examples/single_repo/hiera.yaml:/opt/k8comp/hiera.yaml \
-v `pwd`/k8comp/examples/single_repo/k8comp.conf:/opt/k8comp/k8comp.conf \
-p 8080:8080 \
--name k8comp \
cststack/k8comp
```
## Test k8comp

Open your browser to http://127.0.0.1:8080 or execute ```docker run -it k8comp bash```

Pull the master branch with
```
k8comp pull
```
Deploy from master branch with
```
k8comp -p galaxies -a andromeda -e development
```

Try deployment from development branch which will fail because auto_git_pull is set to false
```
k8comp -p galaxies -a andromeda -e development -b development
```

Pull development branch with
```
k8comp pull -b development
```
Try again deployment from development branch
```
k8comp -p galaxies -a andromeda -e development -b development
```

Stop the container and remove the image with a double ctrl+c and
```
docker rmi cststack/k8comp
```

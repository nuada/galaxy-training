# galaxy-training

Galaxy Docker image prepared for simple Galaxy tutorial.

Image based on [bgruening/docker-galaxy-stable](https://github.com/bgruening/docker-galaxy-stable) and [bgruening/galaxy-exom-seq](https://github.com/bgruening/docker-recipes/tree/master/galaxy-exom-seq).

## Usage
Create image:
```
docker build -t nuada/galaxy-training .
```

Create container:
```
docker run -d --name galaxy --volume=/resources:/resources nuada/galaxy-training
```

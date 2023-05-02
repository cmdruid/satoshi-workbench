## Building with Dockerfiles

To build:
```bash
docker build -f DOCKERFILE_PATH -o type=local,dest=OUT_PATH ROOT_PATH
```

Example Usage:

```bash
docker build -f bitcoind.dockerfile -o type=local,dest=out . 
```
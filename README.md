# Standalone Spark-cluster on Docker

A `ubuntu:14.04` based [Spark](http://spark.apache.org) container. This container compiles Apache Spark from source against Scala 2.11. Use it in a standalone cluster with the accompanying `docker-compose.yml`, or as a base for more complex recipes.

Some of the projects are skipped at the Maven build process to make the container a bit lighter and shorten compile time, please look at the `Dockerfile` for more information.

## Usage

The docker-compose contains three configurations: `master`, `worker` and `history`. Where `master` is the master-node which delegates the task over the worker nodes. The `worker` which gets work assigned from the master and does the actual processing. At last the `history` which solely runs the history server to keep track of the jobs when finished.

To create a standalone cluster with [docker-compose](http://docs.docker.com/compose):

    docker-compose up

Which will start up the cluster and process the example task, once finished it will shut the cluster down. If you want to continue use the cluster, please add the `-d` argument to daemonize the containers. Scaling can be done using docker-compose:

	docker-compose scale worker=4

The SparkUI will be running at `http://${YOUR_DOCKER_HOST}:8080` with one worker listed. To run `spark-shell`, exec into a container:

    docker exec -it dockerspark_master_1 /bin/bash
    /usr/spark/bin/spark-shell

## License

Apache 2.0 License

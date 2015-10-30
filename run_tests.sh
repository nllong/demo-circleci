#!/bin/bash

NODE_TOTAL=2
NODE_INDEX=$1

echo $NODE_TOTAL
echo $NODE_INDEX

i=0
docker_images=(
    'openstudio-1.8.1-mongo-2.4'
    'openstudio-1.8.5-mongo-2.4'
)

docker_split=()
for image in ${docker_images[@]}
do
  if [ $(($i % ${NODE_TOTAL})) -eq ${NODE_INDEX} ]
  then
    docker_split+=${image}

    #test=`basename $file | sed -e "s/.java//"`
    #tests+="${test},"
  fi
  ((i++))
done

function run_docker {
  echo "Running Docker container for $image"
  echo "Copying the files to a new test directory"
  mkdir -p docker_tests/$image
  rsync -av --progress . docker_tests/$image/ --exclude openstudio-*
  docker run -v $(pwd):/var/simdata/openstudio nrel/docker-test-containers:$image /var/simdata/openstudio/docker-run.sh
}

for image in ${docker_split[@]}
do
  run_docker
done


# copy all the files into a new test directory because they will clobber each other in parallel

# docker run -v $(pwd):/var/simdata/openstudio nrel/docker-test-containers:openstudio-1.8.1-mongo-2.4 /var/simdata/openstudio/docker-run.sh


#!/bin/bash

NODE_TOTAL=$CIRCLE_NODE_TOTAL
NODE_INDEX=$CIRCLE_NODE_INDEX

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

# copy all the files into a new test directory because they will clobber each other in parallel
function run_docker {
  echo "Running Docker container for $image"
  echo "Copying the files to a new test directory"
  mkdir -p docker_tests/$image
  rsync -av --progress . docker_tests/$image/ --exclude docker_tests --exclude .idea --exclude .git
  cd docker_tests/$image

  echo "Executing the docker command"
  docker run -v $(pwd):/var/simdata/openstudio nrel/docker-test-containers:$image /var/simdata/openstudio/docker-run.sh
}

for image in ${docker_split[@]}
do
  run_docker
done

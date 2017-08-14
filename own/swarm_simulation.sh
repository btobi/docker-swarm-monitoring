SWARM_TOKEN=$(docker swarm join-token -q worker)
SWARM_MASTER=$(docker info | grep -w 'Node Address' | awk '{print $3}')
NUM_WORKERS=3

echo
echo 'Remove / clear worker containers and nodes'
echo

for i in $(seq "${NUM_WORKERS}"); do
  docker container stop worker-${i}
  docker container rm worker-${i}
done

for i in $(seq "${NUM_WORKERS}"); do
  docker node rm worker-${i}
done

echo
echo 'Create' ${NUM_WORKERS} 'worker nodes'

for i in $(seq "${NUM_WORKERS}"); do
  echo '----------------------------------------'
  echo '# Will create worker node on port' $(expr ${i} + 7000) '#'
  echo '----------------------------------------'
  PORT=$(expr ${i} + 7000)
  docker run -d --privileged --name worker-${i} --hostname=worker-${i} -p ${PORT}:2375 docker:dind
  sleep 1  # this sleep is needed so that container has time to start before we connect to it
  docker --host=localhost:${PORT} swarm join --token ${SWARM_TOKEN} ${SWARM_MASTER}:2377
  echo 
done


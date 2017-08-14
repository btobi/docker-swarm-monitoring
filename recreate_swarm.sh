ADVERTISE_ADDRESS=192.168.20.190


docker swarm leave --force
docker swarm init --advertise-addr ${ADVERTISE_ADDRESS}



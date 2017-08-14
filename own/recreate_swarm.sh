ADVERTISE_ADDRESS=192.168.0.14


docker swarm leave --force
docker swarm init --advertise-addr ${ADVERTISE_ADDRESS}


